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

  UrbanUser copyWith({
    String? name,
    String? avatarUrl,
    double? totalDistanceKm,
    int? totalRides,
    double? co2SavedKg,
    String? activePass,
    List<RecentTrip>? recentTrips,
  }) {
    return UrbanUser(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
      totalRides: totalRides ?? this.totalRides,
      co2SavedKg: co2SavedKg ?? this.co2SavedKg,
      activePass: activePass ?? this.activePass,
      recentTrips: recentTrips ?? this.recentTrips,
    );
  }
}
