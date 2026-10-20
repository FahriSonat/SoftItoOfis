class ExerciseItem {
  final String id;
  final String title;
  final String category; // Kardiyo, Kuvvet, Esneme, vb.
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime? timestamp;

  const ExerciseItem({
    required this.id,
    required this.title,
    required this.category,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.timestamp,
  });
}
