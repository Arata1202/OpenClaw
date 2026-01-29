resource "aws_security_group" "clawdbot_sg" {
  name        = "clawdbot_sg"
  description = "clawdbot_sg"

  ingress = []

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "clawdbot_sg"
  }
}
