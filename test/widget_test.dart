import 'package:flutter_test/flutter_test.dart';
import 'package:efficials_web_app_4/main.dart';

void main() {
  testWidgets('SchedulerHomeScreen displays welcome message', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EfficialsApp());

    expect(find.text('Welcome, Scheduler!'), findsOneWidget);
    expect(
      find.text('You’ve received 1 free game token for signing up!'),
      findsOneWidget,
    );
    expect(find.text('Let’s create your first game!'), findsOneWidget);
  });
}
