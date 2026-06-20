resource "aws_s3_bucket" "my_bucket" {
  bucket = "s3-tf-test-bucket-1978"

  tags = {
    Name = "S3 Bucket for Terraform"
  }
}
