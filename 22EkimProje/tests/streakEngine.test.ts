import { describe, it, expect } from 'vitest';
import { Habit, HabitEntry } from '../src/types/models';
import {
  calculatePositiveStreak,
  calculateNegativeStreak,
  getDailyProgressMap,
  isDayCompleted
} from '../src/domain/streakEngine';
import { calculateColorStage } from '../src/domain/colorStage';
import { estimateSavings } from '../src/domain/savingsEstimator';
import { repository } from '../src/storage/repository';
import { toLocalDateString, calendarDaysDifference } from '../src/domain/dateUtils';

describe('Streak Engine - Pozitif Alışkanlıklar', () => {
  const basePositiveHabit: Habit = {
    id: 'h_pos',
    userId: 'u1',
    name: 'Günde 2000ml Su',
    kind: 'positive',
    category: 'water',
    icon: '💧',
    status: 'active',
    startAt: '2026-10-18T00:00:00.000Z',
    measurementType: 'volume',
    targetValue: 2000,
    unit: 'ml',
    scheduleType: 'daily',
    scheduleConfig: {},
    reminders: ['10:00'],
    neutralNotification: false,
    createdAt: '2026-10-18T00:00:00.000Z',
    updatedAt: '2026-10-18T00:00:00.000Z'
  };

  it('1. Günlük hedef art arda üç gün tamamlandığında streak 3 olmalı', () => {
    const fixedNow = new Date('2026-10-20T18:00:00.000Z');
    const entries: HabitEntry[] = [
      {
        id: 'e1',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-10-18T12:00:00.000Z',
        createdAt: '2026-10-18T12:00:00.000Z',
        updatedAt: '2026-10-18T12:00:00.000Z'
      },
      {
        id: 'e2',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-10-19T14:00:00.000Z',
        createdAt: '2026-10-19T14:00:00.000Z',
        updatedAt: '2026-10-19T14:00:00.000Z'
      },
      {
        id: 'e3',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-10-20T10:00:00.000Z',
        createdAt: '2026-10-20T10:00:00.000Z',
        updatedAt: '2026-10-20T10:00:00.000Z'
      }
    ];

    const result = calculatePositiveStreak(basePositiveHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(3);
    expect(result.status).toBe('completed');
  });

  it('2. Günlük hedef bir gün kaçırıldığında streak sıfırlanmalı', () => {
    const fixedNow = new Date('2026-10-20T18:00:00.000Z');
    const entries: HabitEntry[] = [
      {
        id: 'e1',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-10-18T12:00:00.000Z',
        createdAt: '2026-10-18T12:00:00.000Z',
        updatedAt: '2026-10-18T12:00:00.000Z'
      }
    ];

    const result = calculatePositiveStreak(basePositiveHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(0);
    expect(result.longest).toBe(1);
  });

  it('3. Seçili günlerde plansız günler seriyi bozmamalı ve artırmamalı', () => {
    const scheduledHabit: Habit = {
      ...basePositiveHabit,
      scheduleType: 'selected_days',
      scheduleConfig: { daysOfWeek: [1, 3, 5] },
      startAt: '2026-10-19T00:00:00.000Z'
    };

    const fixedNow = new Date('2026-10-21T18:00:00.000Z');
    const entries: HabitEntry[] = [
      {
        id: 'e1',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-10-19T12:00:00.000Z',
        createdAt: '2026-10-19T12:00:00.000Z',
        updatedAt: '2026-10-19T12:00:00.000Z'
      },
      {
        id: 'e2',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-10-21T14:00:00.000Z',
        createdAt: '2026-10-21T14:00:00.000Z',
        updatedAt: '2026-10-21T14:00:00.000Z'
      }
    ];

    const result = calculatePositiveStreak(scheduledHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(2);
  });

  it('4. Miktar hedefi aynı gün birkaç kayıtla birleştirilip tamamlanabilmeli', () => {
    const fixedNow = new Date('2026-10-20T18:00:00.000Z');
    const entries: HabitEntry[] = [
      {
        id: 'e1',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'progress',
        value: 500,
        unit: 'ml',
        occurredAt: '2026-10-20T08:00:00.000Z',
        createdAt: '2026-10-20T08:00:00.000Z',
        updatedAt: '2026-10-20T08:00:00.000Z'
      },
      {
        id: 'e2',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'progress',
        value: 750,
        unit: 'ml',
        occurredAt: '2026-10-20T12:00:00.000Z',
        createdAt: '2026-10-20T12:00:00.000Z',
        updatedAt: '2026-10-20T12:00:00.000Z'
      },
      {
        id: 'e3',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'progress',
        value: 800,
        unit: 'ml',
        occurredAt: '2026-10-20T16:00:00.000Z',
        createdAt: '2026-10-20T16:00:00.000Z',
        updatedAt: '2026-10-20T16:00:00.000Z'
      }
    ];

    const map = getDailyProgressMap(basePositiveHabit, entries);
    expect(map.get('2026-10-20')).toBe(2050);
    expect(isDayCompleted(basePositiveHabit, map, fixedNow)).toBe(true);

    const result = calculatePositiveStreak(basePositiveHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(1);
    expect(result.status).toBe('completed');
  });

  it('5. Yıl ve ay geçişinde (31 Aralık -> 1 Ocak) streak kesintisiz devam etmeli', () => {
    const yearHabit: Habit = {
      ...basePositiveHabit,
      startAt: '2026-12-30T00:00:00.000Z'
    };
    const fixedNow = new Date('2027-01-01T15:00:00.000Z');
    const entries: HabitEntry[] = [
      {
        id: 'y1',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-12-30T12:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      },
      {
        id: 'y2',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2026-12-31T12:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      },
      {
        id: 'y3',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'completion',
        value: 2000,
        unit: 'ml',
        occurredAt: '2027-01-01T12:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      }
    ];

    const result = calculatePositiveStreak(yearHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(3);
    expect(result.status).toBe('completed');
  });

  it('6. Geçmiş kayıt düzeltildiğinde (örn. 500ml -> 2000ml) streak dinamik güncellenmeli', () => {
    const fixedNow = new Date('2026-10-20T18:00:00.000Z');
    // Başlangıçta eksik kaydedilmiş
    let entries: HabitEntry[] = [
      {
        id: 'e1',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'progress',
        value: 500, // Eksik
        unit: 'ml',
        occurredAt: '2026-10-20T12:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      }
    ];
    let result = calculatePositiveStreak(basePositiveHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(0);

    // Kullanıcı düzeltme kaydı yaptı ve 1500ml daha ekledi
    entries = [
      ...entries,
      {
        id: 'e2',
        habitId: 'h_pos',
        userId: 'u1',
        entryType: 'progress',
        value: 1500,
        unit: 'ml',
        occurredAt: '2026-10-20T15:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      }
    ];
    result = calculatePositiveStreak(basePositiveHabit, entries, { currentTime: fixedNow });
    expect(result.current).toBe(1);
    expect(result.status).toBe('completed');
  });
});

describe('Streak Engine - Negatif Alışkanlıklar', () => {
  const baseNegativeHabit: Habit = {
    id: 'h_neg',
    userId: 'u1',
    name: 'Sigarayı Bırakma',
    kind: 'negative',
    category: 'smoking',
    icon: '🚭',
    status: 'active',
    startAt: '2026-10-20T00:00:00.000Z',
    measurementType: 'count',
    targetValue: 0,
    unit: 'adet',
    scheduleType: 'daily',
    scheduleConfig: {},
    reminders: [],
    neutralNotification: true,
    previousFrequencyPerDay: 20,
    estimatedCostPerUnit: 4,
    estimatedTimePerOccurrenceMinutes: 5,
    createdAt: '2026-10-20T00:00:00.000Z',
    updatedAt: '2026-10-20T00:00:00.000Z'
  };

  it('7. Negatif seri 23 saat sürdüğünde saat formatında ve unit "hour" olmalı', () => {
    const fixedNow = new Date('2026-10-20T23:00:00.000Z');
    const result = calculateNegativeStreak(baseNegativeHabit, [], { currentTime: fixedNow });
    expect(result.current).toBe(23);
    expect(result.unit).toBe('hour');
    expect(result.status).toBe('active');
  });

  it('8. Negatif seri 24 saati geçtiğinde gün formatında ve unit "day" olmalı', () => {
    const fixedNow = new Date('2026-10-21T02:00:00.000Z');
    const result = calculateNegativeStreak(baseNegativeHabit, [], { currentTime: fixedNow });
    expect(result.current).toBe(1);
    expect(result.unit).toBe('day');
    expect(result.status).toBe('active');
  });

  it('9. Kırılma kaydında (lapse) seri broken durumuna geçmeli, eski seri longest olarak korunmalı', () => {
    const habit10Days: Habit = {
      ...baseNegativeHabit,
      startAt: '2026-10-01T00:00:00.000Z'
    };
    const lapseTime = '2026-10-11T12:00:00.000Z';
    const fixedNow = new Date('2026-10-12T10:00:00.000Z');

    const entries: HabitEntry[] = [
      {
        id: 'lapse_1',
        habitId: 'h_neg',
        userId: 'u1',
        entryType: 'lapse',
        value: 1,
        unit: 'adet',
        occurredAt: lapseTime,
        note: 'Stresli toplantı',
        createdAt: lapseTime,
        updatedAt: lapseTime
      }
    ];

    const result = calculateNegativeStreak(habit10Days, entries, { currentTime: fixedNow });
    expect(result.status).toBe('broken');
    expect(result.current).toBe(0);
    expect(result.longest).toBe(10);
  });

  it('10. Yeniden söz verildikten ve yeni başlangıç ayarlandıktan sonra yeni seri başlamalı', () => {
    const habitRestarted: Habit = {
      ...baseNegativeHabit,
      startAt: '2026-10-12T00:00:00.000Z'
    };
    const entries: HabitEntry[] = [
      {
        id: 'lapse_1',
        habitId: 'h_neg',
        userId: 'u1',
        entryType: 'lapse',
        value: 1,
        unit: 'adet',
        occurredAt: '2026-10-11T12:00:00.000Z',
        createdAt: '2026-10-11T12:00:00.000Z',
        updatedAt: '2026-10-11T12:00:00.000Z'
      }
    ];

    const fixedNow = new Date('2026-10-14T00:00:00.000Z');
    const result = calculateNegativeStreak(habitRestarted, entries, { currentTime: fixedNow });
    expect(result.status).toBe('active');
    expect(result.current).toBe(2);
  });
});

describe('Color Stages & Savings Estimation', () => {
  it('11. Negatif renk aşamaları günlere göre doğru eşleşmeli', () => {
    expect(calculateColorStage('negative', 0).hex).toBe('#FF5D68');
    expect(calculateColorStage('negative', 1).hex).toBe('#FF735C');
    expect(calculateColorStage('negative', 5).hex).toBe('#F59E45');
    expect(calculateColorStage('negative', 10).hex).toBe('#C4C94A');
    expect(calculateColorStage('negative', 20).hex).toBe('#71C96B');
    expect(calculateColorStage('negative', 45).hex).toBe('#35D083');
    expect(calculateColorStage('negative', 10, true).hex).toBe('#FF9F43');
  });

  it('12. Pozitif renk aşamaları periyotlara göre doğru eşleşmeli', () => {
    expect(calculateColorStage('positive', 1).hex).toBe('#4D8DFF');
    expect(calculateColorStage('positive', 4).hex).toBe('#3B9EF3');
    expect(calculateColorStage('positive', 8).hex).toBe('#2BAFE4');
    expect(calculateColorStage('positive', 18).hex).toBe('#22C1D0');
    expect(calculateColorStage('positive', 35).hex).toBe('#20D3B0');
  });

  it('13. Tasarruf tahminleri doğru ve tahmini etiketli olmalı', () => {
    const habit: Habit = {
      id: 'h1',
      userId: 'u1',
      name: 'Sigara',
      kind: 'negative',
      category: 'smoking',
      icon: '🚭',
      status: 'active',
      startAt: '2026-10-01T00:00:00.000Z',
      measurementType: 'count',
      targetValue: 0,
      unit: 'adet',
      scheduleType: 'daily',
      scheduleConfig: {},
      reminders: [],
      neutralNotification: true,
      previousFrequencyPerDay: 20,
      estimatedCostPerUnit: 5,
      estimatedTimePerOccurrenceMinutes: 6,
      createdAt: '',
      updatedAt: ''
    };

    const savings = estimateSavings(habit, 5 * 86400);
    expect(savings.unitsAvoided).toBe(100);
    expect(savings.moneySaved).toBe(500);
    expect(savings.timeSavedMinutes).toBe(600);
    expect(savings.isEstimated).toBe(true);
  });
});
