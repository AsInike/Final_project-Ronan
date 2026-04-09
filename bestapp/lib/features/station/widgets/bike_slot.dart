import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../models/bike.dart';

class BikeSlot extends StatelessWidget {
  const BikeSlot({
    required this.slotNumber,
    required this.status,
    super.key,
  });

  final int slotNumber;
  final BikeSlotStatus status;

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = status == BikeSlotStatus.available;
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isAvailable ? AppColors.available.withValues(alpha: 0.15) : AppColors.empty,
        borderRadius: BorderRadius.circular(AppConstants.radius12),
        border: Border.all(
          color: isAvailable ? AppColors.available : AppColors.border,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAvailable ? Icons.pedal_bike : Icons.block,
            color: isAvailable ? AppColors.available : AppColors.textSecondary,
          ),
          const SizedBox(height: 6),
          Text('Slot $slotNumber', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
