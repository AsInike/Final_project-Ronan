import 'package:flutter_test/flutter_test.dart';

import 'package:bestapp/main.dart';

void main() {
	testWidgets('UrbanPulse app loads map screen', (WidgetTester tester) async {
		await tester.pumpWidget(const UrbanPulseApp());

		expect(find.text('UrbanPulse'), findsOneWidget);
		expect(find.text('Find a station...'), findsOneWidget);
	});
}
