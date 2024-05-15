import boto3
import json

from csv_processor import get_csv_body
from email_validator import validate_email

def lambda_handler(event, context):
    email_list = list(map(str.strip,get_csv_body(event)))

    valid_emails = list(filter(lambda email: validate_email(email), email_list))
    invalid_emails = [email for email in email_list if email not in valid_emails]
    
    client = boto3.client('stepfunctions')
    
    response = client.start_execution(
        stateMachineArn='arn:aws:states:eu-north-1:471112532786:stateMachine:email-send-sf',
        input=  json.dumps({"valid_emails":valid_emails,"invalid_emails":invalid_emails,"sender":"s091365@student.tu.kielce.pl"  })
    )
