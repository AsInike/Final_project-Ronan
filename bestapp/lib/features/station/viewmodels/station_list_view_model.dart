import 'package:flutter/foundation.dart';

import '../../../models/bike.dart';
import '../../../models/station.dart';
import '../../../services/app_state.dart';

class StationListViewModel extends ChangeNotifier {
  StationListViewModel(this._appState);

  final AppState _appState;

  List<Station> get stations => _appState.stations;

  int availableBikesForStation(Station station) {
    return station.slots
        .where((slot) => slot.status == BikeSlotStatus.available)
        .length;
  }

  int totalSlotsForStation(Station station) => station.slots.length;

  String usageLabel(Station station) {
    return '${availableBikesForStation(station)}/${totalSlotsForStation(station)} bikes';
  }

  void selectStation(Station station) {
    _appState.selectStation(station);
  }
}
