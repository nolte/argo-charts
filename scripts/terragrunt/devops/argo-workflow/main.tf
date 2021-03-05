resource "minio_s3_bucket" "workflow_storage" {
  bucket = "workflow-storage"
  acl   = "public-read-write"
}

data "minio_iam_policy_document" "example" {
  statement {
    sid = "1"
    actions = [
      "s3:ListAllMyBuckets",
      "s3:GetBucketLocation",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${minio_s3_bucket.workflow_storage.bucket}",
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${minio_s3_bucket.workflow_storage.bucket}",
      "arn:aws:s3:::${minio_s3_bucket.workflow_storage.bucket}/*",
    ]
  }
}

resource "minio_iam_user" "workflow_user" {
  name = "workflow-user"
}
output "workflow_user" {
  value = minio_iam_user.workflow_user
}

resource "minio_iam_policy" "workflow_storage" {
  name = "workflow-storage"
  policy    = data.minio_iam_policy_document.example.json
}
resource "minio_iam_user_policy_attachment" "workflow_user" {
  user_name      = "${minio_iam_user.workflow_user.id}"
  policy_name = "${minio_iam_policy.workflow_storage.id}"
}



resource "vault_generic_secret" "example" {
  path = format("%s/argo/sa/s3",var.secrets_engine_path)

  data_json = jsonencode(minio_iam_user.workflow_user)
}

