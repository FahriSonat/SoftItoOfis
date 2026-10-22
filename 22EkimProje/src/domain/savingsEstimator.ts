import { Habit, SavingsEstimate } from '../types/models';

/**
 * Calculates estimated money, time, and units saved for a negative habit.
 * Per project.md Section 9.4, all values must be explicitly labeled "Tahmini".
 */
export function estimateSavings(habit: Habit, elapsedSeconds: number): SavingsEstimate {
  const elapsedDays = Math.max(0, elapsedSeconds / (24 * 3600));

  const freqPerDay = habit.previousFrequencyPerDay || 0;
  const costPerUnit = habit.estimatedCostPerUnit || 0;
  const timePerOccurrence = habit.estimatedTimePerOccurrenceMinutes || 0;

  const unitsAvoided = Math.round(freqPerDay * elapsedDays);
  const moneySaved = Math.round(unitsAvoided * costPerUnit);
  const timeSavedMinutes = Math.round(unitsAvoided * timePerOccurrence);

  return {
    moneySaved,
    timeSavedMinutes,
    unitsAvoided,
    isEstimated: true
  };
}
