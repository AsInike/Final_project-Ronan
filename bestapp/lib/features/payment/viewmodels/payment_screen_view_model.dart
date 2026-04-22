import 'package:flutter/foundation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../models/pass_plan.dart';
import '../../../services/app_state.dart';

class PaymentScreenViewModel extends ChangeNotifier {
  PaymentScreenViewModel(this._appState);

  final AppState _appState;

  int _step = 0;
  bool _isPassFlow = false;

  int get step => _step;
  bool get isPassFlow => _isPassFlow;

  String get title {
    if (_step == 0) {
      return 'Choose Ride Type';
    }
    if (_step == 1) {
      return 'Choose Pass';
    }
    return 'Payment Info';
  }

  List<PassPlan> get passPlans {
    return _appState.passPlans.where((plan) => plan.id != 'single-ride').toList();
  }

  double get totalAmount {
    return _isPassFlow ? _appState.totalPrice : AppConstants.singleRidePrice;
  }

  String get singleRidePriceLabel =>
      '\$${AppConstants.singleRidePrice.toStringAsFixed(2)}';

  void chooseRideType({required bool passFlow}) {
    if (_isPassFlow == passFlow) {
      return;
    }
    _isPassFlow = passFlow;
    notifyListeners();
  }

  void continueFromRideType() {
    _step = _isPassFlow ? 1 : 2;
    notifyListeners();
  }

  void backFromPassSelection() {
    if (_step == 0) {
      return;
    }
    _step = 0;
    notifyListeners();
  }

  void continueFromPassSelection() {
    _step = 2;
    notifyListeners();
  }

  void backFromPayment() {
    _step = _isPassFlow ? 1 : 0;
    notifyListeners();
  }
}
