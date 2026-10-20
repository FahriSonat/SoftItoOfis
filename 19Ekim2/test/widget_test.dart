import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/features/water_tracking/controllers/water_tracking_controller.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadim App Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    await tester.pumpAndSettle();
    expect(find.byType(SusadimApp), findsOneWidget);
  });

  test('WaterTrackingController state management test', () {
    final controller = WaterTrackingController();
    final initialWater = controller.currentWater.value;

    controller.addWater(250);
    expect(controller.currentWater.value, initialWater + 250);

    controller.resetWater();
    expect(controller.currentWater.value, 0);
  });
}
