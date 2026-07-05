from firebase_functions import https_fn
from firebase_admin import initialize_app, firestore
import typing

# 1. Create a global variable for the database, but DON'T initialize it yet.
db = None

@https_fn.on_call(enforce_app_check=True)
def join_waitlist(req: https_fn.CallableRequest) -> typing.Any:
    global db

    # 2. "Lazy load" the database only when the function is actually called
    # This prevents the local Firebase CLI from crashing during deployment!
    if db is None:
        initialize_app()
        db = firestore.client()

    # 3. Extract and sanitize data
    email = req.data.get("email", "").strip().lower()
    phone = req.data.get("phone", "").strip()

    # 4. Basic Validation
    if not email or "@" not in email or "." not in email:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message="Please provide a valid email address."
        )

    # 5. Check if the user is already on the waitlist
    doc_ref = db.collection("waitlist_emails").document(email)
    doc = doc_ref.get()

    if doc.exists:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.ALREADY_EXISTS,
            message="You're already on the waitlist!"
        )

    # 6. Save to Firestore
    data_to_save = {
        "email": email,
        "timestamp": firestore.SERVER_TIMESTAMP
    }

    if phone:
        data_to_save["phone"] = phone

    try:
        doc_ref.set(data_to_save)
        return {"success": True, "message": "Successfully joined the waitlist!"}
    except Exception as e:
        print(f"Firestore Error: {e}")
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INTERNAL,
            message="Something went wrong saving your data."
        )