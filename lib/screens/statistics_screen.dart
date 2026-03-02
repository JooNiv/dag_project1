import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

import '../services/settings_service.dart';
import '../services/entry_service.dart';
import '../components/floating_button.dart';
import '../components/screen_base.dart';
import '../components/responsive_widget.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenBase(
        floatingActionButton:
            FloatingButton(route: "/", icon: Icons.arrow_back),
        body: ResponsiveWidget(
            mobile: MobileStatisticsScreen(),
            tablet: TabletStatisticsScreen(),
            desktop: Center(child: SizedBox(width: 1000, child: DesktopStatisticsScreen()))));
  }
}

class DesktopStatisticsScreen extends StatelessWidget {
  const DesktopStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatisticsDashboard(layout: _StatisticsLayout.desktop);
  }
}

class TabletStatisticsScreen extends StatelessWidget {
  const TabletStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatisticsDashboard(layout: _StatisticsLayout.tablet);
  }
}

class MobileStatisticsScreen extends StatelessWidget {
  const MobileStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _StatisticsDashboard(layout: _StatisticsLayout.mobile);
  }
}

enum _StatisticsLayout { mobile, tablet, desktop }

class _StatisticsDashboard extends StatelessWidget {
  const _StatisticsDashboard({required this.layout});

  final _StatisticsLayout layout;

  List<PieChartSectionData> _buildPieSections(Map<String, int> statistics) {
    final sections = <PieChartSectionData>[];
    for (final entry in statistics.entries) {
      final color = Get.find<SettingsService>().getColorSettings()[entry.key] ??
          Colors.grey;
      sections.add(
        PieChartSectionData(
          value: entry.value.toDouble(),
          color: color,
          title: '${entry.key}\n${entry.value}',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }
    return sections;
  }

  List<BarChartGroupData> _buildMonthlyBars(Map<String, int> monthlyStats) {
    final sortedKeys = monthlyStats.keys.toList()..sort();

    return List.generate(sortedKeys.length, (index) {
      final key = sortedKeys[index];
      final value = monthlyStats[key] ?? 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            width: 24,
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(Get.context!).colorScheme.primary,
          ),
        ],
      );
    });
  }

  String _formatMonthLabel(String monthKey) {
    final parts = monthKey.split('-');
    if (parts.length != 2) {
      return monthKey;
    }
    final year = parts[0];
    final month = int.tryParse(parts[1]) ?? 1;
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${monthNames[month - 1]} ${year.substring(2)}';
  }

  Widget _kpiCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  double get _chartHeight {
    if (layout == _StatisticsLayout.mobile) {
      return 240;
    }
    return 260;
  }

  double get _horizontalPadding {
    if (layout == _StatisticsLayout.mobile) {
      return 12;
    }
    if (layout == _StatisticsLayout.tablet) {
      return 16;
    }
    return 24;
  }

  Widget _buildChartCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(height: _chartHeight, child: child),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EntryService>(
      builder: (entryService) {
        final moodStats = entryService.getStatistics();
        final monthlyStats = entryService.getMonthlyStatistics(monthsBack: 6);
        final commentMonthlyStats =
            entryService.getMonthlyCommentStatistics(monthsBack: 6);
        final commentWordStats = entryService.getCommentWordStatistics();
        final totalEntries =
            moodStats.values.fold<int>(0, (sum, count) => sum + count);
        final topMood = moodStats.entries.isEmpty
            ? null
            : (moodStats.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value)))
                .first;

        if (totalEntries == 0) {
          return const Center(
            child:
                Text('No entries yet. Add your first entry to see statistics.'),
          );
        }

        final sortedMonths = monthlyStats.keys.toList()..sort();
        final sortedCommentMonths = commentMonthlyStats.keys.toList()..sort();
        final totalWords = commentWordStats['totalWords'] as int;
        final averageWords = commentWordStats['averageWords'] as double;
        final longestComment = commentWordStats['longestComment'] as String;
        final longestWordCount = commentWordStats['longestWordCount'] as int;

        final moodDistributionCard = _buildChartCard(
          title: 'Mood Distribution',
          child: PieChart(
            PieChartData(
              sections: _buildPieSections(moodStats),
              centerSpaceRadius: 30,
              sectionsSpace: 2,
            ),
          ),
        );

        final entriesPerMonthCard = _buildChartCard(
          title: 'Entries per Month (Last 6 Months)',
          child: BarChart(
            BarChartData(
              barGroups: _buildMonthlyBars(monthlyStats),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor:
                      Colors.deepPurple,
                  tooltipRoundedRadius: 8,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    return BarTooltipItem(
                      rod.toY.toStringAsFixed(0),
                      const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value % 1 != 0) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= sortedMonths.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          _formatMonthLabel(sortedMonths[index]),
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );

        final commentsPerMonthCard = _buildChartCard(
          title: 'Comments per Month',
          child: commentMonthlyStats.isEmpty
              ? const Center(
                  child: Text('No comments yet for this period.'),
                )
              : BarChart(
                  BarChartData(
                    barGroups: _buildMonthlyBars(commentMonthlyStats),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor:
                            Colors.deepPurple,
                        tooltipRoundedRadius: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            rod.toY.toStringAsFixed(0),
                            const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          );
                        },
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: true),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value % 1 != 0) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              value.toInt().toString(),
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 ||
                                index >= sortedCommentMonths.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _formatMonthLabel(sortedCommentMonths[index]),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
        );

        final wordInsightCard = Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comment Word Insights',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _metricRow('Total number of words', '$totalWords'),
                _metricRow('Average words', averageWords.toStringAsFixed(1)),
                _metricRow(
                  'Longest Comment',
                  longestComment.isEmpty
                      ? '-'
                      : '($longestWordCount words) ${longestComment.length > 90 ? '${longestComment.substring(0, 90)}...' : longestComment}',
                ),
              ],
            ),
          ),
        );

        return SingleChildScrollView(
          padding: EdgeInsets.all(_horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (layout == _StatisticsLayout.mobile) ...[
                _kpiCard(
                  title: 'Total Entries',
                  value: '$totalEntries',
                  icon: Icons.notes,
                ),
                const SizedBox(height: 12),
                _kpiCard(
                  title: 'Distinct Moods',
                  value: '${moodStats.length}',
                  icon: Icons.palette,
                ),
                const SizedBox(height: 12),
                _kpiCard(
                  title: 'Top Mood',
                  value: topMood == null
                      ? '-'
                      : '${topMood.key} (${topMood.value})',
                  icon: Icons.emoji_emotions,
                ),
              ] else ...[
                Row(
                  children: [
                    Expanded(
                      child: _kpiCard(
                        title: 'Total Entries',
                        value: '$totalEntries',
                        icon: Icons.notes,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _kpiCard(
                        title: 'Distinct Moods',
                        value: '${moodStats.length}',
                        icon: Icons.palette,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _kpiCard(
                        title: 'Top Mood',
                        value: topMood == null
                            ? '-'
                            : '${topMood.key} (${topMood.value})',
                        icon: Icons.emoji_emotions,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              if (layout == _StatisticsLayout.mobile) ...[
                moodDistributionCard,
                const SizedBox(height: 16),
                entriesPerMonthCard,
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: moodDistributionCard),
                    const SizedBox(width: 16),
                    Expanded(child: entriesPerMonthCard),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              if (layout == _StatisticsLayout.mobile) ...[
                commentsPerMonthCard,
                const SizedBox(height: 16),
                wordInsightCard,
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: commentsPerMonthCard),
                    const SizedBox(width: 16),
                    Expanded(child: wordInsightCard),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
