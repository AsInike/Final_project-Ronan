import 'bike.dart';

class Station {
  const Station({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.slots,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<BikeSlotModel> slots;
}
