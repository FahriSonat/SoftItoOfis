import React, { useState, useEffect, useMemo, useCallback } from 'react';
import {
  Habit,
  HabitEntry,
  TriggerNote,
  CopingStrategy,
  RestartPledge,
  UserProfile,
  StreakResult
} from './types/models';
import { repository } from './storage/repository';
import { evaluateHabitStreak, isDayCompleted, getDailyProgressMap } from './domain/streakEngine';
import { evaluateBadges } from './domain/badgeEngine';
import { BottomNav, NavTab } from './components/Navigation/BottomNav';
import { HabitCard } from './components/HabitCard/HabitCard';
import { HabitDetailView } from './components/Detail/HabitDetailView';
import { AddHabitModal } from './components/Modals/AddHabitModal';
import { LogEntryModal } from './components/Modals/LogEntryModal';
import { StrugglingModal } from './components/Modals/StrugglingModal';
import { BreakStreakModal } from './components/Modals/BreakStreakModal';
import { TriggerNoteModal } from './components/Modals/TriggerNoteModal';
import { CopingStrategyModal } from './components/Modals/CopingStrategyModal';
import { ProfileModal } from './components/Modals/ProfileModal';
import {
  Plus,
  Shield,
  Sparkles,
  Flame,
  CheckCircle2,
  HeartHandshake,
  TrendingUp,
  AlertCircle
} from 'lucide-react';

interface ToastInfo {
  id: string;
  message: string;
  type?: 'success' | 'info' | 'warning';
}

export const App: React.FC = () => {
  // Global State
  const [profile, setProfile] = useState<UserProfile>(repository.getProfile());
  const [habits, setHabits] = useState<Habit[]>([]);
  const [entries, setEntries] = useState<HabitEntry[]>([]);
  const [notes, setNotes] = useState<TriggerNote[]>([]);
  const [strategies, setStrategies] = useState<CopingStrategy[]>([]);
  const [pledges, setPledges] = useState<RestartPledge[]>([]);

  // Navigation & View State
  const [activeTab, setActiveTab] = useState<NavTab>('home');
  const [selectedHabitId, setSelectedHabitId] = useState<string | null>(null);

  // Active Modals
  const [modalType, setModalType] = useState<
    | null
    | 'add_habit'
    | 'log_entry'
    | 'struggling'
    | 'break_streak'
    | 'add_note'
    | 'add_strategy'
    | 'profile'
  >(null);
  const [modalTargetHabit, setModalTargetHabit] = useState<Habit | null>(null);

  // Toasts
  const [toasts, setToasts] = useState<ToastInfo[]>([]);

  // Clock tick for live timers
  const [, setClock] = useState<number>(Date.now());

  const showToast = useCallback((message: string, type: 'success' | 'info' | 'warning' = 'success') => {
    const id = 'toast_' + Date.now();
    setToasts(prev => [...prev, { id, message, type }]);
    setTimeout(() => {
      setToasts(prev => prev.filter(t => t.id !== id));
    }, 3500);
  }, []);

  // Initialize data on mount
  useEffect(() => {
    repository.initialize();
    setProfile(repository.getProfile());
    setHabits(repository.getHabits());
    setEntries(repository.getEntries());
    setNotes(repository.getNotes());
    setStrategies(repository.getStrategies());
    setPledges(repository.getPledges());

    // Update time every 15s for live streak display
    const timer = setInterval(() => {
      setClock(Date.now());
    }, 15000);

    return () => clearInterval(timer);
  }, []);

  // Calculate streaks map for all habits
  const streakResults = useMemo(() => {
    const map = new Map<string, StreakResult>();
    for (const h of habits) {
      map.set(h.id, evaluateHabitStreak(h, entries));
    }
    return map;
  }, [habits, entries]);

  // Evaluate user badges
  const userBadges = useMemo(() => {
    return evaluateBadges(habits, entries, pledges, streakResults);
  }, [habits, entries, pledges, streakResults]);

  // Partition habits
  const negativeHabits = useMemo(() => habits.filter(h => h.kind === 'negative'), [habits]);
  const positiveHabits = useMemo(() => habits.filter(h => h.kind === 'positive'), [habits]);

  // Selected habit object for detail view
  const selectedHabit = useMemo(
    () => (selectedHabitId ? habits.find(h => h.id === selectedHabitId) || null : null),
    [selectedHabitId, habits]
  );

  // Overall Daily Summary
  const dailySummary = useMemo(() => {
    const now = new Date();
    let completedPositives = 0;
    for (const h of positiveHabits) {
      const dailyMap = getDailyProgressMap(h, entries);
      if (isDayCompleted(h, dailyMap, now)) {
        completedPositives++;
      }
    }

    let activeNegatives = 0;
    for (const h of negativeHabits) {
      const sr = streakResults.get(h.id);
      if (sr && sr.status === 'active') {
        activeNegatives++;
      }
    }

    const totalTracked = positiveHabits.length;
    const completionPercent = totalTracked > 0 ? Math.round((completedPositives / totalTracked) * 100) : 100;

    return {
      completedPositives,
      totalPositives: totalTracked,
      activeNegatives,
      completionPercent
    };
  }, [positiveHabits, negativeHabits, entries, streakResults]);

  // --- Actions ---

  const handleCreateHabit = (newHabit: Habit) => {
    repository.upsertHabit(newHabit);
    setHabits(repository.getHabits());
    showToast(`"${newHabit.name}" alışkanlığı oluşturuldu.`);
    // Navigate directly to the corresponding tab
    setActiveTab(newHabit.kind);
  };

  const handleDeleteHabit = (habitId: string) => {
    const h = habits.find(x => x.id === habitId);
    repository.deleteHabit(habitId);
    setHabits(repository.getHabits());
    setEntries(repository.getEntries());
    setNotes(repository.getNotes());
    setSelectedHabitId(null);
    showToast(`"${h?.name || 'Alışkanlık'}" silindi.`, 'warning');
  };

  const handleSaveEntry = (entry: HabitEntry) => {
    repository.addEntry(entry);
    setEntries(repository.getEntries());
    showToast(`+${entry.value} ${entry.unit} kaydedildi.`);
  };

  const handleQuickLog = (habit: Habit) => {
    if (habit.category === 'water') {
      const entry: HabitEntry = {
        id: 'entry_' + Date.now(),
        habitId: habit.id,
        userId: habit.userId,
        entryType: 'progress',
        value: 250,
        unit: 'ml',
        occurredAt: new Date().toISOString(),
        note: '+250 ml hızlı su kaydı',
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };
      handleSaveEntry(entry);
    } else {
      setModalTargetHabit(habit);
      setModalType('log_entry');
    }
  };

  const handleStrugglingAction = (habit: Habit) => {
    setModalTargetHabit(habit);
    setModalType('struggling');
  };

  const handleSaveStrugglingOutcome = (note: TriggerNote, strategyUsedId?: string) => {
    repository.addNote(note);
    setNotes(repository.getNotes());
    if (strategyUsedId) {
      repository.incrementStrategyUse(strategyUsedId);
      setStrategies(repository.getStrategies());
    }
    showToast('Zorlanma deneyimi günlüğe kaydedildi.');
  };

  const handleTriggerBreakStreak = (habit: Habit) => {
    // Record lapse
    const lapse: HabitEntry = {
      id: 'lapse_' + Date.now(),
      habitId: habit.id,
      userId: habit.userId,
      entryType: 'lapse',
      value: 1,
      unit: habit.unit,
      occurredAt: new Date().toISOString(),
      note: 'Seri kesintisi bildirildi',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };
    repository.addEntry(lapse);
    setEntries(repository.getEntries());

    // Open reflection & restart pledge modal
    setModalTargetHabit(habit);
    setModalType('break_streak');
  };

  const handleCommitRestartPledge = (pledge: RestartPledge) => {
    repository.addPledge(pledge);
    setPledges(repository.getPledges());

    // Update habit startAt to NOW
    if (modalTargetHabit) {
      const updated: Habit = {
        ...modalTargetHabit,
        startAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
      };
      repository.upsertHabit(updated);
      setHabits(repository.getHabits());
      showToast('Sözün kaydedildi. Yeni serin başladı! ✨');
    }
    setModalType(null);
  };

  const handleSaveStrategy = (strategy: CopingStrategy) => {
    repository.upsertStrategy(strategy);
    setStrategies(repository.getStrategies());
    showToast('Çözüm yöntemi kaydedildi.');
  };

  const handleExportData = () => {
    const dataStr = repository.exportData();
    const blob = new Blob([dataStr], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = `denge_yedek_${new Date().toISOString().slice(0, 10)}.json`;
    link.click();
    URL.revokeObjectURL(url);
    showToast('Tüm veriler indirildi.');
  };

  const handleClearAllData = () => {
    repository.clearAllData();
    setProfile(repository.getProfile());
    setHabits(repository.getHabits());
    setEntries(repository.getEntries());
    setNotes(repository.getNotes());
    setStrategies(repository.getStrategies());
    setPledges(repository.getPledges());
    setSelectedHabitId(null);
    showToast('Tüm veriler sıfırlandı.', 'warning');
  };

  return (
    <div className="app-container">
      {/* Header */}
      <header className="app-header">
        <div className="header-left">
          <h1 className="header-title">Denge</h1>
          <p className="header-date">
            {new Date().toLocaleDateString('tr-TR', { weekday: 'long', day: 'numeric', month: 'long' })}
          </p>
        </div>

        <div className="header-actions">
          <button
            className="btn-icon btn-add-primary"
            onClick={() => {
              setModalTargetHabit(null);
              setModalType('add_habit');
            }}
            aria-label="Yeni Alışkanlık Ekle"
          >
            <Plus size={22} color="#071018" strokeWidth={2.8} />
          </button>

          <button
            className="btn-icon"
            onClick={() => setModalType('profile')}
            aria-label="Profil ve Ayarlar"
          >
            <span style={{ fontSize: '18px' }}>{profile.avatar}</span>
          </button>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="main-content">
        {/* If a habit is selected, show its full detail view */}
        {selectedHabit ? (
          <HabitDetailView
            habit={selectedHabit}
            entries={entries.filter(e => e.habitId === selectedHabit.id)}
            streak={streakResults.get(selectedHabit.id) || evaluateHabitStreak(selectedHabit, entries)}
            notes={notes.filter(n => n.habitId === selectedHabit.id)}
            strategies={strategies}
            onBack={() => setSelectedHabitId(null)}
            onQuickLog={handleQuickLog}
            onStruggling={handleStrugglingAction}
            onBreakStreak={handleTriggerBreakStreak}
            onAddNote={(h) => {
              setModalTargetHabit(h);
              setModalType('add_note');
            }}
            onAddStrategy={(h) => {
              setModalTargetHabit(h);
              setModalType('add_strategy');
            }}
            onDeleteHabit={handleDeleteHabit}
          />
        ) : (
          <>
            {/* VIEW 1: HOME (ANA SAYFA) */}
            {activeTab === 'home' && (
              <>
                {/* Daily Balance Card */}
                <section className="daily-balance-card" aria-label="Günün Dengesi">
                  <div className="balance-header">
                    <div>
                      <span className="balance-title">Bugünkü Dengen</span>
                      <h2 className="balance-summary">
                        {dailySummary.totalPositives > 0
                          ? `${dailySummary.totalPositives} hedefin ${dailySummary.completedPositives}'i tamamlandı`
                          : 'Bugün için hedeflerini belirle'}
                      </h2>
                    </div>
                    <div style={{ textAlign: 'right' }}>
                      <span style={{ fontSize: '24px', fontWeight: 800, color: 'var(--positive-stage-3)' }}>
                        %{dailySummary.completionPercent}
                      </span>
                    </div>
                  </div>

                  {/* Dual progress bar */}
                  <div className="balance-bar-container">
                    <div
                      className="balance-bar-fill"
                      style={{ width: `${dailySummary.completionPercent}%` }}
                    />
                  </div>

                  <div className="balance-footer">
                    <span>🛡️ {dailySummary.activeNegatives} aktif uzak durma serisi</span>
                    <span>🌱 {dailySummary.completedPositives}/{dailySummary.totalPositives} pozitif tamamlandı</span>
                  </div>

                  <div className="motivation-quote">
                    “Uzak durduklarını güçlendir, hayatına kattıklarını büyüt. Her küçük adım senin emeğin.”
                  </div>
                </section>

                {/* Critical Habits Section */}
                <div className="section-header">
                  <h3 className="section-title">
                    <Flame size={18} color="var(--positive-stage-3)" />
                    <span>Öncelikli Alışkanlıklar</span>
                  </h3>
                  <span className="section-badge">{habits.length} takip ediliyor</span>
                </div>

                {habits.length === 0 ? (
                  <div style={{ textAlign: 'center', padding: '48px 20px', background: 'var(--color-bg-surface)', borderRadius: 'var(--radius-xl)' }}>
                    <span style={{ fontSize: '42px', display: 'block', marginBottom: '12px' }}>🌱</span>
                    <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#F8FAFC', marginBottom: '6px' }}>
                      İlk Adımını Seç
                    </h3>
                    <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', marginBottom: '20px' }}>
                      Hayatına değer katmak istediğin veya uzak durmak istediğin ilk alışkanlığını ekle.
                    </p>
                    <button
                      className="btn-primary"
                      onClick={() => setModalType('add_habit')}
                      style={{ maxWidth: '240px', margin: '0 auto' }}
                    >
                      <Plus size={18} />
                      <span>Alışkanlık Ekle</span>
                    </button>
                  </div>
                ) : (
                  <div>
                    {habits.map(h => {
                      const sr = streakResults.get(h.id) || evaluateHabitStreak(h, entries);
                      return (
                        <HabitCard
                          key={h.id}
                          habit={h}
                          entries={entries}
                          streak={sr}
                          onClick={() => setSelectedHabitId(h.id)}
                          onQuickLog={handleQuickLog}
                          onStruggling={handleStrugglingAction}
                        />
                      );
                    })}
                  </div>
                )}
              </>
            )}

            {/* VIEW 2: NEGATIVE (UZAK DURDUKLARIM) */}
            {activeTab === 'negative' && (
              <>
                <div style={{ marginBottom: '20px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                      <h2 style={{ fontSize: '22px', fontWeight: 800, color: '#F8FAFC' }}>
                        Uzak Durduklarım
                      </h2>
                      <p style={{ fontSize: '13px', color: 'var(--color-text-secondary)', marginTop: '2px' }}>
                        Geçen her süre ilerlemenin ve özgürlüğünün bir parçası.
                      </p>
                    </div>

                    <button
                      className="btn-icon btn-add-primary"
                      onClick={() => {
                        setModalTargetHabit(null);
                        setModalType('add_habit');
                      }}
                      aria-label="Yeni Negatif Alışkanlık Ekle"
                    >
                      <Plus size={20} color="#071018" />
                    </button>
                  </div>
                </div>

                {negativeHabits.length === 0 ? (
                  <div style={{ textAlign: 'center', padding: '48px 20px', background: 'var(--color-bg-surface)', borderRadius: 'var(--radius-xl)' }}>
                    <span style={{ fontSize: '42px', display: 'block', marginBottom: '12px' }}>🛡️</span>
                    <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#F8FAFC', marginBottom: '6px' }}>
                      Uzak durmak istediğin bir şey var mı?
                    </h3>
                    <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', marginBottom: '20px' }}>
                      Hazır olduğunda bir hedef ekleyebilir ve kendi hızında ilerleyebilirsin.
                    </p>
                    <button
                      className="btn-primary"
                      onClick={() => setModalType('add_habit')}
                      style={{ maxWidth: '240px', margin: '0 auto', background: 'linear-gradient(135deg, #FF5D68 0%, #F59E45 100%)' }}
                    >
                      <Plus size={18} />
                      <span>Uzak Durma Hedefi Ekle</span>
                    </button>
                  </div>
                ) : (
                  <div>
                    {negativeHabits.map(h => {
                      const sr = streakResults.get(h.id) || evaluateHabitStreak(h, entries);
                      return (
                        <HabitCard
                          key={h.id}
                          habit={h}
                          entries={entries}
                          streak={sr}
                          onClick={() => setSelectedHabitId(h.id)}
                          onStruggling={handleStrugglingAction}
                        />
                      );
                    })}
                  </div>
                )}
              </>
            )}

            {/* VIEW 3: POSITIVE (HAYATIMA KATTIKLARIM) */}
            {activeTab === 'positive' && (
              <>
                <div style={{ marginBottom: '20px' }}>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div>
                      <h2 style={{ fontSize: '22px', fontWeight: 800, color: '#F8FAFC' }}>
                        Hayatıma Kattıklarım
                      </h2>
                      <p style={{ fontSize: '13px', color: 'var(--color-text-secondary)', marginTop: '2px' }}>
                        Küçük adımlar, tekrarlandığında yaşam tarzına dönüşür.
                      </p>
                    </div>

                    <button
                      className="btn-icon btn-add-primary"
                      onClick={() => {
                        setModalTargetHabit(null);
                        setModalType('add_habit');
                      }}
                      aria-label="Yeni Pozitif Alışkanlık Ekle"
                    >
                      <Plus size={20} color="#071018" />
                    </button>
                  </div>
                </div>

                {positiveHabits.length === 0 ? (
                  <div style={{ textAlign: 'center', padding: '48px 20px', background: 'var(--color-bg-surface)', borderRadius: 'var(--radius-xl)' }}>
                    <span style={{ fontSize: '42px', display: 'block', marginBottom: '12px' }}>🌱</span>
                    <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#F8FAFC', marginBottom: '6px' }}>
                      Yeni bir rutin başlat
                    </h3>
                    <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', marginBottom: '20px' }}>
                      Su içme, kitap okuma, spor veya meditasyon gibi alışkanlıklarla gününü zenginleştir.
                    </p>
                    <button
                      className="btn-primary"
                      onClick={() => setModalType('add_habit')}
                      style={{ maxWidth: '240px', margin: '0 auto' }}
                    >
                      <Plus size={18} />
                      <span>Pozitif Alışkanlık Ekle</span>
                    </button>
                  </div>
                ) : (
                  <div>
                    {positiveHabits.map(h => {
                      const sr = streakResults.get(h.id) || evaluateHabitStreak(h, entries);
                      return (
                        <HabitCard
                          key={h.id}
                          habit={h}
                          entries={entries}
                          streak={sr}
                          onClick={() => setSelectedHabitId(h.id)}
                          onQuickLog={handleQuickLog}
                        />
                      );
                    })}
                  </div>
                )}
              </>
            )}
          </>
        )}
      </main>

      {/* Fixed Bottom Navigation (3 Tabs: Sol=Negatif, Orta=Ana Sayfa, Sağ=Pozitif) */}
      <BottomNav
        activeTab={activeTab}
        onTabChange={(tab) => {
          setSelectedHabitId(null);
          setActiveTab(tab);
        }}
        negativeCount={negativeHabits.length}
        positiveCount={positiveHabits.length}
      />

      {/* --- MODALS --- */}

      {/* Add Habit Modal */}
      {modalType === 'add_habit' && (
        <AddHabitModal
          initialKind={activeTab === 'negative' ? 'negative' : 'positive'}
          onClose={() => setModalType(null)}
          onCreate={handleCreateHabit}
        />
      )}

      {/* Log Entry Modal */}
      {modalType === 'log_entry' && modalTargetHabit && (
        <LogEntryModal
          habit={modalTargetHabit}
          onClose={() => setModalType(null)}
          onSaveEntry={handleSaveEntry}
        />
      )}

      {/* Struggling Focus Modal */}
      {modalType === 'struggling' && modalTargetHabit && (
        <StrugglingModal
          habit={modalTargetHabit}
          strategies={strategies}
          onClose={() => setModalType(null)}
          onSaveOutcome={handleSaveStrugglingOutcome}
        />
      )}

      {/* Break Streak & Pledge Modal */}
      {modalType === 'break_streak' && modalTargetHabit && (
        <BreakStreakModal
          habit={modalTargetHabit}
          previousDurationDays={streakResults.get(modalTargetHabit.id)?.longest || 0}
          strategies={strategies}
          onClose={() => setModalType(null)}
          onCommitRestart={handleCommitRestartPledge}
        />
      )}

      {/* Trigger Note Modal */}
      {modalType === 'add_note' && modalTargetHabit && (
        <TriggerNoteModal
          habit={modalTargetHabit}
          onClose={() => setModalType(null)}
          onSaveNote={(n) => {
            repository.addNote(n);
            setNotes(repository.getNotes());
            showToast('Zorlanma kaydı günlüğe eklendi.');
          }}
        />
      )}

      {/* Coping Strategy Modal */}
      {modalType === 'add_strategy' && (
        <CopingStrategyModal
          habitId={modalTargetHabit?.id}
          onClose={() => setModalType(null)}
          onSaveStrategy={handleSaveStrategy}
        />
      )}

      {/* Profile & Settings Modal */}
      {modalType === 'profile' && (
        <ProfileModal
          profile={profile}
          userBadges={userBadges}
          onClose={() => setModalType(null)}
          onSaveProfile={(p) => {
            repository.saveProfile(p);
            setProfile(p);
            showToast('Ayarlar güncellendi.');
          }}
          onExportData={handleExportData}
          onClearAllData={handleClearAllData}
        />
      )}

      {/* Toast Notification Container */}
      <div className="toast-container" aria-live="polite">
        {toasts.map(t => (
          <div key={t.id} className="toast-message">
            <CheckCircle2 size={16} color="var(--positive-stage-3)" />
            <span>{t.message}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default App;
