import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import 'haptic_service.dart';

class AppReviewService {
  static const String packageName = 'com.smart.calculator.converter.bmi.smart_calculator';
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=$packageName';
  static const String privacyPolicyUrl = 'https://vickyparajapati-flutter.github.io/smartcalculatorapp/';
  static const String supportEmail = 'hello@aianthro.com';

  /// 1. Share App with friends & family
  static Future<void> shareApp() async {
    HapticService.lightClick();
    await SharePlus.instance.share(
      ShareParams(
        text: 'Check out Smart Calculator & Converter! ⚡ 18+ All-in-One tools, secret vault, GST invoice maker, EMI & unit converter.\n\nDownload now from Google Play:\n$playStoreUrl',
        subject: 'Smart Calculator & Converter App',
      ),
    );
  }

  /// 2. Rate Us / In-App Review (Opens Google Play Rating)
  static Future<void> rateApp(BuildContext context) async {
    HapticService.mediumClick();
    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await inAppReview.openStoreListing();
      }
    } catch (_) {
      // Fallback directly to Play Store URL
      final uri = Uri.parse(playStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// 3. Open Official Privacy Policy Webpage
  static Future<void> openPrivacyPolicy() async {
    HapticService.lightClick();
    final uri = Uri.parse(privacyPolicyUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 4. Contact Developer / Support
  static Future<void> contactSupport() async {
    HapticService.lightClick();
    final uri = Uri.parse('mailto:$supportEmail?subject=Smart%20Calculator%20Feedback');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 5. Automatically prompts in-app review after 15 successful calculations
  static Future<void> checkAndPromptAutoReview() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasReviewed = prefs.getBool('has_prompted_review') ?? false;
      if (hasReviewed) return;

      final count = (prefs.getInt('calc_action_count') ?? 0) + 1;
      await prefs.setInt('calc_action_count', count);

      if (count >= 15) {
        final inAppReview = InAppReview.instance;
        if (await inAppReview.isAvailable()) {
          await prefs.setBool('has_prompted_review', true);
          await inAppReview.requestReview();
        }
      }
    } catch (_) {}
  }

  /// 5. Show Sleek Options Bottom Sheet
  static void showMoreOptionsSheet(BuildContext context) {
    HapticService.lightClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),

                // App Branding Header
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Calculator & Converter',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Version 1.0.0 • All-in-One Utility',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: AppColors.darkBorder, height: 1),
                const SizedBox(height: 10),

                // 1. Rate Us
                _buildOptionTile(
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFFBBF24),
                  title: 'Rate Us (5 Stars)',
                  subtitle: 'Support us with a 5-star review on Google Play',
                  onTap: () {
                    Navigator.pop(context);
                    rateApp(context);
                  },
                ),

                // 2. Share App
                _buildOptionTile(
                  icon: Icons.share_rounded,
                  iconColor: AppColors.primary,
                  title: 'Share with Friends',
                  subtitle: 'Spread the word via WhatsApp, Telegram, etc.',
                  onTap: () {
                    Navigator.pop(context);
                    shareApp();
                  },
                ),

                // 3. Privacy Policy
                _buildOptionTile(
                  icon: Icons.privacy_tip_outlined,
                  iconColor: const Color(0xFF38BDF8),
                  title: 'Privacy Policy',
                  subtitle: 'Read our secure offline-first data protection policy',
                  onTap: () {
                    Navigator.pop(context);
                    openPrivacyPolicy();
                  },
                ),

                // 4. Contact Developer Support
                _buildOptionTile(
                  icon: Icons.mail_outline_rounded,
                  iconColor: const Color(0xFF34D399),
                  title: 'Feedback & Support',
                  subtitle: 'Send feedback directly to hello@aianthro.com',
                  onTap: () {
                    Navigator.pop(context);
                    contactSupport();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildOptionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.outfit(
          fontSize: 12,
          color: AppColors.darkTextSecondary,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: Colors.white30),
      onTap: onTap,
    );
  }
}
