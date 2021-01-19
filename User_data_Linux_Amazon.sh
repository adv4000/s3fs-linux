#!/bin/bash
#---------------------------------------------------------------
# Mount S3 Bucket on EC2 Bootstrap of Amazon Linux 2
# EC2 Userdata - Tested on s3fs Version 1.87
#
# Copyleft (c) by Denis Astahov    Date: 18-Jan-2021
# https://github.com/s3fs-fuse/s3fs-fuse
#---------------------------------------------------------------
# Make Sure to attach IAM Role with the following Policy to EC2:
#{
#    "Version": "2012-10-17",
#    "Statement": [
#        {
#            "Effect": "Allow",
#            "Action": [
#                "s3:DeleteObject",
#                "s3:GetObject",
#                "s3:ListBucket",
#                "s3:PutObject"
#            ],
#            "Resource": [
#                "arn:aws:s3:::YOUR_BUCKET_NAME",
#                "arn:aws:s3:::YOUR_BUCKET_NAME/*"
#            ]
#        }
#    ]
#}

BUCKET="YOUR_BUCKET_NAME"
MOUNT="/home/ec2-user/s3disk"
REGION="us-west-2"

amazon-linux-extras install epel -y
yum install s3fs-fuse -y

mkdir $MOUNT
s3fs -o allow_other -o iam_role=auto -o endpoint=$REGION -o url="https://s3-$REGION.amazonaws.com" $BUCKET $MOUNT

echo "s3fs#$BUCKET $MOUNT fuse allow_other,nonempty,use_path_request_style,iam_role=auto,url=https://s3-$REGION.amazonaws.com,endpoint=$REGION 0 0" >> /etc/fstab

