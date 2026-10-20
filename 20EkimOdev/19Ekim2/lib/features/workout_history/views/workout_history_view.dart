import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/workout_history_controller.dart';
import '../models/workout_history_model.dart';
import '../widgets/workout_history_card.dart';

class WorkoutHistoryView extends StatelessWidget {
  final WorkoutHistoryController _controller = WorkoutHistoryController();

  WorkoutHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrenman Geçmişi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
              child: Text(
                'Tamamlanan Aktiviteler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ValueListenableBuilder<List<WorkoutHistoryModel>>(
              valueListenable: _controller.history,
              builder: (context, historyList, _) {
                if (historyList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Text('Kayıtlı antrenman geçmişi bulunamadı.'),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return WorkoutHistoryCard(item: historyList[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
