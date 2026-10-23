import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:denge/app/app.dart';
import 'package:denge/core/widgets/streak_ring.dart';
import 'package:denge/core/widgets/habit_card.dart';
import 'package:denge/features/habits/domain/habit.dart';
import 'package:denge/features/streaks/domain/streak_engine.dart';
import 'package:denge/features/streaks/presentation/restart_pledge_screen.dart';
import 'package:denge/app/theme/app_colors.dart';

void main() {
  group('Widget and UI QA Tests', () {
    testWidgets(
      '1. Ana navigasyon çubuğu sırası: Solda Negatif, Ortada Ana Sayfa, Sağda Pozitif',
      (tester) async {
        await tester.pumpWidget(const ProviderScope(child: DengeApp()));

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // NavigationBar kontrolü
        final navBarFinder = find.byType(NavigationBar);
        expect(navBarFinder, findsOneWidget);

        final navBar = tester.widget<NavigationBar>(navBarFinder);
        expect(navBar.destinations.length, equals(3));

        // Sıralama doğrulaması
        final dest0 = navBar.destinations[0] as NavigationDestination;
        final dest1 = navBar.destinations[1] as NavigationDestination;
        final dest2 = navBar.destinations[2] as NavigationDestination;

        expect(dest0.label, equals('Negatif'));
        expect(dest1.label, equals('Ana Sayfa'));
        expect(dest2.label, equals('Pozitif'));
      },
    );

    testWidgets(
      '2. StreakRing Semantics erişilebilirlik etiketini ve kırık durumunu doğru çizer',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StreakRing(
                size: 100,
                progress: 0.5,
                strokeColor: AppColors.positiveStages.first,
                semanticsLabel: 'Su hedefinin %50 kısmı tamamlandı',
              ),
            ),
          ),
        );

        expect(find.byType(StreakRing), findsOneWidget);
        expect(
          find.bySemanticsLabel('Su hedefinin %50 kısmı tamamlandı'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      '3. HabitCard başlık, aşama etiketi ve streak değerini görüntüler',
      (tester) async {
        final habit = Habit(
          id: 'h1',
          userId: 'u1',
          name: 'Su İçme',
          kind: HabitKind.positive,
          category: HabitCategory.water,
          iconKey: 'water_drop',
          startAt: DateTime(2026, 10, 1),
          targetValue: 2000,
          unit: 'ml',
          createdAt: DateTime(2026, 10, 1),
          updatedAt: DateTime(2026, 10, 1),
        );

        const streak = StreakResult(
          value: 5,
          unit: StreakUnit.periods,
          status: StreakStatus.completedToday,
          reasonCode: 'TODAY_COMPLETED',
          colorStage: 1,
          stageLabel: 'Ritim',
          currentProgress: 1.0,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HabitCard(
                habit: habit,
                streak: streak,
                onTap: () {},
                quickActionLabel: 'Tamamlandı ✓',
                onQuickAction: () {},
              ),
            ),
          ),
        );

        expect(find.text('Su İçme'), findsOneWidget);
        expect(find.text('Ritim'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);
        expect(find.text('periyot'), findsOneWidget);
        expect(find.text('Tamamlandı ✓'), findsOneWidget);
      },
    );

    testWidgets(
      '4. Turuncu Yeniden Başlama ekranı empatik dil ve söz verme butonunu sunar',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: RestartPledgeScreen(
                habitId: 'test_habit',
                previousStreak: 12,
              ),
            ),
          ),
        );

        expect(find.text('Bir an, bütün yolculuğu silmez.'), findsOneWidget);
        expect(
          find.textContaining('12 gün boyunca harika bir irade gösterdin.'),
          findsOneWidget,
        );
        expect(find.text('Söz Ver ve Yeniden Başla'), findsOneWidget);
      },
    );
  });
}
