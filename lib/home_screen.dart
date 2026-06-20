import 'package:flutter/material.dart';
import 'package:waiting_list/waitlist_input.dart';

import 'l10n/app_localizations.dart';
import 'main.dart';

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
          // Language Switcher (more compact)
          TextButton(
            style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 8)),
            onPressed: () => PotlyWaitlistApp.of(context)?.setLocale(const Locale('en')),
            child: const Text('EN', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
          const Center(child: Text('|', style: TextStyle(color: Colors.white38))),
          TextButton(
            style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 8)),
            onPressed: () => PotlyWaitlistApp.of(context)?.setLocale(const Locale('de')),
            child: const Text('DE', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          // Join Waitlist Button (Responsive padding)
          Padding(
            padding: EdgeInsets.only(right: isDesktop ? 20.0 : 10.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _scrollToTop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 24 : 12,
                      vertical: isDesktop ? 18 : 12
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  AppLocalizations.of(context)!.joinWaitlist,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: isDesktop ? 16 : 12),
                ),
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
          AppLocalizations.of(context)!.heroTitle,
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
          AppLocalizations.of(context)!.heroSubtitle,
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
          AppLocalizations.of(context)!.waitlistOffer,
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
            color: const Color(0xFF13F3C6).withValues(alpha:  0.2),
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
          title: AppLocalizations.of(context)!.feature1Title,
          description: AppLocalizations.of(context)!.feature1Desc,
          imagePath: 'assets/1_Potly_Hook.png',
          isReversed: false,
        ),
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: AppLocalizations.of(context)!.feature2Title,
          description: AppLocalizations.of(context)!.feature2Desc,
          imagePath: 'assets/2_Potly_Math.png',
          isReversed: true,
        ),
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: AppLocalizations.of(context)!.feature3Title,
          description: AppLocalizations.of(context)!.feature3Desc,
          imagePath: 'assets/3_Potly_Reward.png',
          isReversed: false,
        ),
        _buildFeatureRow(
          context: context,
          isDesktop: isDesktop,
          title: AppLocalizations.of(context)!.feature4Title,
          description: AppLocalizations.of(context)!.feature4Desc,
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
           Text(
            AppLocalizations.of(context)!.footerTitle,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
           Text(
            AppLocalizations.of(context)!.footerDesc,
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
            '© 2026 Potly. Emanuel Biruk Seifegebreal. All rights reserved.',
            style: TextStyle(color: Colors.white38, fontSize: 12),
          )
        ],
      ),
    );
  }
}

