import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../models/bike.dart';
import '../../../routes/app_routes.dart';
import '../../../services/app_state.dart';

class StationDetailScreen extends StatelessWidget {
  const StationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final station = state.selectedStation;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Station Detail', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.padding16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE9ECEE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('CAPACITY', style: AppTextStyles.caption.copyWith(fontSize: 9)),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: '${station.availableBikes} / ${station.totalSlots}',
                          style: AppTextStyles.heading.copyWith(fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(
                              text: ' slots available',
                              style: AppTextStyles.caption.copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.pedal_bike, size: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Bike Station', style: AppTextStyles.heading),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
                    child: Text("Bike Slots Top view", style: AppTextStyles.caption),
                  ),
                  ...List.generate((station.slots.length / 2).ceil(), (row) {
                    final left = station.slots[row * 2];
                    final BikeSlotModel? right = row * 2 + 1 < station.slots.length
                        ? station.slots[row * 2 + 1]
                        : null;
                    return Container(
                      height: 40,
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.textPrimary, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _TableBikeCell(slot: left),
                          ),
                          const VerticalDivider(width: 1, thickness: 1, color: AppColors.textPrimary),
                          Expanded(
                            child: right != null
                                ? _TableBikeCell(slot: right)
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 22),
            CustomButton(
              label: 'Rent Now',
              icon: Icons.electric_bike,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.payment),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          state.setCurrentNavIndex(index);
          AppRoutes.navigateByTab(context, index);
        },
      ),
    );
  }
}

class _TableBikeCell extends StatelessWidget {
  const _TableBikeCell({required this.slot});

  final BikeSlotModel slot;

  @override
  Widget build(BuildContext context) {
    final isAvailable = slot.status == BikeSlotStatus.available;
    if (isAvailable) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(
              'Available',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.available,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            const Icon(Icons.pedal_bike, size: 16),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        width: 22,
        height: 22,
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
