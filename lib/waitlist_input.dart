import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class WaitlistInput extends StatefulWidget {
  const WaitlistInput({super.key});

  @override
  State<WaitlistInput> createState() => _WaitlistInputState();
}

class _WaitlistInputState extends State<WaitlistInput> {
  // Controller to read the text typed into the field
  final TextEditingController _emailController = TextEditingController();

  // Variable to track if we are currently saving to the database
  bool _isLoading = false;

  // The function that runs when the button is pressed
  Future<void> _joinWaitlist() async {
    final email = _emailController.text.trim();

    // 1. Basic Validation: Ensure it looks like an email
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    // 2. Start Loading
    setState(() {
      _isLoading = true;
    });

    try {
      // Save to Firestore
      // 1. Convert email to lowercase so 'Test@Test.com' and 'test@test.com' don't count twice
      final normalizedEmail = email.toLowerCase();

      // 2. Use .doc(normalizedEmail).set() instead of .add()
      await FirebaseFirestore.instance
          .collection('waitlist_emails')
          .doc(normalizedEmail)
          .set({
        'email': normalizedEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 4. Success handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success! You are on the list. 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        _emailController.clear(); // Clear the input field
      }
    } catch (e) {
      // 5. Error handling
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // 6. Stop Loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    Widget inputField = TextField(
      controller: _emailController, // Attach the controller here
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: 'Enter your email address',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );

    Widget button = ElevatedButton(
      onPressed: _isLoading ? null : _joinWaitlist, // Disable button if loading
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.grey[800], // Color when disabled
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: _isLoading
          ? const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
      )
          : const Text(
        'Join Waitlist',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: isDesktop
          ? Row(
        children: [
          Expanded(child: inputField),
          const SizedBox(width: 10),
          button,
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          inputField,
          const SizedBox(height: 10),
          button,
        ],
      ),
    );
  }
}