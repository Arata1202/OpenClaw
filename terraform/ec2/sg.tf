resource "aws_security_group" "openclaw_sg" {
  name        = "openclaw_sg"
  description = "openclaw_sg"

  ingress = []

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "openclaw_sg"
  }
}
