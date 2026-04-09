import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../models/station.dart';
import '../models/user.dart';
import 'mock_data_service.dart';

class AppState extends ChangeNotifier {
  AppState()
      : _stations = MockDataService.getStations(),
        _user = MockDataService.getUser() {
    _selectedStation = _stations.first;
  }

  final List<Station> _stations;
  final UrbanUser _user;

  late Station _selectedStation;
  RidePassType _selectedPassType = RidePassType.singleRide;
  int _currentNavIndex = 0;

  List<Station> get stations => _stations;
  UrbanUser get user => _user;
  Station get selectedStation => _selectedStation;
  RidePassType get selectedPassType => _selectedPassType;
  int get currentNavIndex => _currentNavIndex;

  double get totalPrice => _selectedPassType.price;

  void selectStation(Station station) {
    if (_selectedStation.id == station.id) {
      return;
    }
    _selectedStation = station;
    notifyListeners();
  }

  void selectPassType(RidePassType type) {
    if (_selectedPassType == type) {
      return;
    }
    _selectedPassType = type;
    notifyListeners();
  }

  void setCurrentNavIndex(int index) {
    if (_currentNavIndex == index) {
      return;
    }
    _currentNavIndex = index;
    notifyListeners();
  }
}
