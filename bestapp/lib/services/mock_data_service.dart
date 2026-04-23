import 'dart:convert';

import 'package:http/http.dart' as http;

import 'app_seed_data.dart';
import 'mock_data_mapper_service.dart';

class MockDataService {
  const MockDataService._();

  static const String firebaseRealtimeDbBaseUrl =
      'https://g2t9-firebase-default-rtdb.firebaseio.com';

  static Future<AppSeedData> loadSeedData() async {
    final response = await http.get(
      Uri.parse('$firebaseRealtimeDbBaseUrl/.json'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load seed data from Firebase (status: ${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Firebase payload must be a top-level JSON object.',
      );
    }

    return MockDataMapperService.fromJson(decoded);
  }
}
