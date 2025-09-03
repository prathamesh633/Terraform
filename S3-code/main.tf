resource "aws_s3_bucket" "buckets" { # Creates 5 identical resources
  bucket = var.bucketname  # Unique name for each bucket
}
  # Optional additional configuration
#   tags = {
#     Environment = "Test"
#   }
# }