resource "aws_key_pair" "my_key" {
  key_name   = "my-terra-key"
  public_key = file("terrakey.pub")
}

resource "aws_default_vpc" "my_vpc" {}

# Create NEW subnet with safe CIDR that will not conflict
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_default_vpc.my_vpc.id
  cidr_block              = "172.31.50.0/24"     # SAFE CIDR
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = { Name = "terra-public-subnet" }
}

# Use DEFAULT IGW and DEFAULT route table — DO NOT CREATE NEW IGW

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_default_vpc.my_vpc.default_route_table_id
}

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

  tags = { Name = "automate-ec" }
}

