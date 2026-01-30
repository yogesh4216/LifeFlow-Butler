import 'package:lifeflow_butler_client/lifeflow_butler_client.dart';

class NaturalLanguageParser {
  static Task parse(String input) {
    String text = input.toLowerCase();
    
    // 1. Parse Priority
    String priority = 'medium';
    if (text.contains('high priority') || text.contains('urgent')) {
      priority = 'high';
      text = text.replaceAll('high priority', '').replaceAll('urgent', '');
    } else if (text.contains('low priority')) {
      priority = 'low';
      text = text.replaceAll('low priority', '');
    } else if (text.contains('medium priority')) {
      priority = 'medium';
      text = text.replaceAll('medium priority', '');
    }

    // 2. Parse Date
    DateTime date = DateTime.now();
    if (text.contains('tomorrow')) {
      date = date.add(const Duration(days: 1));
      text = text.replaceAll('tomorrow', '');
    } else if (text.contains('today')) {
       text = text.replaceAll('today', '');
    }
    // Simple MVP: doesn't handle "next friday" etc yet.

    // 3. Parse Time
    String time = '9:00 am'; // Default
    // Regex for 5:30 pm, 5pm, 5:30pm, 17:00
    final timeRegex = RegExp(r'(\d{1,2}:\d{2}\s?(?:am|pm)?)|(\d{1,2}\s?(?:am|pm))');
    final match = timeRegex.firstMatch(text);
    if (match != null) {
      time = match.group(0)!.trim();
      text = text.substring(0, match.start) + text.substring(match.end);
    }

    // 4. Title is what remains
    String title = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (title.isEmpty) title = 'New Task';

    // Capitalize title
    title = title[0].toUpperCase() + title.substring(1);

    return Task(
      title: title,
      date: date,
      time: time,
      priority: priority,
      completed: false,
      createdAt: DateTime.now(),
    );
  }
}
