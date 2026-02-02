resource "aws_kms_key" "rds_primary" {
  description             = "KMS key for Aurora Global primary"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "rds_primary" {
  name          = "alias/aurora-global-primary"
  target_key_id = aws_kms_key.rds_primary.id
}



------------------------- us-east-2 -----------------------------------------------




resource "aws_kms_key" "rds_secondary" {
  provider                = aws.us_east_2
  description             = "KMS key for Aurora Global secondary"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "rds_secondary" {
  provider      = aws.us_east_2
  name          = "alias/aurora-global-secondary"
  target_key_id = aws_kms_key.rds_secondary.id
}