import 'package:bestapp/main.dart';
import 'package:bestapp/routes/app_routes.dart';
import 'package:bestapp/services/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
	testWidgets('map search filters station results', (WidgetTester tester) async {
		await tester.pumpWidget(const UrbanPulseApp());
		await tester.pump();

		expect(find.byKey(const ValueKey('map_search_field')), findsOneWidget);
		expect(find.byKey(const ValueKey('map_station_count_label')), findsOneWidget);

		await tester.enterText(
			find.byKey(const ValueKey('map_search_field')),
			'zzzz-not-a-station',
		);
		await tester.pump();

		expect(find.text('0 stations'), findsOneWidget);
	});

	testWidgets('station list tap opens station detail', (WidgetTester tester) async {
		await tester.pumpWidget(
			ChangeNotifierProvider(
				create: (_) => AppState(),
				child: MaterialApp(
					initialRoute: AppRoutes.stationList,
					onGenerateRoute: AppRoutes.onGenerateRoute,
				),
			),
		);
		await tester.pumpAndSettle();

		await tester.tap(find.byType(InkWell).first);
		await tester.pumpAndSettle();

		expect(find.byKey(const ValueKey('station_detail_capacity_card')), findsOneWidget);
		expect(find.byKey(const ValueKey('station_detail_rent_now_button')), findsOneWidget);
	});

	testWidgets('payment form validates required and invalid fields', (WidgetTester tester) async {
		await tester.pumpWidget(
			ChangeNotifierProvider(
				create: (_) => AppState(),
				child: MaterialApp(
					initialRoute: AppRoutes.payment,
					onGenerateRoute: AppRoutes.onGenerateRoute,
				),
			),
		);
		await tester.pumpAndSettle();

		await tester.tap(find.byKey(const ValueKey('payment_continue_from_ride_type')));
		await tester.pumpAndSettle();

		await tester.tap(find.byKey(const ValueKey('payment_pay_now_button')));
		await tester.pumpAndSettle();

		expect(find.text('Required'), findsNWidgets(2));
		expect(find.text('Invalid card number'), findsOneWidget);
		expect(find.text('Invalid CVV'), findsOneWidget);
	});
}
