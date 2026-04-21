import '../models/pass_plan.dart';
import '../models/station.dart';
import '../models/user.dart';

class AppSeedData {
  const AppSeedData({
    required this.stations,
    required this.user,
    required this.passPlans,
  });

  final List<Station> stations;
  final UrbanUser user;
  final List<PassPlan> passPlans;
}
