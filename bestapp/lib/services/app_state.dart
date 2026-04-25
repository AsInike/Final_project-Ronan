import 'package:flutter/foundation.dart';

import '../models/pass_plan.dart';
import '../models/station.dart';
import '../models/user.dart';
import 'app_seed_data.dart';

class AppState extends ChangeNotifier {
  AppState.fromSeedData(AppSeedData seedData)
      : _stations = seedData.stations,
        _user = seedData.user,
        _passPlans = seedData.passPlans {
    _selectedStation = _stations.first;
    _selectedPassPlan = _passPlans.firstWhere(
      (plan) => plan.id == 'day-pass',
      orElse: () => _passPlans.first,
    );
  }

  final List<Station> _stations;
  UrbanUser _user;
  final List<PassPlan> _passPlans;

  late Station _selectedStation;
  late PassPlan _selectedPassPlan;
  int _currentNavIndex = 0;
  bool _hasSelectedStationForBooking = false;
  bool _hasStartedRentFlow = false;

  List<Station> get stations => _stations;
  UrbanUser get user => _user;
  List<PassPlan> get passPlans => _passPlans;
  Station get selectedStation => _selectedStation;
  PassPlan get selectedPassPlan => _selectedPassPlan;
  int get currentNavIndex => _currentNavIndex;
  bool get hasSelectedStationForBooking => _hasSelectedStationForBooking;
  bool get hasStartedRentFlow => _hasStartedRentFlow;
  bool get canContinuePaymentFlow =>
      _hasSelectedStationForBooking && _hasStartedRentFlow;

  double get totalPrice => _selectedPassPlan.priceUsd;

  void selectStation(Station station) {
    if (_selectedStation.id == station.id) {
      if (_hasSelectedStationForBooking) {
        return;
      }
      _hasSelectedStationForBooking = true;
      return;
    }
    _selectedStation = station;
    _hasSelectedStationForBooking = true;
    _hasStartedRentFlow = false;
    notifyListeners();
  }

  void startRentFlow() {
    if (!_hasSelectedStationForBooking || _hasStartedRentFlow) {
      return;
    }
    _hasStartedRentFlow = true;
    notifyListeners();
  }

  void selectPassPlan(PassPlan plan) {
    if (_selectedPassPlan.id == plan.id) {
      return;
    }
    _selectedPassPlan = plan;
    notifyListeners();
  }

  void setCurrentNavIndex(int index) {
    if (_currentNavIndex == index) {
      return;
    }
    _currentNavIndex = index;
    notifyListeners();
  }

  void recordRide() {
    _user = _user.copyWith(totalRides: _user.totalRides + 1);
    _hasStartedRentFlow = false;
    notifyListeners();
  }
}
