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

  int get totalSlots => slots.length;

  int get availableBikes =>
      slots.where((slot) => slot.status == BikeSlotStatus.available).length;

  int get unavailableBikes => totalSlots - availableBikes;
}
