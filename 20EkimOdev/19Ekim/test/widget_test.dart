import 'package:flutter_test/flutter_test.dart';
import 'package:susadim/core/constants/app_constants.dart';
import 'package:susadim/main.dart';

void main() {
  testWidgets('SusadimApp başlatma ve splash ekranı duman testi', (WidgetTester tester) async {
    await tester.pumpWidget(const SusadimApp());
    // Splash ekranındaki uygulama adını doğrula
    expect(find.text(AppConstants.appName), findsOneWidget);

    // Splash ekranındaki geçiş süresini tüket (timer temizliği)
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
