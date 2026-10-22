import {
  Habit,
  HabitEntry,
  TriggerNote,
  CopingStrategy,
  RestartPledge,
  UserProfile
} from '../types/models';

const STORAGE_KEY_HABITS = 'denge_habits_v1';
const STORAGE_KEY_ENTRIES = 'denge_entries_v1';
const STORAGE_KEY_NOTES = 'denge_notes_v1';
const STORAGE_KEY_STRATEGIES = 'denge_strategies_v1';
const STORAGE_KEY_PLEDGES = 'denge_pledges_v1';
const STORAGE_KEY_PROFILE = 'denge_profile_v1';

export const DEFAULT_USER: UserProfile = {
  id: 'user_default',
  displayName: 'Deniz',
  email: 'deniz@denge.app',
  avatar: '🌊',
  timezone: Intl.DateTimeFormat().resolvedOptions().timeZone || 'Europe/Istanbul',
  locale: 'tr-TR',
  createdAt: new Date().toISOString(),
  notificationPreferences: {
    enabled: true,
    quietHoursStart: '23:00',
    quietHoursEnd: '07:30',
    neutralLockscreen: true
  }
};

export const INITIAL_STRATEGIES: CopingStrategy[] = [
  {
    id: 'strat_1',
    title: '2 Dakika Sakin Nefes Molası',
    actionText: '4 saniye nefes al, 4 saniye tut, 6 saniye yavaşça ver. Gözlerini dinlendir.',
    estimatedMinutes: 2,
    triggerTags: ['stres', 'yorgunluk', 'öfke'],
    effectivenessScore: 5,
    isFavorite: true,
    timesUsed: 6,
    createdAt: new Date(Date.now() - 7 * 86400000).toISOString()
  },
  {
    id: 'strat_2',
    title: 'Bir Bardak Soğuk Su İç',
    actionText: 'Mutfağa git, büyük bir bardak soğuk su doldur ve yudum yudum iç.',
    estimatedMinutes: 2,
    triggerTags: ['sıkılma', 'dürtü', 'alışkanlık'],
    effectivenessScore: 4,
    isFavorite: true,
    timesUsed: 4,
    createdAt: new Date(Date.now() - 5 * 86400000).toISOString()
  },
  {
    id: 'strat_3',
    title: 'Telefonu Başka Odaya Bırak',
    actionText: 'Cihazı sessize al, ekranı ters çevirip başka bir odaya koy.',
    estimatedMinutes: 10,
    triggerTags: ['sosyal medya', 'bildirim', 'gece dürtüsü'],
    effectivenessScore: 5,
    isFavorite: true,
    timesUsed: 8,
    createdAt: new Date(Date.now() - 4 * 86400000).toISOString()
  },
  {
    id: 'strat_4',
    title: 'Kısa Açık Hava Yürüyüşü',
    actionText: 'Balkona çık veya binanın etrafında 5 dakika temiz hava al.',
    estimatedMinutes: 5,
    triggerTags: ['stres', 'çaresizlik', 'kapana kısılma'],
    effectivenessScore: 4,
    isFavorite: false,
    timesUsed: 3,
    createdAt: new Date(Date.now() - 2 * 86400000).toISOString()
  }
];

export const INITIAL_HABITS: Habit[] = [
  {
    id: 'habit_neg_1',
    userId: 'user_default',
    name: 'Sosyal Medya Bağımlılığı',
    kind: 'negative',
    category: 'social_media',
    icon: '📱',
    status: 'active',
    startAt: new Date(Date.now() - 4 * 86400000 - 6 * 3600000).toISOString(), // 4 days 6 hours ago
    measurementType: 'duration',
    targetValue: 0,
    unit: 'dakika',
    scheduleType: 'daily',
    scheduleConfig: {},
    reminders: ['21:00'],
    neutralNotification: true,
    previousFrequencyPerDay: 5,
    estimatedCostPerUnit: 0,
    estimatedTimePerOccurrenceMinutes: 30, // 150 mins saved per day
    createdAt: new Date(Date.now() - 5 * 86400000).toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: 'habit_pos_1',
    userId: 'user_default',
    name: 'Günlük Su Tüketimi',
    kind: 'positive',
    category: 'water',
    icon: '💧',
    status: 'active',
    startAt: new Date(Date.now() - 6 * 86400000).toISOString(),
    measurementType: 'volume',
    targetValue: 2000,
    unit: 'ml',
    scheduleType: 'daily',
    scheduleConfig: {},
    reminders: ['10:00', '14:00', '18:00', '20:30'],
    neutralNotification: false,
    createdAt: new Date(Date.now() - 6 * 86400000).toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: 'habit_pos_2',
    userId: 'user_default',
    name: 'Akşam Kitap Okuma',
    kind: 'positive',
    category: 'book',
    icon: '📖',
    status: 'active',
    startAt: new Date(Date.now() - 5 * 86400000).toISOString(),
    measurementType: 'pages',
    targetValue: 20,
    unit: 'sayfa',
    scheduleType: 'daily',
    scheduleConfig: {},
    reminders: ['21:30'],
    neutralNotification: false,
    createdAt: new Date(Date.now() - 5 * 86400000).toISOString(),
    updatedAt: new Date().toISOString()
  }
];

export const INITIAL_ENTRIES: HabitEntry[] = [
  // Water entries for today (1500ml logged so far)
  {
    id: 'entry_w_1',
    habitId: 'habit_pos_1',
    userId: 'user_default',
    entryType: 'progress',
    value: 500,
    unit: 'ml',
    occurredAt: new Date(Date.now() - 5 * 3600000).toISOString(),
    note: 'Sabah büyük bardak',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: 'entry_w_2',
    habitId: 'habit_pos_1',
    userId: 'user_default',
    entryType: 'progress',
    value: 500,
    unit: 'ml',
    occurredAt: new Date(Date.now() - 3 * 3600000).toISOString(),
    note: 'Öğle yemeği sonrası',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  {
    id: 'entry_w_3',
    habitId: 'habit_pos_1',
    userId: 'user_default',
    entryType: 'progress',
    value: 500,
    unit: 'ml',
    occurredAt: new Date(Date.now() - 1 * 3600000).toISOString(),
    note: 'İkindi takviyesi',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  // Yesterday completed (2000ml)
  {
    id: 'entry_w_y',
    habitId: 'habit_pos_1',
    userId: 'user_default',
    entryType: 'completion',
    value: 2000,
    unit: 'ml',
    occurredAt: new Date(Date.now() - 86400000).toISOString(),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  // Day before completed (2200ml)
  {
    id: 'entry_w_y2',
    habitId: 'habit_pos_1',
    userId: 'user_default',
    entryType: 'completion',
    value: 2200,
    unit: 'ml',
    occurredAt: new Date(Date.now() - 2 * 86400000).toISOString(),
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  },
  // Book yesterday completed (25 pages)
  {
    id: 'entry_b_y',
    habitId: 'habit_pos_2',
    userId: 'user_default',
    entryType: 'completion',
    value: 25,
    unit: 'sayfa',
    occurredAt: new Date(Date.now() - 86400000).toISOString(),
    note: 'Bölüm 4 bitti',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }
];

export const INITIAL_NOTES: TriggerNote[] = [
  {
    id: 'note_1',
    habitId: 'habit_neg_1',
    userId: 'user_default',
    occurredAt: new Date(Date.now() - 2 * 86400000).toISOString(),
    triggerTags: ['gece', 'sıkılma'],
    emotionTags: ['yalnızlık'],
    intensity: 4,
    context: 'Yatakta uyumaya çalışırken',
    note: 'Uykum gelmeyince otomatik olarak telefona uzandım, hemen fark edip suyu tercih ettim.'
  }
];

class AppRepository {
  private get<T>(key: string, fallback: T): T {
    try {
      const data = localStorage.getItem(key);
      if (!data) return fallback;
      return JSON.parse(data) as T;
    } catch {
      return fallback;
    }
  }

  private set<T>(key: string, value: T): void {
    try {
      localStorage.setItem(key, JSON.stringify(value));
    } catch (e) {
      console.error('LocalStorage write error', e);
    }
  }

  initialize(): void {
    if (!localStorage.getItem(STORAGE_KEY_HABITS)) {
      this.set(STORAGE_KEY_HABITS, INITIAL_HABITS);
      this.set(STORAGE_KEY_ENTRIES, INITIAL_ENTRIES);
      this.set(STORAGE_KEY_NOTES, INITIAL_NOTES);
      this.set(STORAGE_KEY_STRATEGIES, INITIAL_STRATEGIES);
      this.set(STORAGE_KEY_PLEDGES, []);
      this.set(STORAGE_KEY_PROFILE, DEFAULT_USER);
    }
  }

  getProfile(): UserProfile {
    return this.get<UserProfile>(STORAGE_KEY_PROFILE, DEFAULT_USER);
  }

  saveProfile(profile: UserProfile): void {
    this.set(STORAGE_KEY_PROFILE, profile);
  }

  getHabits(): Habit[] {
    return this.get<Habit[]>(STORAGE_KEY_HABITS, []);
  }

  saveHabits(habits: Habit[]): void {
    this.set(STORAGE_KEY_HABITS, habits);
  }

  upsertHabit(habit: Habit): void {
    const habits = this.getHabits();
    const idx = habits.findIndex(h => h.id === habit.id);
    if (idx >= 0) {
      habits[idx] = { ...habit, updatedAt: new Date().toISOString() };
    } else {
      habits.push(habit);
    }
    this.saveHabits(habits);
  }

  deleteHabit(habitId: string): void {
    const habits = this.getHabits().filter(h => h.id !== habitId);
    this.saveHabits(habits);
    // Also remove related entries and notes
    const entries = this.getEntries().filter(e => e.habitId !== habitId);
    this.saveEntries(entries);
    const notes = this.getNotes().filter(n => n.habitId !== habitId);
    this.saveNotes(notes);
  }

  getEntries(): HabitEntry[] {
    return this.get<HabitEntry[]>(STORAGE_KEY_ENTRIES, []);
  }

  saveEntries(entries: HabitEntry[]): void {
    this.set(STORAGE_KEY_ENTRIES, entries);
  }

  addEntry(entry: HabitEntry): void {
    const entries = this.getEntries();
    // Idempotency check: don't insert duplicate by ID
    if (!entries.some(e => e.id === entry.id)) {
      entries.push(entry);
      this.saveEntries(entries);
    }
  }

  getNotes(): TriggerNote[] {
    return this.get<TriggerNote[]>(STORAGE_KEY_NOTES, []);
  }

  saveNotes(notes: TriggerNote[]): void {
    this.set(STORAGE_KEY_NOTES, notes);
  }

  addNote(note: TriggerNote): void {
    const notes = this.getNotes();
    notes.unshift(note);
    this.saveNotes(notes);
  }

  getStrategies(): CopingStrategy[] {
    return this.get<CopingStrategy[]>(STORAGE_KEY_STRATEGIES, INITIAL_STRATEGIES);
  }

  saveStrategies(strategies: CopingStrategy[]): void {
    this.set(STORAGE_KEY_STRATEGIES, strategies);
  }

  upsertStrategy(strategy: CopingStrategy): void {
    const list = this.getStrategies();
    const idx = list.findIndex(s => s.id === strategy.id);
    if (idx >= 0) {
      list[idx] = strategy;
    } else {
      list.unshift(strategy);
    }
    this.saveStrategies(list);
  }

  incrementStrategyUse(strategyId: string): void {
    const list = this.getStrategies();
    const item = list.find(s => s.id === strategyId);
    if (item) {
      item.timesUsed++;
      this.saveStrategies(list);
    }
  }

  getPledges(): RestartPledge[] {
    return this.get<RestartPledge[]>(STORAGE_KEY_PLEDGES, []);
  }

  savePledges(pledges: RestartPledge[]): void {
    this.set(STORAGE_KEY_PLEDGES, pledges);
  }

  addPledge(pledge: RestartPledge): void {
    const pledges = this.getPledges();
    pledges.unshift(pledge);
    this.savePledges(pledges);
  }

  exportData(): string {
    return JSON.stringify({
      version: '1.0.0',
      exportedAt: new Date().toISOString(),
      profile: this.getProfile(),
      habits: this.getHabits(),
      entries: this.getEntries(),
      notes: this.getNotes(),
      strategies: this.getStrategies(),
      pledges: this.getPledges()
    }, null, 2);
  }

  clearAllData(): void {
    localStorage.removeItem(STORAGE_KEY_HABITS);
    localStorage.removeItem(STORAGE_KEY_ENTRIES);
    localStorage.removeItem(STORAGE_KEY_NOTES);
    localStorage.removeItem(STORAGE_KEY_STRATEGIES);
    localStorage.removeItem(STORAGE_KEY_PLEDGES);
    localStorage.removeItem(STORAGE_KEY_PROFILE);
    this.initialize();
  }
}

export const repository = new AppRepository();
