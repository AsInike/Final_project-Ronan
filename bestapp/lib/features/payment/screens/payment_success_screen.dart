import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';
import '../../../services/app_state.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Payment Success', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.success,
                    child: Icon(Icons.check, color: AppColors.textPrimary, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text('Payment Successful!', style: AppTextStyles.heading),
                  const SizedBox(height: 4),
                  Text(
                    'Your ${state.selectedPassPlan.name} is now active.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC2EEF7), Color(0xFF9BD3E3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.deepGreen,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'ACTIVE PASS',
                            style: AppTextStyles.caption.copyWith(color: Colors.white, fontSize: 9),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Urban Explorer', style: AppTextStyles.heading),
                        Text(state.selectedPassPlan.name, style: AppTextStyles.body),
                        const SizedBox(height: 6),
                        Text('\$${state.totalPrice.toStringAsFixed(2)}', style: AppTextStyles.heading),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: AppColors.empty,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.qr_code_2, size: 36),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Show this code at station to scan directly on the bike screen.',
                          style: AppTextStyles.caption,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    label: 'Confirm Bike Booking',
                    icon: Icons.pedal_bike,
                    onPressed: () {
                      state.setCurrentNavIndex(3);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.profile,
                        (route) => route.settings.name == AppRoutes.map,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('View Receipt', style: AppTextStyles.caption),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          state.setCurrentNavIndex(index);
          AppRoutes.navigateByTab(context, index);
        },
      ),
    );
  }
}
