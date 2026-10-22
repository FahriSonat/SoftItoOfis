import React from 'react';
import { Habit, HabitEntry, StreakResult } from '../../types/models';
import { calculateColorStage } from '../../domain/colorStage';
import { ProgressRing } from '../Common/ProgressRing';
import { isDayCompleted, getDailyProgressMap } from '../../domain/streakEngine';
import { Flame, AlertCircle, Plus, CheckCircle2, ChevronRight, HeartHandshake } from 'lucide-react';

interface HabitCardProps {
  habit: Habit;
  entries: HabitEntry[];
  streak: StreakResult;
  onClick: () => void;
  onQuickLog?: (habit: Habit) => void;
  onStruggling?: (habit: Habit) => void;
}

export const HabitCard: React.FC<HabitCardProps> = ({
  habit,
  entries,
  streak,
  onClick,
  onQuickLog,
  onStruggling
}) => {
  const isBroken = streak.status === 'broken';
  const stage = calculateColorStage(habit.kind, streak.current, isBroken);

  // Compute daily progress for positive habits
  const isPositive = habit.kind === 'positive';
  let todayProgress = 0;
  let isTodayDone = false;

  if (isPositive) {
    const dailyMap = getDailyProgressMap(habit, entries);
    isTodayDone = isDayCompleted(habit, dailyMap, new Date());
    const dayStr = new Date().toISOString().split('T')[0];
    const loggedToday = dailyMap.get(dayStr) || 0;
    todayProgress = habit.targetValue > 0 ? loggedToday / habit.targetValue : 0;
  }

  return (
    <article
      className={`habit-card ${isBroken ? 'broken' : ''}`}
      onClick={onClick}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          onClick();
        }
      }}
      aria-label={`${habit.name}, durum: ${stage.label}, seri: ${streak.current} ${streak.unit}`}
    >
      {/* Stage top line */}
      <div
        className="card-stage-indicator"
        style={{
          background: isBroken ? 'var(--restart-primary)' : stage.hex
        }}
      />

      {/* Top Header */}
      <div className="card-top">
        <div className="card-icon-box" aria-hidden="true">
          {habit.icon || (isPositive ? '✨' : '🛡️')}
        </div>
        <div className="card-info">
          <h3 className="card-title">{habit.name}</h3>
          <p className="card-subtitle">
            {isPositive
              ? `Hedef: ${habit.targetValue} ${habit.unit} / gün`
              : `${stage.label} · ${stage.description}`}
          </p>
        </div>

        {/* Status Pill with Text & Color */}
        <div
          className="card-status-pill"
          style={{
            background: isBroken ? 'var(--restart-soft)' : `${stage.hex}18`,
            color: isBroken ? 'var(--restart-primary)' : stage.hex,
            border: `1px solid ${isBroken ? 'var(--restart-primary)' : stage.hex}33`
          }}
        >
          {isBroken ? (
            <>
              <AlertCircle size={13} />
              <span>Yeniden Başla</span>
            </>
          ) : isPositive && isTodayDone ? (
            <>
              <CheckCircle2 size={13} />
              <span>Bugün Tamam</span>
            </>
          ) : (
            <>
              <Flame size={13} />
              <span>{stage.label}</span>
            </>
          )}
        </div>
      </div>

      {/* Body / Streak & Actions */}
      <div className="card-body">
        <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
          {isPositive ? (
            <ProgressRing
              progress={todayProgress}
              size="small"
              colorHex={stage.hex}
              centerValue={`${Math.round(todayProgress * 100)}%`}
            />
          ) : (
            <ProgressRing
              progress={1}
              size="small"
              colorHex={stage.hex}
              isBroken={isBroken}
              centerValue={streak.current}
              centerUnit={streak.unit === 'hour' ? 'sa' : 'gün'}
            />
          )}

          <div>
            <div className="card-streak-info">
              <span className="streak-number">{streak.current}</span>
              <span className="streak-unit">
                {streak.unit === 'hour' ? 'saat' : streak.unit === 'day' ? 'gün' : 'periyot'}
              </span>
            </div>
            <p className="streak-longest">
              En iyi: {streak.longest} {streak.unit === 'hour' ? 'saat' : streak.unit === 'day' ? 'gün' : 'periyot'}
            </p>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="card-actions" onClick={(e) => e.stopPropagation()}>
          {!isPositive && !isBroken && onStruggling && (
            <button
              className="btn-action-primary btn-struggling"
              onClick={() => onStruggling(habit)}
              aria-label="Zorlanıyorum destek akışı aç"
            >
              <HeartHandshake size={16} />
              <span>Zorlanıyorum</span>
            </button>
          )}

          {isPositive && !isTodayDone && onQuickLog && (
            <button
              className="btn-action-primary btn-complete-quick"
              onClick={() => onQuickLog(habit)}
              aria-label="Kayıt ekle"
            >
              <Plus size={16} />
              <span>{habit.category === 'water' ? '+250 ml' : 'Ekle'}</span>
            </button>
          )}

          <button
            className="btn-icon"
            onClick={onClick}
            aria-label={`${habit.name} detaylarını aç`}
            style={{ width: '36px', height: '36px' }}
          >
            <ChevronRight size={18} />
          </button>
        </div>
      </div>
    </article>
  );
};
