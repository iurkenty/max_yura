// Azure AD as an Identity Provider
resource "aws_iam_saml_provider" "azure_ad" {
  name                   = var.identity_provider_name
  saml_metadata_document = file("AWS_DevOps_Prod.xml")
}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "idp_assume_role" {
  name               = "idp_assume_role"
  assume_role_policy = jsonencode({

  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRoleWithSAML",
    "Principal": {
      "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${aws_iam_saml_provider.azure_ad.name}"
    },
    "Condition": {
      "StringEquals": {
        "SAML:aud": "https://signin.aws.amazon.com/saml"
      }
    }
  }
})
}