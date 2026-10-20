import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('Susadım uygulaması başarıyla açılmalı ve başlığı göstermelidir', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    expect(find.text('Susadım - Su Takibi'), findsOneWidget);
    expect(find.text('Günlük Hedef'), findsOneWidget);
  });
}
