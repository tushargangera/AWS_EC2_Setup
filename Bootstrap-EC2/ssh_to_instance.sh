#!/bin/bash

# Format the code
terraform fmt

# Apply the Terraform configuration
terraform apply -auto-approve

# Retrieve the instance IP and private key
INSTANCE_IP=$(terraform output -raw instance_ip)
PRIVATE_KEY=$(terraform output -raw private_key)

# Specify the PEM file path
KEY_FILE="bootstrapped-key.pem"

# Check if the PEM file exists
if [ -e "$KEY_FILE" ]; then
  # If the file exists, check if it's writable
  if [ ! -w "$KEY_FILE" ]; then
    # If the file is not writable, grant write permissions
    echo "Granting write permissions to $KEY_FILE"
    chmod +w "$KEY_FILE"
  fi
else
  # If the file does not exist, create it
  touch "$KEY_FILE"
fi

# Save the private key to the PEM file
echo "$PRIVATE_KEY" > "$KEY_FILE"

# Grant read-only permission to the PEM file
chmod 400 "$KEY_FILE"

# SSH into the EC2 instance
ssh -i "$KEY_FILE" ec2-user@"$INSTANCE_IP"
