resource "aws_instance" "expense" {
  count         = length(var.instances)
  ami           = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.common.id,
    aws_security_group.expense[count.index].id
  ]

  tags = {
    Name = "${var.project}-${var.environment}-${var.instances[count.index]}"
  }
}

resource "aws_security_group" "common" {
  name        = "${var.project}-${var.environment}-common"
  description = "Allow TLS inbound traffic and all outbound traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.environment}-common"
  }
}

resource "aws_security_group" "expense" {
  count       = length(var.instances)
  name        =  "${var.project}-${var.environment}-${var.instances[count.index]}"
  description = "A component security group for expense instances"

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

  tags = {
    Name = "${var.project}-${var.environment}-${var.instances[count.index]}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "common" {
  security_group_id = aws_security_group.common.id
  cidr_ipv4         = "223.185.49.204/32" # Replace with your IP or "0.0.0.0/0" for public (not recommended)
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


# Frontend Inbound: Open to the public internet on web ports (80/443)
resource "aws_vpc_security_group_ingress_rule" "frontend_http" {
  count             = index(var.instances, "frontend") != null ? 1 : 0
  security_group_id = aws_security_group.expense[index(var.instances, "frontend")].id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# NodeJS Inbound: ONLY accepts traffic on Port 3000 originating from Frontend
resource "aws_vpc_security_group_ingress_rule" "frontend_to_nodejs" {
  count                        = (contains(var.instances, "nodejs") && contains(var.instances, "frontend")) ? 1 : 0
  security_group_id            = aws_security_group.expense[index(var.instances, "nodejs")].id
  referenced_security_group_id = aws_security_group.expense[index(var.instances, "frontend")].id
  from_port                    = 3000
  to_port                      = 3000
  ip_protocol                  = "tcp"
}

# MySQL Inbound: ONLY accepts traffic on Port 3306 originating from NodeJS
resource "aws_vpc_security_group_ingress_rule" "nodejs_to_mysql" {
  count                        = (contains(var.instances, "mysql") && contains(var.instances, "nodejs")) ? 1 : 0
  security_group_id            = aws_security_group.expense[index(var.instances, "mysql")].id
  referenced_security_group_id = aws_security_group.expense[index(var.instances, "nodejs")].id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

