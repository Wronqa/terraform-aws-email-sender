import json
from botocore.exceptions import ClientError
from email_send import email_send
from logs_template import get_logs_template


def lambda_handler(event, context):
    valid_emails = event['valid_emails']
    invalid_emails = event['invalid_emails']
    verified_emails = event['verified_emails']
    unverified_emails = event['unverified_emails']
    sender = event['sender']
    
    logs_template_message = get_logs_template(verified_emails,unverified_emails,invalid_emails)
   
    
    try:
        if len(verified_emails) > 0:
            response = email_send(verified_emails,{"subject":"Test message", "body":"Hi! It's my test message!", "sender":sender})
    except ClientError as e:
        email_send([sender], {"subject":"Sending logs", "body":json.dumps(e.response['Error']['Message']), "sender":sender})
        print(e.response['Error']['Message'])
    else:
        email_send([sender], {"subject":"Sending logs", "body":logs_template_message, "sender":sender})
        print(response['MessageId'])