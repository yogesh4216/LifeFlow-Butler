import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class IntegrationsScreen extends StatefulWidget {
  final bool isConnected;
  final ValueChanged<bool> onConnectionChanged;

  const IntegrationsScreen({
    super.key,
    required this.isConnected,
    required this.onConnectionChanged,
  });

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  late bool _isConnected;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _isConnected = widget.isConnected;
  }

  Future<void> _toggleConnection(bool value) async {
    if (value) {
      setState(() => _isConnecting = true);
      // Simulate network delay for "Connecting..." effect
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isConnecting = false;
        _isConnected = true;
      });
      widget.onConnectionChanged(true);
      if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gmail connected successfully! ✅')),
        );
      }
    } else {
      setState(() => _isConnected = false);
      widget.onConnectionChanged(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Integrations', style: TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Connect your digital life',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 24),
          _buildIntegrationItem(
            icon: Icons.mail_outline,
            name: 'Gmail',
            description: 'Sync your emails and get smart briefings.',
            color: Colors.redAccent,
            connected: _isConnected,
            onChanged: _toggleConnection,
          ),
          _buildIntegrationItem(
            icon: Icons.calendar_today,
            name: 'Google Calendar',
            description: 'Sync meetings and schedule.',
            color: Colors.blueAccent,
            connected: _isConnected, // Tying both together for simple demo
            onChanged: (val) {}, 
            isBeta: true,
          ),
           _buildIntegrationItem(
            icon: Icons.chat_bubble_outline,
            name: 'Slack',
            description: 'Catch up on team channels.',
            color: Colors.purpleAccent,
            connected: false,
            onChanged: (val) {},
            isBeta: true,
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationItem({
    required IconData icon,
    required String name,
    required String description,
    required Color color,
    required bool connected,
    required Function(bool) onChanged,
    bool isBeta = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: connected 
          ? Border.all(color: color.withOpacity(0.5))
          : Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (isBeta) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('SOON', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
          if (_isConnecting && name == 'Gmail' && !connected)
            const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            )
          else
            Switch(
              value: connected,
              onChanged: isBeta ? null : onChanged,
              activeColor: color,
              activeTrackColor: color.withOpacity(0.2),
            ),
        ],
      ),
    );
  }
}
