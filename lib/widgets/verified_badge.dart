import 'package:flutter/material.dart';
import '../config/theme.dart';

class VerifiedBadge extends StatelessWidget {
  final String label;
  final bool isSmall;

  const VerifiedBadge({
    Key? key,
    this.label = 'Vendeur Vérifié Nigeria',
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 6 : 8,
        vertical: isSmall ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppTheme.nigeriaGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.nigeriaGreen.withOpacity(0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified,
            color: AppTheme.nigeriaGreen,
            size: isSmall ? 12 : 14,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.nigeriaGreen,
              fontSize: isSmall ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
