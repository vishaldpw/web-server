#!/usr/bin/env bash
# One-time S3 setup for static website hosting.
# Requires: AWS CLI installed and `aws configure` already done.
#
# Usage:  ./setup-s3.sh

set -euo pipefail

BUCKET="vishal-protein-fitness-demo"   # must be globally unique
REGION="us-east-1"

echo "Creating bucket: $BUCKET in $REGION"
aws s3api create-bucket \
  --bucket "$BUCKET" \
  --region "$REGION"

echo "Disabling block-public-access (needed for static website hosting)"
aws s3api put-public-access-block \
  --bucket "$BUCKET" \
  --public-access-block-configuration \
    "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"

echo "Adding public read bucket policy"
cat > /tmp/bucket-policy.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::${BUCKET}/*"
  }]
}
EOF
aws s3api put-bucket-policy --bucket "$BUCKET" --policy file:///tmp/bucket-policy.json

echo "Enabling static website hosting"
aws s3 website "s3://${BUCKET}/" --index-document index.html

echo ""
echo "Done. Your site URL will be:"
echo "  http://${BUCKET}.s3-website-${REGION}.amazonaws.com"
echo ""
echo "Next: push to GitHub and the Action will sync files automatically."
