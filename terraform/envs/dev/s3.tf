module "s3_artifacts" {
  source = "../../modules/s3"
  #s3-bucket 
  s3_bucket = {
    name = "${var.project}-${var.env}-artifacts"
  }

  s3_bucket_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Id" : "Policy1591079668806",
        "Statement" : [
          {
            "Sid" : "",
            "Effect" : "Allow",
            "Principal" : {
              "AWS" : "arn:aws:iam::${var.account_id}:root"
            },
            "Action" : [
              "s3:Get*",
              "s3:Put*"
            ],
            "Resource" : "arn:aws:s3:::${var.project}-${var.env}-artifacts/*"
          },
          {
            "Sid" : "",
            "Effect" : "Allow",
            "Principal" : {
              "AWS" : "arn:aws:iam::${var.account_id}:root"
            },
            "Action" : "s3:ListBucket",
            "Resource" : "arn:aws:s3:::${var.project}-${var.env}-artifacts"
          }
        ]
      }
    )
  }
}

module "s3_logs" {
  source = "../../modules/s3"
  #s3-bucket 
  s3_bucket = {
    name             = "${var.project}-${var.env}-logs"
    object_ownership = "ObjectWriter"
  }

  #s3-bucket-policy
  s3_bucket_policy = {
    template = jsonencode(
      {
        "Version" : "2012-10-17",
        "Id" : "Policy1429136655940",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Principal" : {
              "AWS" : "arn:aws:iam::${var.elb_region_id}:root"
            },
            "Action" : "s3:PutObject",
            "Resource" : "arn:aws:s3:::${var.project}-${var.env}-logs/AWSLogs/*"
          },
          {
            "Sid" : "S3ServerAccessLogsPolicy",
            "Effect" : "Allow",
            "Principal" : {
              "Service" : "logging.s3.amazonaws.com"
            },
            "Action" : [
              "s3:PutObject"
            ],
            "Resource" : "arn:aws:s3:::${var.project}-${var.env}-logs/s3*",
          }
        ]
      }
    )
  }
}
