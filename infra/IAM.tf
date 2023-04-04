// Current AWS account number
data "aws_caller_identity" "current" {}

// Azure AD as an Identity Provider
resource "aws_iam_saml_provider" "azure_ad" {
  name                   = var.identity_provider_name
  saml_metadata_document = file("AWS_DevOps_Prod.xml")
}
// Admin role for IdP with a trust policy
resource "aws_iam_role" "idp_admin_role" {
  name                = "idp_assume_role"
  managed_policy_arns = [var.admin_policy_arn]
  assume_role_policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow",
      "Action" : "sts:AssumeRoleWithSAML",
      "Principal" : {
        "Federated" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:saml-provider/${aws_iam_saml_provider.azure_ad.name}"
      },
      "Condition" : {
        "StringEquals" : {
          "SAML:aud" : "https://signin.aws.amazon.com/saml"
        }
      }
    }
  })
}
// IAM user for Azure AD provisioning
resource "aws_iam_user" "azure_ad_provisioner" {
  name          = "azure_provisioner"
  force_destroy = true
}
resource "aws_iam_access_key" "provisioner_creds" {
  user = aws_iam_user.azure_ad_provisioner.name
}
resource "aws_iam_user_policy" "list_roles_policy" {
  name = "list_roles"
  user = aws_iam_user.azure_ad_provisioner.name
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "iam:ListRoles"
          ],
          "Resource" : "*"
        }
      ]
  })
}