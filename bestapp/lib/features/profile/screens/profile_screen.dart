import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../routes/app_routes.dart';
import '../../../services/app_state.dart';
import '../viewmodels/profile_view_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(appState),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) {
          final user = viewModel.user;

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const CustomAppBar(title: 'User Profile'),
            body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: AppTextStyles.titleMedium.copyWith(fontSize: 30, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF61D3E2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('URBAN EXPLORER', style: AppTextStyles.caption.copyWith(fontSize: 9, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E4C12), Color(0xFF0C1108)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DISTANCE MILESTONE', style: AppTextStyles.caption.copyWith(color: Colors.white54, fontSize: 9)),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      text: user.totalDistanceKm.toStringAsFixed(0),
                      style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary, fontSize: 44, height: 0.9),
                      children: [
                        TextSpan(
                          text: 'km',
                          style: AppTextStyles.heading.copyWith(color: AppColors.primary, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Text('You crossed the equivalent of 8 city loops', style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    value: '${user.totalRides}',
                    unit: '',
                    label: 'TOTAL RIDES',
                    isLime: true,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniStat(
                    value: user.co2SavedKg.toStringAsFixed(1),
                    unit: 'kg',
                    label: 'CO2 SAVED',
                    isLime: false,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewModel.activePassLabel, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                        Text('Active subscription', style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(999)),
                    child: Text('ACTIVE', style: AppTextStyles.caption.copyWith(fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _SectionHeader(title: 'Recent Trips', action: 'VIEW ALL'),
            const SizedBox(height: 8),
            ...viewModel.previewTrips.map(
                  (trip) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFF153C22),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trip.routeName, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                              Text('${trip.date} • ${trip.distanceKm.toStringAsFixed(1)} km', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        Text('\$${trip.cost.toStringAsFixed(2)}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 2),
            const _SettingTile(icon: Icons.credit_card, title: 'Payment Methods'),
            const _SettingTile(icon: Icons.history, title: 'Ride History'),
            const _SettingTile(icon: Icons.support_agent, title: 'Support & Safety'),
            const _SettingTile(icon: Icons.logout, title: 'Logout', isDanger: true),
          ],
        ),
      ),
            bottomNavigationBar: BottomNavBar(
              currentIndex: 3,
              onTap: (index) {
                appState.setCurrentNavIndex(index);
                AppRoutes.navigateByTab(context, index);
              },
            ),
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.value,
    required this.unit,
    required this.label,
    required this.isLime,
  });

  final String value;
  final String unit;
  final String label;
  final bool isLime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: isLime ? AppColors.primary : const Color(0xFFEFF1F3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: value,
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w800),
              children: [
                TextSpan(text: unit, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 9)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.heading),
        const Spacer(),
        Text(action, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    this.isDanger = false,
  });

  final IconData icon;
  final String title;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDanger ? const Color(0xFFFFF0E8) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: isDanger ? AppColors.orange : AppColors.textSecondary, size: 18),
        title: Text(
          title,
          style: AppTextStyles.body.copyWith(
            fontSize: 13,
            color: isDanger ? AppColors.orange : AppColors.textPrimary,
          ),
        ),
        trailing: Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
