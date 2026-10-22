import React, { useState } from 'react';
import {
  Habit,
  HabitEntry,
  StreakResult,
  TriggerNote,
  CopingStrategy,
  SavingsEstimate
} from '../../types/models';
import { calculateColorStage } from '../../domain/colorStage';
import { ProgressRing } from '../Common/ProgressRing';
import { estimateSavings } from '../../domain/savingsEstimator';
import { CalendarView } from '../Calendar/CalendarView';
import {
  ArrowLeft,
  Flame,
  Plus,
  HeartHandshake,
  AlertTriangle,
  Trash2,
  Edit2,
  Calendar,
  BookOpen,
  Sparkles,
  TrendingUp,
  Star
} from 'lucide-react';

interface HabitDetailViewProps {
  habit: Habit;
  entries: HabitEntry[];
  streak: StreakResult;
  notes: TriggerNote[];
  strategies: CopingStrategy[];
  onBack: () => void;
  onQuickLog: (habit: Habit) => void;
  onStruggling: (habit: Habit) => void;
  onBreakStreak: (habit: Habit) => void;
  onAddNote: (habit: Habit) => void;
  onAddStrategy: (habit: Habit) => void;
  onDeleteHabit: (habitId: string) => void;
}

export const HabitDetailView: React.FC<HabitDetailViewProps> = ({
  habit,
  entries,
  streak,
  notes,
  strategies,
  onBack,
  onQuickLog,
  onStruggling,
  onBreakStreak,
  onAddNote,
  onAddStrategy,
  onDeleteHabit
}) => {
  const [activeTab, setActiveTab] = useState<'overview' | 'calendar' | 'triggers' | 'strategies'>('overview');
  const [confirmDelete, setConfirmDelete] = useState(false);

  const isBroken = streak.status === 'broken';
  const stage = calculateColorStage(habit.kind, streak.current, isBroken);
  const isPositive = habit.kind === 'positive';

  // Savings for negative
  let savings: SavingsEstimate | null = null;
  if (!isPositive && streak.rawDurationSeconds) {
    savings = estimateSavings(habit, streak.rawDurationSeconds);
  }

  const isPrescriptionDrug = habit.category === 'medication' || habit.name.toLowerCase().includes('ilaç');

  return (
    <div style={{ paddingBottom: '40px' }}>
      {/* Top Bar */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '20px' }}>
        <button className="btn-icon" onClick={onBack} aria-label="Geri dön">
          <ArrowLeft size={20} />
        </button>

        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <span
            className="card-status-pill"
            style={{
              background: isBroken ? 'var(--restart-soft)' : `${stage.hex}18`,
              color: isBroken ? 'var(--restart-primary)' : stage.hex,
              border: `1px solid ${isBroken ? 'var(--restart-primary)' : stage.hex}33`
            }}
          >
            <Flame size={14} />
            <span>{isBroken ? 'Yeniden Başlama' : stage.label}</span>
          </span>

          <button
            className="btn-icon"
            onClick={() => setConfirmDelete(!confirmDelete)}
            aria-label="Alışkanlığı Sil"
            style={{ color: 'var(--danger-primary)' }}
          >
            <Trash2 size={18} />
          </button>
        </div>
      </div>

      {/* Delete confirmation banner */}
      {confirmDelete && (
        <div
          style={{
            padding: '14px 16px',
            borderRadius: 'var(--radius-lg)',
            background: 'rgba(255, 93, 104, 0.12)',
            border: '1px solid rgba(255, 93, 104, 0.4)',
            marginBottom: '20px',
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center'
          }}
        >
          <span style={{ fontSize: '13px', color: '#F8FAFC' }}>
            Bu alışkanlığı ve tüm geçmiş kayıtlarını silmek istediğine emin misin?
          </span>
          <div style={{ display: 'flex', gap: '8px' }}>
            <button className="btn-secondary" style={{ height: '36px', padding: '0 12px' }} onClick={() => setConfirmDelete(false)}>
              İptal
            </button>
            <button className="btn-primary" style={{ height: '36px', padding: '0 12px', background: 'var(--danger-primary)' }} onClick={() => onDeleteHabit(habit.id)}>
              Evet, Sil
            </button>
          </div>
        </div>
      )}

      {/* Hero Progress Ring */}
      <div
        style={{
          background: 'var(--color-bg-surface)',
          border: '1px solid var(--color-border-subtle)',
          borderRadius: 'var(--radius-xl)',
          padding: '28px 20px',
          textAlign: 'center',
          boxShadow: 'var(--shadow-card)',
          marginBottom: '24px',
          position: 'relative',
          overflow: 'hidden'
        }}
      >
        <div style={{ fontSize: '36px', marginBottom: '8px' }}>{habit.icon}</div>
        <h1 style={{ fontSize: '24px', fontWeight: 800, color: '#F8FAFC', marginBottom: '4px' }}>{habit.name}</h1>
        <p style={{ fontSize: '14px', color: 'var(--color-text-muted)', marginBottom: '24px' }}>
          {isPositive ? `Hedef: ${habit.targetValue} ${habit.unit} / gün` : stage.description}
        </p>

        {/* Big Ring */}
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: '20px' }}>
          <ProgressRing
            progress={1}
            size="large"
            colorHex={stage.hex}
            isBroken={isBroken}
            centerValue={streak.current}
            centerUnit={streak.unit === 'hour' ? 'saat' : streak.unit === 'day' ? 'gün' : 'periyot'}
          />
        </div>

        <p style={{ fontSize: '13px', color: 'var(--color-text-secondary)', marginBottom: '20px' }}>
          {streak.reason}
        </p>

        {/* Primary Action Buttons */}
        <div style={{ display: 'flex', gap: '10px', justifyContent: 'center' }}>
          {isPositive ? (
            <button className="btn-primary" onClick={() => onQuickLog(habit)} style={{ maxWidth: '280px' }}>
              <Plus size={18} />
              <span>İlerleme Kaydet</span>
            </button>
          ) : !isBroken ? (
            <>
              <button
                className="btn-primary"
                onClick={() => onStruggling(habit)}
                style={{
                  background: 'linear-gradient(135deg, #FF5D68 0%, #F59E45 100%)',
                  maxWidth: '220px'
                }}
              >
                <HeartHandshake size={18} />
                <span>Zorlanıyorum</span>
              </button>

              <button
                className="btn-secondary"
                onClick={() => onBreakStreak(habit)}
                style={{ borderColor: 'rgba(255, 159, 67, 0.4)', color: '#FFB347' }}
              >
                <span>Seriyi Bozdum</span>
              </button>
            </>
          ) : (
            <button className="btn-primary btn-orange-restart" onClick={() => onBreakStreak(habit)} style={{ maxWidth: '280px' }}>
              <Sparkles size={18} />
              <span>Söz Ver ve Yeniden Başla</span>
            </button>
          )}
        </div>
      </div>

      {/* Prescription Medication Medical Notice */}
      {isPrescriptionDrug && (
        <div className="medical-warning-box">
          <AlertTriangle size={18} style={{ flexShrink: 0, marginTop: '2px' }} />
          <div>
            <strong>Reçeteli İlaç Hatırlatması:</strong> Reçeteli bir ilacı hekim tavsiyesi olmadan bırakmamalı ve dozunu değiştirmemelisin. Bu uygulama tıbbi tanı veya tedavi amacıyla kullanılmaz.
          </div>
        </div>
      )}

      {/* Tabs */}
      <div
        style={{
          display: 'flex',
          gap: '8px',
          overflowX: 'auto',
          paddingBottom: '8px',
          marginBottom: '18px',
          borderBottom: '1px solid var(--color-border-subtle)'
        }}
      >
        <button
          className={`chip-item ${activeTab === 'overview' ? 'selected' : ''}`}
          onClick={() => setActiveTab('overview')}
        >
          <TrendingUp size={14} />
          <span>Genel Bakış</span>
        </button>
        <button
          className={`chip-item ${activeTab === 'calendar' ? 'selected' : ''}`}
          onClick={() => setActiveTab('calendar')}
        >
          <Calendar size={14} />
          <span>Takvim & Geçmiş</span>
        </button>
        <button
          className={`chip-item ${activeTab === 'triggers' ? 'selected' : ''}`}
          onClick={() => setActiveTab('triggers')}
        >
          <AlertTriangle size={14} />
          <span>Beni Zorlayanlar ({notes.length})</span>
        </button>
        <button
          className={`chip-item ${activeTab === 'strategies' ? 'selected' : ''}`}
          onClick={() => setActiveTab('strategies')}
        >
          <BookOpen size={14} />
          <span>Çözümlerim ({strategies.length})</span>
        </button>
      </div>

      {/* TAB CONTENT 1: Overview */}
      {activeTab === 'overview' && (
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {/* Savings Card (Negative) */}
          {savings && (
            <div
              style={{
                background: 'var(--color-bg-surface)',
                border: '1px solid var(--color-border-subtle)',
                borderRadius: 'var(--radius-xl)',
                padding: '20px'
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px' }}>
                <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#F8FAFC' }}>
                  Kazanım Göstergeleri
                </h3>
                <span
                  style={{
                    fontSize: '11px',
                    fontWeight: 600,
                    background: 'var(--color-bg-surfaceStrong)',
                    color: 'var(--color-text-muted)',
                    padding: '2px 8px',
                    borderRadius: 'var(--radius-full)'
                  }}
                >
                  Tahmini
                </span>
              </div>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '10px', textAlign: 'center' }}>
                <div style={{ background: 'var(--color-bg-surfaceStrong)', padding: '12px 8px', borderRadius: 'var(--radius-md)' }}>
                  <span style={{ fontSize: '20px', fontWeight: 800, color: 'var(--positive-stage-3)' }}>
                    {savings.unitsAvoided}
                  </span>
                  <p style={{ fontSize: '11px', color: 'var(--color-text-muted)', marginTop: '2px' }}>Tüketilmeyen ({habit.unit})</p>
                </div>

                <div style={{ background: 'var(--color-bg-surfaceStrong)', padding: '12px 8px', borderRadius: 'var(--radius-md)' }}>
                  <span style={{ fontSize: '20px', fontWeight: 800, color: 'var(--positive-stage-4)' }}>
                    {savings.moneySaved > 0 ? `${savings.moneySaved} ₺` : '—'}
                  </span>
                  <p style={{ fontSize: '11px', color: 'var(--color-text-muted)', marginTop: '2px' }}>Maddi Tasarruf</p>
                </div>

                <div style={{ background: 'var(--color-bg-surfaceStrong)', padding: '12px 8px', borderRadius: 'var(--radius-md)' }}>
                  <span style={{ fontSize: '20px', fontWeight: 800, color: 'var(--info-primary)' }}>
                    {savings.timeSavedMinutes > 0 ? `${Math.round(savings.timeSavedMinutes / 60)} sa` : '—'}
                  </span>
                  <p style={{ fontSize: '11px', color: 'var(--color-text-muted)', marginTop: '2px' }}>Kazanılan Zaman</p>
                </div>
              </div>
            </div>
          )}

          {/* Habit Details Info */}
          <div
            style={{
              background: 'var(--color-bg-surface)',
              border: '1px solid var(--color-border-subtle)',
              borderRadius: 'var(--radius-xl)',
              padding: '20px'
            }}
          >
            <h3 style={{ fontSize: '15px', fontWeight: 700, color: '#F8FAFC', marginBottom: '14px' }}>
              Alışkanlık Bilgileri
            </h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', fontSize: '14px', color: 'var(--color-text-secondary)' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span>Mevcut Seri</span>
                <strong style={{ color: '#F8FAFC' }}>{streak.current} {streak.unit}</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span>En Uzun Seri</span>
                <strong style={{ color: '#F8FAFC' }}>{streak.longest} {streak.unit}</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span>Başlangıç</span>
                <strong style={{ color: '#F8FAFC' }}>{new Date(habit.startAt).toLocaleDateString('tr-TR')}</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                <span>Hatırlatma</span>
                <strong style={{ color: '#F8FAFC' }}>
                  {habit.reminders.length > 0 ? habit.reminders.join(', ') : 'Belirlenmedi'}
                </strong>
              </div>
            </div>
          </div>
        </div>
      )}

      {/* TAB CONTENT 2: Calendar */}
      {activeTab === 'calendar' && (
        <CalendarView habit={habit} entries={entries} notes={notes} />
      )}

      {/* TAB CONTENT 3: Beni Zorlayanlar Günlüğü */}
      {activeTab === 'triggers' && (
        <div>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px' }}>
            <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)' }}>
              Zorlandığın anları fark etmek ve tetikleyicilerini görmek için kaydet.
            </p>
            <button className="btn-secondary" style={{ height: '38px', padding: '0 14px' }} onClick={() => onAddNote(habit)}>
              <Plus size={15} />
              <span>Not Ekle</span>
            </button>
          </div>

          {notes.length === 0 ? (
            <div style={{ textAlign: 'center', padding: '32px 16px', background: 'var(--color-bg-surface)', borderRadius: 'var(--radius-xl)' }}>
              <p style={{ color: 'var(--color-text-muted)', fontSize: '14px' }}>Henüz zorlanma notu eklenmemiş.</p>
              <button className="btn-secondary" style={{ marginTop: '12px' }} onClick={() => onAddNote(habit)}>
                İlk Notu Ekle
              </button>
            </div>
          ) : (
            <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
              {notes.map(n => (
                <div
                  key={n.id}
                  style={{
                    background: 'var(--color-bg-surface)',
                    border: '1px solid var(--color-border-subtle)',
                    borderRadius: 'var(--radius-lg)',
                    padding: '14px 16px'
                  }}
                >
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
                    <div style={{ display: 'flex', gap: '6px', flexWrap: 'wrap' }}>
                      {n.triggerTags.map(t => (
                        <span key={t} className="section-badge" style={{ background: 'rgba(255, 93, 104, 0.15)', color: 'var(--negative-stage-1)' }}>
                          {t}
                        </span>
                      ))}
                    </div>
                    <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
                      {new Date(n.occurredAt).toLocaleDateString('tr-TR')}
                    </span>
                  </div>
                  <p style={{ fontSize: '14px', color: '#F8FAFC', margin: '6px 0' }}>{n.note}</p>
                  {n.context && <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>Ortam: {n.context}</p>}
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* TAB CONTENT 4: Çözüm Yöntemlerim */}
      {activeTab === 'strategies' && (
        <div>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '14px' }}>
            <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)' }}>
              Zor anlarda başvurabileceğin kendi çözüm repertuvarın.
            </p>
            <button className="btn-secondary" style={{ height: '38px', padding: '0 14px' }} onClick={() => onAddStrategy(habit)}>
              <Plus size={15} />
              <span>Çözüm Ekle</span>
            </button>
          </div>

          <div style={{ display: 'flex', flexDirection: 'column', gap: '10px' }}>
            {strategies.map(s => (
              <div
                key={s.id}
                style={{
                  background: 'var(--color-bg-surface)',
                  border: '1px solid var(--color-border-subtle)',
                  borderRadius: 'var(--radius-lg)',
                  padding: '16px'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                    {s.isFavorite && <Star size={16} fill="#FF9F43" color="#FF9F43" />}
                    <h4 style={{ fontSize: '16px', fontWeight: 700, color: '#F8FAFC' }}>{s.title}</h4>
                  </div>
                  <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>~{s.estimatedMinutes} dk</span>
                </div>
                <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', margin: '8px 0 12px 0' }}>
                  {s.actionText}
                </p>
                <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                  <div style={{ display: 'flex', gap: '6px' }}>
                    {s.triggerTags.map(t => (
                      <span key={t} className="section-badge">{t}</span>
                    ))}
                  </div>
                  <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>{s.timesUsed} kez kullanıldı</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
