resource "aws_iam_role" "openclaw_lambda_iam_role" {
  name = "openclaw_lambda_iam_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "openclaw_lambda_iam_role_policy" {
  name = "openclaw_lambda_iam_role_policy"
  role = var.ec2_invoke_role_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction"
        ]
        Resource = [
          aws_lambda_function.openclaw_microcms_lambda_function.arn,
          "${aws_lambda_function.openclaw_microcms_lambda_function.arn}:*",
          aws_lambda_function.openclaw_nanobanana_lambda_function.arn,
          "${aws_lambda_function.openclaw_nanobanana_lambda_function.arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "openclaw_lambda_iam_role_policy_attachment" {
  role       = aws_iam_role.openclaw_lambda_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
