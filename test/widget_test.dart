import 'package:flutter_test/flutter_test.dart';
import 'package:vaahflutter/app_config.dart';

void main() {
  testWidgets('test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppConfig());
    expect(find.byType(AppConfig), findsOneWidget);
  });
}
