import json
import urllib.parse
import boto3


def get_csv_body(event):
    s3 = boto3.client('s3')
    
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        rows = response['Body'].read().decode('utf-8').split(',')
        
        return rows
        
    except Exception as e:
        print(e)
        


