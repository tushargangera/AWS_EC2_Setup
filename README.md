# Terraform EC2 Instance Setup with S3 Backend and GitHub to S3 Sync

This repository contains Terraform scripts to set up an EC2 instance within a VPC, using an S3 bucket as a remote backend for Terraform state files. Additionally, it includes a bash script to clone a GitHub repository and upload its contents to an S3 bucket.

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Setup Instructions](#setup-instructions)
    - [1. Create S3 Bucket](#1-create-s3-bucket)
    - [2. Configure S3 Remote Backend](#2-configure-s3-remote-backend)
    - [3. Deploy EC2 Instance](#3-deploy-ec2-instance)
4. [GitHub to S3 Sync Script](#4-github-to-s3-sync-script)
5. [IAM Policy for S3 Access](#5-iam-policy-for-s3-access)
6. [Outputs](#6-outputs)
7. [Cleanup](#7-cleanup)

## Introduction

This project automates the creation of an AWS EC2 instance along with its required network components using Terraform. The state files are stored in an S3 bucket for remote backend configuration. Furthermore, it includes a script to sync a GitHub repository to an S3 bucket.

## Prerequisites

- Terraform installed on your local machine.
- AWS CLI configured with appropriate permissions.
- An AWS account with permissions to create VPCs, subnets, security groups, EC2 instances, and S3 buckets.

## Setup Instructions

### 1. Create S3 Bucket

First, create an S3 bucket to store the Terraform state files.

Navigate to the `s3-bucket` directory and run the following commands:

```bash
cd s3-bucket
terraform init
terraform apply -auto-approve
```

### 2. Configure S3 Remote Backend

Next, configure Terraform to use the S3 bucket as a remote backend.
Navigate to the remote-backend directory and follow these steps:

```bash
cd Remote-backend
terraform init
terraform apply -auto-approve
```

This will create a remote backend configuration using the specified S3 bucket.


### 3. Deploy EC2 Instance

Finally, create the EC2 instance along with its required network components.
Navigate to the ec2-setup directory and run the following commands:

```bash
cd Bootstrap-EC2
terraform init
terraform apply -auto-approve
```

This will deploy an EC2 instance within a VPC along with its associated resources like subnets, security groups, etc.

### 4. GitHub to S3 Sync Script

A bash script is provided to clone a GitHub repository and upload its contents to an S3 bucket. The script ensures that the files are uploaded with a timestamp, making it easy to store multiple versions of the code.

Place the following script in a file named `github_to_s3_sync.sh`:

```bash
#!/bin/bash

# Deleting the tmp file
rm -rf tmp

# Variables
GIT_REPO_URL="https://github.com/ayushvarma7/AWS_EC2_Setup.git"
S3_BUCKET_NAME="ayush-varma"
S3_FOLDER_PATH="Github_to_S3_code_transfer"
LOCAL_DIR="./tmp/cloned_repo"

# Clone the Git repository
git clone $GIT_REPO_URL $LOCAL_DIR

# Check if the clone was successful
if [ $? -ne 0 ]; then
  echo "Failed to clone the repository."
  exit 1
fi

# Get the current date and time in YYYY-MM-DD_HH-MM-SS format
CURRENT_DATE=$(date +"%Y-%m-%d_%H-%M-%S")
echo $CURRENT_DATE

# Define the S3 path with the current date and time
S3_PATH="s3://$S3_BUCKET_NAME/$S3_FOLDER_PATH/$CURRENT_DATE/"

echo $S3_PATH

# Upload to S3 with the date and time as the folder name
aws s3 sync $LOCAL_DIR $S3_PATH

# Check if the upload was successful
if [ $? -ne 0 ]; then
  echo "Failed to upload to S3."
  exit 1
fi

echo "Code successfully uploaded to S3 at $S3_PATH"

rm -rf tmp
```

### 5. IAM Policy for S3 Access

Ensure your IAM user or role has the necessary permissions to perform S3 operations. Attach the following policy to your IAM user or role:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "arn:aws:s3:::ayush-varma",
        "arn:aws:s3:::ayush-varma/*"
      ]
    }
  ]
}

```

### 6. Outputs

`S3 Bucket Creation`: Success message confirming the creation of the S3 bucket.  
`Remote Backend Configuration`: Success message confirming the setup of the remote backend.  
`EC2 Instance Deployment`: Public IP address of the EC2 instance.  
GitHub to S3 Sync: Confirmation message with the S3 path where the code was uploaded.


### 7. Cleanup

To clean up the resources created by Terraform, navigate to each directory and run:

```bash
terraform destroy -auto-approve
```

Repeat the above command in the following order:

```
ec2-setup
remote-backend
s3-bucket
```

This consolidated README provides clear instructions for setting up the infrastructure using Terraform, syncing code from GitHub to S3, configuring IAM policies, and performing cleanup.    
Feel free to copy and paste this content into your README.md file for your GitHub repository.
