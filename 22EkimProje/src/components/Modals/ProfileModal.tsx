import React, { useState } from 'react';
import { UserProfile, Badge, UserBadge } from '../../types/models';
import { SYSTEM_BADGES } from '../../domain/badgeEngine';
import { X, Award, Bell, Download, Trash2, Shield, Moon, Check } from 'lucide-react';

interface ProfileModalProps {
  profile: UserProfile;
  userBadges: UserBadge[];
  onClose: () => void;
  onSaveProfile: (profile: UserProfile) => void;
  onExportData: () => void;
  onClearAllData: () => void;
}

export const ProfileModal: React.FC<ProfileModalProps> = ({
  profile,
  userBadges,
  onClose,
  onSaveProfile,
  onExportData,
  onClearAllData
}) => {
  const [activeTab, setActiveTab] = useState<'profile' | 'badges' | 'settings'>('profile');
  const [displayName, setDisplayName] = useState(profile.displayName);
  const [quietStart, setQuietStart] = useState(profile.notificationPreferences.quietHoursStart);
  const [quietEnd, setQuietEnd] = useState(profile.notificationPreferences.quietHoursEnd);
  const [neutralLockscreen, setNeutralLockscreen] = useState(profile.notificationPreferences.neutralLockscreen);
  const [confirmClear, setConfirmClear] = useState(false);
  const [savedSuccess, setSavedSuccess] = useState(false);

  const handleSaveSettings = () => {
    onSaveProfile({
      ...profile,
      displayName,
      notificationPreferences: {
        ...profile.notificationPreferences,
        quietHoursStart: quietStart,
        quietHoursEnd: quietEnd,
        neutralLockscreen
      }
    });
    setSavedSuccess(true);
    setTimeout(() => setSavedSuccess(false), 2000);
  };

  return (
    <div className="modal-scrim" onClick={onClose} role="dialog" aria-modal="true" aria-labelledby="profile-title">
      <div className="modal-sheet" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <span style={{ fontSize: '24px' }}>{profile.avatar}</span>
            <div>
              <h2 id="profile-title" className="modal-title">{profile.displayName}</h2>
              <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>{profile.email}</p>
            </div>
          </div>
          <button className="btn-icon" onClick={onClose} aria-label="Kapat">
            <X size={20} />
          </button>
        </div>

        {/* Tab Selection */}
        <div style={{ display: 'flex', padding: '12px 20px 0 20px', gap: '8px', borderBottom: '1px solid var(--color-border-subtle)' }}>
          <button
            className={`chip-item ${activeTab === 'profile' ? 'selected' : ''}`}
            onClick={() => setActiveTab('profile')}
          >
            Profil
          </button>
          <button
            className={`chip-item ${activeTab === 'badges' ? 'selected' : ''}`}
            onClick={() => setActiveTab('badges')}
          >
            Rozetler ({userBadges.filter(b => b.earnedAt).length}/{SYSTEM_BADGES.length})
          </button>
          <button
            className={`chip-item ${activeTab === 'settings' ? 'selected' : ''}`}
            onClick={() => setActiveTab('settings')}
          >
            Ayarlar & Veri
          </button>
        </div>

        <div className="modal-body">
          {/* TAB 1: Profile info */}
          {activeTab === 'profile' && (
            <div>
              <div className="form-group">
                <label className="form-label">Görünen Ad</label>
                <input
                  type="text"
                  className="form-input"
                  value={displayName}
                  onChange={(e) => setDisplayName(e.target.value)}
                />
              </div>

              <div
                style={{
                  background: 'var(--color-bg-surface)',
                  borderRadius: 'var(--radius-lg)',
                  padding: '16px',
                  border: '1px solid var(--color-border-subtle)',
                  marginTop: '16px'
                }}
              >
                <h4 style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC', marginBottom: '10px' }}>
                  Hesap Özeti
                </h4>
                <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '13px', color: 'var(--color-text-secondary)' }}>
                  <div>Saat Dilimi: <strong>{profile.timezone}</strong></div>
                  <div>Dil: <strong>Türkçe (tr-TR)</strong></div>
                  <div>Katılım: <strong>{new Date(profile.createdAt).toLocaleDateString('tr-TR')}</strong></div>
                </div>
              </div>

              <button
                className="btn-primary"
                onClick={handleSaveSettings}
                style={{ marginTop: '20px' }}
              >
                {savedSuccess ? <Check size={18} /> : null}
                <span>{savedSuccess ? 'Kaydedildi' : 'Değişiklikleri Kaydet'}</span>
              </button>
            </div>
          )}

          {/* TAB 2: Badges */}
          {activeTab === 'badges' && (
            <div>
              <p style={{ fontSize: '14px', color: 'var(--color-text-secondary)', marginBottom: '16px' }}>
                Alışkanlık yolculuğunda kazandığın rozetler ve ilerlemen:
              </p>

              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: '12px' }}>
                {SYSTEM_BADGES.map((b) => {
                  const ub = userBadges.find(u => u.badgeId === b.id);
                  const isEarned = Boolean(ub && ub.earnedAt);

                  return (
                    <div
                      key={b.id}
                      style={{
                        padding: '16px',
                        borderRadius: 'var(--radius-lg)',
                        background: isEarned ? 'rgba(53, 208, 131, 0.08)' : 'var(--color-bg-surface)',
                        border: `1px solid ${isEarned ? 'rgba(53, 208, 131, 0.35)' : 'var(--color-border-subtle)'}`,
                        display: 'flex',
                        flexDirection: 'column',
                        alignItems: 'center',
                        textAlign: 'center',
                        position: 'relative'
                      }}
                    >
                      <span style={{ fontSize: '32px', marginBottom: '6px', filter: isEarned ? 'none' : 'grayscale(1) opacity(0.5)' }}>
                        {b.icon}
                      </span>
                      <strong style={{ fontSize: '14px', color: isEarned ? '#F8FAFC' : 'var(--color-text-muted)' }}>
                        {b.title}
                      </strong>
                      <p style={{ fontSize: '11px', color: 'var(--color-text-muted)', marginTop: '4px' }}>
                        {b.description}
                      </p>

                      {isEarned ? (
                        <span style={{ fontSize: '11px', fontWeight: 700, color: 'var(--positive-stage-4)', marginTop: '8px' }}>
                          Kazanıldı ✨
                        </span>
                      ) : (
                        <div style={{ width: '100%', marginTop: '8px' }}>
                          <div style={{ height: '4px', background: 'var(--color-bg-surfaceStrong)', borderRadius: '4px', overflow: 'hidden' }}>
                            <div
                              style={{
                                width: `${Math.min(100, Math.round(((ub?.progress || 0) / b.threshold) * 100))}%`,
                                height: '100%',
                                background: 'var(--info-primary)'
                              }}
                            />
                          </div>
                          <span style={{ fontSize: '10px', color: 'var(--color-text-muted)', display: 'block', marginTop: '2px' }}>
                            {ub?.progress || 0} / {b.threshold}
                          </span>
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* TAB 3: Settings & Data */}
          {activeTab === 'settings' && (
            <div>
              {/* Quiet hours */}
              <div className="form-group">
                <label className="form-label" style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                  <Moon size={16} />
                  <span>Sessiz Saatler</span>
                </label>
                <div style={{ display: 'flex', gap: '10px' }}>
                  <input
                    type="time"
                    className="form-input"
                    value={quietStart}
                    onChange={(e) => setQuietStart(e.target.value)}
                    title="Başlangıç"
                  />
                  <span style={{ alignSelf: 'center', color: 'var(--color-text-muted)' }}>-</span>
                  <input
                    type="time"
                    className="form-input"
                    value={quietEnd}
                    onChange={(e) => setQuietEnd(e.target.value)}
                    title="Bitiş"
                  />
                </div>
                <p className="form-help">Bu saatler arasında bildirim gönderilmez.</p>
              </div>

              {/* Neutral notification toggle */}
              <div className="form-group" style={{ marginTop: '16px' }}>
                <label style={{ display: 'flex', alignItems: 'flex-start', gap: '10px', cursor: 'pointer' }}>
                  <input
                    type="checkbox"
                    checked={neutralLockscreen}
                    onChange={(e) => setNeutralLockscreen(e.target.checked)}
                    style={{ width: '18px', height: '18px', marginTop: '2px', accentColor: 'var(--info-primary)' }}
                  />
                  <div>
                    <span style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC' }}>
                      Nötr Kilit Ekranı Bildirimleri (Mahremiyet)
                    </span>
                    <p style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
                      Kilit ekranında alışkanlık adı yerine genel motivasyon metni gösterir.
                    </p>
                  </div>
                </label>
              </div>

              {/* Data Export & Reset */}
              <div style={{ marginTop: '28px', paddingTop: '20px', borderTop: '1px solid var(--color-border-subtle)' }}>
                <h4 style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC', marginBottom: '12px' }}>
                  Veri Yönetimi
                </h4>

                <button
                  type="button"
                  className="btn-secondary"
                  onClick={onExportData}
                  style={{ width: '100%', marginBottom: '12px', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}
                >
                  <Download size={16} />
                  <span>Tüm Verilerimi İndir (.json)</span>
                </button>

                {!confirmClear ? (
                  <button
                    type="button"
                    className="btn-danger-outline"
                    onClick={() => setConfirmClear(true)}
                    style={{ width: '100%', height: '48px', borderRadius: 'var(--radius-lg)', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '8px' }}
                  >
                    <Trash2 size={16} />
                    <span>Tüm Verileri Sıfırla</span>
                  </button>
                ) : (
                  <div style={{ padding: '12px', background: 'rgba(255, 93, 104, 0.12)', borderRadius: 'var(--radius-md)', textAlign: 'center' }}>
                    <p style={{ fontSize: '13px', color: '#F8FAFC', marginBottom: '10px' }}>
                      Tüm kayıtlar silinecek. Emin misin?
                    </p>
                    <div style={{ display: 'flex', gap: '8px' }}>
                      <button className="btn-secondary" style={{ flex: 1, height: '38px' }} onClick={() => setConfirmClear(false)}>
                        Vazgeç
                      </button>
                      <button
                        className="btn-primary"
                        style={{ flex: 1, height: '38px', background: 'var(--danger-primary)' }}
                        onClick={() => {
                          onClearAllData();
                          setConfirmClear(false);
                          onClose();
                        }}
                      >
                        Evet, Sıfırla
                      </button>
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
