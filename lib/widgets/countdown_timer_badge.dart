import 'package:flutter/material.dart';
import '../config/theme.dart';

class CountdownTimerBadge extends StatelessWidget {
  final int secondsRemaining;

  const CountdownTimerBadge({
    Key? key,
    required this.secondsRemaining,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final minutes = secondsRemaining ~/ 60;
    final seconds = secondsRemaining % 60;
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final isCritical = secondsRemaining <= 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isCritical ? AppTheme.error.withOpacity(0.12) : AppTheme.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCritical ? AppTheme.error : AppTheme.warning,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_clock,
            size: 16,
            color: isCritical ? AppTheme.error : AppTheme.warning,
          ),
          const SizedBox(width: 6),
          Text(
            'Taux garanti : $formattedTime',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isCritical ? AppTheme.error : AppTheme.warning,
            ),
          ),
        ],
      ),
    );
  }
}
