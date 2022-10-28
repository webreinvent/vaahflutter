import 'package:flutter_test/flutter_test.dart';

<<<<<<< Updated upstream
import 'package:team/app/app.dart';
=======
<<<<<<< Updated upstream
import 'package:team/main.dart';
=======
import 'package:team/app_config.dart';
>>>>>>> Stashed changes
>>>>>>> Stashed changes

void main() {
  testWidgets('test', (WidgetTester tester) async {
    await tester.pumpWidget(const AppConfig());
    expect(find.byType(AppConfig), findsOneWidget);
  });
}
