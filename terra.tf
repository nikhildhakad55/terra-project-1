provider "aws" {
  region     = "us-west-1"
  access_key = "AKIAW3MEEL54UMXNW"
  secret_key = "6HafefpFp7kn+I2w1tNaaOVrWBYR/7AEZtvdB"
}

resource "aws_instance" "example" {
  ami           = "ami-014b33341e3a1178e"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "subnet"
  }
}

resource "aws_route_table" "R-table" {
  vpc_id = aws_vpc.my-vpc.id
 route {
 cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "associate_pub" {
  subnet_id = aws_subnet.subnet.id
   route_table_id = aws_route_table.R-table.id
depends_on = [aws_vpc.my-vpc, aws_internet_gateway.igw, aws_subnet.subnet, aws_route_table.R-table]
}




resource "aws_security_group" "mysg" {
   name        = "mysg"
  description = "mysg for vpc"
  vpc_id      = aws_vpc.my-vpc.id


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
 ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"                      #for all traffic
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "auto" {
  ami           = "ami-014b33341e3a1178e"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet.id

  tags = {
    Name = "terra-inst"
  }
}
