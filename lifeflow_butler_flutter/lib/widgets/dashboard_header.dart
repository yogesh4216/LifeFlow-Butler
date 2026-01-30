import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final String greeting;
  final VoidCallback onProfileTap;
  final VoidCallback onHistoryTap;

  const DashboardHeader({
    super.key,
    required this.greeting,
    required this.onProfileTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting.split('.').first + '.', // Main Greeting
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                greeting.split('.').skip(1).join('.').trim(), // Status text
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: onHistoryTap,
              icon: const Icon(Icons.history, color: AppColors.textSecondary),
              tooltip: 'Task History',
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onProfileTap,
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
