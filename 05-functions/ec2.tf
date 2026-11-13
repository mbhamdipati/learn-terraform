resource "aws_instance" "functions" {
  instance_type = "t3.micro"
  ami           = "ami-0055977a6e828a4f4" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  vpc_security_group_ids = [
    aws_security_group.functions.id
  ]
  tags = merge(
    var.common_tags,
    {
      Name      = "functions-demo"
      Component = "poc"
    }
  )
}

resource "aws_security_group" "functions" {
  name        = "functions"
  description = "Allow TLS inbound traffic and all outbound traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = merge(
    var.common_tags,
    {
      Name      = "functions-sg"
      Component = "poc"
    }
  )
}

