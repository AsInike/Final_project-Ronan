import 'package:flutter/foundation.dart';

import '../../../models/user.dart';
import '../../../services/app_state.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel(this._appState);

  final AppState _appState;

  UrbanUser get user => _appState.user;

  List<RecentTrip> get previewTrips => user.recentTrips.take(2).toList();

  String get activePassLabel => user.activePass;
}
