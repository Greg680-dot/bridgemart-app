import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../models/order_model.dart';

class EscrowStatusStepper extends StatelessWidget {
  final List<TrackingStep> steps;

  const EscrowStatusStepper({
    Key? key,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy à HH:mm', 'fr_FR');

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colonne Icône + Ligne verticale
            Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: step.isCompleted
                        ? AppTheme.success
                        : step.isCurrent
                            ? AppTheme.secondary
                            : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: step.isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : step.isCurrent
                            ? const Icon(Icons.sync, size: 16, color: Colors.white)
                            : Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 48,
                    color: step.isCompleted ? AppTheme.success : Colors.grey.shade300,
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Contenu de l'étape
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: step.isCurrent || step.isCompleted ? FontWeight.w700 : FontWeight.w500,
                        color: step.isCurrent
                            ? AppTheme.secondary
                            : step.isCompleted
                                ? AppTheme.textPrimary
                                : AppTheme.textMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      step.description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    if (step.timestamp != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        dateFormatter.format(step.timestamp!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
