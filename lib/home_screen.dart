import 'package:flutter/material.dart';
import 'package:waiting_list/waitlist_input.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Breakpoint for responsive design
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 80,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/Potly_App_Icon.png',
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance_wallet, size: 50, color: Color(0xFF13F3C6)),
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              'POTLY',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _scrollToTop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black, // High contrast text on neon
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Join Waitlist', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _buildHeroSection(context, isDesktop),
            const SizedBox(height: 80),
            _buildFeaturesSection(context, isDesktop),
            const SizedBox(height: 80),
            _buildFAQAndFooter(context, isDesktop),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, bool isDesktop) {
    Widget textContent = Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          'GROUP SAVINGS,\nSOLVED.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 64 : 40,
            fontWeight: FontWeight.bold,
            height: 1.1,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Ditch messy WhatsApp chats.\nGet clear automated payouts.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: TextStyle(
            fontSize: isDesktop ? 24 : 18,
            color: const Color(0xFF13F3C6), // Neon accent
          ),
        ),
        const SizedBox(height: 40),
        const WaitlistInput(),
        const SizedBox(height: 15),
        Text(
          '🎉 Join the waitlist today and get your first full savings cycle entirely free.',
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: const TextStyle(fontSize: 14, color: Colors.white70, fontStyle: FontStyle.italic),
        ),
      ],
    );

    Widget imageContent = Container(
      constraints: BoxConstraints(maxWidth: isDesktop ? 500 : double.infinity),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF13F3C6).withOpacity(0.2),
            blurRadius: 50,
            spreadRadius: 10,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/Mini_Billboard_v2.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 300,
            color: Colors.grey[900],
            child: const Center(child: Text('Mini_Billboard_v2.png missing')),
          ),
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 40),
      child: isDesktop
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: textContent),
          const SizedBox(width: 60),
          Expanded(child: imageContent),
        ],
      )
          : Column(
        children: [
          textContent,
          const SizedBox(height: 60),
          imageContent,
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, bool isDesktop) {
    return Column(
      children: [
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: 'A Single Source of Truth',
          description: 'Ditch the messy chats. Potly acts as your group\'s digital ledger, making tracking contributions effortless and transparent for everyone.',
          imagePath: 'assets/1_Potly_Hook .png',
          isReversed: false,
        ),
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: 'The Math is on Us',
          description: 'Automated tracking, instant reminders, and clear payout dates. Never manually calculate who owes what ever again.',
          imagePath: 'assets/2_Potly_Math.png',
          isReversed: true,
        ),
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: 'Stress-Free Payouts',
          description: 'Celebrate your payout! Enjoy seamless winner selection and turn management without the typical administrative headaches.',
          imagePath: 'assets/3_Potly_Reward.png',
          isReversed: false,
        ),
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: 'Built on Trust',
          description: 'Strict digital rules keep your savings circle safe. Deadlines are final, and automatic suspensions ensure fair play for everyone involved.',
          imagePath: 'assets/4_Potly_Trust_v3.png',
          isReversed: true,
        ),
      ],
    );
  }

  Widget _buildFeatureRow({
    required BuildContext context,
    required bool isDesktop,
    required String title,
    required String description,
    required String imagePath,
    required bool isReversed,
  }) {
    Widget textBlock = Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white70, height: 1.5),
        ),
      ],
    );

    Widget imageBlock = Container(
      constraints: const BoxConstraints(maxHeight: 500),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 300,
            width: 250,
            color: Colors.grey[800],
            child: Center(child: Text(imagePath.split('/').last)),
          ),
        ),
      ),
    );

    if (!isDesktop) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          children: [
            textBlock,
            const SizedBox(height: 40),
            imageBlock,
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isReversed
            ? [
          Expanded(child: imageBlock),
          const SizedBox(width: 80),
          Expanded(child: textBlock),
        ]
            : [
          Expanded(child: textBlock),
          const SizedBox(width: 80),
          Expanded(child: imageBlock),
        ],
      ),
    );
  }

  Widget _buildFAQAndFooter(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 100 : 20, vertical: 60),
      child: Column(
        children: [
          const Text(
            'Claim Your Free Cycle & Secure Your Spot.',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Your first cycle is completely free. After that, Potly costs just €1/month or €10/year.\nThe price of a coffee to secure your group\'s financial peace of mind.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: isDesktop ? 500 : double.infinity,
            child: const WaitlistInput(),
          ),
          const SizedBox(height: 40),
          const Text(
            '© 2026 Potly. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          )
        ],
      ),
    );
  }
}

