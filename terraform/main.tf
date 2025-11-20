########################################
# SSH KEY GENERATION (SECURE - NO FILES IN GIT)
########################################

resource "tls_private_key" "ssh_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "my_key" {
  key_name   = "my-terra-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Save private key locally inside Jenkins workspace for Ansible
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_openssh
  filename        = "${path.module}/generated_key.pem"
  file_permission = "0400"
}

########################################
# DEFAULT VPC
########################################

resource "aws_default_vpc" "my_vpc" {}

########################################
# PUBLIC SUBNET
########################################

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_default_vpc.my_vpc.id
  cidr_block              = "172.31.50.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terra-public-subnet"
  }
}

########################################
# ROUTE TABLE ASSOCIATION
########################################

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_default_vpc.my_vpc.default_route_table_id
}

########################################
# SECURITY GROUP
########################################

resource "aws_security_group" "my_security_group" {
  name        = "my_sg1"
  description = "security group"
  vpc_id      = aws_default_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 19999
    to_port     = 19999
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# EC2 INSTANCE
########################################

resource "aws_instance" "my_ec2_instance" {
  ami                    = "ami-02b8269d5e85954ef"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.my_key.key_name

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "automate-ec"
  }
}
