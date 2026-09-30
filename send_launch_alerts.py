import os
import firebase_admin
from firebase_admin import credentials, firestore
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from twilio.rest import Client
import re
import time
from dotenv import load_dotenv

# 1. Load the secret variables from the .env file
load_dotenv()

# ==========================================
# CONFIGURATION
# ==========================================

# Firebase Setup
PATH_TO_SERVICE_ACCOUNT = "serviceAccountKey.json"

# Email Setup
SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
# Pulling secrets from .env instead of hardcoding!
SENDER_EMAIL = os.getenv("SENDER_EMAIL")
SENDER_PASSWORD = os.getenv("SENDER_PASSWORD")

# Twilio SMS Setup
TWILIO_SID = os.getenv("TWILIO_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_PHONE_NUMBER = os.getenv("TWILIO_PHONE_NUMBER")

# Notification Content
EMAIL_SUBJECT = "Potly is now LIVE! 🎉"
EMAIL_BODY = """\
Hi there,

Great news! Potly is officially live on the App Store and Google Play Store.
Thank you for joining our waitlist. You can download the app now and start your first free savings cycle!

Download here: [Insert Link]

Cheers,
Your Potly Developer
Emanuel B. Seifegebreal
"""

SMS_BODY = "Potly is LIVE! 🎉 Download the app now on the App Store or Google Play: IOS: [Insert Link]"

# ==========================================
# HELPER FUNCTIONS
# ==========================================

def clean_email(email_str):
    if not email_str:
        return None
    cleaned = email_str.replace(" ", "").rstrip(".")
    return cleaned.lower()

def clean_phone(phone_str):
    if not phone_str:
        return None
    cleaned = re.sub(r"[^\d+]", "", phone_str)
    return cleaned

def send_email(target_email):
    msg = MIMEMultipart()
    msg['From'] = SENDER_EMAIL
    msg['To'] = target_email
    msg['Subject'] = EMAIL_SUBJECT
    msg.attach(MIMEText(EMAIL_BODY, 'plain'))

    try:
        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SENDER_EMAIL, SENDER_PASSWORD)
        server.send_message(msg)
        server.quit()
        return True
    except Exception as e:
        print(f"Failed to send email to {target_email}: {e}")
        return False

def send_sms(target_phone, twilio_client):
    try:
        message = twilio_client.messages.create(
            body=SMS_BODY,
            from_=TWILIO_PHONE_NUMBER,
            to=target_phone
        )
        return True
    except Exception as e:
        print(f"Failed to send SMS to {target_phone}: {e}")
        return False

# ==========================================
# MAIN EXECUTION
# ==========================================

def main():
    # Double-check that environment variables loaded properly
    if not SENDER_PASSWORD or not TWILIO_AUTH_TOKEN:
        print("ERROR: Missing credentials. Please check your .env file.")
        return

    # Initialize Firebase
    cred = credentials.Certificate(PATH_TO_SERVICE_ACCOUNT)
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    # Initialize Twilio
    twilio_client = Client(TWILIO_SID, TWILIO_AUTH_TOKEN)

    print("Fetching users from Firestore...")
    users_ref = db.collection("waitlist_emails") #[cite: 2]
    docs = users_ref.stream()

    success_emails = 0
    success_sms = 0

    for doc in docs:
        user_data = doc.to_dict()

        email = clean_email(user_data.get("email", ""))
        phone = clean_phone(user_data.get("phone", ""))

        if email and "@" in email and "." in email:
            print(f"Sending email to {email}...")
            if send_email(email):
                success_emails += 1

        if phone:
            print(f"Sending SMS to {phone}...")
            if send_sms(phone, twilio_client):
                success_sms += 1

        time.sleep(0.5)

    print("\n--- LAUNCH CAMPAIGN COMPLETE ---")
    print(f"Emails Sent: {success_emails}")
    print(f"SMS Sent: {success_sms}")

if __name__ == "__main__":
    main()