#!/bin/bash

# deleting the tmp file
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