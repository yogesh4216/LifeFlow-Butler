import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../logic/natural_language_parser.dart';
import 'package:lifeflow_butler_client/lifeflow_butler_client.dart';

class QuickAddFAB extends StatelessWidget {
  final Function(Task) onTaskParsed;

  const QuickAddFAB({super.key, required this.onTaskParsed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showAddDialog(context),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add),
      label: const Text('Quick Add'),
    );
  }

  void _showAddDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'New Task',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'e.g., "Client sync tomorrow at 5pm high priority"',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  final task = NaturalLanguageParser.parse(value);
                  onTaskParsed(task);
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    final task = NaturalLanguageParser.parse(controller.text);
                    onTaskParsed(task);
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white, 
                ),
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
