import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:lifeflow_butler_client/lifeflow_butler_client.dart';

class BriefingsWidget extends StatelessWidget {
  final List<Briefing> briefings;
  final bool isConnected;
  final VoidCallback onConnectTap;

  const BriefingsWidget({
    super.key, 
    required this.briefings, 
    required this.isConnected, 
    required this.onConnectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.background,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Daily Briefing',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          if (!isConnected)
            _buildDisconnectedState()
          else if (briefings.isEmpty)
             _buildEmptyState(),
          if (isConnected)
            ...briefings.map((b) => _buildBriefingItem(b)),
        ],
      ),
    );
  }

  Widget _buildDisconnectedState() {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.link_off, size: 40, color: AppColors.textSecondary),
          const SizedBox(height: 12),
          const Text(
            "Connect integrations to see AI briefings.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onConnectTap,
            icon: const Icon(Icons.add_link),
            label: const Text('Connect Gmail'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
     return const Center(
      child: Column(
        children: [
           Text(
            "Zero inbox, zero stress. 🌱",
             style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBriefingItem(Briefing b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(b.summary, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
        ],
      ),
    );
  }
}
