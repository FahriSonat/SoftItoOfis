import 'package:flutter_test/flutter_test.dart';
import 'package:personal_finance_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('PersonalFinanceApp loads and renders Bütçe Özeti smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PersonalFinanceApp());
    await tester.pumpAndSettle();

    // Verify title and main elements are rendered
    expect(find.text('Bütçe Özeti'), findsWidgets);
    expect(find.text('Dönem Net Bakiyesi'), findsOneWidget);
    expect(find.text('Kalan Günlük Harcanabilir'), findsOneWidget);
  });
}
