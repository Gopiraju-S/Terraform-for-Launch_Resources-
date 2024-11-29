provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Web_server" {
  instance_type = "t2.micro"
  ami = "ami-053b0d53c279acc90" # change this
  subnet_id = "subnet-019ea91ed9b5252e7" # change this

  provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo yum install -y httpd",
    "sudo systemctl start httpd",
  ]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = aws_instance.example.public_ip
  }
}
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "statefile-s3" # change this
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = data.aws_iam_policy_document.allow_access_from_another_account.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.example.arn,
      "${aws_s3_bucket.example.arn}/*",
    ]
  }
}
resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
