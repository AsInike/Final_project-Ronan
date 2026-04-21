import 'package:flutter_test/flutter_test.dart';

import 'package:bestapp/main.dart';
import 'package:bestapp/services/mock_data_service.dart';

void main() {
	testWidgets('UrbanPulse app loads map screen', (WidgetTester tester) async {
		final seedData = await MockDataService.loadSeedData();
		await tester.pumpWidget(UrbanPulseApp(seedData: seedData));

		expect(find.text('UrbanPulse'), findsOneWidget);
		expect(find.text('Find a station...'), findsOneWidget);
	});
}
