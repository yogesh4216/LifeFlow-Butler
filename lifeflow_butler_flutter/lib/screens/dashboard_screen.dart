import 'package:flutter/material.dart';
import 'package:lifeflow_butler_client/lifeflow_butler_client.dart';
import '../core/theme/app_colors.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/priority_tasks_widget.dart';
import '../widgets/briefings_widget.dart';
import '../widgets/calendar_strip.dart';
import '../widgets/quick_add_fab.dart';
import 'integrations_screen.dart';
import 'history_screen.dart';
import '../main.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DailyOverview? _dailyOverview;
  bool _isLoading = true;
  String? _error;
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isFocusMode = false;
  
  // Demo State
  bool _isGmailConnected = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_dailyOverview == null) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }

    try {
      final result = await client.butler.getDailyOverview();
      setState(() {
        _dailyOverview = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _onAddTask(Task task) async {
    try {
      await client.butler.addTask(task);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added successfully!')));
      }
      _fetchData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding task: $e')));
      }
    }
  }

  Future<void> _onToggleTask(Task task) async {
    setState(() {}); 
    try {
      await client.butler.updateTask(task);
      _fetchData();
    } catch (e) {
      setState(() {
        task.completed = !task.completed;
      });
    }
  }

  Future<void> _onDeleteTask(int id) async {
    try {
      await client.butler.deleteTask(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task deleted.')));
      }
      _fetchData();
    } catch (e) {
    }
  }

  void _onConnectGmail() {
     _showIntegrationsScreen(context);
  }

  Future<void> _simulateEmailTasks() async {
     // Create mock tasks derived from emails
     final now = DateTime.now();
     final tasks = [
       Task(
         title: 'Review: Project Alpha Contract (via Email)',
         date: now,
         time: '5:00 pm',
         priority: 'high',
         completed: false,
         createdAt: now,
       ),
       Task(
         title: 'Reply to Sarah: Lunch Logistics',
         date: now,
         time: '12:30 pm',
         priority: 'medium',
         completed: false,
         createdAt: now,
       ),
     ];

     for (var t in tasks) {
       await client.butler.addTask(t);
     }
     
     if (mounted) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('Synced 2 new tasks from Gmail 📨')),
       );
     }
     _fetchData();
  }

  void _showIntegrationsScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IntegrationsScreen(
          isConnected: _isGmailConnected,
          onConnectionChanged: (isConnected) async {
            setState(() {
              _isGmailConnected = isConnected;
            });
            if (isConnected) {
               await _simulateEmailTasks();
            }
          },
        ),
      ),
    );
  }

  void _showProfileSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingsItem(Icons.settings, 'Settings', () {}),
              _buildSettingsItem(Icons.extension, 'Integrations', () {
                Navigator.pop(context);
                _showIntegrationsScreen(context);
              }),
              _buildSettingsItem(Icons.center_focus_strong, 'Start Focus Mode', () {
                Navigator.pop(context);
                setState(() => _isFocusMode = true);
              }),
              _buildSettingsItem(Icons.logout, 'Log Out', () {}, isDestructive: true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
     return ListTile(
       leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.textPrimary),
       title: Text(title, style: TextStyle(color: isDestructive ? AppColors.error : AppColors.textPrimary)),
       onTap: onTap,
       trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
     );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _dailyOverview == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    if (_error != null) {
       return Scaffold(body: Center(child: Text('Error: $_error', style: const TextStyle(color: AppColors.error))));
    }

    final overview = _dailyOverview!;
    
    final isToday = _selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month;
    
    final filteredTasks = overview.tasks.where((t) {
      if (_searchQuery.isNotEmpty) {
        return t.title.toLowerCase().contains(_searchQuery);
      }
      final isSameDay = t.date.year == _selectedDate.year && 
                        t.date.month == _selectedDate.month && 
                        t.date.day == _selectedDate.day;
      if (isSameDay) return true;
      if (isToday && t.priority == 'high' && t.date.isBefore(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day))) {
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(
                      greeting: overview.greeting,
                      onProfileTap: () => _showProfileSettings(context),
                      onHistoryTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                    ),
                    const SizedBox(height: 24),
                    
                    if (!_isFocusMode) ...[
                       Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.search, color: AppColors.textSecondary),
                            hintText: 'Search...',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ] else
                       Center(
                        child: ElevatedButton.icon(
                            onPressed: () => setState(() => _isFocusMode = false),
                            icon: const Icon(Icons.close),
                            label: const Text('Exit Focus Mode'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (!_isFocusMode)
                    CalendarStrip(
                      selectedDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                    ),
                    
                  if (!_isFocusMode) const SizedBox(height: 24),

                  PriorityTasksWidget(
                    tasks: filteredTasks,
                    onToggle: _onToggleTask,
                    onDelete: (id) => _onDeleteTask(id),
                  ),

                  if (!_isFocusMode) ...[
                    const SizedBox(height: 24),
                    BriefingsWidget(
                      briefings: overview.briefings,
                      isConnected: _isGmailConnected,
                      onConnectTap: _onConnectGmail,
                    ),
                  ],
                  const SizedBox(height: 80), 
                ]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: !_isFocusMode ? QuickAddFAB(onTaskParsed: _onAddTask) : null,
    );
  }
}
