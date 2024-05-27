provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "bootstrapped_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    name = "Bootstrapped VPC"
  }
}

resource "aws_subnet" "bootstrapped_subnet" {
  vpc_id            = aws_vpc.bootstrapped_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  map_public_ip_on_launch = true # To ensure that your EC2 instance is assigned a public IP address
  tags = {
    name = "Bootstrapped Subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "bootstrapped_internet_gateway" {
  vpc_id = aws_vpc.bootstrapped_vpc.id

  tags = {
    Name = "BootstrappedInternetGateway"
  }
}

# Create a Route Table
resource "aws_route_table" "bootstrapped_route_table" {
  vpc_id = aws_vpc.bootstrapped_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bootstrapped_internet_gateway.id
  }

  tags = {
    Name = "BootstrappedRouteTable"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "bootstrapped_route_table_association" {
  subnet_id      = aws_subnet.bootstrapped_subnet.id
  route_table_id = aws_route_table.bootstrapped_route_table.id


}


resource "aws_security_group" "bootstrapped_security_group" {
  name        = "bootstrapped_security_gp"
  description = "Security group for bootstrapped EC2 instance"
  vpc_id      = aws_vpc.bootstrapped_vpc.id

  // Inbound rule to allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere
  }

  // Inbound rule to allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from anywhere
  }

  // Outbound rule to allow all traffic to go out to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "BootstrappedInstanceSG"
  }
}

resource "aws_instance" "bootstrapped_instance" {
  ami           = "ami-02bf8ce06a8ed6092"
  instance_type = "t2.micro"
  #   security_groups = [aws_security_group.bootstrapped_security_group.name]
  subnet_id = aws_subnet.bootstrapped_subnet.id

  associate_public_ip_address = true # To ensure that your EC2 instance is assigned a public IP address

  user_data = <<-EOF
                #!/bin/bash

            # initiating the super user
                sudo su

            # update all the packages
            yum update -y
  
            #   Install Python3 and pip
            sudo pip3 install -y python3
            sudo pip3 install -y python-pip

            # Install necessary Python libraries

            sudo pip3 install boto3
            sudo pip3 install databricks-api

                EOF

  tags = {
    Name = "BootstrappedEC2"
  }
}


output "name" {
  value = "!!!Bootstrapped EC2 instance with necessary libraries!!!"
}