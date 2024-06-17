
variable "aws_region" {
    type = string
    default = "ap-south-1"  
    description = "AWS region" 
}

variable "aws_az" {
    type = list(string)
    default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
    description = "aws availability_zone in Mumbai region"
}


variable "ami_id" {
    type = string 
    default = "ami-0f58b397bc5c1f2e8"
    description = "server image"
}

variable "instance_type" {
    type = string
    default = "t2.micro"  
    description = "hardware type of server" 
}

variable "monitoring" {
    type = bool
    default = false
    description = "Disable detailed monitoring"
}

variable "tags" {
    type = list(string)
    default = ["terraform-uat-env", "terraform-prod-env", "terraform-staging-env"]
}

variable "cidr_block" {
    type = map(string) 
    default = {
        "vpc_cidr" = "192.168.0.0/16"
        "subnet_cidr" = "192.168.0.0/16"
    }  
}
