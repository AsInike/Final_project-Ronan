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
      child: isAvailable
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.pedal_bike,
                  color: AppColors.available,
                ),
                const SizedBox(height: 6),
                Text('Slot $slotNumber', style: AppTextStyles.caption),
              ],
            )
          : Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.orange.withValues(alpha: 0.15),
                border: Border.all(color: AppColors.orange),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'P',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.orange,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );
  }
}
