resource "aws_vpc" "terravpc" {
  cidr_block = var.vpc-cidr
}

resource "aws_subnet" "terra-subnet-1" {
  vpc_id                  = aws_vpc.terravpc.id
  cidr_block              = var.sub1
  availability_zone       = var.az-1a
  map_public_ip_on_launch = true
}

resource "aws_subnet" "terra-subnet-2" {
  vpc_id                  = aws_vpc.terravpc.id
  cidr_block              = var.sub2
  availability_zone       = var.az-1b
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terravpc.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.terravpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rt1a" {
  subnet_id      = aws_subnet.terra-subnet-1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rt1b" {
  subnet_id      = aws_subnet.terra-subnet-2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "sg" {
  name_prefix = "websg"
  vpc_id      = aws_vpc.terravpc.id
}

resource "aws_security_group_rule" "ing1" {
  description       = "allow HTTP inbound traffic from anywhere"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "ing2" {
  description       = "allow SSH"
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_security_group_rule" "egr1" {
  description       = "allow outbound traffic to anywhere"
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg.id
}

resource "aws_s3_bucket" "s3-bucket" {
  bucket = "terras3-sriproj678567"
}


resource "aws_instance" "webserver1" {
  ami                    = var.ec2-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.terra-subnet-1.id
  user_data              = base64encode(file("userdata1.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = var.ec2-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.terra-subnet-2.id
  user_data              = base64encode(file("userdata2.sh"))
}

#create elb
resource "aws_lb" "alb" {
  name               = "loadbal"
  internal           = false #public load balance
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [aws_subnet.terra-subnet-1.id, aws_subnet.terra-subnet-2.id]
}

resource "aws_lb_target_group" "tg" {
  name     = "TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terravpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

# In prod env, use countdown index, for loop or map, instead of repeating attach1 & attach2
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}
