// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get joinWaitlist => 'Join Waitlist';

  @override
  String get heroTitle => 'GROUP SAVINGS,\nSOLVED.';

  @override
  String get emailHint => 'Enter your email address';

  @override
  String get errorInvalidEmail => 'Please enter a valid email address.';

  @override
  String get errorAlreadyOnWaitlist =>
      'You\'re already on the waitlist! (Made a typo? Refresh the page to try again) 😎';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get successJoined => 'Success! You are on the list. 🎉';

  @override
  String get phoneHint => 'Phone number (optional)';

  @override
  String get heroSubtitle =>
      'Ditch messy WhatsApp chats.\nGet clear automated payouts.';

  @override
  String get waitlistOffer =>
      '🎉 Join the waitlist today and get your first full savings cycle entirely free.';

  @override
  String get feature1Title => 'A Single Source of Truth';

  @override
  String get feature1Desc =>
      'Ditch the messy chats. Potly acts as your group\'s digital ledger, making tracking contributions effortless and transparent for everyone.';

  @override
  String get feature2Title => 'The Math is on Us';

  @override
  String get feature2Desc =>
      'Automated tracking, instant reminders, and clear payout dates. Never manually calculate who owes what ever again.';

  @override
  String get feature3Title => 'Stress-Free Payouts';

  @override
  String get feature3Desc =>
      'Celebrate your payout! Enjoy seamless winner selection and turn management without the typical administrative headaches.';

  @override
  String get feature4Title => 'Built on Trust';

  @override
  String get feature4Desc =>
      'Strict digital rules keep your savings circle safe. Deadlines are final, and automatic suspensions ensure fair play for everyone involved.';

  @override
  String get footerTitle => 'Claim Your Free Cycle & Secure Your Spot.';

  @override
  String get footerDesc =>
      'Your first cycle is completely free. After that, Potly costs just €0,99/month or €9,99/year.\nThe price of a scoop of ice cream to secure your group\'s financial peace of mind.';
}
