export type HabitKind = 'positive' | 'negative';

export type MeasurementType =
  | 'boolean'
  | 'count'
  | 'duration'
  | 'distance'
  | 'volume'
  | 'pages'
  | 'amount';

export type ScheduleType = 'daily' | 'selected_days' | 'weekly_frequency' | 'interval';

export interface ScheduleConfig {
  daysOfWeek?: number[]; // 0 = Sunday, 1 = Monday, ... 6 = Saturday
  weeklyTargetCount?: number;
  intervalDays?: number;
}

export type HabitStatus = 'active' | 'paused' | 'archived';

export interface Habit {
  id: string;
  userId: string;
  name: string;
  kind: HabitKind;
  category: string;
  icon: string;
  status: HabitStatus;
  startAt: string; // ISO string
  measurementType: MeasurementType;
  targetValue: number;
  unit: string;
  scheduleType: ScheduleType;
  scheduleConfig: ScheduleConfig;
  reminders: string[]; // HH:mm format
  neutralNotification: boolean; // hide sensitive category on lockscreen
  colorStage?: number;
  // Optional savings data for negative habits
  previousFrequencyPerDay?: number;
  estimatedCostPerUnit?: number; // e.g., cost per cigarette or drink
  estimatedTimePerOccurrenceMinutes?: number; // for screen/gaming
  createdAt: string;
  updatedAt: string;
}

export type EntryType = 'completion' | 'progress' | 'lapse' | 'abstinence_check' | 'correction';

export interface HabitEntry {
  id: string;
  habitId: string;
  userId: string;
  entryType: EntryType;
  value: number;
  unit: string;
  occurredAt: string; // ISO string
  note?: string;
  source?: 'manual' | 'wearable' | 'import';
  createdAt: string;
  updatedAt: string;
}

export interface StreakPeriod {
  id: string;
  habitId: string;
  startedAt: string;
  endedAt: string | null;
  status: 'active' | 'completed' | 'broken';
  successfulPeriods: number;
  durationSeconds: number;
  endReason?: string;
  restartPledgeId?: string;
}

export interface TriggerNote {
  id: string;
  habitId: string;
  userId: string;
  occurredAt: string;
  triggerTags: string[];
  emotionTags: string[];
  intensity: number; // 1-5
  context?: string;
  note: string;
}

export interface CopingStrategy {
  id: string;
  habitId?: string; // specific habit or global
  title: string;
  actionText: string;
  estimatedMinutes: number;
  triggerTags: string[];
  effectivenessScore: number; // 1-5
  isFavorite: boolean;
  timesUsed: number;
  createdAt: string;
}

export interface RestartPledge {
  id: string;
  habitId: string;
  previousStreakPeriodId?: string;
  pledgeText: string;
  reflection?: string;
  selectedStrategyId?: string;
  triggerTag?: string;
  committedAt: string;
}

export interface Badge {
  id: string;
  title: string;
  description: string;
  level: number;
  conditionType: 'total_habits' | 'streak_days' | 'restart_pledge' | 'water_volume' | 'book_pages' | 'distance';
  threshold: number;
  icon: string;
}

export interface UserBadge {
  badgeId: string;
  earnedAt: string;
  progress: number;
}

export interface UserProfile {
  id: string;
  displayName: string;
  email: string;
  avatar: string;
  timezone: string;
  locale: string;
  createdAt: string;
  notificationPreferences: {
    enabled: boolean;
    quietHoursStart: string; // HH:mm
    quietHoursEnd: string;   // HH:mm
    neutralLockscreen: boolean;
  };
}

export type StreakStatus = 'active' | 'pending' | 'completed' | 'missed' | 'broken';

export interface StreakResult {
  current: number;
  longest: number;
  unit: 'minute' | 'hour' | 'day' | 'period' | 'week';
  status: StreakStatus;
  startedAt: string | null;
  nextEvaluationAt: string | null;
  reason: string;
  rawDurationSeconds?: number;
}

export interface ColorStageResult {
  stageIndex: number;
  tokenName: string;
  hex: string;
  label: string;
  description: string;
}

export interface SavingsEstimate {
  moneySaved: number;
  timeSavedMinutes: number;
  unitsAvoided: number;
  isEstimated: true;
}
