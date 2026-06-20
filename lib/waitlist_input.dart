import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WaitlistInput extends StatefulWidget {
  const WaitlistInput({super.key});

  @override
  State<WaitlistInput> createState() => _WaitlistInputState();
}

class _WaitlistInputState extends State<WaitlistInput> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _joinWaitlist() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final normalizedEmail = email.toLowerCase();
      final docRef = FirebaseFirestore.instance
          .collection('waitlist_emails')
          .doc(normalizedEmail);

      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are already on the waitlist! 😎'),
              backgroundColor: Colors.orange,
            ),
          );
          _emailController.clear();
        }
        return;
      }

      await docRef.set({
        'email': normalizedEmail,
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success! You are on the list. 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        _emailController.clear();
      }
    } catch (e) {
      if (mounted) {
        print('Error joining waitlist: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
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
      controller: _emailController,
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
      onPressed: _isLoading ? null : _joinWaitlist,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.grey[800],
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
        color: Colors.white.withValues(alpha: 0.1),
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