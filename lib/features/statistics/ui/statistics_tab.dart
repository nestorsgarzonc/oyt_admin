import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oyt_front_widgets/tabs/tab_header.dart';
import 'package:oyt_front_core/theme/theme.dart';
import 'package:oyt_front_widgets/title/section_title.dart';

class StatisticsTab extends ConsumerStatefulWidget {
  const StatisticsTab({super.key});

  @override
  ConsumerState<StatisticsTab> createState() => _StatisticsTab();
}

class _StatisticsTab extends ConsumerState<StatisticsTab> {
  final _scrollController = ScrollController();
  static const _gradientColors = [
    Colors.deepOrange,
    Colors.deepOrangeAccent,
  ];
  final _flLineStyle = FlLine(color: Colors.grey, strokeWidth: 0.2);
  static const _titleStyles = TextStyle(
    color: CustomTheme.greyColor,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TabHeader(
          title: 'Estadísticas',
          subtitle: 'Acá puedes ver las principales metricas de tu restaurante.',
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            child: ListView(
              controller: _scrollController,
              children: [
                const SectionTitle(
                  title: 'Ventas',
                  subtitle: 'Acá puedes ver las ventas de tu restaurante en un periodo de tiempo.',
                ),
                AspectRatio(
                  aspectRatio: 2.6,
                  child: Container(
                    padding: const EdgeInsets.only(right: 18.0, left: 12.0, top: 24, bottom: 12),
                    decoration: CustomTheme.roundedBoxDecoration,
                    child: LineChart(
                      LineChartData(
                        lineTouchData: LineTouchData(
                          enabled: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                final flSpot = barSpot;
                                return LineTooltipItem(
                                  '${flSpot.y.toInt()} ventas',
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: true,
                          horizontalInterval: 1,
                          verticalInterval: 1,
                          getDrawingHorizontalLine: (_) => _flLineStyle,
                          getDrawingVerticalLine: (_) => _flLineStyle,
                        ),
                        titlesData: FlTitlesData(
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                            axisNameSize: 35,
                            axisNameWidget: const Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Text(
                                'Ventas mensuales',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: (value, meta) => SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(value.toInt().toString(), style: _titleStyles),
                              ),
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) => SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(value.toInt().toString(), style: _titleStyles),
                              ),
                              reservedSize: 42,
                            ),
                          ),
                        ),
                        minX: 0,
                        maxX: 11,
                        minY: 0,
                        maxY: 6,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 3),
                              FlSpot(2.6, 2),
                              FlSpot(4.9, 5),
                              FlSpot(6.8, 3.1),
                              FlSpot(8, 4),
                              FlSpot(9.5, 3),
                              FlSpot(11, 4),
                            ],
                            gradient: const LinearGradient(colors: _gradientColors),
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: _gradientColors.map((e) => e.withOpacity(0.3)).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SectionTitle(title: 'Productos'),
              ],
            ),
          ),
        )
      ],
    );
  }
}
