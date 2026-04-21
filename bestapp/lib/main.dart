import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/colors.dart';
import 'routes/app_routes.dart';
import 'services/app_state.dart';
import 'services/app_seed_data.dart';
import 'services/mock_data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final seedData = await MockDataService.loadSeedData();
  runApp(UrbanPulseApp(seedData: seedData));
}

class UrbanPulseApp extends StatelessWidget {
  const UrbanPulseApp({
    required this.seedData,
    super.key,
  });

  final AppSeedData seedData;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState.fromSeedData(seedData),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UrbanPulse',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: AppColors.background,
          fontFamily: 'NotoSans',
          textTheme: ThemeData.light().textTheme.apply(
                fontFamily: 'NotoSans',
              ),
          useMaterial3: true,
          inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
        initialRoute: AppRoutes.map,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
