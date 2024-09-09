# aws-infra-terraform
**Setup AWS infra using Terraform:**

**Terraform Commands:**
1. terraform init
2. terraform plan
3. terraform apply
4. terraform destroy - to delete the setup
   
5. terraform validate - validates the configuration files
6. terraform fmt - format Terraform configuration files into a canonical format and style
7. terraform apply -auto-approve


**Resources Created:**
1. aws_vpc
2. aws_subnet
3. aws_internet_gateway
4. aws_route_table + route 
5. aws_route_table_association
6. aws_security_group
7. aws_security_group_rule + ingress
8. aws_security_group_rule + egress
9. aws_s3_bucket
10. aws_instance
11. aws_lb   (elb)
12. aws_lb_target_group + health_check
13. aws_lb_target_group_attachment (In prod env, use countdown index, for loop or map, instead of repeating)
14. aws_lb_listener + default_action

