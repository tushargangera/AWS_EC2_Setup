import boto3
# Initialize a default boto3 session
session = boto3.Session()
# Fetch and print the active default region
default_region = session.region_name
print(f"Default AWS Region: {default_region}")
