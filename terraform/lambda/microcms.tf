data "archive_file" "microcms_lambda_zip" {
  type        = "zip"
  source_file = "../lambda/microcms.py"
  output_path = "../lambda/zip/microcms.zip"
}

resource "aws_lambda_function" "openclaw_microcms_lambda_function" {
  function_name    = "openclaw_microcms_lambda_function"
  filename         = data.archive_file.microcms_lambda_zip.output_path
  source_code_hash = data.archive_file.microcms_lambda_zip.output_base64sha256
  runtime          = "python3.12"
  role             = aws_iam_role.openclaw_lambda_iam_role.arn
  handler          = "microcms.lambda_handler"
  timeout          = 900

  environment {
    variables = {
      MICROCMS_SERVICE_DOMAIN = var.microcms_service_domain
      MICROCMS_API_KEY        = var.microcms_api_key
    }
  }

  depends_on = [aws_iam_role_policy_attachment.openclaw_lambda_iam_role_policy_attachment]
}
