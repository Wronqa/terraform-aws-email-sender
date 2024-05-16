from email_verify import send_verification_emails, get_verified_emails

def lambda_handler(event, context):
    valid_emails = event['valid_emails']
    invalid_emails = event['invalid_emails']
    sender = event['sender']
    
    is_sender_verified = len(get_verified_emails([sender])) > 0
    
    if not is_sender_verified:
        send_verification_emails([sender])


    verified_emails = get_verified_emails(valid_emails)
    unverified_emails = list(filter(lambda email: email not in verified_emails,valid_emails))
    
    if len(unverified_emails) != 0:
        send_verification_emails(unverified_emails)
    
    return {
        "verified_emails":verified_emails,
        "unverified_emails":unverified_emails,
        "valid_emails":valid_emails,
        "invalid_emails":invalid_emails,
        "sender":sender
        
    }
    
    
