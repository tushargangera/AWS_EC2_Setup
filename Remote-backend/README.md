# Terraform Infrastructure Project

## Introduction

This project automates the deployment of cloud infrastructure using Terraform. The infrastructure includes creating an S3 bucket and configuring it as a remote backend to store Terraform state files.

## Prerequisites

Before you begin, ensure you have the following installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html) (version >= 0.12)
- [AWS CLI](https://aws.amazon.com/cli/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- A configured AWS account

## Getting Started

1. **Clone the repository:**

    ```bash
    git clone https://github.com/yourusername/your-repo-name.git
    cd your-repo-name
    ```

2. **Configure your environment variables:**

    Set up your environment variables for AWS credentials:

    ```bash
    export AWS_ACCESS_KEY_ID=your-access-key-id
    export AWS_SECRET_ACCESS_KEY=your-secret-access-key
    export AWS_DEFAULT_REGION=us-east-2
    ```

    Alternatively, you can configure the AWS CLI with your credentials:

    ```bash
    aws configure
    ```

3. **Create the S3 bucket:**

    Navigate to the `S3-bucket` directory and initialize Terraform:

    ```bash
    cd S3-bucket
    terraform init
    ```

    Apply the Terraform configuration to create the S3 bucket:

    ```bash
    terraform apply
    ```

    Confirm the creation by typing `yes` when prompted. You should see an output message confirming the bucket creation.

4. **Set up the remote backend:**

    Navigate to the `Remote-backend` directory:

    ```bash
    cd ../Remote-backend
    terraform init
    ```

    Apply the Terraform configuration to set up the remote backend:

    ```bash
    terraform apply
    ```

    Confirm the setup by typing `yes` when prompted. You should see output messages confirming the backend setup.

    One can now see the Terraform state files in the newly created S3 bucket once we have any changes in the infrastructure.