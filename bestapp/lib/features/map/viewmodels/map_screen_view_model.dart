import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/bike.dart';
import '../../../models/station.dart';
import '../../../services/app_state.dart';

class MapScreenViewModel extends ChangeNotifier {
  MapScreenViewModel(this._appState);

  final AppState _appState;

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  List<Station> get filteredStations {
    final normalized = _searchQuery.trim().toLowerCase();
    if (normalized.isEmpty) {
      return _appState.stations;
    }
    return _appState.stations
        .where((station) => station.name.toLowerCase().contains(normalized))
        .toList();
  }

  LatLng get initialCenter {
    final stations = filteredStations;
    if (stations.isNotEmpty) {
      return LatLng(stations.first.latitude, stations.first.longitude);
    }
    return const LatLng(37.7749, -122.4194);
  }

  int availableBikesForStation(Station station) {
    return station.slots
        .where((slot) => slot.status == BikeSlotStatus.available)
        .length;
  }

  bool stationHasNoBikes(Station station) {
    return availableBikesForStation(station) == 0;
  }

  void onSearchChanged(String value) {
    if (_searchQuery == value) {
      return;
    }
    _searchQuery = value;
    notifyListeners();
  }
}
