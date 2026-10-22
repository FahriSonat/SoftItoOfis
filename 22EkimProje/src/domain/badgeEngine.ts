import { Badge, UserBadge, Habit, HabitEntry, RestartPledge, StreakResult } from '../types/models';

export const SYSTEM_BADGES: Badge[] = [
  {
    id: 'first_step',
    title: 'İlk Adım',
    description: 'İlk alışkanlığını sisteme ekledin.',
    level: 1,
    conditionType: 'total_habits',
    threshold: 1,
    icon: '🌱'
  },
  {
    id: 'one_week_strong',
    title: 'Bir Hafta Güçlü',
    description: '7 periyotluk kesintisiz seriyi tamamladın.',
    level: 2,
    conditionType: 'streak_days',
    threshold: 7,
    icon: '⚡'
  },
  {
    id: 'stability_master',
    title: 'İstikrar Ustası',
    description: '30 periyot boyunca kararlılığını korudun.',
    level: 3,
    conditionType: 'streak_days',
    threshold: 30,
    icon: '👑'
  },
  {
    id: 'water_friend',
    title: 'Su Dostu',
    description: 'Toplam 100 litre (100.000 ml) su kaydına ulaştın.',
    level: 2,
    conditionType: 'water_volume',
    threshold: 100000,
    icon: '💧'
  },
  {
    id: 'book_worm',
    title: 'Kitap Kurdu',
    description: 'Toplam 200 sayfa okuma tamamladın.',
    level: 2,
    conditionType: 'book_pages',
    threshold: 200,
    icon: '📚'
  },
  {
    id: 'traveler',
    title: 'Yolcu',
    description: 'Toplam 100 km yürüyüş veya koşu mesafesine ulaştın.',
    level: 2,
    conditionType: 'distance',
    threshold: 100,
    icon: '🏃'
  },
  {
    id: 'restarted',
    title: 'Yeniden Başladım',
    description: 'Seri kesintiye uğradıktan sonra yeniden söz verdin ve devam ettin.',
    level: 1,
    conditionType: 'restart_pledge',
    threshold: 1,
    icon: '🌅'
  }
];

export function evaluateBadges(
  habits: Habit[],
  entries: HabitEntry[],
  pledges: RestartPledge[],
  streakResults: Map<string, StreakResult>
): UserBadge[] {
  const result: UserBadge[] = [];

  for (const badge of SYSTEM_BADGES) {
    let progress = 0;
    let earned = false;

    switch (badge.conditionType) {
      case 'total_habits':
        progress = habits.length;
        earned = habits.length >= badge.threshold;
        break;

      case 'streak_days': {
        let maxStreak = 0;
        for (const sr of streakResults.values()) {
          const val = Math.max(sr.current, sr.longest);
          if (val > maxStreak) {
            maxStreak = val;
          }
        }
        progress = maxStreak;
        earned = maxStreak >= badge.threshold;
        break;
      }

      case 'restart_pledge':
        progress = pledges.length;
        earned = pledges.length >= badge.threshold;
        break;

      case 'water_volume': {
        const waterEntries = entries.filter(e => {
          const h = habits.find(habit => habit.id === e.habitId);
          return h && (h.category === 'water' || h.name.toLowerCase().includes('su'));
        });
        const totalMl = waterEntries.reduce((sum, e) => {
          // normalize to ml: if value < 10 treat as liters
          const ml = e.value < 15 ? e.value * 1000 : e.value;
          return sum + ml;
        }, 0);
        progress = Math.round(totalMl);
        earned = totalMl >= badge.threshold;
        break;
      }

      case 'book_pages': {
        const bookEntries = entries.filter(e => {
          const h = habits.find(habit => habit.id === e.habitId);
          return h && (h.category === 'book' || h.name.toLowerCase().includes('kitap'));
        });
        const totalPages = bookEntries.reduce((sum, e) => sum + e.value, 0);
        progress = totalPages;
        earned = totalPages >= badge.threshold;
        break;
      }

      case 'distance': {
        const runEntries = entries.filter(e => {
          const h = habits.find(habit => habit.id === e.habitId);
          return h && (h.category === 'running' || h.category === 'walking' || h.unit === 'km');
        });
        const totalKm = runEntries.reduce((sum, e) => sum + e.value, 0);
        progress = Math.round(totalKm);
        earned = totalKm >= badge.threshold;
        break;
      }
    }

    result.push({
      badgeId: badge.id,
      earnedAt: earned ? new Date().toISOString() : '',
      progress
    });
  }

  return result;
}
