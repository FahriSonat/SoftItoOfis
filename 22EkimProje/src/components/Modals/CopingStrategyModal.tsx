import React, { useState } from 'react';
import { CopingStrategy } from '../../types/models';
import { X, Check, Star } from 'lucide-react';

interface CopingStrategyModalProps {
  initialStrategy?: CopingStrategy;
  habitId?: string;
  onClose: () => void;
  onSaveStrategy: (strategy: CopingStrategy) => void;
}

const COMMON_TRIGGERS = ['stres', 'sıkılma', 'yalnızlık', 'öfke', 'sosyal medya', 'gece dürtüsü', 'yorgunluk'];

export const CopingStrategyModal: React.FC<CopingStrategyModalProps> = ({
  initialStrategy,
  habitId,
  onClose,
  onSaveStrategy
}) => {
  const [title, setTitle] = useState(initialStrategy?.title || '');
  const [actionText, setActionText] = useState(initialStrategy?.actionText || '');
  const [estimatedMinutes, setEstimatedMinutes] = useState(initialStrategy?.estimatedMinutes || 2);
  const [selectedTriggers, setSelectedTriggers] = useState<string[]>(
    initialStrategy?.triggerTags || ['stres']
  );
  const [isFavorite, setIsFavorite] = useState(initialStrategy?.isFavorite || false);

  const toggleTrigger = (tag: string) => {
    setSelectedTriggers(prev =>
      prev.includes(tag) ? prev.filter(t => t !== tag) : [...prev, tag]
    );
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!title.trim() || !actionText.trim()) return;

    const strategy: CopingStrategy = {
      id: initialStrategy?.id || 'strat_' + Date.now(),
      habitId,
      title: title.trim(),
      actionText: actionText.trim(),
      estimatedMinutes,
      triggerTags: selectedTriggers,
      effectivenessScore: initialStrategy?.effectivenessScore || 5,
      isFavorite,
      timesUsed: initialStrategy?.timesUsed || 0,
      createdAt: initialStrategy?.createdAt || new Date().toISOString()
    };

    onSaveStrategy(strategy);
    onClose();
  };

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="strategy-modal-title">
      <div className="modal-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 id="strategy-modal-title" className="modal-title">
              {initialStrategy ? 'Çözüm Yöntemini Düzenle' : 'Yeni Çözüm Yöntemi Ekle'}
            </h2>
            <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>Çözüm Yöntemlerim Repertuvarı</p>
          </div>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            <div className="form-group">
              <label className="form-label">Çözüm Başlığı</label>
              <input
                type="text"
                className="form-input"
                placeholder="Örn: 2 Dakika Sakin Nefes, Bir Bardak Soğuk Su"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
                required
              />
            </div>

            <div className="form-group">
              <label className="form-label">Uygulanacak Küçük Eylem</label>
              <textarea
                className="form-textarea"
                placeholder="Örn: Mutfağa git, büyük bir bardak soğuk su doldur ve yavaşça iç."
                value={actionText}
                onChange={(e) => setActionText(e.target.value)}
                required
              />
            </div>

            <div className="form-group">
              <label className="form-label">Tahmini Süre (Dakika)</label>
              <input
                type="number"
                min={1}
                max={60}
                className="form-input"
                value={estimatedMinutes}
                onChange={(e) => setEstimatedMinutes(Number(e.target.value))}
              />
            </div>

            <div className="form-group">
              <label className="form-label">Hangi durumlarda işe yarıyor?</label>
              <div className="chip-grid">
                {COMMON_TRIGGERS.map((t) => (
                  <button
                    type="button"
                    key={t}
                    className={`chip-item ${selectedTriggers.includes(t) ? 'selected' : ''}`}
                    onClick={() => toggleTrigger(t)}
                  >
                    {t}
                  </button>
                ))}
              </div>
            </div>

            <div className="form-group">
              <label style={{ display: 'flex', alignItems: 'center', gap: '10px', cursor: 'pointer' }}>
                <input
                  type="checkbox"
                  checked={isFavorite}
                  onChange={(e) => setIsFavorite(e.target.checked)}
                  style={{ width: '18px', height: '18px', accentColor: 'var(--restart-primary)' }}
                />
                <span style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC', display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <Star size={16} fill={isFavorite ? '#FF9F43' : 'none'} color="#FF9F43" />
                  Favorilere Ekle (Zorlanma anında öncelikli önerilir)
                </span>
              </label>
            </div>
          </div>

          <div className="modal-footer">
            <button type="button" className="btn-secondary" onClick={onClose}>
              Vazgeç
            </button>
            <button type="submit" className="btn-primary" style={{ flex: 1 }}>
              <Check size={18} />
              <span>Kaydet</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
