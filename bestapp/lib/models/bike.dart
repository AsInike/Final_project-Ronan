enum BikeSlotStatus {
  available,
  empty,
}

class BikeSlotModel {
  const BikeSlotModel({
    required this.index,
    required this.status,
  });

  final int index;
  final BikeSlotStatus status;
}
