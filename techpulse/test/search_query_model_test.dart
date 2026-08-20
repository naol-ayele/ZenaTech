import 'package:flutter_test/flutter_test.dart';
import 'package:techpulse/data/models/search_query_model.dart';

void main() {
  group('SearchQueryModel fromJson', () {
    test('parses full query JSON correctly', () {
      final json = {
        'query': 'flutter',
        'timestamp': '2024-01-15T10:30:00.000Z',
      };

      final query = SearchQueryModel.fromJson(json);

      expect(query.query, 'flutter');
      expect(query.timestamp, DateTime.utc(2024, 1, 15, 10, 30));
    });
  });

  group('SearchQueryModel toJson', () {
    test('produces valid JSON round-trip', () {
      final original = SearchQueryModel(
        query: 'riverpod',
        timestamp: DateTime(2024, 2, 1, 12, 0),
      );

      final json = original.toJson();
      final restored = SearchQueryModel.fromJson(json);

      expect(restored.query, original.query);
      expect(restored.timestamp, original.timestamp);
    });

    test('serializes timestamp as ISO-8601 string', () {
      final query = SearchQueryModel(
        query: 'test',
        timestamp: DateTime(2024, 3, 1, 8, 15),
      );

      final json = query.toJson();

      expect(json['timestamp'], '2024-03-01T08:15:00.000');
    });
  });
}
