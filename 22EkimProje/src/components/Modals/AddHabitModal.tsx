import React, { useState } from 'react';
import { Habit, HabitKind, MeasurementType, ScheduleType } from '../../types/models';
import { X, ArrowRight, ArrowLeft, Check, Sparkles, Shield, AlertTriangle } from 'lucide-react';

interface AddHabitModalProps {
  initialKind?: HabitKind;
  onClose: () => void;
  onCreate: (habit: Habit) => void;
}

const PRESET_CATEGORIES_NEGATIVE = [
  { id: 'smoking', name: 'Sigara', icon: '🚭', unit: 'adet', defaultFreq: 15, defaultCost: 4 },
  { id: 'alcohol', name: 'Alkol', icon: '🍷', unit: 'kadeh/şişe', defaultFreq: 2, defaultCost: 80 },
  { id: 'social_media', name: 'Sosyal Medya', icon: '📱', unit: 'dakika', defaultFreq: 6, defaultTime: 30 },
  { id: 'gaming', name: 'Oyun Bağımlılığı', icon: '🎮', unit: 'saat', defaultFreq: 3, defaultTime: 60 },
  { id: 'gambling', name: 'Kumar / Bahis', icon: '🎲', unit: 'TL', defaultFreq: 1, defaultCost: 200 },
  { id: 'junk_food', name: 'Sağlıksız Beslenme', icon: '🍔', unit: 'öğün', defaultFreq: 2, defaultCost: 150 },
  { id: 'shopping', name: 'Gereksiz Alışveriş', icon: '🛍️', unit: 'harcama', defaultFreq: 1, defaultCost: 300 },
  { id: 'medication', name: 'Gereksiz İlaç Kullanımı', icon: '💊', unit: 'adet', defaultFreq: 1, isMedical: true },
  { id: 'custom_neg', name: 'Özel Negatif Alışkanlık', icon: '🛡️', unit: 'adet' }
];

const PRESET_CATEGORIES_POSITIVE = [
  { id: 'water', name: 'Su İçme', icon: '💧', unit: 'ml', defaultTarget: 2000, measurement: 'volume' as MeasurementType },
  { id: 'book', name: 'Kitap Okuma', icon: '📖', unit: 'sayfa', defaultTarget: 20, measurement: 'pages' as MeasurementType },
  { id: 'walking', name: 'Yürüyüş', icon: '🚶', unit: 'dakika', defaultTarget: 30, measurement: 'duration' as MeasurementType },
  { id: 'running', name: 'Koşu', icon: '🏃', unit: 'km', defaultTarget: 5, measurement: 'distance' as MeasurementType },
  { id: 'fitness', name: 'Fitness / Spor', icon: '🏋️', unit: 'dakika', defaultTarget: 45, measurement: 'duration' as MeasurementType },
  { id: 'healthy_food', name: 'Sağlıklı Beslenme', icon: '🥗', unit: 'öğün', defaultTarget: 3, measurement: 'count' as MeasurementType },
  { id: 'instrument', name: 'Enstrüman Çalma', icon: '🎸', unit: 'dakika', defaultTarget: 25, measurement: 'duration' as MeasurementType },
  { id: 'art', name: 'Resim / Sanat', icon: '🎨', unit: 'dakika', defaultTarget: 30, measurement: 'duration' as MeasurementType },
  { id: 'meditation', name: 'Nefes & Meditasyon', icon: '🧘', unit: 'dakika', defaultTarget: 10, measurement: 'duration' as MeasurementType },
  { id: 'custom_pos', name: 'Özel Pozitif Alışkanlık', icon: '🌱', unit: 'adet', defaultTarget: 1, measurement: 'count' as MeasurementType }
];

export const AddHabitModal: React.FC<AddHabitModalProps> = ({
  initialKind = 'positive',
  onClose,
  onCreate
}) => {
  const [step, setStep] = useState<number>(1);
  const [kind, setKind] = useState<HabitKind>(initialKind);
  const [category, setCategory] = useState<string>(
    initialKind === 'positive' ? 'water' : 'smoking'
  );
  const [name, setName] = useState<string>('');
  const [icon, setIcon] = useState<string>('💧');

  // Positive properties
  const [measurementType, setMeasurementType] = useState<MeasurementType>('volume');
  const [targetValue, setTargetValue] = useState<number>(2000);
  const [unit, setUnit] = useState<string>('ml');
  const [scheduleType, setScheduleType] = useState<ScheduleType>('daily');
  const [selectedDays, setSelectedDays] = useState<number[]>([1, 2, 3, 4, 5]);

  // Negative properties
  const [startDateTime, setStartDateTime] = useState<string>(
    new Date().toISOString().slice(0, 16)
  );
  const [prevFrequency, setPrevFrequency] = useState<number>(10);
  const [costPerUnit, setCostPerUnit] = useState<number>(0);
  const [timeSavedMins, setTimeSavedMins] = useState<number>(0);

  // Reminders & Privacy
  const [reminderTime, setReminderTime] = useState<string>('09:00');
  const [neutralNotification, setNeutralNotification] = useState<boolean>(
    initialKind === 'negative'
  );

  const [formError, setFormError] = useState<string>('');

  const handleSelectPreset = (cat: typeof PRESET_CATEGORIES_POSITIVE[0] | typeof PRESET_CATEGORIES_NEGATIVE[0]) => {
    setCategory(cat.id);
    setName(cat.name);
    setIcon(cat.icon);
    setUnit(cat.unit);

    if (kind === 'positive') {
      const pos = cat as typeof PRESET_CATEGORIES_POSITIVE[0];
      if (pos.defaultTarget) setTargetValue(pos.defaultTarget);
      if (pos.measurement) setMeasurementType(pos.measurement);
    } else {
      const neg = cat as typeof PRESET_CATEGORIES_NEGATIVE[0];
      if (neg.defaultFreq) setPrevFrequency(neg.defaultFreq);
      if (neg.defaultCost) setCostPerUnit(neg.defaultCost);
      if (neg.defaultTime) setTimeSavedMins(neg.defaultTime);
      setNeutralNotification(true);
    }
  };

  const handleNext = () => {
    setFormError('');
    if (step === 2 && !name.trim()) {
      setFormError('Lütfen alışkanlık için bir ad belirle.');
      return;
    }
    if (step === 3) {
      if (kind === 'positive' && targetValue <= 0) {
        setFormError('Hedef değeri 0 dan büyük olmalıdır.');
        return;
      }
    }
    setStep(prev => prev + 1);
  };

  const handleCreate = () => {
    const habit: Habit = {
      id: 'habit_' + Date.now(),
      userId: 'user_default',
      name: name.trim() || (kind === 'positive' ? 'Yeni Pozitif Alışkanlık' : 'Yeni Hedef'),
      kind,
      category,
      icon,
      status: 'active',
      startAt: kind === 'negative' ? new Date(startDateTime).toISOString() : new Date().toISOString(),
      measurementType: kind === 'positive' ? measurementType : 'count',
      targetValue: kind === 'positive' ? targetValue : 0,
      unit,
      scheduleType: kind === 'positive' ? scheduleType : 'daily',
      scheduleConfig: {
        daysOfWeek: scheduleType === 'selected_days' ? selectedDays : undefined
      },
      reminders: reminderTime ? [reminderTime] : [],
      neutralNotification,
      previousFrequencyPerDay: kind === 'negative' ? prevFrequency : undefined,
      estimatedCostPerUnit: kind === 'negative' ? costPerUnit : undefined,
      estimatedTimePerOccurrenceMinutes: kind === 'negative' ? timeSavedMins : undefined,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    onCreate(habit);
    onClose();
  };

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="add-habit-title">
      <div className="modal-sheet" onClick={(e) => e.stopPropagation()}>
        {/* Header */}
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
            <span style={{ fontSize: '20px' }}>{kind === 'positive' ? '🌱' : '🛡️'}</span>
            <h2 id="add-habit-title" className="modal-title">
              Yeni Alışkanlık Ekle
            </h2>
          </div>
          <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>Adım {step} / 5</span>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        {/* Body */}
        <div className="modal-body">
          {formError && (
            <div className="form-error" style={{ marginBottom: '14px' }}>
              <AlertTriangle size={15} />
              <span>{formError}</span>
            </div>
          )}

          {/* STEP 1: Type Selection */}
          {step === 1 && (
            <div>
              <p style={{ fontSize: '15px', color: 'var(--color-text-secondary)', marginBottom: '18px' }}>
                Hangi yönde bir alışkanlık oluşturmak istiyorsun?
              </p>

              <div style={{ display: 'grid', gridTemplateColumns: '1fr', gap: '14px' }}>
                {/* Positive Card */}
                <div
                  onClick={() => { setKind('positive'); setIcon('💧'); setName('Su İçme'); }}
                  style={{
                    padding: '20px',
                    borderRadius: 'var(--radius-xl)',
                    background: kind === 'positive' ? 'rgba(77, 141, 255, 0.12)' : 'var(--color-bg-surface)',
                    border: `2px solid ${kind === 'positive' ? 'var(--positive-stage-3)' : 'var(--color-border-subtle)'}`,
                    cursor: 'pointer',
                    transition: 'all 160ms'
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '8px' }}>
                    <span style={{ fontSize: '28px' }}>🌱</span>
                    <div>
                      <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#F8FAFC' }}>Hayatıma Katmak İstiyorum</h3>
                      <p style={{ fontSize: '13px', color: 'var(--positive-stage-3)' }}>Pozitif Alışkanlık</p>
                    </div>
                  </div>
                  <p style={{ fontSize: '13px', color: 'var(--color-text-secondary)' }}>
                    Su içme, kitap okuma, spor, müzik gibi her gün hayatına değer katan ritimler kazan.
                  </p>
                </div>

                {/* Negative Card */}
                <div
                  onClick={() => { setKind('negative'); setIcon('🚭'); setName('Sigara'); }}
                  style={{
                    padding: '20px',
                    borderRadius: 'var(--radius-xl)',
                    background: kind === 'negative' ? 'rgba(255, 93, 104, 0.12)' : 'var(--color-bg-surface)',
                    border: `2px solid ${kind === 'negative' ? 'var(--negative-stage-1)' : 'var(--color-border-subtle)'}`,
                    cursor: 'pointer',
                    transition: 'all 160ms'
                  }}
                >
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '8px' }}>
                    <span style={{ fontSize: '28px' }}>🛡️</span>
                    <div>
                      <h3 style={{ fontSize: '18px', fontWeight: 700, color: '#F8FAFC' }}>Uzak Durmak İstiyorum</h3>
                      <p style={{ fontSize: '13px', color: 'var(--negative-stage-1)' }}>Negatif Alışkanlık</p>
                    </div>
                  </div>
                  <p style={{ fontSize: '13px', color: 'var(--color-text-secondary)' }}>
                    Sigara, alkol, sosyal medya veya sağlıksız beslenme gibi enerjini tüketen davranışlardan arın.
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* STEP 2: Category & Presets */}
          {step === 2 && (
            <div>
              <p style={{ fontSize: '15px', color: 'var(--color-text-secondary)', marginBottom: '14px' }}>
                Hazır seçeneklerden birini seç veya kendi özel adını gir:
              </p>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '10px', marginBottom: '18px' }}>
                {(kind === 'positive' ? PRESET_CATEGORIES_POSITIVE : PRESET_CATEGORIES_NEGATIVE).map((cat) => (
                  <button
                    type="button"
                    key={cat.id}
                    onClick={() => handleSelectPreset(cat)}
                    style={{
                      padding: '12px 14px',
                      borderRadius: 'var(--radius-lg)',
                      background: category === cat.id ? 'var(--color-bg-surfaceStrong)' : 'var(--color-bg-surface)',
                      border: `1px solid ${category === cat.id ? 'var(--info-primary)' : 'var(--color-border-subtle)'}`,
                      color: '#F8FAFC',
                      display: 'flex',
                      alignItems: 'center',
                      gap: '10px',
                      cursor: 'pointer',
                      textAlign: 'left'
                    }}
                  >
                    <span style={{ fontSize: '20px' }}>{cat.icon}</span>
                    <span style={{ fontSize: '14px', fontWeight: 600 }}>{cat.name}</span>
                  </button>
                ))}
              </div>

              {/* Name Input */}
              <div className="form-group">
                <label className="form-label">Alışkanlık Adı</label>
                <div style={{ display: 'flex', gap: '8px' }}>
                  <input
                    type="text"
                    value={icon}
                    onChange={(e) => setIcon(e.target.value)}
                    style={{ width: '56px', textAlign: 'center', fontSize: '20px' }}
                    className="form-input"
                    title="İkon / Emoji"
                  />
                  <input
                    type="text"
                    className="form-input"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    placeholder="Örn: Günlük Su İçme"
                  />
                </div>
              </div>
            </div>
          )}

          {/* STEP 3: Schedule & Target */}
          {step === 3 && (
            <div>
              {kind === 'positive' ? (
                <>
                  <div className="form-group">
                    <label className="form-label">Hedef Miktarı ve Birimi</label>
                    <div style={{ display: 'flex', gap: '10px' }}>
                      <input
                        type="number"
                        className="form-input"
                        value={targetValue}
                        onChange={(e) => setTargetValue(Number(e.target.value))}
                        style={{ flex: 1 }}
                      />
                      <input
                        type="text"
                        className="form-input"
                        value={unit}
                        onChange={(e) => setUnit(e.target.value)}
                        placeholder="ml, sayfa, dk"
                        style={{ width: '120px' }}
                      />
                    </div>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Program Sıklığı</label>
                    <div style={{ display: 'flex', gap: '8px' }}>
                      <button
                        type="button"
                        className={`btn-secondary ${scheduleType === 'daily' ? 'selected' : ''}`}
                        onClick={() => setScheduleType('daily')}
                        style={{ flex: 1, height: '44px' }}
                      >
                        Her Gün
                      </button>
                      <button
                        type="button"
                        className={`btn-secondary ${scheduleType === 'selected_days' ? 'selected' : ''}`}
                        onClick={() => setScheduleType('selected_days')}
                        style={{ flex: 1, height: '44px' }}
                      >
                        Seçili Günler
                      </button>
                    </div>
                  </div>

                  {scheduleType === 'selected_days' && (
                    <div className="form-group">
                      <label className="form-label">Aktif Günler</label>
                      <div style={{ display: 'flex', gap: '6px' }}>
                        {['Pz', 'Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct'].map((dName, dIdx) => (
                          <button
                            type="button"
                            key={dName}
                            onClick={() => {
                              setSelectedDays(prev =>
                                prev.includes(dIdx) ? prev.filter(x => x !== dIdx) : [...prev, dIdx]
                              );
                            }}
                            className={`btn-secondary ${selectedDays.includes(dIdx) ? 'selected' : ''}`}
                            style={{
                              flex: 1,
                              height: '42px',
                              padding: 0,
                              borderColor: selectedDays.includes(dIdx) ? 'var(--info-primary)' : undefined
                            }}
                          >
                            {dName}
                          </button>
                        ))}
                      </div>
                      <p className="form-help">Plansız dinlenme günleri seriyi bozmaz veya artırmaz.</p>
                    </div>
                  )}
                </>
              ) : (
                <>
                  <div className="form-group">
                    <label className="form-label">Uzak Durma Başlangıç Tarihi ve Saati</label>
                    <input
                      type="datetime-local"
                      className="form-input"
                      value={startDateTime}
                      onChange={(e) => setStartDateTime(e.target.value)}
                    />
                    <p className="form-help">Sayacın başladığı kesin tarih ve saati belirleyebilirsin.</p>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Önceki Günlük Ortalama Kullanım (Tahmin için)</label>
                    <div style={{ display: 'flex', gap: '10px' }}>
                      <input
                        type="number"
                        className="form-input"
                        value={prevFrequency}
                        onChange={(e) => setPrevFrequency(Number(e.target.value))}
                        style={{ flex: 1 }}
                      />
                      <span style={{ alignSelf: 'center', color: 'var(--color-text-muted)' }}>{unit} / gün</span>
                    </div>
                  </div>

                  <div className="form-group">
                    <label className="form-label">Birim Başına Maliyet (TL, İsteğe Bağlı)</label>
                    <input
                      type="number"
                      className="form-input"
                      value={costPerUnit}
                      onChange={(e) => setCostPerUnit(Number(e.target.value))}
                      placeholder="Örn: 4 TL"
                    />
                  </div>
                </>
              )}
            </div>
          )}

          {/* STEP 4: Reminders & Privacy */}
          {step === 4 && (
            <div>
              <div className="form-group">
                <label className="form-label">Hatırlatma Saati</label>
                <input
                  type="time"
                  className="form-input"
                  value={reminderTime}
                  onChange={(e) => setReminderTime(e.target.value)}
                />
              </div>

              {/* Neutral notification toggle */}
              <div className="form-group" style={{ marginTop: '20px' }}>
                <label style={{ display: 'flex', alignItems: 'flex-start', gap: '10px', cursor: 'pointer' }}>
                  <input
                    type="checkbox"
                    checked={neutralNotification}
                    onChange={(e) => setNeutralNotification(e.target.checked)}
                    style={{ width: '18px', height: '18px', marginTop: '2px', accentColor: 'var(--info-primary)' }}
                  />
                  <div>
                    <span style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC' }}>
                      Kilit ekranında nötr bildirim metni kullan (Mahremiyet Koruması)
                    </span>
                    <p style={{ fontSize: '12px', color: 'var(--color-text-muted)', marginTop: '2px' }}>
                      Bildirimde hassas alışkanlık adı yerine "Kendin için ayırdığın küçük zamanı hatırla" şeklinde genel bir metin gösterilir.
                    </p>
                  </div>
                </label>
              </div>

              {/* Notification Preview */}
              <div
                style={{
                  padding: '14px 16px',
                  borderRadius: 'var(--radius-lg)',
                  background: 'var(--color-bg-surfaceStrong)',
                  border: '1px solid var(--color-border-subtle)',
                  marginTop: '16px'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '11px', color: 'var(--color-text-muted)' }}>
                  <span>DENGE BİLDİRİMİ</span>
                  <span>Şimdi</span>
                </div>
                <p style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC', marginTop: '4px' }}>
                  {neutralNotification
                    ? 'Kendin için ayırdığın küçük zamanı hatırla.'
                    : `${name} için belirlediğin vakit geldi.`}
                </p>
              </div>
            </div>
          )}

          {/* STEP 5: Summary */}
          {step === 5 && (
            <div>
              <div
                style={{
                  padding: '20px',
                  borderRadius: 'var(--radius-xl)',
                  background: 'var(--color-bg-surface)',
                  border: '1px solid var(--color-border-subtle)',
                  marginBottom: '20px'
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '12px', marginBottom: '14px' }}>
                  <span style={{ fontSize: '32px' }}>{icon}</span>
                  <div>
                    <h3 style={{ fontSize: '20px', fontWeight: 700, color: '#F8FAFC' }}>{name}</h3>
                    <p style={{ fontSize: '13px', color: kind === 'positive' ? 'var(--positive-stage-3)' : 'var(--negative-stage-1)' }}>
                      {kind === 'positive' ? 'Pozitif Alışkanlık' : 'Uzak Durulan Alışkanlık'}
                    </p>
                  </div>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '14px', color: 'var(--color-text-secondary)' }}>
                  {kind === 'positive' ? (
                    <>
                      <div>🎯 Günlük Hedef: <strong>{targetValue} {unit}</strong></div>
                      <div>📅 Program: <strong>{scheduleType === 'daily' ? 'Her Gün' : 'Seçili Günler'}</strong></div>
                    </>
                  ) : (
                    <>
                      <div>⏳ Başlangıç: <strong>{new Date(startDateTime).toLocaleString('tr-TR')}</strong></div>
                      <div>🛡️ Kural: <strong>Kesintisiz Uzak Durma</strong></div>
                    </>
                  )}
                  <div>🔔 Hatırlatma: <strong>{reminderTime || 'Kapalı'}</strong> ({neutralNotification ? 'Nötr mod aktif' : 'Açık mod'})</div>
                </div>
              </div>

              <p style={{ fontSize: '13px', color: 'var(--color-text-muted)', textAlign: 'center' }}>
                Alışkanlık oluşturulduktan sonra istediğin zaman detay sayfasından düzenleyebilirsin.
              </p>
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="modal-footer">
          {step > 1 && (
            <button
              type="button"
              className="btn-secondary"
              onClick={() => setStep(prev => prev - 1)}
            >
              <ArrowLeft size={16} />
              <span>Geri</span>
            </button>
          )}

          {step < 5 ? (
            <button
              type="button"
              className="btn-primary"
              onClick={handleNext}
              style={{ flex: 1 }}
            >
              <span>Devam Et</span>
              <ArrowRight size={16} />
            </button>
          ) : (
            <button
              type="button"
              className="btn-primary"
              onClick={handleCreate}
              style={{ flex: 1 }}
            >
              <Check size={18} />
              <span>Alışkanlığı Oluştur</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
