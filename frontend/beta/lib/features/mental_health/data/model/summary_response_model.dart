// models/summary_response.dart
import 'package:beta/features/mental_health/data/model/summary_stats_model.dart';


class SummaryResponse {
  final String summary;
  final SummaryStats stats;

  SummaryResponse({
    required this.summary,
    required this.stats,
  });

  factory SummaryResponse.fromJson(Map<String, dynamic> json) {
    return SummaryResponse(
      summary: json['summary'],
      stats: SummaryStats.fromJson(json['stats']),
    );
  }
}
