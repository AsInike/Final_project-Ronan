import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/colors.dart';
import 'routes/app_routes.dart';
import 'services/app_state.dart';

void main() {
  runApp(const UrbanPulseApp());
}

class UrbanPulseApp extends StatelessWidget {
  const UrbanPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
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
