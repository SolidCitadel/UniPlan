'use client';

import { useState, useMemo, useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { registrationApi } from '@/lib/api';
import { WeeklyGrid } from '@/components/timetable/weekly-grid';
import type { TimetableItem, Scenario } from '@/types';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

type MarkAction = 'toSuccess' | 'toFail' | 'toPending';

export default function RegistrationDetailPage() {
  const params = useParams();
  const router = useRouter();
  const queryClient = useQueryClient();
  const registrationId = Number(params.id);

  const [succeeded, setSucceeded] = useState<Set<number>>(new Set());
  const [failed, setFailed] = useState<Set<number>>(new Set());
  const [canceled, setCanceled] = useState<Set<number>>(new Set());
  const [initialized, setInitialized] = useState(false);

  const { data: registration, isLoading } = useQuery({
    queryKey: ['registration', registrationId],
    queryFn: () => registrationApi.getById(registrationId),
  });

  // Initialize local state from server data
  useEffect(() => {
    if (registration && !initialized) {
      setSucceeded(new Set(registration.succeededCourses));
      setFailed(new Set(registration.failedCourses));
      setCanceled(new Set(registration.canceledCourses));
      setInitialized(true);
    }
  }, [registration, initialized]);

  const addStepMutation = useMutation({
    mutationFn: () =>
      registrationApi.addStep(registrationId, {
        succeededCourses: Array.from(succeeded),
        failedCourses: Array.from(failed),
        canceledCourses: Array.from(canceled),
      }),
    onSuccess: (updated) => {
      setSucceeded(new Set(updated.succeededCourses));
      setFailed(new Set(updated.failedCourses));
      setCanceled(new Set(updated.canceledCourses));
      queryClient.invalidateQueries({ queryKey: ['registration', registrationId] });
      toast.success('다음 단계가 저장되었습니다');
    },
    onError: () => toast.error('저장 실패'),
  });

  const completeMutation = useMutation({
    mutationFn: () => registrationApi.complete(registrationId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['registrations'] });
      toast.success('수강신청이 완료되었습니다');
      router.push('/registrations');
    },
    onError: () => toast.error('완료 처리 실패'),
  });

  const cancelMutation = useMutation({
    mutationFn: () => registrationApi.cancel(registrationId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['registrations'] });
      toast.success('수강신청이 취소되었습니다');
      router.push('/registrations');
    },
    onError: () => toast.error('취소 처리 실패'),
  });

  const deleteMutation = useMutation({
    mutationFn: () => registrationApi.delete(registrationId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['registrations'] });
      toast.success('수강신청이 삭제되었습니다');
      router.push('/registrations');
    },
    onError: () => toast.error('삭제 실패'),
  });

  // Collect courses from scenario
  const collectCourses = (scenario: Scenario): Map<number, TimetableItem> => {
    const map = new Map<number, TimetableItem>();
    for (const item of scenario.timetable.items) {
      map.set(item.courseId, item);
    }
    return map;
  };

  // Collect courses from both start and current scenario
  const collectCoursesUnion = (a: Scenario, b: Scenario): Map<number, TimetableItem> => {
    const map = new Map<number, TimetableItem>();
    const addScenario = (s: Scenario) => {
      for (const item of s.timetable.items) {
        map.set(item.courseId, item);
      }
      for (const child of s.children) {
        addScenario(child);
      }
    };
    addScenario(a);
    addScenario(b);
    return map;
  };

  const { courseMapAll, courseMapGrid, pending } = useMemo(() => {
    if (!registration) {
      return { courseMapAll: new Map(), courseMapGrid: new Map(), pending: new Set<number>() };
    }

    const mapAll = collectCoursesUnion(registration.startScenario, registration.currentScenario);
    const mapGrid = collectCourses(registration.currentScenario);

    // Derive canceled: explicit + succeeded but not in current grid
    const derivedCanceled = new Set([
      ...canceled,
      ...Array.from(succeeded).filter((id) => !mapGrid.has(id)),
    ]);

    // Pending: in grid but not succeeded, failed, or canceled
    const pendingSet = new Set(
      Array.from(mapGrid.keys()).filter(
        (id) => !succeeded.has(id) && !failed.has(id) && !derivedCanceled.has(id)
      )
    );

    return { courseMapAll: mapAll, courseMapGrid: mapGrid, pending: pendingSet };
  }, [registration, succeeded, failed, canceled]);

  const mapIdsToItems = (ids: Set<number>, map: Map<number, TimetableItem>): TimetableItem[] => {
    return Array.from(ids).map((id) => {
      const found = map.get(id);
      if (found) return found;
      return {
        id,
        courseId: id,
        courseName: `알 수 없는 과목 (${id})`,
        professor: '',
        classroom: '',
        classTimes: [],
      };
    });
  };

  const handleMark = (courseId: number, action: MarkAction) => {
    switch (action) {
      case 'toSuccess':
        setSucceeded((prev) => new Set([...prev, courseId]));
        setFailed((prev) => {
          const next = new Set(prev);
          next.delete(courseId);
          return next;
        });
        break;
      case 'toFail':
        setFailed((prev) => new Set([...prev, courseId]));
        setSucceeded((prev) => {
          const next = new Set(prev);
          next.delete(courseId);
          return next;
        });
        break;
      case 'toPending':
        setSucceeded((prev) => {
          const next = new Set(prev);
          next.delete(courseId);
          return next;
        });
        setFailed((prev) => {
          const next = new Set(prev);
          next.delete(courseId);
          return next;
        });
        break;
    }
  };

  if (isLoading || !registration) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  const succeededItems = mapIdsToItems(succeeded, courseMapAll);
  const failedItems = mapIdsToItems(failed, courseMapAll);
  const pendingItems = mapIdsToItems(pending, courseMapGrid);
  const gridItems = Array.from(courseMapGrid.values());

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Button variant="ghost" onClick={() => router.push('/registrations')}>
            ← 목록
          </Button>
          <h1 className="text-xl font-bold">
            {registration.name || `수강신청 #${registration.id}`}
          </h1>
        </div>
        <div className="flex items-center gap-2">
          <Button variant="outline" onClick={() => completeMutation.mutate()}>
            완료 처리
          </Button>
          <Button
            variant="outline"
            onClick={() => {
              if (confirm('수강신청을 취소하시겠습니까?')) {
                cancelMutation.mutate();
              }
            }}
          >
            취소
          </Button>
          <Button
            variant="destructive"
            onClick={() => {
              if (confirm('수강신청을 완전히 삭제하시겠습니까?')) {
                deleteMutation.mutate();
              }
            }}
          >
            삭제
          </Button>
        </div>
      </div>

      <div className="flex gap-4">
        {/* Left Panel - Status Lists */}
        <Card className="w-96 p-4 shrink-0">
          <h3 className="font-semibold mb-2">현재 시나리오</h3>
          <p className="text-sm text-muted-foreground mb-4">
            {registration.currentScenario.name}
          </p>

          {/* Success List */}
          <StatusList
            label="신청 성공"
            color="green"
            items={succeededItems}
            onAction={(item) => handleMark(item.courseId, 'toPending')}
            actionLabel="대기로"
          />

          {/* Pending List */}
          <StatusList
            label="신청 대기"
            color="gray"
            items={pendingItems}
            onAction={(item) => handleMark(item.courseId, 'toSuccess')}
            onAction2={(item) => handleMark(item.courseId, 'toFail')}
            actionLabel="성공"
            actionLabel2="실패"
          />

          {/* Failed List */}
          <StatusList
            label="신청 실패"
            color="red"
            items={failedItems}
            onAction={(item) => handleMark(item.courseId, 'toSuccess')}
            actionLabel="성공으로"
          />

          <Button
            className="w-full mt-4"
            onClick={() => addStepMutation.mutate()}
            disabled={addStepMutation.isPending}
          >
            {addStepMutation.isPending ? '저장 중...' : '다음 단계 저장'}
          </Button>
        </Card>

        {/* Right Panel - Weekly Grid */}
        <div className="flex-1">
          <WeeklyGrid
            items={gridItems}
            succeededCourseIds={succeeded}
            failedCourseIds={failed}
            pendingCourseIds={pending}
          />
        </div>
      </div>
    </div>
  );
}

function StatusList({
  label,
  color,
  items,
  onAction,
  onAction2,
  actionLabel,
  actionLabel2,
}: {
  label: string;
  color: 'green' | 'gray' | 'red';
  items: TimetableItem[];
  onAction: (item: TimetableItem) => void;
  onAction2?: (item: TimetableItem) => void;
  actionLabel: string;
  actionLabel2?: string;
}) {
  const colorClasses = {
    green: 'text-green-600',
    gray: 'text-gray-500',
    red: 'text-red-600',
  };

  return (
    <div className="mb-4">
      <h4 className={cn('font-semibold mb-2', colorClasses[color])}>{label}</h4>
      {items.length === 0 ? (
        <p className="text-xs text-muted-foreground">없음</p>
      ) : (
        <div className="space-y-1 max-h-32 overflow-y-auto">
          {items.map((item) => (
            <div
              key={item.courseId}
              className="flex items-center justify-between p-1 rounded hover:bg-gray-50"
            >
              <div className="min-w-0 flex-1">
                <p className="text-sm font-medium truncate">{item.courseName}</p>
                <p className="text-xs text-muted-foreground truncate">
                  {item.professor || '담당 미정'}
                </p>
              </div>
              <div className="flex gap-1">
                <Button size="sm" variant="ghost" onClick={() => onAction(item)}>
                  {actionLabel}
                </Button>
                {onAction2 && actionLabel2 && (
                  <Button size="sm" variant="ghost" onClick={() => onAction2(item)}>
                    {actionLabel2}
                  </Button>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
