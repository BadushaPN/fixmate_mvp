import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OfferCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const OfferCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.color,
    required this.icon,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadii.md),
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.10), AppColors.cardFor(context)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          ...AppShadows.card(context),
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.md),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(icon, size: 20, color: color),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.subtextFor(context),
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.deep,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.deep.withValues(alpha: 0.20),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
