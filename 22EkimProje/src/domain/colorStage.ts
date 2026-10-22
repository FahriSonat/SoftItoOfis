import { HabitKind, ColorStageResult } from '../types/models';

export const NEGATIVE_STAGES: Array<{
  maxDays: number; // inclusive upper bound
  hex: string;
  tokenName: string;
  label: string;
  description: string;
}> = [
  { maxDays: 0, hex: '#FF5D68', tokenName: 'negative.stage.0', label: 'Başlangıç', description: '0–23 saatlik ilk odak' },
  { maxDays: 2, hex: '#FF735C', tokenName: 'negative.stage.1', label: 'İlk ilerleme', description: '1–2 gün geride kaldı' },
  { maxDays: 6, hex: '#F59E45', tokenName: 'negative.stage.2', label: 'Dayanıklılık', description: '3–6 gün direnç' },
  { maxDays: 13, hex: '#C4C94A', tokenName: 'negative.stage.3', label: 'Dönüşüm', description: '7–13 gün yeni alışkanlık' },
  { maxDays: 29, hex: '#71C96B', tokenName: 'negative.stage.4', label: 'Güçlenme', description: '14–29 gün sağlamlaşma' },
  { maxDays: Infinity, hex: '#35D083', tokenName: 'negative.stage.5', label: 'İstikrar', description: '30+ gün kalıcı kontrol' },
];

export const POSITIVE_STAGES: Array<{
  maxPeriods: number; // inclusive upper bound
  hex: string;
  tokenName: string;
  label: string;
  description: string;
}> = [
  { maxPeriods: 2, hex: '#4D8DFF', tokenName: 'positive.stage.0', label: 'Başlangıç', description: '0–2 başarılı periyot' },
  { maxPeriods: 6, hex: '#3B9EF3', tokenName: 'positive.stage.1', label: 'Ritim', description: '3–6 periyotluk düzen' },
  { maxPeriods: 13, hex: '#2BAFE4', tokenName: 'positive.stage.2', label: 'Akış', description: '7–13 periyotluk ivme' },
  { maxPeriods: 29, hex: '#22C1D0', tokenName: 'positive.stage.3', label: 'Devamlılık', description: '14–29 periyotluk kararlılık' },
  { maxPeriods: Infinity, hex: '#20D3B0', tokenName: 'positive.stage.4', label: 'İstikrar', description: '30+ periyotluk yaşam tarzı' },
];

export const RESTART_STAGE: ColorStageResult = {
  stageIndex: -1,
  tokenName: 'restart.primary',
  hex: '#FF9F43',
  label: 'Yeniden Yön Bulma',
  description: 'Seri kesintiye uğradı; yeni bir sözle başlayabilirsin.'
};

/**
 * Calculates semantic color stage and tokens according to design.md.
 */
export function calculateColorStage(
  kind: HabitKind,
  currentStreakValue: number, // days for negative, periods for positive
  isBroken: boolean = false
): ColorStageResult {
  if (isBroken) {
    return RESTART_STAGE;
  }

  if (kind === 'negative') {
    const days = Math.max(0, currentStreakValue);
    for (let i = 0; i < NEGATIVE_STAGES.length; i++) {
      if (days <= NEGATIVE_STAGES[i].maxDays) {
        return {
          stageIndex: i,
          tokenName: NEGATIVE_STAGES[i].tokenName,
          hex: NEGATIVE_STAGES[i].hex,
          label: NEGATIVE_STAGES[i].label,
          description: NEGATIVE_STAGES[i].description
        };
      }
    }
    const last = NEGATIVE_STAGES[NEGATIVE_STAGES.length - 1];
    return {
      stageIndex: NEGATIVE_STAGES.length - 1,
      tokenName: last.tokenName,
      hex: last.hex,
      label: last.label,
      description: last.description
    };
  } else {
    const periods = Math.max(0, currentStreakValue);
    for (let i = 0; i < POSITIVE_STAGES.length; i++) {
      if (periods <= POSITIVE_STAGES[i].maxPeriods) {
        return {
          stageIndex: i,
          tokenName: POSITIVE_STAGES[i].tokenName,
          hex: POSITIVE_STAGES[i].hex,
          label: POSITIVE_STAGES[i].label,
          description: POSITIVE_STAGES[i].description
        };
      }
    }
    const last = POSITIVE_STAGES[POSITIVE_STAGES.length - 1];
    return {
      stageIndex: POSITIVE_STAGES.length - 1,
      tokenName: last.tokenName,
      hex: last.hex,
      label: last.label,
      description: last.description
    };
  }
}
