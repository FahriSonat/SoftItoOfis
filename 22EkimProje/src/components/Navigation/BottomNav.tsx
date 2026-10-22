import React from 'react';
import { Shield, Home, Sparkles } from 'lucide-react';

export type NavTab = 'negative' | 'home' | 'positive';

interface BottomNavProps {
  activeTab: NavTab;
  onTabChange: (tab: NavTab) => void;
  negativeCount?: number;
  positiveCount?: number;
}

export const BottomNav: React.FC<BottomNavProps> = ({
  activeTab,
  onTabChange
}) => {
  return (
    <nav className="bottom-nav" aria-label="Ana Gezinme">
      {/* 1. Sol: Negatif */}
      <button
        id="nav-tab-negative"
        className={`nav-item tab-negative ${activeTab === 'negative' ? 'active' : ''}`}
        onClick={() => onTabChange('negative')}
        aria-label="Uzak Durduklarım - Negatif Alışkanlıklar"
      >
        <Shield size={22} strokeWidth={activeTab === 'negative' ? 2.5 : 2} />
        <span>Negatif</span>
      </button>

      {/* 2. Orta: Ana Sayfa */}
      <button
        id="nav-tab-home"
        className={`nav-item tab-home ${activeTab === 'home' ? 'active' : ''}`}
        onClick={() => onTabChange('home')}
        aria-label="Ana Sayfa"
      >
        <Home size={24} strokeWidth={activeTab === 'home' ? 2.5 : 2} />
        <span className="desktop-only-text" style={{ fontSize: '12px' }}>Ana Sayfa</span>
      </button>

      {/* 3. Sağ: Pozitif */}
      <button
        id="nav-tab-positive"
        className={`nav-item tab-positive ${activeTab === 'positive' ? 'active' : ''}`}
        onClick={() => onTabChange('positive')}
        aria-label="Hayatıma Kattıklarım - Pozitif Alışkanlıklar"
      >
        <Sparkles size={22} strokeWidth={activeTab === 'positive' ? 2.5 : 2} />
        <span>Pozitif</span>
      </button>
    </nav>
  );
};
