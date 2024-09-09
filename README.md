# aws-infra-terraform
**Setup AWS infra using Terraform:**

Run command in this sequence:
1. terraform init
2. terraform plan
3. terraform apply
4. terraform destroy - to delete the setup

terraform validate - validates the configuration files
terraform fmt - format Terraform configuration files into a canonical format and style
terraform apply -auto-approve


**Resources Created:**
aws_vpc
aws_subnet
aws_internet_gateway
aws_route_table + route 
aws_route_table_association
aws_security_group
aws_security_group_rule + ingress
aws_security_group_rule + egress
aws_s3_bucket
aws_instance
aws_lb   #create elb
aws_lb_target_group + health_check 
# In prod env, use countdown index, for loop or map, instead of repeating attach1 & attach2
aws_lb_target_group_attachment
aws_lb_listener + default_action

