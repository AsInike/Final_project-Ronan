class AppConstants {
  static const double padding8 = 8;
  static const double padding16 = 16;
  static const double padding24 = 24;

  static const double radius12 = 12;
  static const double radius16 = 16;
  static const double radius20 = 20;

  static const double singleRidePrice = 2.5;
  static const double dailyPassPrice = 9.99;
  static const double weeklyPassPrice = 39.99;
}

enum RidePassType {
  singleRide,
  dailyPass,
  weeklyPass,
}

extension RidePassTypeX on RidePassType {
  String get label {
    switch (this) {
      case RidePassType.singleRide:
        return 'Single Ride';
      case RidePassType.dailyPass:
        return 'Daily Pass';
      case RidePassType.weeklyPass:
        return 'Weekly Pass';
    }
  }

  double get price {
    switch (this) {
      case RidePassType.singleRide:
        return AppConstants.singleRidePrice;
      case RidePassType.dailyPass:
        return AppConstants.dailyPassPrice;
      case RidePassType.weeklyPass:
        return AppConstants.weeklyPassPrice;
    }
  }
}
