import '../models/bike.dart';
import '../models/pass_plan.dart';
import '../models/station.dart';
import '../models/user.dart';
import 'app_seed_data.dart';

class MockDataMapperService {
  const MockDataMapperService._();

  static AppSeedData fromJson(Map<String, dynamic> json) {
    final passPlansJson = _readCollection(json, 'passPlans');
    final stationsJson = _readCollection(json, 'stations');
    final bikesJson = _readCollection(json, 'bikes');
    final userJson = _readMap(json, 'user');

    final bikesByStation = <String, List<BikeSlotModel>>{};
    for (var i = 0; i < bikesJson.length; i++) {
      final bike = _toBike(bikesJson[i], fallbackIndex: i + 1);
      bikesByStation.putIfAbsent(bike.stationId, () => <BikeSlotModel>[]).add(bike);
    }

    for (final entry in bikesByStation.entries) {
      entry.value.sort((a, b) => a.index.compareTo(b.index));
    }

    final passPlans = passPlansJson.map(_toPassPlan).toList(growable: false);
    final stations = stationsJson
        .map((stationJson) {
          final stationId = _readString(stationJson, 'id');
          final bikes = bikesByStation[stationId] ?? const <BikeSlotModel>[];
          return _toStation(stationJson, bikes);
        })
        .toList(growable: false);
    final user = _toUser(userJson);

    return AppSeedData(stations: stations, user: user, passPlans: passPlans);
  }

  static PassPlan _toPassPlan(Map<String, dynamic> json) {
    return PassPlan(
      id: _readString(json, 'id'),
      name: _readString(json, 'name'),
      priceUsd: _readDouble(json, 'priceUsd'),
      billingCycle: _readString(json, 'billingCycle'),
      includedRideMinutes: _readInt(json, 'includedRideMinutes'),
      unlockFeeUsd: _readDouble(json, 'unlockFeeUsd'),
      overagePer30MinUsd: _readDouble(json, 'overagePer30MinUsd'),
      autoRenew: _readRequiredBool(json, 'autoRenew'),
      description: _readString(json, 'description'),
      requiresVerification: _readBool(json, 'requiresVerification', fallback: false),
    );
  }

  static Station _toStation(Map<String, dynamic> json, List<BikeSlotModel> bikes) {
    return Station(
      id: _readString(json, 'id'),
      name: _readString(json, 'name'),
      address: _readString(json, 'address'),
      latitude: _readDouble(json, 'latitude'),
      longitude: _readDouble(json, 'longitude'),
      slots: bikes,
    );
  }

  static BikeSlotModel _toBike(
    Map<String, dynamic> json, {
    required int fallbackIndex,
  }) {
    final isAvailable = _readRequiredBool(json, 'isAvailable');

    return BikeSlotModel(
      id: _readString(json, 'id'),
      stationId: _readString(json, 'stationId'),
      index: _readOptionalInt(json, 'index') ?? fallbackIndex,
      status: isAvailable ? BikeSlotStatus.available : BikeSlotStatus.empty,
    );
  }

  static UrbanUser _toUser(Map<String, dynamic> json) {
    final recentTripsJson = _readCollection(json, 'recentTrips');

    return UrbanUser(
      name: _readString(json, 'name'),
      avatarUrl: _readString(json, 'avatarUrl'),
      totalDistanceKm: _readDouble(json, 'totalDistanceKm'),
      totalRides: _readInt(json, 'totalRides'),
      co2SavedKg: _readDouble(json, 'co2SavedKg'),
      activePass: _readString(json, 'activePass'),
      recentTrips: recentTripsJson.map(_toRecentTrip).toList(growable: false),
    );
  }

  static RecentTrip _toRecentTrip(Map<String, dynamic> json) {
    return RecentTrip(
      routeName: _readString(json, 'routeName'),
      date: _readString(json, 'date'),
      distanceKm: _readDouble(json, 'distanceKm'),
      cost: _readDouble(json, 'cost'),
    );
  }

  static List<Map<String, dynamic>> _readCollection(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is List) {
      return value.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Expected items in "$key" to be JSON objects.');
        }
        return item;
      }).toList(growable: false);
    }

    if (value is Map<String, dynamic>) {
      final entries = value.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      return entries.map((entry) {
        final item = entry.value;
        if (item is! Map<String, dynamic>) {
          throw FormatException(
            'Expected values in "$key" map to be JSON objects.',
          );
        }
        return item;
      }).toList(growable: false);
    }

    throw FormatException('Expected "$key" to be a list or map.');
  }

  static Map<String, dynamic> _readMap(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! Map<String, dynamic>) {
      throw FormatException('Expected "$key" to be an object.');
    }
    return value;
  }

  static String _readString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String) {
      throw FormatException('Expected "$key" to be a string.');
    }
    return value;
  }

  static int _readInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    throw FormatException('Expected "$key" to be a number.');
  }

  static int? _readOptionalInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    throw FormatException('Expected "$key" to be a number when provided.');
  }

  static double _readDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is num) {
      return value.toDouble();
    }
    throw FormatException('Expected "$key" to be a number.');
  }

  static bool _readBool(
    Map<String, dynamic> json,
    String key, {
    required bool fallback,
  }) {
    final value = json[key];
    if (value == null) {
      return fallback;
    }
    if (value is bool) {
      return value;
    }
    throw FormatException('Expected "$key" to be a boolean.');
  }

  static bool _readRequiredBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    throw FormatException('Expected "$key" to be a boolean.');
  }
}
