import React, { useState, useEffect } from 'react';
import { Habit, CopingStrategy, TriggerNote } from '../../types/models';
import { X, Play, CheckCircle2, AlertTriangle, ArrowRight, Sparkles } from 'lucide-react';

interface StrugglingModalProps {
  habit: Habit;
  strategies: CopingStrategy[];
  onClose: () => void;
  onSaveOutcome: (note: TriggerNote, strategyUsedId?: string) => void;
}

export const StrugglingModal: React.FC<StrugglingModalProps> = ({
  habit,
  strategies,
  onClose,
  onSaveOutcome
}) => {
  const [step, setStep] = useState<1 | 2 | 3>(1);
  const [timerSeconds, setTimerSeconds] = useState(120);
  const [isTimerRunning, setIsTimerRunning] = useState(false);
  const [selectedStrategy, setSelectedStrategy] = useState<CopingStrategy | null>(
    strategies.find(s => s.isFavorite) || strategies[0] || null
  );

  // Evaluation form state
  const [newIntensity, setNewIntensity] = useState<number>(2);
  const [urgeTrend, setUrgeTrend] = useState<'decreased' | 'same' | 'increased'>('decreased');
  const [noteText, setNoteText] = useState('');

  // Countdown timer effect
  useEffect(() => {
    let interval: ReturnType<typeof setInterval>;
    if (isTimerRunning && timerSeconds > 0) {
      interval = setInterval(() => {
        setTimerSeconds(prev => prev - 1);
      }, 1000);
    } else if (timerSeconds === 0 && isTimerRunning) {
      setIsTimerRunning(false);
      setStep(2); // Auto progress to small action step
    }
    return () => clearInterval(interval);
  }, [isTimerRunning, timerSeconds]);

  const handleFinish = () => {
    const note: TriggerNote = {
      id: 'note_' + Date.now(),
      habitId: habit.id,
      userId: habit.userId,
      occurredAt: new Date().toISOString(),
      triggerTags: selectedStrategy ? selectedStrategy.triggerTags : ['anlık dürtü'],
      emotionTags: [urgeTrend === 'decreased' ? 'sakinleşme' : 'direnç'],
      intensity: newIntensity,
      context: selectedStrategy ? selectedStrategy.title : '2 dakikalık mola',
      note: noteText || `Dürtü eğilimi: ${urgeTrend === 'decreased' ? 'Azaldı' : urgeTrend === 'same' ? 'Aynı' : 'Arttı'}. Yoğunluk: ${newIntensity}/5.`
    };

    onSaveOutcome(note, selectedStrategy?.id);
    onClose();
  };

  const isPrescriptionOrDrug = habit.category === 'medication' || habit.name.toLowerCase().includes('ilaç');

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="struggling-modal-title">
      <div className="modal-sheet" onClick={(e) => e.stopPropagation()} style={{ borderTop: '3px solid var(--negative-stage-1)' }}>
        {/* Header */}
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span style={{ fontSize: '20px' }}>🛡️</span>
            <div>
              <h2 id="struggling-modal-title" className="modal-title">Zorlanma Anı Desteği</h2>
              <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>{habit.name}</p>
            </div>
          </div>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        {/* Body */}
        <div className="modal-body">
          {/* Medical guidance banner if related to prescription medication */}
          {isPrescriptionOrDrug && (
            <div className="medical-warning-box">
              <AlertTriangle size={18} style={{ flexShrink: 0, marginTop: '2px' }} />
              <div>
                <strong>Önemli Sağlık Uyarısı:</strong> Reçeteli bir ilacı bırakmadan veya dozunu değiştirmeden önce mutlaka doktoruna ya da eczacına danışmalısın. Bu uygulama tıbbi tedavi yerine geçmez.
              </div>
            </div>
          )}

          {/* STEP 1: Calm Breathe & 2-Minute Delay */}
          {step === 1 && (
            <div style={{ textAlign: 'center', padding: '12px 0' }}>
              <p style={{ fontSize: '20px', fontWeight: 700, color: '#F8FAFC', marginBottom: '8px' }}>
                Bu dürtü geçici.
              </p>
              <p style={{ fontSize: '15px', color: 'var(--color-text-secondary)', marginBottom: '24px' }}>
                Karar vermeden önce iki dakika kendimize alan açalım ve nefesimize odaklanalım.
              </p>

              {/* Breathing circle timer */}
              <div
                style={{
                  width: '140px',
                  height: '140px',
                  borderRadius: '50%',
                  margin: '0 auto 24px auto',
                  background: 'rgba(255, 93, 104, 0.08)',
                  border: '2px solid rgba(255, 93, 104, 0.35)',
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  animation: isTimerRunning ? 'pulseRing 4s infinite ease-in-out' : 'none'
                }}
              >
                <span style={{ fontSize: '32px', fontWeight: 800, fontVariantNumeric: 'tabular-nums' }}>
                  {Math.floor(timerSeconds / 60)}:{String(timerSeconds % 60).padStart(2, '0')}
                </span>
                <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
                  {isTimerRunning ? 'Nefes al / ver' : '2 dakika'}
                </span>
              </div>

              <div style={{ display: 'flex', gap: '10px', justifyContent: 'center' }}>
                {!isTimerRunning ? (
                  <button
                    className="btn-primary"
                    onClick={() => setIsTimerRunning(true)}
                    style={{ background: 'linear-gradient(135deg, #FF5D68 0%, #F59E45 100%)', maxWidth: '240px' }}
                  >
                    <Play size={18} />
                    <span>2 Dakikayı Başlat</span>
                  </button>
                ) : (
                  <button
                    className="btn-secondary"
                    onClick={() => setStep(2)}
                  >
                    <span>Doğrudan Çözüme Geç</span>
                  </button>
                )}
              </div>
            </div>
          )}

          {/* STEP 2: Coping Action */}
          {step === 2 && (
            <div>
              <p style={{ fontSize: '17px', fontWeight: 700, color: '#F8FAFC', marginBottom: '6px' }}>
                Şimdi küçük bir eyleme odaklan
              </p>
              <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', marginBottom: '18px' }}>
                Geçmişte işe yarayan çözüm yöntemlerinden birini uygula:
              </p>

              {/* Strategy Cards */}
              <div style={{ display: 'flex', flexDirection: 'column', gap: '10px', marginBottom: '20px' }}>
                {strategies.map((strat) => (
                  <div
                    key={strat.id}
                    onClick={() => setSelectedStrategy(strat)}
                    style={{
                      padding: '14px 16px',
                      borderRadius: 'var(--radius-lg)',
                      background: selectedStrategy?.id === strat.id ? 'var(--color-bg-surfaceStrong)' : 'var(--color-bg-surface)',
                      border: `1px solid ${selectedStrategy?.id === strat.id ? 'var(--info-primary)' : 'var(--color-border-subtle)'}`,
                      cursor: 'pointer',
                      transition: 'all 160ms'
                    }}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                      <strong style={{ fontSize: '15px', color: '#F8FAFC' }}>{strat.title}</strong>
                      <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>~{strat.estimatedMinutes} dk</span>
                    </div>
                    <p style={{ fontSize: '13px', color: 'var(--color-text-secondary)', marginTop: '4px' }}>
                      {strat.actionText}
                    </p>
                  </div>
                ))}
              </div>

              <button
                className="btn-primary"
                onClick={() => setStep(3)}
              >
                <CheckCircle2 size={18} />
                <span>Eylemi Yaptım, Değerlendir</span>
              </button>
            </div>
          )}

          {/* STEP 3: Re-evaluate Urge */}
          {step === 3 && (
            <div>
              <p style={{ fontSize: '17px', fontWeight: 700, color: '#F8FAFC', marginBottom: '6px' }}>
                Dürtü şu anda nasıl?
              </p>
              <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', marginBottom: '18px' }}>
                Fark etmek, kontrolü yeniden ele almanın ilk adımıdır.
              </p>

              {/* Trend Selection */}
              <div className="form-group">
                <label className="form-label">Dürtü Değişimi</label>
                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: '8px' }}>
                  <button
                    type="button"
                    className={`btn-secondary ${urgeTrend === 'decreased' ? 'selected' : ''}`}
                    onClick={() => setUrgeTrend('decreased')}
                    style={{
                      height: '44px',
                      borderColor: urgeTrend === 'decreased' ? 'var(--positive-stage-3)' : undefined,
                      color: urgeTrend === 'decreased' ? 'var(--positive-stage-3)' : undefined
                    }}
                  >
                    Azaldı ✨
                  </button>
                  <button
                    type="button"
                    className={`btn-secondary ${urgeTrend === 'same' ? 'selected' : ''}`}
                    onClick={() => setUrgeTrend('same')}
                    style={{
                      height: '44px',
                      borderColor: urgeTrend === 'same' ? 'var(--warning-primary)' : undefined,
                      color: urgeTrend === 'same' ? 'var(--warning-primary)' : undefined
                    }}
                  >
                    Aynı ⏳
                  </button>
                  <button
                    type="button"
                    className={`btn-secondary ${urgeTrend === 'increased' ? 'selected' : ''}`}
                    onClick={() => setUrgeTrend('increased')}
                    style={{
                      height: '44px',
                      borderColor: urgeTrend === 'increased' ? 'var(--negative-stage-1)' : undefined,
                      color: urgeTrend === 'increased' ? 'var(--negative-stage-1)' : undefined
                    }}
                  >
                    Zorluyor 🔥
                  </button>
                </div>
              </div>

              {/* Intensity Slider */}
              <div className="form-group">
                <label className="form-label">Şu anki Yoğunluk (1: Çok Hafif — 5: Çok Güçlü): {newIntensity}/5</label>
                <input
                  type="range"
                  min="1"
                  max="5"
                  value={newIntensity}
                  onChange={(e) => setNewIntensity(Number(e.target.value))}
                  style={{ width: '100%', accentColor: 'var(--negative-stage-1)' }}
                />
              </div>

              {/* Note */}
              <div className="form-group">
                <label className="form-label">Kısa Not (İsteğe Bağlı)</label>
                <textarea
                  className="form-textarea"
                  placeholder="Bu anda ne hissettin, seni ne rahatlattı?"
                  value={noteText}
                  onChange={(e) => setNoteText(e.target.value)}
                />
              </div>

              <button
                className="btn-primary"
                onClick={handleFinish}
              >
                <span>Sonucu Kaydet ve Çık</span>
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
