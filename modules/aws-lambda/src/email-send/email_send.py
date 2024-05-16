import boto3
import os


AWS_REGION = os.environ.get('aws_region')

client = boto3.client('ses',region_name=AWS_REGION)

def email_send(emails,content):
    return client.send_email(
            Destination={
                'ToAddresses': emails,
            
            },
            Message={
                'Body': {
                    'Text': {
                        'Charset': 'UTF-8',
                        'Data': content['body'],
                    },
                },
                'Subject': {
                    'Charset': 'UTF-8',
                    'Data': content['subject'],
                },
            },
            Source=content['sender'],
        )