import json

def get_logs_template(verified_emails,unverified_emails,invalid_emails):
    return (
        "The operation you ordered has been completed. \n\n"
        f"{"Some messages were not sent because email addresses were not verified. We sent verification messages to the addresses provided. Verify them and try again.".upper() if len(unverified_emails) > 0 else ""}\n\n"
        f"Successfully send emails: {json.dumps(verified_emails)} \n"
        f"Unverified emails: {json.dumps(unverified_emails)} \n"
        f"Invalid emails: {json.dumps(invalid_emails)} \n"
        )