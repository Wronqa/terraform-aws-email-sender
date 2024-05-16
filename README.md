# AWS Terraform Email Sender

AWS Terraform Email Sender enables users to send a CSV file containing email addresses to the server (e.g., via Postman) and then sends a message to all these emails. Using AWS Free Tier, each email must be verified before sending, which this application also facilitates.

## Table of Contents
- [Features](#features)
- [Technologies](#technologies)
- [Installation](#installation)
- [Architecture](#architecture)
- [Additional Information](#additional-information)

## Features
- Upload a CSV file with email addresses.
- Send emails to all addresses in the CSV file.
- Verify email addresses before sending (required by AWS Free Tier).

## Technologies
- **Infrastructure as Code**: Terraform
- **Cloud Services**: AWS
  - API Gateway
  - S3 Bucket
  - AWS Lambda (Python)
  - AWS Step Functions
  - AWS SES (Simple Email Service)
- **Programming Languages**: Python (for AWS Lambda)

## Installation
1. **Configure AWS ACCOUNT**:
    ```bash
    aws configure
    ```
2. **Fill in the variables in the `terraform.tfvars` file**:
    ```hcl
    region       = "YOUR_AWS_REGION"
    bucket_name  = "BUCKET_NAME"
    sender_email = "SENDER_EMAIL_ADDRESS"

    ```
3. **Initialize and apply Terraform**:
    ```bash
    terraform init
    terraform apply
    ```

## Architecture
![Architecture Diagram](https://i.imgur.com/J8LaOaT.png)

**Architecture Description:**
- The user uploads a CSV file with email addresses via API Gateway.
- API Gateway stores the file in an S3 Bucket.
- The S3 Bucket triggers a Lambda function.
- The Lambda function initiates a Step Function.
- The Step Function coordinates two other Lambda functions: one for verifying email addresses and one for sending emails.

**AWS Services Used:**
- API Gateway
- S3 Bucket
- AWS Lambda
- AWS Step Functions
- AWS SES

## Additional Information
- **Authors**: Wronqa
- **License**: MIT