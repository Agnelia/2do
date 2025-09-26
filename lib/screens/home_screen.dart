import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/reminder_provider.dart';
import 'package:todo_health_reminders/providers/statistics_provider.dart';
import 'package:todo_health_reminders/widgets/reminder_card.dart';
import 'package:todo_health_reminders/widgets/statistics_chart.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';
import 'package:todo_health_reminders/screens/add_reminder_screen.dart';
import 'package:todo_health_reminders/screens/statistics_screen.dart';
import 'package:todo_health_reminders/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('2do Health Reminders'),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Show notifications
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboard(),
            const StatisticsScreen(),
            _buildProfile(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              selectedIcon: Icon(Icons.analytics),
              label: 'Statistics',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddReminderScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }

  Widget _buildDashboard() {
    return Consumer<ReminderProvider>(
      builder: (context, reminderProvider, child) {
        final upcomingReminders = reminderProvider.upcomingReminders;
        
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 16),
                    _buildQuickStats(),
                    const SizedBox(height: 24),
                    Text(
                      'Today\'s Reminders',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (upcomingReminders.isEmpty)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.self_improvement,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No reminders for today!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tap the + button to add your first health reminder',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final reminder = upcomingReminders[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: ReminderCard(reminder: reminder),
                    );
                  },
                  childCount: upcomingReminders.length,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good day!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Keep up with your health goals',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Consumer<StatisticsProvider>(
      builder: (context, statsProvider, child) {
        return SizedBox(
          height: 120,
          child: Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Completed Today',
                  statsProvider.completedToday.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Weekly Streak',
                  '${statsProvider.weeklyStreak} days',
                  Icons.local_fire_department,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatCard(
                  'Health Score',
                  '${statsProvider.healthScore}%',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.person),
            title: Text('User Profile'),
            subtitle: Text('Manage your account settings'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            subtitle: const Text('App preferences and theme'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            subtitle: Text('Manage notification preferences'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.backup),
            title: Text('Data Backup'),
            subtitle: Text('Backup and restore your data'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Help & Support'),
            subtitle: Text('Get help and contact support'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}