import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool isLink;

  const CustomInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasIcon = icon != null;
    final bool hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    // Build the row layout inside the card
    Widget cardContent = Row(
      crossAxisAlignment: hasSubtitle ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        if (hasIcon) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0065FF), // Consistent brand blue
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.2,
                ),
              ),
              if (hasSubtitle) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isLink ? const Color(0xFF0065FF) : Colors.black87,
                    decoration: isLink ? TextDecoration.underline : TextDecoration.none,
                    decorationColor: const Color(0xFF0065FF),
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    // Determine target onTap action (handle standard tap or automatic link launching)
    VoidCallback? resolveOnTap() {
      if (onTap != null) return onTap;
      if (isLink && hasSubtitle) {
        return () async {
          final Uri url = Uri.parse(subtitle!);
          try {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } catch (e) {
            // Ignore error
          }
        };
      }
      return null;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: resolveOnTap(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: cardContent,
          ),
        ),
      ),
    );
  }
}
