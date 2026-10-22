import React, { useState } from 'react';
import { Habit, TriggerNote } from '../../types/models';
import { X, Check } from 'lucide-react';

interface TriggerNoteModalProps {
  habit: Habit;
  onClose: () => void;
  onSaveNote: (note: TriggerNote) => void;
}

const PRESET_TRIGGERS = ['stres', 'yalnızlık', 'sıkılma', 'sosyal ortam', 'yorgunluk', 'öfke', 'bildirim', 'gece dürtüsü'];
const PRESET_EMOTIONS = ['kaygı', 'çaresizlik', 'huzursuzluk', 'baskı', 'boşluk hissi'];

export const TriggerNoteModal: React.FC<TriggerNoteModalProps> = ({
  habit,
  onClose,
  onSaveNote
}) => {
  const [selectedTriggers, setSelectedTriggers] = useState<string[]>(['stres']);
  const [selectedEmotions, setSelectedEmotions] = useState<string[]>(['kaygı']);
  const [intensity, setIntensity] = useState<number>(3);
  const [context, setContext] = useState<string>('');
  const [note, setNote] = useState<string>('');

  const toggleTrigger = (tag: string) => {
    setSelectedTriggers(prev =>
      prev.includes(tag) ? prev.filter(t => t !== tag) : [...prev, tag]
    );
  };

  const toggleEmotion = (tag: string) => {
    setSelectedEmotions(prev =>
      prev.includes(tag) ? prev.filter(t => t !== tag) : [...prev, tag]
    );
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!note.trim() && selectedTriggers.length === 0) return;

    const triggerNote: TriggerNote = {
      id: 'trig_' + Date.now(),
      habitId: habit.id,
      userId: habit.userId,
      occurredAt: new Date().toISOString(),
      triggerTags: selectedTriggers,
      emotionTags: selectedEmotions,
      intensity,
      context: context.trim() || undefined,
      note: note.trim()
    };

    onSaveNote(triggerNote);
    onClose();
  };

  const intensityLabels: Record<number, string> = {
    1: '1/5 · Çok Hafif',
    2: '2/5 · Hafif',
    3: '3/5 · Orta',
    4: '4/5 · Güçlü',
    5: '5/5 · Çok Yoğun'
  };

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="trigger-modal-title">
      <div className="modal-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div>
            <h2 id="trigger-modal-title" className="modal-title">Zorlanma Kaydı Ekle</h2>
            <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>{habit.name} · Beni Zorlayanlar Günlüğü</p>
          </div>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            {/* Trigger tags */}
            <div className="form-group">
              <label className="form-label">Seni ne tetikledi?</label>
              <div className="chip-grid">
                {PRESET_TRIGGERS.map((tag) => (
                  <button
                    type="button"
                    key={tag}
                    className={`chip-item ${selectedTriggers.includes(tag) ? 'selected' : ''}`}
                    onClick={() => toggleTrigger(tag)}
                  >
                    {tag}
                  </button>
                ))}
              </div>
            </div>

            {/* Emotion tags */}
            <div className="form-group">
              <label className="form-label">Hissettiğin Duygu</label>
              <div className="chip-grid">
                {PRESET_EMOTIONS.map((tag) => (
                  <button
                    type="button"
                    key={tag}
                    className={`chip-item ${selectedEmotions.includes(tag) ? 'selected' : ''}`}
                    onClick={() => toggleEmotion(tag)}
                  >
                    {tag}
                  </button>
                ))}
              </div>
            </div>

            {/* Intensity slider with text */}
            <div className="form-group">
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '6px' }}>
                <label className="form-label" style={{ margin: 0 }}>Dürtü Yoğunluğu</label>
                <span style={{ fontSize: '13px', fontWeight: 600, color: 'var(--warning-primary)' }}>
                  {intensityLabels[intensity]}
                </span>
              </div>
              <input
                type="range"
                min="1"
                max="5"
                value={intensity}
                onChange={(e) => setIntensity(Number(e.target.value))}
                style={{ width: '100%', accentColor: 'var(--negative-stage-1)' }}
              />
            </div>

            {/* Context */}
            <div className="form-group">
              <label className="form-label">Neredeydin? (Ortam / Durum)</label>
              <input
                type="text"
                className="form-input"
                placeholder="Örn: Evde tek başıma, iş yerinde toplantı sonrası vb."
                value={context}
                onChange={(e) => setContext(e.target.value)}
              />
            </div>

            {/* Free Note */}
            <div className="form-group">
              <label className="form-label">Notların</label>
              <textarea
                className="form-textarea"
                placeholder="O anda ne düşündün, dürtüyü nasıl yönetmeye çalıştın?"
                value={note}
                onChange={(e) => setNote(e.target.value)}
                required
              />
            </div>
          </div>

          <div className="modal-footer">
            <button type="button" className="btn-secondary" onClick={onClose}>
              Vazgeç
            </button>
            <button type="submit" className="btn-primary" style={{ flex: 1 }}>
              <Check size={18} />
              <span>Günlüğe Kaydet</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
