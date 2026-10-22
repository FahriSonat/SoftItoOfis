/**
 * Date utilities with timezone and calendar day safety.
 */

export function toLocalDateString(dateInput: Date | string): string {
  const d = typeof dateInput === 'string' ? new Date(dateInput) : dateInput;
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

export function isSameDay(d1: Date | string, d2: Date | string): boolean {
  return toLocalDateString(d1) === toLocalDateString(d2);
}

export function addDays(date: Date, days: number): Date {
  const result = new Date(date);
  result.setDate(result.getDate() + days);
  return result;
}

export function getStartOfDay(dateInput: Date | string): Date {
  const d = typeof dateInput === 'string' ? new Date(dateInput) : new Date(dateInput.getTime());
  d.setHours(0, 0, 0, 0);
  return d;
}

export function getEndOfDay(dateInput: Date | string): Date {
  const d = typeof dateInput === 'string' ? new Date(dateInput) : new Date(dateInput.getTime());
  d.setHours(23, 59, 59, 999);
  return d;
}

/**
 * Returns difference in whole calendar days (d2 - d1).
 */
export function calendarDaysDifference(d1: Date | string, d2: Date | string): number {
  const start1 = getStartOfDay(d1).getTime();
  const start2 = getStartOfDay(d2).getTime();
  const diffMs = start2 - start1;
  return Math.round(diffMs / (24 * 60 * 60 * 1000));
}

/**
 * Formats duration in seconds to Turkish display string.
 * Under 24h: "X saat Y dk" or "X dk"
 * Over 24h: "X gün Y saat"
 */
export function formatDurationTurkish(seconds: number): { value: number; unit: 'minute' | 'hour' | 'day'; text: string; fullText: string } {
  if (seconds < 60) {
    return { value: seconds, unit: 'minute', text: `${seconds} sn`, fullText: `${seconds} saniye` };
  }
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) {
    return { value: minutes, unit: 'minute', text: `${minutes} dk`, fullText: `${minutes} dakika` };
  }
  const hours = Math.floor(minutes / 60);
  const remainingMinutes = minutes % 60;
  if (hours < 24) {
    return {
      value: hours,
      unit: 'hour',
      text: `${hours} sa`,
      fullText: remainingMinutes > 0 ? `${hours} sa ${remainingMinutes} dk` : `${hours} saat`
    };
  }
  const days = Math.floor(hours / 24);
  const remainingHours = hours % 24;
  return {
    value: days,
    unit: 'day',
    text: `${days} gün`,
    fullText: remainingHours > 0 ? `${days} gün ${remainingHours} sa` : `${days} gün`
  };
}

export function formatFriendlyDateTR(dateInput: Date | string): string {
  const d = typeof dateInput === 'string' ? new Date(dateInput) : dateInput;
  const now = new Date();
  if (isSameDay(d, now)) {
    return 'Bugün';
  }
  const yesterday = addDays(now, -1);
  if (isSameDay(d, yesterday)) {
    return 'Dün';
  }

  const monthsTR = [
    'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
    'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
  ];
  return `${d.getDate()} ${monthsTR[d.getMonth()]}`;
}

export function formatFriendlyDateTimeTR(dateInput: Date | string): string {
  const d = typeof dateInput === 'string' ? new Date(dateInput) : dateInput;
  const dateStr = formatFriendlyDateTR(d);
  const hours = String(d.getHours()).padStart(2, '0');
  const minutes = String(d.getMinutes()).padStart(2, '0');
  return `${dateStr}, ${hours}:${minutes}`;
}
