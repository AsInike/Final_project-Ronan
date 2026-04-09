class RecentTrip {
  const RecentTrip({
    required this.routeName,
    required this.date,
    required this.distanceKm,
    required this.cost,
  });

  final String routeName;
  final String date;
  final double distanceKm;
  final double cost;
}

class UrbanUser {
  const UrbanUser({
    required this.name,
    required this.avatarUrl,
    required this.totalDistanceKm,
    required this.totalRides,
    required this.co2SavedKg,
    required this.activePass,
    required this.recentTrips,
  });

  final String name;
  final String avatarUrl;
  final double totalDistanceKm;
  final int totalRides;
  final double co2SavedKg;
  final String activePass;
  final List<RecentTrip> recentTrips;
}
