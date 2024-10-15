terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_key_pair" "timemanager_key" {
  key_name   = "ssh-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINdsufdBe+P7TN9893YnL1rojxecWr3YeY7xhv3wR4ct"
}

resource "aws_security_group" "ssh" {
  name = "allow-ssh"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "postgres" {
  name = "allow-postgres"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "api" {
  name = "allow-api"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 4000
    to_port   = 4000
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "front" {
  name = "allow-front"

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 5173
    to_port   = 5173
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "timemanager_server" {
  ami                         = "ami-0a3598a00eff32f66"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.timemanager_key.key_name
  security_groups             = [aws_security_group.ssh.name, aws_security_group.postgres.name, aws_security_group.api.name, aws_security_group.front.name]
  associate_public_ip_address = true

  tags = {
    Name = "TimeManager"
  }
}
