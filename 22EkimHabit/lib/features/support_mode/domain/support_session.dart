enum SupportOutcome { reduced, unchanged, increased, lapse, abandoned }

class SupportSession {
  final String id;
  final String habitId;
  final DateTime startedAtUtc;
  final DateTime? completedAtUtc;
  final int intensityBefore;
  final int? intensityAfter;
  final String? selectedSolutionId;
  final int? timerSeconds;
  final SupportOutcome? outcome;

  const SupportSession({
    required this.id,
    required this.habitId,
    required this.startedAtUtc,
    this.completedAtUtc,
    required this.intensityBefore,
    this.intensityAfter,
    this.selectedSolutionId,
    this.timerSeconds,
    this.outcome,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'habitId': habitId,
    'startedAtUtc': startedAtUtc.toIso8601String(),
    'completedAtUtc': completedAtUtc?.toIso8601String(),
    'intensityBefore': intensityBefore,
    'intensityAfter': intensityAfter,
    'selectedSolutionId': selectedSolutionId,
    'timerSeconds': timerSeconds,
    'outcome': outcome?.name,
  };

  factory SupportSession.fromJson(Map<String, dynamic> json) {
    return SupportSession(
      id: json['id'] as String,
      habitId: json['habitId'] as String,
      startedAtUtc: DateTime.parse(json['startedAtUtc'] as String),
      completedAtUtc: json['completedAtUtc'] != null
          ? DateTime.parse(json['completedAtUtc'] as String)
          : null,
      intensityBefore: json['intensityBefore'] as int? ?? 3,
      intensityAfter: json['intensityAfter'] as int?,
      selectedSolutionId: json['selectedSolutionId'] as String?,
      timerSeconds: json['timerSeconds'] as int?,
      outcome: json['outcome'] != null
          ? SupportOutcome.values.byName(json['outcome'] as String)
          : null,
    );
  }
}
