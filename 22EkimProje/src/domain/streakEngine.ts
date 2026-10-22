import { Habit, HabitEntry, StreakPeriod, StreakResult } from '../types/models';
import {
  toLocalDateString,
  isSameDay,
  addDays,
  calendarDaysDifference
} from './dateUtils';

export interface StreakEngineEvaluationOptions {
  currentTime?: Date;
  periods?: StreakPeriod[];
}

/**
 * Calculates streak result for negative habits (abstinence).
 */
export function calculateNegativeStreak(
  habit: Habit,
  entries: HabitEntry[],
  options: StreakEngineEvaluationOptions = {}
): StreakResult {
  const now = options.currentTime || new Date();
  const habitStart = new Date(habit.startAt);

  // If start is in the future
  if (habitStart.getTime() > now.getTime()) {
    return {
      current: 0,
      longest: 0,
      unit: 'hour',
      status: 'pending',
      startedAt: habit.startAt,
      nextEvaluationAt: null,
      reason: 'Alışkanlık başlangıç tarihi henüz gelmedi.',
      rawDurationSeconds: 0
    };
  }

  // Filter lapses (streak breaking events) for this habit
  const lapses = entries
    .filter(e => e.habitId === habit.id && e.entryType === 'lapse')
    .sort((a, b) => new Date(a.occurredAt).getTime() - new Date(b.occurredAt).getTime());

  // Historical periods evaluation:
  // The very first period starts at habit.createdAt or habit.startAt, whichever is earlier
  const initialCreationTime = habit.createdAt ? new Date(habit.createdAt) : habitStart;
  let periodStart = initialCreationTime.getTime() < habitStart.getTime() ? initialCreationTime : habitStart;
  let longestSeconds = 0;

  for (const lapse of lapses) {
    const lapseTime = new Date(lapse.occurredAt);
    if (lapseTime.getTime() > periodStart.getTime()) {
      const dur = Math.floor((lapseTime.getTime() - periodStart.getTime()) / 1000);
      if (dur > longestSeconds) {
        longestSeconds = dur;
      }
    }
    // New period starts at this lapse time
    periodStart = lapseTime;
  }

  // Check if the latest lapse is in a "broken" unacknowledged state
  // A lapse only breaks the active streak if it occurred STRICTLY AFTER the current startAt
  const latestLapse = lapses.length > 0 ? lapses[lapses.length - 1] : null;
  const isCurrentlyBroken = latestLapse && new Date(latestLapse.occurredAt).getTime() > habitStart.getTime();

  if (isCurrentlyBroken) {
    return {
      current: 0,
      longest: Math.floor(longestSeconds / (24 * 3600)),
      unit: 'day',
      status: 'broken',
      startedAt: habit.startAt,
      nextEvaluationAt: null,
      reason: 'Seri kesintiye uğradı. Yeniden söz vererek yeni bir başlangıç yapabilirsin.',
      rawDurationSeconds: 0
    };
  }

  // Calculate current active streak from habitStart to now
  const elapsedSeconds = Math.max(0, Math.floor((now.getTime() - habitStart.getTime()) / 1000));
  if (elapsedSeconds > longestSeconds) {
    longestSeconds = elapsedSeconds;
  }

  const elapsedHours = Math.floor(elapsedSeconds / 3600);
  const elapsedDays = Math.floor(elapsedSeconds / (24 * 3600));

  if (elapsedHours < 24) {
    return {
      current: elapsedHours,
      longest: Math.max(elapsedDays, Math.floor(longestSeconds / (24 * 3600))),
      unit: 'hour',
      status: 'active',
      startedAt: habit.startAt,
      nextEvaluationAt: null,
      reason: `${elapsedHours} saattir başarıyla uzak duruyorsun.`,
      rawDurationSeconds: elapsedSeconds
    };
  }

  return {
    current: elapsedDays,
    longest: Math.floor(longestSeconds / (24 * 3600)),
    unit: 'day',
    status: 'active',
    startedAt: habit.startAt,
    nextEvaluationAt: null,
    reason: `${elapsedDays} gündür kesintisiz devam ediyorsun.`,
    rawDurationSeconds: elapsedSeconds
  };
}

/**
 * Calculates daily completions map for a positive habit.
 * Aggregates entries by calendar day (summing value).
 */
export function getDailyProgressMap(habit: Habit, entries: HabitEntry[]): Map<string, number> {
  const map = new Map<string, number>();
  const habitEntries = entries.filter(
    e => e.habitId === habit.id && (e.entryType === 'completion' || e.entryType === 'progress')
  );

  for (const entry of habitEntries) {
    const dayStr = toLocalDateString(entry.occurredAt);
    const currentVal = map.get(dayStr) || 0;
    map.set(dayStr, currentVal + entry.value);
  }

  return map;
}

/**
 * Check if a given calendar date meets the target for the habit.
 */
export function isDayCompleted(habit: Habit, dailyMap: Map<string, number>, date: Date | string): boolean {
  const dayStr = toLocalDateString(date);
  const total = dailyMap.get(dayStr) || 0;
  if (habit.measurementType === 'boolean') {
    return total >= 1;
  }
  return total >= habit.targetValue;
}

/**
 * Checks if a specific day is a planned day for the habit schedule.
 */
export function isScheduledDay(habit: Habit, date: Date): boolean {
  if (habit.scheduleType === 'daily') {
    return true;
  }
  if (habit.scheduleType === 'selected_days') {
    const allowed = habit.scheduleConfig.daysOfWeek ?? [1, 2, 3, 4, 5];
    return allowed.includes(date.getDay());
  }
  // For weekly_frequency or interval, days themselves aren't restricted
  return true;
}

/**
 * Calculates streak result for positive habits.
 */
export function calculatePositiveStreak(
  habit: Habit,
  entries: HabitEntry[],
  options: StreakEngineEvaluationOptions = {}
): StreakResult {
  const now = options.currentTime || new Date();
  const habitStart = new Date(habit.startAt);

  if (habitStart.getTime() > now.getTime()) {
    return {
      current: 0,
      longest: 0,
      unit: 'period',
      status: 'pending',
      startedAt: habit.startAt,
      nextEvaluationAt: null,
      reason: 'Alışkanlık başlangıç tarihi henüz gelmedi.'
    };
  }

  const dailyMap = getDailyProgressMap(habit, entries);

  // WEEKLY FREQUENCY MODE
  if (habit.scheduleType === 'weekly_frequency') {
    return calculateWeeklyFrequencyStreak(habit, dailyMap, habitStart, now);
  }

  // DAILY OR SELECTED DAYS MODE
  // We evaluate backwards from today or yesterday depending on today's status.
  const todayCompleted = isDayCompleted(habit, dailyMap, now);
  const todayIsScheduled = isScheduledDay(habit, now);

  // Check from today going backwards
  let currentStreak = 0;
  let pointer = new Date(now);

  if (todayCompleted) {
    currentStreak++;
    pointer = addDays(pointer, -1);
  } else {
    // If today is scheduled but not completed yet, today is pending (does not break streak)
    // We check from yesterday
    pointer = addDays(pointer, -1);
  }

  // Count consecutive scheduled days completed going backwards until habitStart
  while (pointer.getTime() >= getStartOfHabitDay(habitStart).getTime()) {
    const isSched = isScheduledDay(habit, pointer);
    if (!isSched) {
      // Unplanned days do not increase or break streak! (SKILL.md & project.md rule)
      pointer = addDays(pointer, -1);
      continue;
    }

    if (isDayCompleted(habit, dailyMap, pointer)) {
      currentStreak++;
      pointer = addDays(pointer, -1);
    } else {
      // Missed scheduled day: streak ends here!
      break;
    }
  }

  // Calculate longest streak in history
  const longest = calculateLongestPositiveStreak(habit, dailyMap, habitStart, now);

  const status = todayCompleted ? 'completed' : 'active';
  const reason = todayCompleted
    ? `Bugünkü hedefini tamamladın. ${currentStreak} periyotluk serin devam ediyor!`
    : todayIsScheduled
    ? `Bugün hedefini tamamlamak için zamanın var. Mevcut seri: ${currentStreak}`
    : `Bugün dinlenme günün. Serin korunuyor: ${currentStreak}`;

  return {
    current: currentStreak,
    longest: Math.max(currentStreak, longest),
    unit: 'period',
    status,
    startedAt: habit.startAt,
    nextEvaluationAt: null,
    reason
  };
}

function getStartOfHabitDay(d: Date): Date {
  const copy = new Date(d);
  copy.setHours(0, 0, 0, 0);
  return copy;
}

/**
 * Calculates longest streak over historical days.
 */
function calculateLongestPositiveStreak(
  habit: Habit,
  dailyMap: Map<string, number>,
  start: Date,
  end: Date
): number {
  let longest = 0;
  let currentRun = 0;
  let pointer = new Date(start);

  while (pointer.getTime() <= end.getTime()) {
    if (isScheduledDay(habit, pointer)) {
      if (isDayCompleted(habit, dailyMap, pointer)) {
        currentRun++;
        if (currentRun > longest) {
          longest = currentRun;
        }
      } else {
        // If it's today and incomplete, don't reset historic run if pointer is today
        if (!isSameDay(pointer, end)) {
          currentRun = 0;
        }
      }
    }
    pointer = addDays(pointer, 1);
  }

  return longest;
}

/**
 * Weekly frequency streak calculation.
 */
function calculateWeeklyFrequencyStreak(
  habit: Habit,
  dailyMap: Map<string, number>,
  start: Date,
  now: Date
): StreakResult {
  const targetPerWeek = habit.scheduleConfig.weeklyTargetCount || 3;
  // Let's count how many weeks in the past met targetPerWeek
  // We can chunk weeks from Monday to Sunday.
  const weeks = getWeeksBetween(start, now);
  let streak = 0;
  let longest = 0;

  for (let i = 0; i < weeks.length; i++) {
    const { startOfWeek, endOfWeek, isCurrentWeek } = weeks[i];
    let completionsThisWeek = 0;

    let p = new Date(startOfWeek);
    while (p.getTime() <= endOfWeek.getTime() && p.getTime() <= now.getTime()) {
      if (isDayCompleted(habit, dailyMap, p)) {
        completionsThisWeek++;
      }
      p = addDays(p, 1);
    }

    const metTarget = completionsThisWeek >= targetPerWeek;
    if (isCurrentWeek) {
      if (metTarget) {
        streak++;
      }
      // If current week not met yet, streak is preserved from past weeks until week ends
    } else {
      if (metTarget) {
        streak++;
      } else {
        streak = 0;
      }
    }
    if (streak > longest) {
      longest = streak;
    }
  }

  return {
    current: streak,
    longest,
    unit: 'week',
    status: 'active',
    startedAt: habit.startAt,
    nextEvaluationAt: null,
    reason: `Haftalık ${targetPerWeek} hedefinde ${streak} başarılı hafta!`
  };
}

function getWeeksBetween(start: Date, end: Date): Array<{ startOfWeek: Date; endOfWeek: Date; isCurrentWeek: boolean }> {
  const weeks = [];
  let curr = new Date(start);
  // Rewind to Monday of start week
  const day = curr.getDay();
  const diffToMonday = (day === 0 ? -6 : 1) - day;
  curr = addDays(curr, diffToMonday);
  curr.setHours(0, 0, 0, 0);

  const now = new Date(end);

  while (curr.getTime() <= now.getTime()) {
    const sunday = addDays(curr, 6);
    sunday.setHours(23, 59, 59, 999);
    const isCurrentWeek = now.getTime() >= curr.getTime() && now.getTime() <= sunday.getTime();
    weeks.push({
      startOfWeek: new Date(curr),
      endOfWeek: sunday,
      isCurrentWeek
    });
    curr = addDays(curr, 7);
  }
  return weeks;
}

/**
 * Universal evaluator dispatching to negative or positive streak calculator.
 */
export function evaluateHabitStreak(
  habit: Habit,
  entries: HabitEntry[],
  options: StreakEngineEvaluationOptions = {}
): StreakResult {
  if (habit.kind === 'negative') {
    return calculateNegativeStreak(habit, entries, options);
  } else {
    return calculatePositiveStreak(habit, entries, options);
  }
}
