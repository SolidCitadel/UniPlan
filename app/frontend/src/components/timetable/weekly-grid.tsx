'use client';

import { useMemo } from 'react';
import { cn } from '@/lib/utils';
import type { TimetableItem, ClassTime } from '@/types';

const DAYS = ['월', '화', '수', '목', '금'] as const;
const START_HOUR = 9;
const END_HOUR = 21;
const GRID_HEIGHT = 640;

interface PlacedBlock {
  item: TimetableItem;
  day: string;
  top: number;
  height: number;
  isPreview?: boolean;
}

interface WeeklyGridProps {
  items: TimetableItem[];
  previewItem?: TimetableItem | null;
  conflicts?: Set<string>;
  selectionMode?: boolean;
  selectedCourseIds?: Set<number>;
  onSelectCourse?: (courseId: number) => void;
  onRemoveCourse?: (courseId: number) => void;
  // Registration mode colors
  succeededCourseIds?: Set<number>;
  failedCourseIds?: Set<number>;
  pendingCourseIds?: Set<number>;
}

function toMinutes(hhmm: string): number {
  const parts = hhmm.split(':');
  if (parts.length !== 2) return 0;
  const h = parseInt(parts[0], 10) || 0;
  const m = parseInt(parts[1], 10) || 0;
  return h * 60 + m;
}

function hasOverlap(a: ClassTime[], b: ClassTime[]): boolean {
  for (const ca of a) {
    for (const cb of b) {
      if (ca.day !== cb.day) continue;
      const aStart = toMinutes(ca.startTime);
      const aEnd = toMinutes(ca.endTime);
      const bStart = toMinutes(cb.startTime);
      const bEnd = toMinutes(cb.endTime);
      if (aStart < bEnd && bStart < aEnd) return true;
    }
  }
  return false;
}

function buildConflicts(items: TimetableItem[]): Set<string> {
  const conflicts = new Set<string>();
  for (let i = 0; i < items.length; i++) {
    for (let j = i + 1; j < items.length; j++) {
      const a = items[i];
      const b = items[j];
      if (hasOverlap(a.classTimes, b.classTimes)) {
        conflicts.add(`${a.courseName} ↔ ${b.courseName}`);
      }
    }
  }
  return conflicts;
}

export function WeeklyGrid({
  items,
  previewItem,
  conflicts: externalConflicts,
  selectionMode = false,
  selectedCourseIds = new Set(),
  onSelectCourse,
  onRemoveCourse,
  succeededCourseIds = new Set(),
  failedCourseIds = new Set(),
  pendingCourseIds = new Set(),
}: WeeklyGridProps) {
  const conflicts = useMemo(
    () => externalConflicts ?? buildConflicts(items),
    [items, externalConflicts]
  );

  const placedBlocks = useMemo(() => {
    const baseMinutes = START_HOUR * 60;
    const totalMinutes = (END_HOUR - START_HOUR) * 60;
    const placed: PlacedBlock[] = [];

    const processItem = (item: TimetableItem, isPreview = false) => {
      for (const slot of item.classTimes) {
        const start = toMinutes(slot.startTime);
        const end = toMinutes(slot.endTime);
        const top = ((start - baseMinutes) / totalMinutes) * GRID_HEIGHT;
        const height = ((end - start) / totalMinutes) * GRID_HEIGHT;
        placed.push({
          item,
          day: slot.day,
          top: Math.max(0, Math.min(top, GRID_HEIGHT)),
          height,
          isPreview,
        });
      }
    };

    items.forEach((item) => processItem(item));
    if (previewItem) {
      processItem(previewItem, true);
    }

    return placed;
  }, [items, previewItem]);

  const getBlockColor = (item: TimetableItem, isPreview: boolean) => {
    if (isPreview) return 'bg-blue-100 border-blue-300';
    if (succeededCourseIds.has(item.courseId)) return 'bg-green-100 border-green-400';
    if (failedCourseIds.has(item.courseId)) return 'bg-red-100 border-red-400 opacity-60';
    if (pendingCourseIds.has(item.courseId)) return 'bg-gray-100 border-gray-300 opacity-60';

    const isConflict = Array.from(conflicts).some((c) => c.includes(item.courseName ?? ''));
    if (isConflict) return 'bg-red-50 border-red-300';

    return 'bg-blue-50 border-blue-200';
  };

  return (
    <div className="border rounded-lg bg-white p-4">
      <h3 className="font-semibold mb-3">주간 그리드</h3>
      <div className="flex" style={{ height: GRID_HEIGHT + 24 }}>
        {/* Time Rail */}
        <div className="w-12 relative">
          {Array.from({ length: END_HOUR - START_HOUR + 1 }, (_, i) => {
            const hour = START_HOUR + i;
            const top = (i / (END_HOUR - START_HOUR)) * GRID_HEIGHT;
            return (
              <div
                key={hour}
                className="absolute text-xs text-muted-foreground"
                style={{ top: top - 8, left: 0 }}
              >
                {hour.toString().padStart(2, '0')}:00
              </div>
            );
          })}
        </div>

        {/* Days Grid */}
        <div className="flex-1 flex">
          {DAYS.map((day) => (
            <div key={day} className="flex-1 relative border-r border-b last:border-r-0">
              {/* Day Header */}
              <div className="text-center text-sm font-medium py-1 border-b bg-gray-50">
                {day}
              </div>

              {/* Hour Lines */}
              <div className="relative" style={{ height: GRID_HEIGHT }}>
                {Array.from({ length: END_HOUR - START_HOUR }, (_, i) => (
                  <div
                    key={i}
                    className="absolute w-full border-b border-gray-100"
                    style={{ top: ((i + 1) / (END_HOUR - START_HOUR)) * GRID_HEIGHT }}
                  />
                ))}

                {/* Course Blocks */}
                {placedBlocks
                  .filter((block) => block.day === day)
                  .map((block, idx) => {
                    const isSelected = selectedCourseIds.has(block.item.courseId);
                    return (
                      <div
                        key={`${block.item.courseId}-${idx}`}
                        className={cn(
                          'absolute left-1 right-1 rounded border p-1 overflow-hidden cursor-pointer transition-all',
                          getBlockColor(block.item, block.isPreview ?? false),
                          isSelected && 'ring-2 ring-blue-500',
                          block.isPreview && 'opacity-50'
                        )}
                        style={{
                          top: block.top,
                          height: Math.max(block.height, 24),
                        }}
                        onClick={() => {
                          if (selectionMode && onSelectCourse) {
                            onSelectCourse(block.item.courseId);
                          }
                        }}
                      >
                        <div className="text-xs font-medium truncate">
                          {block.item.courseName}
                        </div>
                        <div className="text-[10px] text-muted-foreground truncate">
                          {block.item.professor || '담당 미정'}
                        </div>
                        {block.item.classroom && (
                          <div className="text-[10px] text-muted-foreground truncate">
                            {block.item.classroom}
                          </div>
                        )}

                        {/* Remove Button */}
                        {!block.isPreview && !selectionMode && onRemoveCourse && (
                          <button
                            className="absolute top-0.5 right-0.5 text-red-500 hover:text-red-700 text-xs"
                            onClick={(e) => {
                              e.stopPropagation();
                              onRemoveCourse(block.item.courseId);
                            }}
                          >
                            ×
                          </button>
                        )}

                        {/* Selection Checkbox */}
                        {selectionMode && (
                          <div className="absolute top-0.5 right-0.5">
                            <input
                              type="checkbox"
                              checked={isSelected}
                              onChange={() => onSelectCourse?.(block.item.courseId)}
                              className="w-3 h-3"
                            />
                          </div>
                        )}
                      </div>
                    );
                  })}
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

export { buildConflicts, hasOverlap, toMinutes };
