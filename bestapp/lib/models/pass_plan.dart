class PassPlan {
  const PassPlan({
    required this.id,
    required this.name,
    required this.priceUsd,
    required this.billingCycle,
    required this.includedRideMinutes,
    required this.unlockFeeUsd,
    required this.overagePer30MinUsd,
    required this.autoRenew,
    required this.description,
    this.requiresVerification = false,
  });

  final String id;
  final String name;
  final double priceUsd;
  final String billingCycle;
  final int includedRideMinutes;
  final double unlockFeeUsd;
  final double overagePer30MinUsd;
  final bool autoRenew;
  final String description;
  final bool requiresVerification;
}
