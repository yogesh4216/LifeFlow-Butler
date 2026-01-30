import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'package:intl/intl.dart';

class ButlerEndpoint extends Endpoint {
  
  Future<DailyOverview> getDailyOverview(Session session) async {
    // 1. Intelligence: Check Overdue Tasks
    await _processOverdueTasks(session);

    // 2. Fetch Tasks
    var tasks = await Task.db.find(
      session,
      where: (t) => t.completed.equals(false),
    );

    // 3. Sort Tasks (Priority > Time)
    tasks.sort((a, b) {
      final pA = _priorityValue(a.priority);
      final pB = _priorityValue(b.priority);
      if (pA != pB) return pB.compareTo(pA); // Descending priority

      // Compare Date
      final dateComp = a.date.compareTo(b.date);
      if (dateComp != 0) return dateComp;

      // Compare Time string
      return _compareTimeStrings(a.time, b.time);
    });

    // 4. Fetch Briefings
    var briefings = await Briefing.db.find(
      session,
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );

    // 5. Seed if empty
    if (tasks.isEmpty && briefings.isEmpty) {
      await _seedData(session);
       tasks = await Task.db.find(session, where: (t) => t.completed.equals(false));
       briefings = await Briefing.db.find(session);
    }

    // 6. Generate Greeting
    final greeting = _generateGreeting(tasks, briefings);

    return DailyOverview(
      greeting: greeting,
      tasks: tasks,
      briefings: briefings,
    );
  }

  Future<void> addTask(Session session, Task task) async {
    task.createdAt = DateTime.now();
    task.completed = false;
    await Task.db.insertRow(session, task);
  }

  Future<void> updateTask(Session session, Task task) async {
    await Task.db.updateRow(session, task);
  }

  Future<void> deleteTask(Session session, int id) async {
    await Task.db.deleteWhere(session, where: (t) => t.id.equals(id));
  }

  Future<List<Task>> getTaskHistory(Session session) async {
    return await Task.db.find(
      session,
      where: (t) => t.completed.equals(true),
      orderBy: (t) => t.createdAt, // Ideally completedAt, but using createdAt/updatedAt logic for MVP
      orderDescending: true,
    );
  }


  // --- Intelligence Logic ---

  Future<void> _processOverdueTasks(Session session) async {
    final tasks = await Task.db.find(session, where: (t) => t.completed.equals(false));
    final now = DateTime.now();
    
    for (var task in tasks) {
      // Combine date and time to check if overdue
      // Assuming naive check for MVP
      final DateTime? dueDateTime = _parseDateTime(task.date, task.time);
      if (dueDateTime != null && dueDateTime.isBefore(now)) {
        if (task.priority != 'high') {
          task.priority = 'high';
          await Task.db.updateRow(session, task);
        }
      }
    }
  }

  String _generateGreeting(List<Task> tasks, List<Briefing> briefings) {
    final highPriority = tasks.where((t) => t.priority.toLowerCase() == 'high').length;
    final briefingCount = briefings.length;
    
    if (highPriority > 0) {
      return "Good Afternoon, Yogesh. You have $highPriority overdue or high-priority items.";
    } else if (tasks.isNotEmpty) {
      return "Good Afternoon, Yogesh. Ready to flow? ${tasks.length} tasks scheduled.";
    } else {
      return "Good Afternoon, Yogesh. Zero inbox, zero stress. 🌱";
    }
  }

  int _priorityValue(String priority) {
    switch (priority.toLowerCase()) {
      case 'high': return 3;
      case 'medium': return 2;
      case 'low': return 1;
      default: return 1;
    }
  }

  DateTime? _parseDateTime(DateTime date, String timeStr) {
    try {
      // timeStr expected like "5:30 pm"
      // Normalized simple parsing
      var t = timeStr.toLowerCase().trim();
      bool isPm = t.contains('pm');
      t = t.replaceAll('am', '').replaceAll('pm', '').trim();
      final parts = t.split(':');
      int h = int.parse(parts[0]);
      int m = parts.length > 1 ? int.parse(parts[1]) : 0;
      
      if (isPm && h < 12) h += 12;
      if (!isPm && h == 12) h = 0; // 12am

      return DateTime(date.year, date.month, date.day, h, m);
    } catch (e) {
      return null;
    }
  }

  int _compareTimeStrings(String t1, String t2) {
    // Simple lexicographical might fail for "1 PM" vs "11 AM", should parse.
    // For prototype speed, letting basic sort or using above parsing if needed.
    // Better:
    final d1 = _parseDateTime(DateTime.now(), t1);
    final d2 = _parseDateTime(DateTime.now(), t2);
    if (d1 == null || d2 == null) return t1.compareTo(t2);
    return d1.compareTo(d2);
  }

  Future<void> _seedData(Session session) async {
    final now = DateTime.now();
    await Task.db.insert(session, [
      Task(
        title: 'Submit Q3 Report',
        date: now,
        time: '2:00 pm',
        priority: 'high',
        completed: false,
        createdAt: now,
      ),
      Task(
        title: 'Team Sync',
        date: now,
        time: '4:30 pm',
        priority: 'medium',
        completed: false,
        createdAt: now,
      ),
    ]);
    
    await Briefing.db.insert(session, [
      Briefing(
        title: 'Daily Market Update',
        summary: 'Tech stocks up 2%. Fed meeting scheduled for this afternoon.',
        priority: 'medium',
        createdAt: now,
      )
    ]);
  }
}
