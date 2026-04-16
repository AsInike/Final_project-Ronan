import 'dart:math';

import '../models/bike.dart';
import '../models/pass_plan.dart';
import '../models/station.dart';
import '../models/user.dart';

class MockDataService {
  static List<PassPlan> getPassPlans() {
    return const [
      PassPlan(
        id: 'single-ride',
        name: 'Single Ride',
        priceUsd: 3.50,
        billingCycle: 'One-time',
        includedRideMinutes: 30,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 2.00,
        autoRenew: false,
        description: 'For occasional trips with no subscription commitment.',
      ),
      PassPlan(
        id: 'day-pass',
        name: 'Day Pass',
        priceUsd: 11.99,
        billingCycle: '24 hours',
        includedRideMinutes: 45,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 2.00,
        autoRenew: false,
        description: 'Unlimited rides for one day, up to 45 minutes each ride.',
      ),
      PassPlan(
        id: 'weekly-flex',
        name: 'Weekly Flex',
        priceUsd: 24.99,
        billingCycle: 'Weekly',
        includedRideMinutes: 45,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 1.50,
        autoRenew: true,
        description: 'Balanced plan for tourists and short-term commuters.',
      ),
      PassPlan(
        id: 'monthly-commuter',
        name: 'Monthly Commuter',
        priceUsd: 59.99,
        billingCycle: 'Monthly',
        includedRideMinutes: 60,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 1.00,
        autoRenew: true,
        description: 'Best value for frequent city riders and daily commuting.',
      ),
      PassPlan(
        id: 'annual-member',
        name: 'Annual Member',
        priceUsd: 499.00,
        billingCycle: 'Yearly',
        includedRideMinutes: 60,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 0.75,
        autoRenew: true,
        description: 'Lowest long-term cost per month for regular riders.',
      ),
      PassPlan(
        id: 'student-monthly',
        name: 'Student Monthly',
        priceUsd: 39.99,
        billingCycle: 'Monthly',
        includedRideMinutes: 45,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 1.00,
        autoRenew: true,
        description: 'Discounted commuter plan for verified students.',
        requiresVerification: true,
      ),
      PassPlan(
        id: 'business-team',
        name: 'Business Team Pass',
        priceUsd: 79.99,
        billingCycle: 'Monthly',
        includedRideMinutes: 60,
        unlockFeeUsd: 0,
        overagePer30MinUsd: 0.90,
        autoRenew: true,
        description: 'Corporate-focused plan with flexible commuting benefits.',
      ),
    ];
  }

  static List<Station> getStations() {
    const stationSeeds = <_StationSeed>[
      _StationSeed('st1', 'Central Park Hub', '12 Green Ave, Downtown', 37.7749, -122.4194, 20, 12),
      _StationSeed('st2', 'Riverfront Station', '58 Harbor Lane, Midtown', 37.7781, -122.4142, 16, 9),
      _StationSeed('st3', 'Campus Exchange', '201 College St, Uptown', 37.7707, -122.4264, 12, 5),
      _StationSeed('st4', 'Sunset Market Stop', '77 Sunset Blvd, West End', 37.7689, -122.4317, 14, 7),
      _StationSeed('st5', 'Union Square Point', '350 Market St, Downtown', 37.7879, -122.4074, 24, 11),
      _StationSeed('st6', 'Harbor View Dock', '18 Bay Front, Embarcadero', 37.7951, -122.3936, 18, 8),
      _StationSeed('st7', 'City Hall Bikes', '1 Civic Center Plaza', 37.7793, -122.4192, 30, 16),
      _StationSeed('st8', 'Mission Plaza Rack', '245 Mission St', 37.7893, -122.3963, 22, 10),
      _StationSeed('st9', 'SoMa Central', '600 Howard St, SoMa', 37.7868, -122.3996, 28, 15),
      _StationSeed('st10', 'Market Street East', '901 Market St', 37.7845, -122.4078, 20, 9),
      _StationSeed('st11', 'Golden Gate Park East', '1010 Stanyan St', 37.7694, -122.4528, 26, 14),
      _StationSeed('st12', 'Presidio Gate', '2100 Presidio Blvd', 37.7982, -122.4662, 32, 18),
      _StationSeed('st13', 'Ferry Building Stand', '1 Ferry Building', 37.7955, -122.3937, 16, 7),
      _StationSeed('st14', 'North Beach Corner', '801 Columbus Ave', 37.8033, -122.4142, 14, 6),
      _StationSeed('st15', 'Chinatown Cross', '620 Grant Ave', 37.7941, -122.4067, 12, 5),
      _StationSeed('st16', 'Financial District Hub', '405 Montgomery St', 37.7926, -122.4010, 34, 21),
      _StationSeed('st17', 'Castro Station', '18th St & Castro', 37.7609, -122.4350, 20, 11),
      _StationSeed('st18', 'Noe Valley Bikes', '24th St & Sanchez', 37.7517, -122.4290, 10, 4),
      _StationSeed('st19', 'Potrero Junction', '16th St & 3rd St', 37.7663, -122.3888, 18, 8),
      _StationSeed('st20', 'Dogpatch Pier', '22nd St & Illinois', 37.7583, -122.3871, 12, 6),
      _StationSeed('st21', 'Ocean Beach Stop', 'Great Hwy & Balboa', 37.7764, -122.5107, 40, 19),
      _StationSeed('st22', 'Inner Sunset Point', '9th Ave & Irving', 37.7648, -122.4661, 24, 12),
      _StationSeed('st23', 'Bernal Heights Rack', 'Cortland Ave & Bennington', 37.7395, -122.4158, 16, 7),
      _StationSeed('st24', 'Excelsior Hub', 'Mission St & Ocean Ave', 37.7236, -122.4352, 20, 9),
      _StationSeed('st25', 'Balboa Park Transit', 'Balboa Park BART', 37.7214, -122.4475, 22, 10),
      _StationSeed('st26', 'Glen Park Village', 'Diamond St & Bosworth', 37.7331, -122.4342, 14, 5),
      _StationSeed('st27', 'Twin Peaks Base', 'Portola Dr & Twin Peaks Blvd', 37.7512, -122.4477, 18, 8),
      _StationSeed('st28', 'Lakeshore Center', 'Sloat Blvd & 19th Ave', 37.7344, -122.4754, 28, 13),
      _StationSeed('st29', 'West Portal Link', 'West Portal Ave & Ulloa', 37.7406, -122.4662, 12, 6),
      _StationSeed('st30', 'Japan Town Plaza', 'Post St & Webster', 37.7856, -122.4298, 26, 11),
      _StationSeed('st31', 'Fillmore Street Hub', 'Fillmore St & Geary', 37.7840, -122.4324, 30, 15),
      _StationSeed('st32', 'Hayes Valley Stop', 'Hayes St & Gough', 37.7764, -122.4231, 18, 8),
      _StationSeed('st33', 'Civic Center West', 'Fulton St & Larkin', 37.7799, -122.4176, 16, 7),
      _StationSeed('st34', 'Pier 39 Bikes', 'Beach St & The Embarcadero', 37.8087, -122.4098, 24, 12),
    ];

    final random = Random();

    return stationSeeds.map((seed) {
      final location = _randomToulouseLocation(random);

      return Station(
        id: seed.id,
        name: seed.name,
        address: '${location.place}, ${location.city}',
        latitude: location.latitude + _randomOffset(random, 0.035),
        longitude: location.longitude + _randomOffset(random, 0.045),
        totalSlots: seed.totalSlots,
        availableBikes: seed.availableBikes,
        slots: _buildSlots(seed.totalSlots, seed.availableBikes),
      );
    }).toList(growable: false);
  }

  static _FrenchLocation _randomToulouseLocation(Random random) {
    return _toulouseLocations[random.nextInt(_toulouseLocations.length)];
  }

  static double _randomOffset(Random random, double spread) {
    return (random.nextDouble() - 0.5) * spread;
  }

  static List<BikeSlotModel> _buildSlots(int totalSlots, int availableBikes) {
    final safeTotalSlots = totalSlots.clamp(10, 40);
    final safeAvailableBikes = availableBikes.clamp(0, safeTotalSlots);

    return List.generate(
      safeTotalSlots,
      (index) => BikeSlotModel(
        index: index + 1,
        status: index < safeAvailableBikes
            ? BikeSlotStatus.available
            : BikeSlotStatus.empty,
      ),
      growable: false,
    );
  }

  static UrbanUser getUser() {
    return const UrbanUser(
      name: 'Ronan Miller',
      avatarUrl: '',
      totalDistanceKm: 142.6,
      totalRides: 39,
      co2SavedKg: 31.4,
      activePass: 'Monthly Commuter',
      recentTrips: [
        RecentTrip(
          routeName: 'Central Park to Riverfront',
          date: 'Apr 07, 2026',
          distanceKm: 4.2,
          cost: 2.5,
        ),
        RecentTrip(
          routeName: 'University Loop',
          date: 'Apr 05, 2026',
          distanceKm: 7.8,
          cost: 9.99,
        ),
        RecentTrip(
          routeName: 'Sunset District Ride',
          date: 'Apr 02, 2026',
          distanceKm: 3.4,
          cost: 2.5,
        ),
      ],
    );
  }
}

const List<_FrenchLocation> _toulouseLocations = [
  _FrenchLocation('Toulouse', 'Capitole', 43.6045, 1.4440),
  _FrenchLocation('Toulouse', 'Saint-Cyprien', 43.5984, 1.4307),
  _FrenchLocation('Toulouse', 'Matabiau', 43.6110, 1.4531),
  _FrenchLocation('Toulouse', 'Canal du Midi', 43.6075, 1.4521),
  _FrenchLocation('Toulouse', 'Compans-Caffarelli', 43.6129, 1.4346),
  _FrenchLocation('Toulouse', 'Carmes', 43.5989, 1.4457),
  _FrenchLocation('Toulouse', 'Jardin des Plantes', 43.5931, 1.4494),
  _FrenchLocation('Toulouse', 'Saint-Michel', 43.5879, 1.4468),
  _FrenchLocation('Toulouse', 'Minimes', 43.6267, 1.4335),
  _FrenchLocation('Toulouse', 'Purpan', 43.6051, 1.4037),
];

class _StationSeed {
  const _StationSeed(
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.totalSlots,
    this.availableBikes,
  );

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int totalSlots;
  final int availableBikes;
}

class _FrenchLocation {
  const _FrenchLocation(this.city, this.place, this.latitude, this.longitude);

  final String city;
  final String place;
  final double latitude;
  final double longitude;
}
