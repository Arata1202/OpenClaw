data "archive_file" "nanobanana_lambda_zip" {
  type        = "zip"
  source_file = "../lambda/nanobanana.py"
  output_path = "../lambda/zip/nanobanana.zip"
}

resource "aws_lambda_function" "openclaw_nanobanana_lambda_function" {
  function_name    = "openclaw_nanobanana_lambda_function"
  filename         = data.archive_file.nanobanana_lambda_zip.output_path
  source_code_hash = data.archive_file.nanobanana_lambda_zip.output_base64sha256
  runtime          = "python3.12"
  role             = aws_iam_role.openclaw_lambda_iam_role.arn
  handler          = "nanobanana.lambda_handler"
  timeout          = 900

  environment {
    variables = {
      NANOBANANA_API_KEY = var.nanobanana_api_key
      NANOBANANA_MODEL   = var.nanobanana_model
    }
  }

  depends_on = [aws_iam_role_policy_attachment.openclaw_lambda_iam_role_policy_attachment]
}
