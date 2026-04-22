import 'package:flutter/foundation.dart';

import '../../../models/bike.dart';
import '../../../models/station.dart';
import '../../../services/app_state.dart';

class StationDetailViewModel extends ChangeNotifier {
  StationDetailViewModel(this._appState);

  final AppState _appState;

  Station get station => _appState.selectedStation;

  int get totalSlots => station.slots.length;

  int get availableBikes =>
      station.slots.where((slot) => slot.status == BikeSlotStatus.available).length;

  bool get hasAvailableBikes => availableBikes > 0;

  String get capacityLabel => '$availableBikes / $totalSlots';

  int get totalRows => (station.slots.length + 1) ~/ 2;
}
