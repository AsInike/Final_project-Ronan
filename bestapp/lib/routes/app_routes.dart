import 'package:flutter/material.dart';

import '../features/map/screens/map_screen.dart';
import '../features/payment/screens/payment_screen.dart';
import '../features/payment/screens/payment_success_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/station/screens/station_detail_screen.dart';
import '../features/station/screens/station_list_screen.dart';

class AppRoutes {
  static const String map = '/';
  static const String stationList = '/stations';
  static const String stationDetail = '/station-detail';
  static const String payment = '/payment';
  static const String paymentSuccess = '/payment-success';
  static const String profile = '/profile';

  static void navigateByTab(BuildContext context, int index) {
    final String target;
    switch (index) {
      case 0:
        target = map;
        break;
      case 1:
        target = stationList;
        break;
      case 2:
        target = payment;
        break;
      case 3:
        target = profile;
        break;
      default:
        target = map;
    }

    final currentName = ModalRoute.of(context)?.settings.name;
    if (currentName == target) {
      return;
    }

    Navigator.of(context).pushReplacementNamed(target);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case map:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MapScreen(),
        );
      case stationDetail:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StationDetailScreen(),
        );
      case stationList:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const StationListScreen(),
        );
      case payment:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PaymentScreen(),
        );
      case paymentSuccess:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PaymentSuccessScreen(),
        );
      case profile:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ProfileScreen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MapScreen(),
        );
    }
  }
}
