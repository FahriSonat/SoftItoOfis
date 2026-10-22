import React, { useState } from 'react';
import { Habit, RestartPledge, CopingStrategy } from '../../types/models';
import { X, Sparkles, HeartHandshake, ArrowRight } from 'lucide-react';

interface BreakStreakModalProps {
  habit: Habit;
  previousDurationDays: number;
  strategies: CopingStrategy[];
  onClose: () => void;
  onCommitRestart: (pledge: RestartPledge) => void;
}

export const BreakStreakModal: React.FC<BreakStreakModalProps> = ({
  habit,
  previousDurationDays,
  strategies,
  onClose,
  onCommitRestart
}) => {
  const [pledgeText, setPledgeText] = useState('Bugün kendim için yeniden başlıyorum.');
  const [isCustomPledge, setIsCustomPledge] = useState(false);
  const [selectedTrigger, setSelectedTrigger] = useState<string>('stres');
  const [reflection, setReflection] = useState('');
  const [selectedStrategyId, setSelectedStrategyId] = useState<string>(
    strategies[0]?.id || ''
  );

  const triggers = ['stres', 'yalnızlık', 'sıkılma', 'sosyal ortam', 'yorgunluk', 'öfke', 'alışkanlık'];

  const handlePledgeSubmit = () => {
    const pledge: RestartPledge = {
      id: 'pledge_' + Date.now(),
      habitId: habit.id,
      pledgeText: pledgeText.trim() || 'Bugün kendim için yeniden başlıyorum.',
      reflection: reflection.trim(),
      triggerTag: selectedTrigger,
      selectedStrategyId: selectedStrategyId || undefined,
      committedAt: new Date().toISOString()
    };

    onCommitRestart(pledge);
  };

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="break-streak-title">
      <div
        className="modal-sheet"
        onClick={(e) => e.stopPropagation()}
        style={{
          borderTop: '3px solid var(--restart-primary)',
          background: 'linear-gradient(180deg, rgba(255,159,67,0.12) 0%, var(--color-bg-canvasElevated) 28%)'
        }}
      >
        {/* Header */}
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span style={{ fontSize: '22px' }}>🌅</span>
            <div>
              <h2 id="break-streak-title" className="modal-title" style={{ color: '#FFB347' }}>
                Yeniden Söz Verme & Başlangıç
              </h2>
              <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>{habit.name}</p>
            </div>
          </div>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        {/* Body */}
        <div className="modal-body">
          {/* Supportive, Non-judgmental Message */}
          <div
            style={{
              padding: '16px',
              borderRadius: 'var(--radius-lg)',
              background: 'rgba(255, 159, 67, 0.1)',
              border: '1px solid rgba(255, 159, 67, 0.25)',
              marginBottom: '20px'
            }}
          >
            <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#F8FAFC', marginBottom: '6px' }}>
              Bir an, bütün yolculuğu silmez.
            </h3>
            <p style={{ fontSize: '14px', color: '#E2E8F0', lineHeight: 1.5 }}>
              {previousDurationDays > 0 ? (
                <>
                  <strong>{previousDurationDays} günlük</strong> emeğin kaybolmadı; kazandığın farkındalık ve deneyim hâlâ seninle.
                </>
              ) : (
                'Her deneyim seni bir sonraki adımda daha dirençli kılar.'
              )}
            </p>
          </div>

          {/* Trigger Reflection */}
          <div className="form-group">
            <label className="form-label">Seni en çok ne zorladı?</label>
            <div className="chip-grid">
              {triggers.map(t => (
                <button
                  type="button"
                  key={t}
                  className={`chip-item ${selectedTrigger === t ? 'selected' : ''}`}
                  onClick={() => setSelectedTrigger(t)}
                >
                  {t}
                </button>
              ))}
            </div>
          </div>

          {/* Solution Choice for Next Time */}
          {strategies.length > 0 && (
            <div className="form-group">
              <label className="form-label">Benzer bir durumda ne denemek istersin?</label>
              <select
                className="form-select"
                value={selectedStrategyId}
                onChange={(e) => setSelectedStrategyId(e.target.value)}
              >
                {strategies.map(s => (
                  <option key={s.id} value={s.id}>
                    {s.title} (~{s.estimatedMinutes} dk)
                  </option>
                ))}
              </select>
            </div>
          )}

          {/* Reflection Note */}
          <div className="form-group">
            <label className="form-label">Kısa Düşünce Notu (İsteğe Bağlı)</label>
            <textarea
              className="form-textarea"
              placeholder="Bu deneyimden ne öğrendin?"
              value={reflection}
              onChange={(e) => setReflection(e.target.value)}
              style={{ minHeight: '70px' }}
            />
          </div>

          {/* Pledge Text */}
          <div className="form-group">
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '6px' }}>
              <label className="form-label" style={{ margin: 0 }}>Kendine Verdiğin Söz</label>
              <button
                type="button"
                onClick={() => setIsCustomPledge(!isCustomPledge)}
                style={{ background: 'none', border: 'none', color: 'var(--info-primary)', fontSize: '12px', cursor: 'pointer' }}
              >
                {isCustomPledge ? 'Hazır sözü kullan' : 'Kendi sözümü yaz'}
              </button>
            </div>

            {isCustomPledge ? (
              <input
                type="text"
                className="form-input"
                value={pledgeText}
                onChange={(e) => setPledgeText(e.target.value)}
                placeholder="Örn: Bugün kendim için temiz bir sayfa açıyorum."
              />
            ) : (
              <div
                style={{
                  padding: '12px 16px',
                  borderRadius: 'var(--radius-md)',
                  background: 'var(--color-bg-surfaceStrong)',
                  border: '1px solid var(--color-border-strong)',
                  fontStyle: 'italic',
                  color: '#F8FAFC'
                }}
              >
                "{pledgeText}"
              </div>
            )}
          </div>
        </div>

        {/* Footer */}
        <div className="modal-footer">
          <button
            type="button"
            className="btn-secondary"
            onClick={onClose}
            style={{ flex: 1 }}
          >
            Şimdilik Kapat
          </button>
          <button
            type="button"
            className="btn-primary btn-orange-restart"
            onClick={handlePledgeSubmit}
            style={{ flex: 2 }}
          >
            <Sparkles size={18} />
            <span>Söz Ver ve Yeniden Başla</span>
          </button>
        </div>
      </div>
    </div>
  );
};
