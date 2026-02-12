module "ec2" {
  source = "./ec2"

  ami               = var.ami
  instance_type     = var.instance_type
  volume_type       = var.volume_type
  volume_size       = var.volume_size
  volume_encrypted  = var.volume_encrypted
  volume_kms_key_id = var.volume_kms_key_id
}

module "lambda" {
  source = "./lambda"

  microcms_service_domain = var.microcms_service_domain
  microcms_api_key        = var.microcms_api_key

  nanobanana_api_key = var.nanobanana_api_key
  nanobanana_model   = var.nanobanana_model

  ec2_invoke_role_name = module.ec2.iam_role_name
}
