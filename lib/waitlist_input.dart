import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'l10n/app_localizations.dart';

class WaitlistInput extends StatefulWidget {
  const WaitlistInput({super.key});

  @override
  State<WaitlistInput> createState() => _WaitlistInputState();
}

class _WaitlistInputState extends State<WaitlistInput> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController(); // Added phone controller
  bool _isLoading = false;

  Future<void> _joinWaitlist() async {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim(); // Capture phone text

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorInvalidEmail)),
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

      // REMOVED: await docRef.get() check

      Map<String, dynamic> dataToSave = {
        'email': normalizedEmail,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (phone.isNotEmpty) {
        dataToSave['phone'] = phone;
      }

      // Try to create the document
      await docRef.set(dataToSave);

      // If it succeeds, they are newly added
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.successJoined), backgroundColor: Colors.green),
        );
        _emailController.clear();
        _phoneController.clear();
      }

    } on FirebaseException catch (e) {
      // Catch the permission-denied error triggered by our rules
      if (e.code == 'permission-denied') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.errorAlreadyOnWaitlist), backgroundColor: Colors.orange),
          );
        }
      } else {
        // Handle other Firebase errors
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.errorGeneric), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error joining waitlist: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorGeneric),
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
    _phoneController.dispose(); // Dispose to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 600;

    Widget emailField = TextField(
      controller: _emailController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.emailHint,
        hintStyle: const TextStyle(color: Colors.white54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );

    // New Phone Input Field
    Widget phoneField = TextField(
      controller: _phoneController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.phone, // Triggers number pad on mobile
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.phoneHint,
        hintStyle: const TextStyle(color: Colors.white54),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          : Text(
        AppLocalizations.of(context)!.joinWaitlist,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          Expanded(flex: 3, child: emailField),
          Container(width: 1, height: 30, color: Colors.white24), // Subtle vertical divider
          Expanded(flex: 2, child: phoneField),
          const SizedBox(width: 10),
          button,
        ],
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          emailField,
          const Divider(color: Colors.white24, height: 1), // Subtle horizontal divider
          phoneField,
          const SizedBox(height: 10),
          button,
        ],
      ),
    );
  }
}