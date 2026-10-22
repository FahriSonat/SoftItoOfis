import React, { useState } from 'react';
import { Habit, HabitEntry, TriggerNote } from '../../types/models';
import { toLocalDateString, isSameDay, addDays } from '../../domain/dateUtils';
import { isDayCompleted, isScheduledDay, getDailyProgressMap } from '../../domain/streakEngine';
import { ChevronLeft, ChevronRight, Check, X, Calendar as CalendarIcon } from 'lucide-react';

interface CalendarViewProps {
  habit: Habit;
  entries: HabitEntry[];
  notes?: TriggerNote[];
}

export const CalendarView: React.FC<CalendarViewProps> = ({
  habit,
  entries,
  notes = []
}) => {
  const [currentDate, setCurrentDate] = useState<Date>(new Date());
  const [selectedDate, setSelectedDate] = useState<Date>(new Date());
  const [viewMode, setViewMode] = useState<'month' | 'week'>('month');

  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();

  // Navigation
  const prevMonth = () => setCurrentDate(new Date(year, month - 1, 1));
  const nextMonth = () => setCurrentDate(new Date(year, month + 1, 1));

  // Build calendar matrix
  const firstDayOfMonth = new Date(year, month, 1);
  const startingDayIndex = (firstDayOfMonth.getDay() + 6) % 7; // Monday = 0
  const daysInMonth = new Date(year, month + 1, 0).getDate();

  const calendarDays: Array<{ date: Date; isCurrentMonth: boolean }> = [];

  // Previous month padding
  for (let i = startingDayIndex - 1; i >= 0; i--) {
    const d = new Date(year, month, -i);
    calendarDays.push({ date: d, isCurrentMonth: false });
  }

  // Current month days
  for (let day = 1; day <= daysInMonth; day++) {
    const d = new Date(year, month, day);
    calendarDays.push({ date: d, isCurrentMonth: true });
  }

  // Next month padding to reach multiple of 7
  const remaining = (7 - (calendarDays.length % 7)) % 7;
  for (let i = 1; i <= remaining; i++) {
    const d = new Date(year, month + 1, i);
    calendarDays.push({ date: d, isCurrentMonth: false });
  }

  const daysToShow = viewMode === 'week'
    ? calendarDays.filter(item => {
        const diff = Math.abs(item.date.getTime() - selectedDate.getTime());
        return diff < 4 * 86400000;
      }).slice(0, 7)
    : calendarDays;

  // Selected day data
  const selectedDayStr = toLocalDateString(selectedDate);
  const dailyEntries = entries.filter(e => toLocalDateString(e.occurredAt) === selectedDayStr);
  const dailyNotes = notes.filter(n => toLocalDateString(n.occurredAt) === selectedDayStr);

  const dailyProgressMap = getDailyProgressMap(habit, entries);
  const isPositive = habit.kind === 'positive';

  const monthsTR = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];

  return (
    <div style={{ background: 'var(--color-bg-surface)', borderRadius: 'var(--radius-xl)', padding: '18px', border: '1px solid var(--color-border-subtle)' }}>
      {/* Header & Controls */}
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '16px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
          <CalendarIcon size={18} color="var(--info-primary)" />
          <h3 style={{ fontSize: '16px', fontWeight: 700, color: '#F8FAFC' }}>
            {monthsTR[month]} {year}
          </h3>
        </div>

        <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
          {/* Segmented control */}
          <div style={{ display: 'flex', background: 'var(--color-bg-surfaceStrong)', borderRadius: 'var(--radius-full)', padding: '2px' }}>
            <button
              onClick={() => setViewMode('month')}
              style={{
                background: viewMode === 'month' ? 'var(--color-bg-surface)' : 'none',
                border: 'none',
                color: viewMode === 'month' ? '#FFF' : 'var(--color-text-muted)',
                fontSize: '11px',
                fontWeight: 600,
                padding: '4px 10px',
                borderRadius: 'var(--radius-full)',
                cursor: 'pointer'
              }}
            >
              Ay
            </button>
            <button
              onClick={() => setViewMode('week')}
              style={{
                background: viewMode === 'week' ? 'var(--color-bg-surface)' : 'none',
                border: 'none',
                color: viewMode === 'week' ? '#FFF' : 'var(--color-text-muted)',
                fontSize: '11px',
                fontWeight: 600,
                padding: '4px 10px',
                borderRadius: 'var(--radius-full)',
                cursor: 'pointer'
              }}
            >
              Hafta
            </button>
          </div>

          <button className="btn-icon" style={{ width: '32px', height: '32px' }} onClick={prevMonth} aria-label="Önceki ay">
            <ChevronLeft size={16} />
          </button>
          <button className="btn-icon" style={{ width: '32px', height: '32px' }} onClick={nextMonth} aria-label="Sonraki ay">
            <ChevronRight size={16} />
          </button>
        </div>
      </div>

      {/* Weekday Names */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', textAlign: 'center', marginBottom: '8px' }}>
        {['Pt', 'Sa', 'Ça', 'Pe', 'Cu', 'Ct', 'Pz'].map(d => (
          <span key={d} style={{ fontSize: '11px', fontWeight: 600, color: 'var(--color-text-muted)' }}>
            {d}
          </span>
        ))}
      </div>

      {/* Calendar Grid */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: '4px' }}>
        {daysToShow.map(({ date, isCurrentMonth }, idx) => {
          const isSelected = isSameDay(date, selectedDate);
          const isToday = isSameDay(date, new Date());
          const dateStr = toLocalDateString(date);

          // Evaluation for this day
          let statusColor = 'transparent';
          let statusText = '';

          if (isPositive) {
            const completed = isDayCompleted(habit, dailyProgressMap, date);
            const scheduled = isScheduledDay(habit, date);
            const total = dailyProgressMap.get(dateStr) || 0;

            if (completed) {
              statusColor = 'var(--positive-stage-3)';
              statusText = '✓';
            } else if (total > 0) {
              statusColor = 'var(--positive-stage-1)';
              statusText = '~';
            } else if (!scheduled) {
              statusColor = 'rgba(255, 255, 255, 0.05)';
            } else if (date.getTime() < new Date().setHours(0,0,0,0)) {
              statusColor = 'rgba(255, 255, 255, 0.15)'; // missed past
              statusText = '—';
            }
          } else {
            // Negative: check if there was a lapse on this day
            const hadLapse = entries.some(e => e.entryType === 'lapse' && toLocalDateString(e.occurredAt) === dateStr);
            const isAfterStart = date.getTime() >= new Date(habit.startAt).setHours(0,0,0,0);
            const isPastOrToday = date.getTime() <= new Date().getTime();

            if (hadLapse) {
              statusColor = 'var(--restart-primary)';
              statusText = '!';
            } else if (isAfterStart && isPastOrToday) {
              statusColor = 'var(--negative-stage-4)';
              statusText = '✓';
            }
          }

          return (
            <button
              type="button"
              key={idx}
              onClick={() => setSelectedDate(date)}
              style={{
                aspectRatio: '1',
                minHeight: '44px',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                background: isSelected ? 'var(--color-bg-surfaceStrong)' : 'transparent',
                border: isSelected
                  ? '1px solid var(--info-primary)'
                  : isToday
                  ? '1px dashed var(--color-border-strong)'
                  : 'none',
                borderRadius: 'var(--radius-md)',
                color: !isCurrentMonth ? 'var(--color-text-disabled)' : '#F8FAFC',
                cursor: 'pointer',
                position: 'relative'
              }}
              aria-label={`${date.getDate()} ${monthsTR[date.getMonth()]}`}
            >
              <span style={{ fontSize: '13px', fontWeight: isToday ? 700 : 500 }}>
                {date.getDate()}
              </span>
              {/* Dot / Indicator */}
              {statusColor !== 'transparent' && (
                <div
                  style={{
                    width: '6px',
                    height: '6px',
                    borderRadius: '50%',
                    background: statusColor,
                    marginTop: '2px'
                  }}
                  title={statusText}
                />
              )}
            </button>
          );
        })}
      </div>

      {/* Selected Day Details Panel */}
      <div style={{ marginTop: '16px', paddingTop: '14px', borderTop: '1px solid rgba(36, 48, 68, 0.4)' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '8px' }}>
          <h4 style={{ fontSize: '14px', fontWeight: 600, color: '#F8FAFC' }}>
            {selectedDate.getDate()} {monthsTR[selectedDate.getMonth()]} Kayıtları
          </h4>
          <span style={{ fontSize: '12px', color: 'var(--color-text-muted)' }}>
            {dailyEntries.length} kayıt, {dailyNotes.length} not
          </span>
        </div>

        {dailyEntries.length === 0 && dailyNotes.length === 0 ? (
          <p style={{ fontSize: '13px', color: 'var(--color-text-muted)', fontStyle: 'italic' }}>
            Bu tarihe ait kayıt bulunmuyor.
          </p>
        ) : (
          <div style={{ display: 'flex', flexDirection: 'column', gap: '8px' }}>
            {dailyEntries.map(e => (
              <div
                key={e.id}
                style={{
                  padding: '8px 12px',
                  borderRadius: 'var(--radius-md)',
                  background: 'var(--color-bg-surfaceStrong)',
                  fontSize: '13px',
                  display: 'flex',
                  justifyContent: 'space-between',
                  alignItems: 'center'
                }}
              >
                <div>
                  <span style={{ fontWeight: 600, color: e.entryType === 'lapse' ? 'var(--restart-primary)' : 'var(--positive-stage-3)' }}>
                    {e.entryType === 'lapse' ? '⚠️ Kırılma Bildirimi' : `+${e.value} ${e.unit}`}
                  </span>
                  {e.note && <span style={{ color: 'var(--color-text-muted)', marginLeft: '8px' }}>— {e.note}</span>}
                </div>
                <span style={{ fontSize: '11px', color: 'var(--color-text-muted)' }}>
                  {new Date(e.occurredAt).toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' })}
                </span>
              </div>
            ))}

            {dailyNotes.map(n => (
              <div
                key={n.id}
                style={{
                  padding: '8px 12px',
                  borderRadius: 'var(--radius-md)',
                  background: 'rgba(255, 93, 104, 0.08)',
                  border: '1px solid rgba(255, 93, 104, 0.2)',
                  fontSize: '13px'
                }}
              >
                <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '2px' }}>
                  <span style={{ fontWeight: 600, color: 'var(--negative-stage-1)' }}>
                    🛡️ Zorlanma Notu ({n.intensity}/5)
                  </span>
                  <span style={{ fontSize: '11px', color: 'var(--color-text-muted)' }}>
                    {new Date(n.occurredAt).toLocaleTimeString('tr-TR', { hour: '2-digit', minute: '2-digit' })}
                  </span>
                </div>
                <p style={{ color: '#E2E8F0', margin: 0 }}>{n.note}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};
