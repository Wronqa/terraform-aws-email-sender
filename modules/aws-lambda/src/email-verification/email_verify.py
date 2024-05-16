import boto3
import os

AWS_REGION = os.environ.get('aws_region')
client = boto3.client('ses',region_name=AWS_REGION)


def send_verification_emails(unverified_emails):
    for email in unverified_emails:
        client.verify_email_identity(
            EmailAddress = email
        )
        
def get_verified_emails(emails):
    verified_emails = client.list_identities(IdentityType = 'EmailAddress')['Identities']
    verified_emails_statuses = client.get_identity_verification_attributes(Identities=verified_emails)
    return [email for email in emails if email in verified_emails and verified_emails_statuses['VerificationAttributes'][email]["VerificationStatus"]=='Success']
