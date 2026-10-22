import React, { useState } from 'react';
import { Habit, HabitEntry } from '../../types/models';
import { X, Check } from 'lucide-react';

interface LogEntryModalProps {
  habit: Habit;
  onClose: () => void;
  onSaveEntry: (entry: HabitEntry) => void;
}

export const LogEntryModal: React.FC<LogEntryModalProps> = ({
  habit,
  onClose,
  onSaveEntry
}) => {
  const isWater = habit.category === 'water' || habit.name.toLowerCase().includes('su');
  const [value, setValue] = useState<number>(isWater ? 250 : habit.measurementType === 'boolean' ? 1 : 10);
  const [note, setNote] = useState<string>('');

  const quickWaterAmounts = [200, 250, 330, 500, 1000];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (value <= 0) return;

    const entry: HabitEntry = {
      id: 'entry_' + Date.now(),
      habitId: habit.id,
      userId: habit.userId,
      entryType: 'progress',
      value,
      unit: habit.unit,
      occurredAt: new Date().toISOString(),
      note: note.trim() || undefined,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    onSaveEntry(entry);
    onClose();
  };

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="log-entry-title">
      <div className="modal-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span style={{ fontSize: '22px' }}>{habit.icon}</span>
            <div>
              <h2 id="log-entry-title" className="modal-title">Kayıt Ekle</h2>
              <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>{habit.name}</p>
            </div>
          </div>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="modal-body">
            {/* Quick chips for water */}
            {isWater && (
              <div className="form-group">
                <label className="form-label">Hızlı Miktar Seçimi</label>
                <div className="chip-grid">
                  {quickWaterAmounts.map((amt) => (
                    <button
                      type="button"
                      key={amt}
                      className={`chip-item ${value === amt ? 'selected' : ''}`}
                      onClick={() => setValue(amt)}
                    >
                      +{amt} ml
                    </button>
                  ))}
                </div>
              </div>
            )}

            <div className="form-group">
              <label className="form-label">Miktar ({habit.unit})</label>
              <input
                type="number"
                className="form-input"
                value={value}
                min={1}
                step={habit.measurementType === 'distance' ? 0.1 : 1}
                onChange={(e) => setValue(Number(e.target.value))}
                required
                autoFocus
              />
            </div>

            <div className="form-group">
              <label className="form-label">Not (İsteğe Bağlı)</label>
              <input
                type="text"
                className="form-input"
                placeholder="Örn: Sabah yürüyüşü, 3. bölüm bitti vb."
                value={note}
                onChange={(e) => setNote(e.target.value)}
              />
            </div>
          </div>

          <div className="modal-footer">
            <button type="button" className="btn-secondary" onClick={onClose}>
              Vazgeç
            </button>
            <button type="submit" className="btn-primary" style={{ flex: 1 }}>
              <Check size={18} />
              <span>Kaydet ({value} {habit.unit})</span>
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
