import 'package:flutter_test/flutter_test.dart';
import 'package:vitrin/main.dart';

void main() {
  testWidgets('Vitrin app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const BenimUygulamam());
    await tester.pumpAndSettle();

    expect(find.text('Canlı Vitrin(ValueNotifier)'), findsOneWidget);
  });
}
