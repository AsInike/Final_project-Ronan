import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'app_seed_data.dart';
import 'mock_data_mapper_service.dart';

class MockDataService {
  const MockDataService._();

  static const String firebaseRealtimeDbBaseUrl =
      'https://g2t9-firebase-default-rtdb.firebaseio.com';
  static const String _defaultMockAssetPath = 'assets/data/mock_data.json';

  static Future<AppSeedData> loadSeedData({String? assetPath}) async {
    final firebaseData = await _loadSeedDataFromFirebase();
    if (firebaseData != null) {
      return firebaseData;
    }

    return _loadSeedDataFromAsset(assetPath: assetPath);
  }

  static Future<AppSeedData?> _loadSeedDataFromFirebase() async {
    try {
      final response = await http.get(Uri.parse('$firebaseRealtimeDbBaseUrl/.json'));
      if (response.statusCode != 200) {
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return null;
      }

      final payload = _extractPayload(decoded);
      if (payload == null) {
        return null;
      }

      return MockDataMapperService.fromJson(payload);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? _extractPayload(Map<String, dynamic> decoded) {
    if (_looksLikeSeedData(decoded)) {
      return decoded;
    }

    final nestedCandidates = [decoded['seedData'], decoded['mockData'], decoded['data']];
    for (final candidate in nestedCandidates) {
      if (candidate is Map<String, dynamic> && _looksLikeSeedData(candidate)) {
        return candidate;
      }
    }

    return null;
  }

  static bool _looksLikeSeedData(Map<String, dynamic> json) {
    return json.containsKey('passPlans') &&
        json.containsKey('stations') &&
        json.containsKey('bikes') &&
        json.containsKey('user');
  }

  static Future<AppSeedData> _loadSeedDataFromAsset({String? assetPath}) async {
    final jsonContent = await rootBundle.loadString(assetPath ?? _defaultMockAssetPath);
    final decoded = jsonDecode(jsonContent);

    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Top-level JSON must be an object.');
    }

    return MockDataMapperService.fromJson(decoded);
  }
}
