resource "aws_codestarconnections_connection" "codestar_connection" {
  name          = "${var.project}-${var.env}-${var.provider_type}"
  provider_type = var.provider_type

  tags = {
    Name = "${var.project}-${var.env}-${var.provider_type}"
  }
}
#After create connection, please do these steps in here to complete the connection:
#https://docs.aws.amazon.com/dtconsole/latest/userguide/connections-update.html
