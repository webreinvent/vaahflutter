import 'package:flutter_test/flutter_test.dart';

import 'package:team/app/app.dart';

void main() {
  testWidgets('test', (WidgetTester tester) async {
    await tester.pumpWidget(const TeamApp());
    expect(find.byType(TeamApp), findsOneWidget);
  });
}
