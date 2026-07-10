import '../../domain/entities/search_query.dart';

class SearchQueryModel extends SearchQuery {
  const SearchQueryModel({required super.query, required super.timestamp});

  factory SearchQueryModel.fromJson(Map<String, dynamic> json) {
    return SearchQueryModel(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {'query': query, 'timestamp': timestamp.toIso8601String()};
  }
}
