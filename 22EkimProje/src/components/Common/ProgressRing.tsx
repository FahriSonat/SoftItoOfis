import React from 'react';

interface ProgressRingProps {
  progress: number; // 0 to 1 (or > 1)
  size?: 'small' | 'medium' | 'large';
  colorHex?: string;
  centerValue?: string | number;
  centerUnit?: string;
  isBroken?: boolean;
  accessibleLabel?: string;
}

export const ProgressRing: React.FC<ProgressRingProps> = ({
  progress,
  size = 'small',
  colorHex = '#4D8DFF',
  centerValue,
  centerUnit,
  isBroken = false,
  accessibleLabel
}) => {
  const dimensions = size === 'small' ? 44 : size === 'medium' ? 76 : 160;
  const strokeWidth = size === 'small' ? 4 : size === 'medium' ? 6 : 10;
  const radius = (dimensions - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;

  // Clamped percentage for standard visual representation
  const clamped = Math.min(Math.max(progress, 0), 1);
  const strokeDashoffset = circumference - clamped * circumference;

  const ringColor = isBroken ? '#FF9F43' : colorHex;

  return (
    <div
      style={{
        position: 'relative',
        width: dimensions,
        height: dimensions,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        flexShrink: 0
      }}
      role="progressbar"
      aria-valuenow={Math.round(clamped * 100)}
      aria-valuemin={0}
      aria-valuemax={100}
      aria-label={accessibleLabel || 'İlerleme halkası'}
    >
      <svg
        width={dimensions}
        height={dimensions}
        style={{ transform: 'rotate(-90deg)', overflow: 'visible' }}
      >
        {/* Background track */}
        <circle
          cx={dimensions / 2}
          cy={dimensions / 2}
          r={radius}
          fill="none"
          stroke="rgba(255, 255, 255, 0.08)"
          strokeWidth={strokeWidth}
        />
        {/* Progress Arc */}
        <circle
          cx={dimensions / 2}
          cy={dimensions / 2}
          r={radius}
          fill="none"
          stroke={ringColor}
          strokeWidth={strokeWidth}
          strokeDasharray={circumference}
          strokeDashoffset={strokeDashoffset}
          strokeLinecap="round"
          style={{
            transition: 'stroke-dashoffset 600ms cubic-bezier(0.2, 0.8, 0.2, 1)',
            filter: `drop-shadow(0 0 ${size === 'large' ? 12 : 6}px ${ringColor}44)`
          }}
        />
      </svg>

      {/* Center Label */}
      {(centerValue !== undefined || centerUnit) && (
        <div
          style={{
            position: 'absolute',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            textAlign: 'center',
            pointerEvents: 'none'
          }}
        >
          {centerValue !== undefined && (
            <span
              style={{
                fontSize: size === 'small' ? '12px' : size === 'medium' ? '18px' : '36px',
                fontWeight: 800,
                color: '#F8FAFC',
                fontVariantNumeric: 'tabular-nums',
                lineHeight: 1.1
              }}
            >
              {centerValue}
            </span>
          )}
          {centerUnit && (
            <span
              style={{
                fontSize: size === 'small' ? '9px' : size === 'medium' ? '11px' : '13px',
                color: '#8491A8',
                fontWeight: 500,
                marginTop: '1px'
              }}
            >
              {centerUnit}
            </span>
          )}
        </div>
      )}
    </div>
  );
};
