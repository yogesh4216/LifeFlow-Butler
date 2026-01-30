import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'package:lifeflow_butler_client/lifeflow_butler_client.dart';
import 'package:intl/intl.dart';

class PriorityTasksWidget extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onToggle;
  final Function(int) onDelete;

  const PriorityTasksWidget({
    super.key,
    required this.tasks,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Priority Tasks',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (tasks.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${tasks.length} Pending', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (tasks.isEmpty)
             _buildEmptyState(),
          if (tasks.isNotEmpty)
            ...tasks.asMap().entries.map((entry) {
              final task = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Dismissible(
                  key: Key('task_${task.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    if (task.id != null) onDelete(task.id!);
                  },
                  child: _buildTaskItem(context, task),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.check_circle_outline, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          const Text(
            "You're all clear! 🎉",
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    final isHigh = task.priority == 'high';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: isHigh ? Border.all(color: AppColors.error.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
           InkWell(
             onTap: () {
               task.completed = !task.completed;
               onToggle(task);
             },
             child: Container(
               width: 24, height: 24,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 border: Border.all(color: isHigh ? AppColors.error : AppColors.textSecondary),
                 color: task.completed ? (isHigh ? AppColors.error : AppColors.primary) : null,
               ),
               child: task.completed ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
             ),
           ),
           const SizedBox(width: 16),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   task.title,
                   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                     fontWeight: FontWeight.w600,
                     decoration: task.completed ? TextDecoration.lineThrough : null,
                     color: task.completed ? AppColors.textSecondary : AppColors.textPrimary,
                   ),
                 ),
               ],
             ),
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
               Text(
                 task.time,
                 style: TextStyle(
                   color: isHigh ? AppColors.error : AppColors.textSecondary,
                   fontWeight: FontWeight.bold,
                   fontSize: 12,
                 ),
               ),
             ],
           ),
        ],
      ),
    );
  }
}
