'use client';

import { useState, useMemo } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { scenarioApi, timetableApi } from '@/lib/api';
import type { Scenario, Timetable, TimetableItem } from '@/types';
import { toast } from 'sonner';
import { cn } from '@/lib/utils';

export default function ScenarioDetailPage() {
  const params = useParams();
  const router = useRouter();
  const queryClient = useQueryClient();
  const scenarioId = Number(params.id);

  const [excludedCourseIds, setExcludedCourseIds] = useState<Set<number>>(new Set());
  const [showCreateDialog, setShowCreateDialog] = useState(false);
  const [selectedTimetable, setSelectedTimetable] = useState<Timetable | null>(null);
  const [altName, setAltName] = useState('');
  const [altDesc, setAltDesc] = useState('');

  const { data: scenario, isLoading } = useQuery({
    queryKey: ['scenario', scenarioId],
    queryFn: () => scenarioApi.getById(scenarioId),
  });

  const { data: timetables = [] } = useQuery({
    queryKey: ['timetables'],
    queryFn: timetableApi.getAll,
  });

  const createAltMutation = useMutation({
    mutationFn: () =>
      scenarioApi.createAlternative(scenarioId, {
        name: altName,
        timetableId: selectedTimetable!.id,
        failedCourseIds: Array.from(excludedCourseIds),
      }),
    onSuccess: (newScenario) => {
      queryClient.invalidateQueries({ queryKey: ['scenarios'] });
      queryClient.invalidateQueries({ queryKey: ['scenario', scenarioId] });
      toast.success('대안 시나리오가 생성되었습니다');
      setShowCreateDialog(false);
      setExcludedCourseIds(new Set());
      router.push(`/scenarios/${newScenario.id}`);
    },
    onError: () => toast.error('생성 실패'),
  });

  const deleteMutation = useMutation({
    mutationFn: () => scenarioApi.delete(scenarioId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['scenarios'] });
      toast.success('시나리오가 삭제되었습니다');
      router.push('/scenarios');
    },
    onError: () => toast.error('삭제 실패'),
  });

  // Get base timetable
  const baseTimetable = useMemo(() => {
    if (!scenario) return null;
    return timetables.find((t) => t.id === scenario.timetableId) ?? null;
  }, [scenario, timetables]);

  // Get compatible timetables (don't contain excluded courses)
  const compatibleTimetables = useMemo(() => {
    if (!baseTimetable) return [];

    const blocked = new Set([
      ...excludedCourseIds,
      ...baseTimetable.excludedCourses.map((c) => c.courseId),
    ]);

    return timetables.filter((t) => {
      if (t.id === baseTimetable.id) return false;
      if (t.openingYear !== baseTimetable.openingYear || t.semester !== baseTimetable.semester)
        return false;
      const courseIds = new Set(t.items.map((i) => i.courseId));
      return Array.from(blocked).every((id) => !courseIds.has(id));
    });
  }, [timetables, baseTimetable, excludedCourseIds]);

  const toggleExclude = (courseId: number) => {
    setExcludedCourseIds((prev) => {
      const next = new Set(prev);
      if (next.has(courseId)) {
        next.delete(courseId);
      } else {
        next.add(courseId);
      }
      return next;
    });
  };

  const handleCreateAlt = (timetable: Timetable) => {
    if (excludedCourseIds.size === 0) {
      toast.error('제외할 과목을 선택해주세요');
      return;
    }
    setSelectedTimetable(timetable);
    setAltName(`${timetable.name} 대안`);
    setAltDesc('');
    setShowCreateDialog(true);
  };

  // Find course name from timetables
  const findCourseName = (courseId: number): string => {
    for (const t of timetables) {
      const item = t.items.find((i) => i.courseId === courseId);
      if (item) return item.courseName;
    }
    return `과목 ${courseId}`;
  };

  if (isLoading || !scenario) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Button variant="ghost" onClick={() => router.push('/scenarios')}>
            ← 목록
          </Button>
          <h1 className="text-xl font-bold">{scenario.name}</h1>
          {scenario.description && (
            <span className="text-muted-foreground">{scenario.description}</span>
          )}
        </div>
        <Button
          variant="destructive"
          size="sm"
          onClick={() => {
            if (confirm('시나리오를 삭제하시겠습니까?')) {
              deleteMutation.mutate();
            }
          }}
        >
          삭제
        </Button>
      </div>

      <div className="flex gap-4">
        {/* Left Panel - Course Selection */}
        <Card className="w-96 p-4 shrink-0">
          <h3 className="font-semibold mb-2">기준 시간표</h3>
          {baseTimetable ? (
            <p className="text-sm text-muted-foreground mb-4">
              {baseTimetable.name} · {baseTimetable.openingYear}년 {baseTimetable.semester}학기
            </p>
          ) : (
            <p className="text-sm text-muted-foreground mb-4">시간표 정보 없음</p>
          )}

          <h3 className="font-semibold mb-2">제외할 과목 선택</h3>
          <p className="text-xs text-muted-foreground mb-4">
            선택된 과목은 대안 시나리오 생성 시 "실패 과목"으로 표시됩니다.
          </p>

          <div className="space-y-1 max-h-[400px] overflow-y-auto">
            {baseTimetable?.items.map((item) => (
              <label
                key={item.courseId}
                className={cn(
                  'flex items-center gap-2 p-2 rounded cursor-pointer hover:bg-gray-50',
                  excludedCourseIds.has(item.courseId) && 'bg-red-50'
                )}
              >
                <input
                  type="checkbox"
                  checked={excludedCourseIds.has(item.courseId)}
                  onChange={() => toggleExclude(item.courseId)}
                />
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium truncate">{item.courseName}</p>
                  <p className="text-xs text-muted-foreground truncate">
                    {item.professor || '담당 미정'}
                  </p>
                </div>
              </label>
            ))}
          </div>
        </Card>

        {/* Right Panel */}
        <div className="flex-1 space-y-4">
          {/* Compatible Timetables */}
          <Card className="p-4">
            <div className="flex items-center justify-between mb-3">
              <h3 className="font-semibold">호환 시간표</h3>
              <span className="text-sm text-muted-foreground">
                제외 과목 {excludedCourseIds.size}개
              </span>
            </div>

            {excludedCourseIds.size === 0 ? (
              <p className="text-sm text-muted-foreground">
                제외할 과목을 선택하면 호환 시간표가 표시됩니다.
              </p>
            ) : compatibleTimetables.length === 0 ? (
              <p className="text-sm text-muted-foreground">조건에 맞는 시간표가 없습니다.</p>
            ) : (
              <div className="space-y-2 max-h-48 overflow-y-auto">
                {compatibleTimetables.map((t) => (
                  <div
                    key={t.id}
                    className="flex items-center justify-between p-2 border rounded"
                  >
                    <div>
                      <p className="font-medium">{t.name}</p>
                      <p className="text-xs text-muted-foreground">
                        {t.openingYear}년 {t.semester}학기 · 과목 {t.items.length}개
                      </p>
                    </div>
                    <Button size="sm" onClick={() => handleCreateAlt(t)}>
                      대안 생성
                    </Button>
                  </div>
                ))}
              </div>
            )}
          </Card>

          {/* Scenario Tree */}
          <Card className="p-4">
            <h3 className="font-semibold mb-3">시나리오 트리</h3>
            <p className="text-xs text-muted-foreground mb-4">
              노드를 클릭하면 해당 시나리오로 이동합니다.
            </p>

            <div className="max-h-64 overflow-y-auto">
              <ScenarioTreeNode
                scenario={scenario}
                currentId={scenarioId}
                depth={0}
                findCourseName={findCourseName}
                onSelect={(id) => router.push(`/scenarios/${id}`)}
              />
            </div>
          </Card>
        </div>
      </div>

      {/* Create Alternative Dialog */}
      <Dialog open={showCreateDialog} onOpenChange={setShowCreateDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>대안 시나리오 생성</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium">이름</label>
              <Input
                value={altName}
                onChange={(e) => setAltName(e.target.value)}
                placeholder="시나리오 이름"
              />
            </div>
            <div>
              <label className="text-sm font-medium">설명 (선택)</label>
              <Input
                value={altDesc}
                onChange={(e) => setAltDesc(e.target.value)}
                placeholder="설명"
              />
            </div>
            <div>
              <p className="text-sm text-muted-foreground">
                기준 시간표: {selectedTimetable?.name}
              </p>
              <p className="text-sm text-muted-foreground">
                실패 과목: {Array.from(excludedCourseIds).map(findCourseName).join(', ')}
              </p>
            </div>
            <Button
              className="w-full"
              onClick={() => createAltMutation.mutate()}
              disabled={createAltMutation.isPending || !altName.trim()}
            >
              {createAltMutation.isPending ? '생성 중...' : '생성'}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

function ScenarioTreeNode({
  scenario,
  currentId,
  depth,
  findCourseName,
  onSelect,
}: {
  scenario: Scenario;
  currentId: number;
  depth: number;
  findCourseName: (id: number) => string;
  onSelect: (id: number) => void;
}) {
  const isCurrent = scenario.id === currentId;
  const failedCourses = scenario.failedCourseIds.map(findCourseName);

  return (
    <div style={{ paddingLeft: depth * 16 }}>
      <div
        className={cn(
          'p-2 rounded cursor-pointer hover:bg-gray-50',
          isCurrent && 'bg-blue-50 border border-blue-200'
        )}
        onClick={() => onSelect(scenario.id)}
      >
        <div className="flex items-center gap-2">
          <span className="font-medium">{scenario.name}</span>
          {isCurrent && <span className="text-xs text-blue-600">현재</span>}
        </div>
        {failedCourses.length > 0 && (
          <p className="text-xs">
            <span className="text-red-500">{failedCourses.join(', ')}</span>
            <span className="text-muted-foreground"> → {scenario.timetable.name}</span>
          </p>
        )}
        {scenario.description && (
          <p className="text-xs text-muted-foreground">{scenario.description}</p>
        )}
      </div>

      {scenario.children.map((child) => (
        <ScenarioTreeNode
          key={child.id}
          scenario={child}
          currentId={currentId}
          depth={depth + 1}
          findCourseName={findCourseName}
          onSelect={onSelect}
        />
      ))}
    </div>
  );
}
