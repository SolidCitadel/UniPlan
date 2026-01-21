'use client';

import { useMemo } from 'react';
import { cn } from '@/lib/utils';
import type { TimetableItem, ClassTime } from '@/types';

const DAYS = ['월', '화', '수', '목', '금'] as const;
const PIXELS_PER_HOUR = 60;
const DEFAULT_START = 9;
const DEFAULT_END = 18;

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
  newCourseIds?: Set<number>;
}

function toMinutes(hhmm: string): number {
  const parts = hhmm.split(':');
  if (parts.length < 2) return 0;
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
  newCourseIds = new Set(),
}: WeeklyGridProps) {
  const conflicts = useMemo(
    () => externalConflicts ?? buildConflicts(items),
    [items, externalConflicts]
  );

  // Calculate Course Range
  const { startHour, endHour, gridHeight } = useMemo(() => {
    let minMin = DEFAULT_START * 60;
    let maxMin = DEFAULT_END * 60;

    const allItems = [...items];
    if (previewItem) allItems.push(previewItem);

    allItems.forEach((item) => {
      item.classTimes.forEach((ct) => {
        const start = toMinutes(ct.startTime);
        const end = toMinutes(ct.endTime);
        if (start < minMin) minMin = start;
        if (end > maxMin) maxMin = end;
      });
    });

    const sHour = Math.floor(minMin / 60);
    const eHour = Math.ceil(maxMin / 60);

    // User requested "exact fit" (e.g. start exactly at 9 if class starts at 9)
    const finalStart = Math.max(0, sHour);
    const finalEnd = Math.min(24, eHour);

    const height = (finalEnd - finalStart) * PIXELS_PER_HOUR;

    return { startHour: finalStart, endHour: finalEnd, gridHeight: height };
  }, [items, previewItem]);

  const placedBlocks = useMemo(() => {
    const baseMinutes = startHour * 60;
    const totalMinutes = (endHour - startHour) * 60;
    const placed: PlacedBlock[] = [];

    const processItem = (item: TimetableItem, isPreview = false) => {
      for (const slot of item.classTimes) {
        const start = toMinutes(slot.startTime);
        const end = toMinutes(slot.endTime);
        const top = ((start - baseMinutes) / totalMinutes) * gridHeight;
        const height = ((end - start) / totalMinutes) * gridHeight;
        placed.push({
          item,
          day: slot.day,
          top: Math.max(0, top), // Don't allow negative top
          height,
          isPreview,
        });
      }
    };

    items.forEach((item) => processItem(item));

    // Only show preview if it's NOT already in the items list
    if (previewItem && !items.some((i) => i.courseId === previewItem.courseId)) {
      processItem(previewItem, true);
    }

    return placed;
  }, [items, previewItem, startHour, endHour, gridHeight]);

  const getBlockColor = (item: TimetableItem, isPreview: boolean) => {
    // Preview: Highlight (Blue)
    if (isPreview) return 'bg-timetable-highlight border-timetable-highlight-fg text-timetable-highlight-fg border-dashed';

    // Status overrides
    if (succeededCourseIds.has(item.courseId)) return 'bg-green-50 border-green-500 text-green-700';
    if (failedCourseIds.has(item.courseId)) return 'bg-red-50 border-red-500 opacity-60 text-red-700';
    if (pendingCourseIds.has(item.courseId)) return 'bg-gray-50 border-gray-500 opacity-60 text-gray-700';

    // Newly Added: Highlight (Blue)
    if (newCourseIds.has(item.courseId)) return 'bg-timetable-highlight border-timetable-highlight-fg text-timetable-highlight-fg';

    // Conflict: Destructive
    const isConflict = Array.from(conflicts).some((c) => c.includes(item.courseName ?? ''));
    if (isConflict) return 'bg-destructive/10 border-destructive text-destructive';

    // Standard: Base (Gray)
    // Using semantic tokens defined in globals.css
    // Note: border-l-4 style relies on the border color here.
    return 'bg-timetable-base border-timetable-base-fg text-foreground';
  };

  return (
    <div className="border rounded-lg bg-white p-4">
      <h3 className="font-semibold mb-3">주간 그리드</h3>
      <div className="flex" style={{ height: gridHeight + 40 }}>
        {/* Time Rail */}
        <div className="w-12 flex flex-col">
          {/* Spacer to match Day Header height */}
          <div className="text-center text-sm font-medium py-1 border-b border-transparent invisible">
            00
          </div>
          <div className="relative flex-1">
            {Array.from({ length: endHour - startHour + 1 }, (_, i) => {
              const hour = startHour + i;
              const top = (i / (endHour - startHour)) * gridHeight;
              return (
                <div
                  key={hour}
                  className="absolute text-xs text-muted-foreground w-full text-right pr-2"
                  style={{ top: top - 8 }}
                >
                  {hour.toString().padStart(2, '0')}:00
                </div>
              );
            })}
          </div>
        </div>

        {/* Days Grid */}
        <div className="flex-1 flex border-t border-l border-r">
          {DAYS.map((day) => (
            <div key={day} className="flex-1 relative border-r border-b last:border-r-0">
              {/* Day Header */}
              <div className="text-center text-sm font-medium py-1 border-b bg-gray-50">
                {day}
              </div>

              {/* Hour Lines */}
              <div className="relative" style={{ height: gridHeight }}>
                {Array.from({ length: endHour - startHour }, (_, i) => (
                  <div
                    key={i}
                    className="absolute w-full border-b border-gray-100"
                    style={{ top: ((i + 1) / (endHour - startHour)) * gridHeight }}
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
                          'absolute inset-x-0 border-l-4 p-1 overflow-hidden cursor-pointer transition-all hover:brightness-95',
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
