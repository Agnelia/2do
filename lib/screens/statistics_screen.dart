import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_health_reminders/providers/statistics_provider.dart';
import 'package:todo_health_reminders/providers/theme_provider.dart';
import 'package:todo_health_reminders/widgets/statistics_chart.dart';
import 'package:todo_health_reminders/widgets/progress_ring.dart';
import 'package:todo_health_reminders/widgets/responsive_layout.dart';
import 'package:todo_health_reminders/utils/constants.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'Week';

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      child: Consumer<StatisticsProvider>(
        builder: (context, statsProvider, child) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Health Statistics',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'Week',
                                label: Text('Week'),
                              ),
                              ButtonSegment(
                                value: 'Month',
                                label: Text('Month'),
                              ),
                              ButtonSegment(
                                value: 'Year',
                                label: Text('Year'),
                              ),
                            ],
                            selected: {_selectedPeriod},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _selectedPeriod = newSelection.first;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildOverviewCards(statsProvider),
                      const SizedBox(height: 24),
                      _buildProgressSection(statsProvider),
                      const SizedBox(height: 24),
                      _buildChartSection(statsProvider),
                      const SizedBox(height: 24),
                      _buildCategoryBreakdown(statsProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(StatisticsProvider statsProvider) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        final isSunnyTheme = themeProvider.currentTheme == AppThemeType.sunnyDay;
        
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildOverviewCard(
              'Total Completed',
              statsProvider.totalCompleted.toString(),
              Icons.task_alt,
              isSunnyTheme ? const Color(0xFF4CAF50) : Colors.green,
              isSunnyTheme,
            ),
            _buildOverviewCard(
              'Success Rate',
              '${statsProvider.successRate.toStringAsFixed(1)}%',
              Icons.trending_up,
              isSunnyTheme ? const Color(0xFF2196F3) : Colors.blue,
              isSunnyTheme,
            ),
            _buildOverviewCard(
              'Best Streak',
              '${statsProvider.bestStreak} days',
              Icons.local_fire_department,
              isSunnyTheme ? const Color(0xFFFF9800) : Colors.orange, // Yellow-orange instead of pinkish
              isSunnyTheme,
            ),
            _buildOverviewCard(
              'Health Score',
              '${statsProvider.healthScore}%',
              Icons.favorite,
              isSunnyTheme ? const Color(0xFFE53935) : Colors.red, // Really red heart for sunny theme
              isSunnyTheme,
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color, bool isSunnyTheme) {
    return Card(
      elevation: isSunnyTheme ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: isSunnyTheme ? const EdgeInsets.all(8) : null,
              decoration: isSunnyTheme ? BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ) : null,
              child: Icon(
                icon, 
                color: color, 
                size: isSunnyTheme ? 40 : 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: isSunnyTheme ? 22 : null,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSunnyTheme ? FontWeight.w600 : null,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(StatisticsProvider statsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ProgressRing(
                    progress: statsProvider.dailyProgress,
                    size: 100,
                    strokeWidth: 8,
                    color: Colors.teal,
                    backgroundColor: Colors.grey.shade300,
                    child: Text(
                      '${(statsProvider.dailyProgress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProgressItem(
                        'Completed',
                        statsProvider.completedToday,
                        statsProvider.totalToday,
                        Colors.green,
                      ),
                      const SizedBox(height: 8),
                      _buildProgressItem(
                        'Remaining',
                        statsProvider.totalToday - statsProvider.completedToday,
                        statsProvider.totalToday,
                        Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      _buildProgressItem(
                        'Overdue',
                        statsProvider.overdueToday,
                        statsProvider.totalToday,
                        Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, int current, int total, Color color) {
    final percentage = total > 0 ? (current / total) : 0.0;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label: $current',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          '${(percentage * 100).toInt()}%',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildChartSection(StatisticsProvider statsProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_selectedPeriod Overview',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: StatisticsChart(
                period: _selectedPeriod,
                data: statsProvider.getChartData(_selectedPeriod),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown(StatisticsProvider statsProvider) {
    final categories = statsProvider.categoryBreakdown;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...categories.entries.map((entry) {
              final percentage = statsProvider.getCategoryPercentage(entry.key);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getCategoryColor(entry.key),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    final index = category.hashCode % colors.length;
    return colors[index.abs()];
  }
}