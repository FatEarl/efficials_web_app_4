import 'package:flutter_test/flutter_test.dart';
import 'package:efficials_web_app_4/main.dart';

void main() {
  testWidgets('SchedulerHomeScreen displays title and button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EfficialsApp());
    expect(find.text('Scheduler Home'), findsOneWidget);
    expect(find.text('Create Schedule'), findsOneWidget);
  });
}
