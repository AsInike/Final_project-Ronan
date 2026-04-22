enum BikeSlotStatus {
  available,
  empty,
}

class BikeSlotModel {
  const BikeSlotModel({
    required this.id,
    required this.stationId,
    required this.index,
    required this.status,
  });

  final String id;
  final String stationId;
  final int index;
  final BikeSlotStatus status;
}
