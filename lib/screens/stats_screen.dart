import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:timer/widgets/app_drawer.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String selectedTab = "Weekly";

  // 🔹 Mock data (backend bağlanınca burası API'den gelecek)
  final Map<String, double> dailyFocus = {
    "Mon": 1.0,
    "Tue": 1.5,
    "Wed": 0.5,
    "Thu": 2.0,
    "Fri": 1.5,
    "Sat": 1.3,
    "Sun": 1.0,
  };

  final Map<String, double> tagDistribution = {
    "Work": 40,
    "Personal": 30,
    "Study": 20,
    "Other": 10,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Statistics"), centerTitle: true),
      drawer: const AppDrawer(currentRoute: "/stats"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // ---------- Activity Title + Tabs ----------
            // ---------- Activity Title + Tabs ----------
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    "Your Activity",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: ["Weekly", "Monthly", "All"].map((tab) {
                      final isSelected = selectedTab == tab;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(tab),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() => selectedTab = tab);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 12),

                  // Eğer sağda başka ikonlar/menü koyacaksan buraya ekleyebilirsin
                ],
              ),
            ),
            // ---------- Total Focus Time ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Focus Time",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "7h 45m",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Bar Chart ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = dailyFocus.keys.toList();
                          if (value.toInt() < 0 ||
                              value.toInt() >= days.length) {
                            return const SizedBox();
                          }
                          return Text(
                            days[value.toInt()],
                            style: theme.textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(dailyFocus.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: dailyFocus.values.toList()[i],
                          color: colorScheme.primary,
                          width: 18,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ---------- Tag Distribution ----------
            // ---------- Tag Distribution ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tag Distribution",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // 🔹 Pie Chart (solda, ince halka)
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: PieChart(
                          PieChartData(
                            sections: tagDistribution.entries.map((entry) {
                              final color = _getTagColor(
                                entry.key,
                                colorScheme,
                              );
                              return PieChartSectionData(
                                value: entry.value,
                                title: "",
                                color: color,
                                radius: 20, // 🔹 halka kalınlığını küçülttük
                              );
                            }).toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius:
                                50, // 🔹 ortayı büyüttük, halka inceldi
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // 🔹 Legend (sağda, alt alta)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: tagDistribution.keys.map((tag) {
                            final color = _getTagColor(tag, colorScheme);
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "$tag (${tagDistribution[tag]?.toInt()}%)",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Etiket rengi seçici
  Color _getTagColor(String tag, ColorScheme scheme) {
    switch (tag) {
      case "Work":
        return Colors.blue;
      case "Personal":
        return Colors.purple;
      case "Study":
        return Colors.orange;
      case "Other":
        return Colors.green;
      default:
        return scheme.primary;
    }
  }
}
