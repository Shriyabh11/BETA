// lib/models/summary_stats.dart
class SummaryStats {
  final int totalEntries;
  final int depressionCount;
  final String lastUpdated;

  SummaryStats({
    required this.totalEntries,
    required this.depressionCount,
    required this.lastUpdated,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    return SummaryStats(
      totalEntries: json['total_entries'],
      depressionCount: json['depression_count'],
      lastUpdated: json['last_updated'],
    );
  }
}
