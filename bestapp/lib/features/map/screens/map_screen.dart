import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../routes/app_routes.dart';
import '../../../services/app_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stationsData = context.select((AppState state) => state.stations);
    final stations = stationsData
        .where(
          (station) => station.name
              .toLowerCase()
              .contains(_searchController.text.trim().toLowerCase()),
        )
        .toList();

      final center = stations.isNotEmpty
        ? LatLng(stations.first.latitude, stations.first.longitude)
        : const LatLng(37.7749, -122.4194);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              color: AppColors.surface,
              child: Row(
                children: [
                  const Icon(Icons.menu, size: 18, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    'UrbanPulse',
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Icon(Icons.person, size: 16, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: center,
                          initialZoom: 13.2,
                          minZoom: 4,
                          maxZoom: 19,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.bestapp',
                          ),
                          MarkerLayer(
                            markers: stations
                                .map(
                                  (station) => Marker(
                                    point: LatLng(station.latitude, station.longitude),
                                    width: 54,
                                    height: 28,
                                    child: GestureDetector(
                                      onTap: () {
                                        final state = context.read<AppState>();
                                        state.selectStation(station);
                                        Navigator.pushNamed(context, AppRoutes.stationDetail);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: station.availableBikes == 0
                                              ? AppColors.lightOrange
                                              : AppColors.primary,
                                          borderRadius: BorderRadius.circular(999),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x22000000),
                                              blurRadius: 6,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.pedal_bike, size: 12, color: AppColors.textPrimary),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                '${station.availableBikes}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles.caption.copyWith(
                                                  color: AppColors.textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      right: 14,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: 'Find a station...',
                            hintStyle: AppTextStyles.caption,
                            prefixIcon: const Icon(Icons.search, size: 18),
                            suffixIcon: Container(
                              width: 30,
                              height: 30,
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.orange,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Icon(
                                Icons.tune,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(999),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${stations.length} stations',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '© OpenStreetMap contributors',
                          style: AppTextStyles.caption.copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          final state = context.read<AppState>();
          state.setCurrentNavIndex(index);
          AppRoutes.navigateByTab(context, index);
        },
      ),
    );
  }
}
