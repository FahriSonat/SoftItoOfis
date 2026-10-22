import { describe, it, expect } from 'vitest';
import { Habit, HabitEntry } from '../src/types/models';
import { calculateNegativeStreak, calculatePositiveStreak } from '../src/domain/streakEngine';

describe('Karmaşık Senaryolar ve Sınır Durumları', () => {
  it('Birden fazla kırılma (lapse) geçmişi olan negatif alışkanlıkta en uzun seri (longest) doğru bulunmalı', () => {
    const habit: Habit = {
      id: 'h_complex',
      userId: 'u1',
      name: 'Oyun Bağımlılığı',
      kind: 'negative',
      category: 'gaming',
      icon: '🎮',
      status: 'active',
      startAt: '2026-10-01T00:00:00.000Z',
      measurementType: 'duration',
      targetValue: 0,
      unit: 'dakika',
      scheduleType: 'daily',
      scheduleConfig: {},
      reminders: [],
      neutralNotification: true,
      createdAt: '2026-10-01T00:00:00.000Z',
      updatedAt: ''
    };

    const entries: HabitEntry[] = [
      {
        id: 'l1',
        habitId: 'h_complex',
        userId: 'u1',
        entryType: 'lapse',
        value: 60,
        unit: 'dakika',
        occurredAt: '2026-10-06T00:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      },
      {
        id: 'l2',
        habitId: 'h_complex',
        userId: 'u1',
        entryType: 'lapse',
        value: 90,
        unit: 'dakika',
        occurredAt: '2026-10-20T00:00:00.000Z',
        createdAt: '',
        updatedAt: ''
      }
    ];

    const restartedHabit: Habit = {
      ...habit,
      startAt: '2026-10-20T00:00:00.000Z'
    };

    const fixedNow = new Date('2026-10-23T00:00:00.000Z');
    const result = calculateNegativeStreak(restartedHabit, entries, { currentTime: fixedNow });

    expect(result.current).toBe(3);
    expect(result.longest).toBe(14);
    expect(result.status).toBe('active');
  });

  it('Gelecek tarihli alışkanlıkta streak 0 ve status pending olmalı', () => {
    const futureHabit: Habit = {
      id: 'h_future',
      userId: 'u1',
      name: 'Gelecek Planı',
      kind: 'positive',
      category: 'exercise',
      icon: '🏋️',
      status: 'active',
      startAt: '2026-11-01T00:00:00.000Z',
      measurementType: 'boolean',
      targetValue: 1,
      unit: 'sefer',
      scheduleType: 'daily',
      scheduleConfig: {},
      reminders: [],
      neutralNotification: false,
      createdAt: '',
      updatedAt: ''
    };

    const fixedNow = new Date('2026-10-22T00:00:00.000Z');
    const result = calculatePositiveStreak(futureHabit, [], { currentTime: fixedNow });

    expect(result.current).toBe(0);
    expect(result.status).toBe('pending');
  });

  it('Tam döngü: Aktif -> Kırılma -> Broken -> Söz Verme & Yeniden Başlama', () => {
    const habit: Habit = {
      id: 'h_cycle',
      userId: 'u1',
      name: 'Sosyal Medya Detoksu',
      kind: 'negative',
      category: 'social_media',
      icon: '📱',
      status: 'active',
      startAt: '2026-10-10T00:00:00.000Z',
      measurementType: 'duration',
      targetValue: 0,
      unit: 'dakika',
      scheduleType: 'daily',
      scheduleConfig: {},
      reminders: [],
      neutralNotification: true,
      createdAt: '2026-10-10T00:00:00.000Z',
      updatedAt: ''
    };

    // 15 Ekim: 5 gün geçti, aktif durumda
    const check1 = calculateNegativeStreak(habit, [], { currentTime: new Date('2026-10-15T00:00:00.000Z') });
    expect(check1.status).toBe('active');
    expect(check1.current).toBe(5);

    // 15 Ekim 12:00: Kullanıcı seriyi bozduğunu kaydetti
    const lapseEntry: HabitEntry = {
      id: 'lapse_now',
      habitId: 'h_cycle',
      userId: 'u1',
      entryType: 'lapse',
      value: 30,
      unit: 'dakika',
      occurredAt: '2026-10-15T12:00:00.000Z',
      createdAt: '2026-10-15T12:00:00.000Z',
      updatedAt: '2026-10-15T12:00:00.000Z'
    };

    // 15 Ekim 13:00 kontrol: Durum "broken" olmalı, önceki seri 5 gün korunmalı
    const check2 = calculateNegativeStreak(habit, [lapseEntry], { currentTime: new Date('2026-10-15T13:00:00.000Z') });
    expect(check2.status).toBe('broken');
    expect(check2.current).toBe(0);
    expect(check2.longest).toBe(5);

    // 15 Ekim 14:00: Kullanıcı söz verdi ve yeniden başladı (startAt güncellendi)
    const restarted: Habit = {
      ...habit,
      startAt: '2026-10-15T14:00:00.000Z'
    };

    // 17 Ekim: Yeni seride 2 gün geçmiş olmalı, longest hala 5 olmalı
    const check3 = calculateNegativeStreak(restarted, [lapseEntry], { currentTime: new Date('2026-10-17T14:00:00.000Z') });
    expect(check3.status).toBe('active');
    expect(check3.current).toBe(2);
    expect(check3.longest).toBe(5);
  });
});
