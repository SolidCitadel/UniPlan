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
import { Tabs, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { timetableApi, wishlistApi } from '@/lib/api';
import { WeeklyGrid, hasOverlap } from '@/components/timetable/weekly-grid';
import type { WishlistItem, TimetableItem, ClassTime } from '@/types';
import { toast } from 'sonner';

type EditorTab = 'available' | 'conflicts' | 'excluded';

export default function TimetableDetailPage() {
  const params = useParams();
  const router = useRouter();
  const queryClient = useQueryClient();
  const timetableId = Number(params.id);

  const [tab, setTab] = useState<EditorTab>('available');
  const [altMode, setAltMode] = useState(false);
  const [excluded, setExcluded] = useState<Set<number>>(new Set());
  const [showAltDialog, setShowAltDialog] = useState(false);
  const [altName, setAltName] = useState('');
  const [previewCourse, setPreviewCourse] = useState<TimetableItem | null>(null);

  const { data: timetable, isLoading } = useQuery({
    queryKey: ['timetable', timetableId],
    queryFn: () => timetableApi.getById(timetableId),
  });

  const { data: wishlistItems = [] } = useQuery({
    queryKey: ['wishlist'],
    queryFn: wishlistApi.getAll,
  });

  const addCourseMutation = useMutation({
    mutationFn: (courseId: number) => timetableApi.addCourse(timetableId, courseId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['timetable', timetableId] });
      queryClient.invalidateQueries({ queryKey: ['timetables'] });
      toast.success('과목이 추가되었습니다');
    },
    onError: () => toast.error('과목 추가 실패'),
  });

  const removeCourseMutation = useMutation({
    mutationFn: (courseId: number) => timetableApi.removeCourse(timetableId, courseId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['timetable', timetableId] });
      queryClient.invalidateQueries({ queryKey: ['timetables'] });
      toast.success('과목이 제거되었습니다');
    },
    onError: () => toast.error('과목 제거 실패'),
  });

  const createAltMutation = useMutation({
    mutationFn: () =>
      timetableApi.createAlternative(timetableId, {
        name: altName,
        excludedCourseIds: Array.from(excluded),
      }),
    onSuccess: (newTimetable) => {
      queryClient.invalidateQueries({ queryKey: ['timetables'] });
      toast.success('대안 시간표가 생성되었습니다');
      setShowAltDialog(false);
      setAltMode(false);
      setExcluded(new Set());
      router.push(`/timetables/${newTimetable.id}`);
    },
    onError: () => toast.error('대안 시간표 생성 실패'),
  });

  // Convert wishlist item to timetable item for preview
  const toTimetableItem = (w: WishlistItem): TimetableItem => ({
    id: -1,
    courseId: w.courseId,
    courseName: w.courseName,
    professor: w.professor,
    classroom: w.classroom,
    classTimes: w.classTimes,
  });

  // Categorize wishlist items
  const { available, conflicting } = useMemo(() => {
    if (!timetable) return { available: [], conflicting: [] };

    const currentCourseIds = new Set(timetable.items.map((i) => i.courseId));
    const notInTimetable = wishlistItems.filter((w) => !currentCourseIds.has(w.courseId));

    const avail: WishlistItem[] = [];
    const conflict: WishlistItem[] = [];

    for (const w of notInTimetable) {
      const overlaps = timetable.items.some((item) =>
        hasOverlap(w.classTimes as ClassTime[], item.classTimes)
      );
      if (overlaps || w.classTimes.length === 0) {
        conflict.push(w);
      } else {
        avail.push(w);
      }
    }

    return { available: avail, conflicting: conflict };
  }, [timetable, wishlistItems]);

  const toggleSelect = (courseId: number) => {
    setExcluded((prev) => {
      const next = new Set(prev);
      if (next.has(courseId)) {
        next.delete(courseId);
      } else {
        next.add(courseId);
      }
      return next;
    });
  };

  const handleCreateAlt = () => {
    if (timetable) {
      setAltName(`${timetable.name} 대안`);
      setShowAltDialog(true);
    }
  };

  if (isLoading || !timetable) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-4">
          <Button variant="ghost" onClick={() => router.push('/timetables')}>
            ← 목록
          </Button>
          <h1 className="text-xl font-bold">{timetable.name} 편집</h1>
          <span className="text-muted-foreground">과목 {timetable.items.length}개</span>
        </div>
        <div className="flex items-center gap-2">
          {altMode ? (
            <>
              <span className="text-sm text-muted-foreground">제외할 과목을 선택하세요</span>
              <Button variant="ghost" onClick={() => { setAltMode(false); setExcluded(new Set()); }}>
                취소
              </Button>
              <Button
                disabled={excluded.size === 0}
                onClick={handleCreateAlt}
              >
                대안 생성
              </Button>
            </>
          ) : (
            <Button variant="outline" onClick={() => setAltMode(true)}>
              대안 시간표 생성
            </Button>
          )}
        </div>
      </div>

      {/* Main Content */}
      <div className="flex gap-4">
        {/* Left Panel - Course Lists */}
        <Card className="w-80 p-4 shrink-0">
          <Tabs value={tab} onValueChange={(v) => setTab(v as EditorTab)}>
            <TabsList className="w-full">
              <TabsTrigger value="available" className="flex-1">추가 가능</TabsTrigger>
              <TabsTrigger value="conflicts" className="flex-1">시간 겹침</TabsTrigger>
              <TabsTrigger value="excluded" className="flex-1">제외됨</TabsTrigger>
            </TabsList>
          </Tabs>

          <div className="mt-4 space-y-2 max-h-[500px] overflow-y-auto">
            {tab === 'available' && (
              available.length === 0 ? (
                <p className="text-sm text-muted-foreground">추가할 수 있는 과목이 없습니다.</p>
              ) : (
                available.map((w) => (
                  <div
                    key={w.id}
                    className="p-2 border rounded hover:bg-gray-50 cursor-pointer"
                    onMouseEnter={() => setPreviewCourse(toTimetableItem(w))}
                    onMouseLeave={() => setPreviewCourse(null)}
                  >
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium text-sm">{w.courseName}</p>
                        <p className="text-xs text-muted-foreground">{w.professor}</p>
                      </div>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => addCourseMutation.mutate(w.courseId)}
                        disabled={addCourseMutation.isPending}
                      >
                        +
                      </Button>
                    </div>
                  </div>
                ))
              )
            )}

            {tab === 'conflicts' && (
              conflicting.length === 0 ? (
                <p className="text-sm text-muted-foreground">시간이 겹치는 과목이 없습니다.</p>
              ) : (
                conflicting.map((w) => (
                  <div key={w.id} className="p-2 border rounded border-red-200 bg-red-50">
                    <p className="font-medium text-sm">{w.courseName}</p>
                    <p className="text-xs text-muted-foreground">{w.professor}</p>
                  </div>
                ))
              )
            )}

            {tab === 'excluded' && (
              timetable.excludedCourses.length === 0 ? (
                <p className="text-sm text-muted-foreground">제외된 과목이 없습니다.</p>
              ) : (
                timetable.excludedCourses.map((c) => (
                  <div key={c.courseId} className="p-2 border rounded">
                    <p className="font-medium text-sm">{c.courseName}</p>
                    <p className="text-xs text-muted-foreground">{c.professor}</p>
                  </div>
                ))
              )
            )}
          </div>
        </Card>

        {/* Right Panel - Weekly Grid */}
        <div className="flex-1">
          <WeeklyGrid
            items={timetable.items}
            previewItem={previewCourse}
            selectionMode={altMode}
            selectedCourseIds={excluded}
            onSelectCourse={toggleSelect}
            onRemoveCourse={(courseId) => removeCourseMutation.mutate(courseId)}
          />
        </div>
      </div>

      {/* Alternative Dialog */}
      <Dialog open={showAltDialog} onOpenChange={setShowAltDialog}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>대안 시간표 생성</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <label className="text-sm font-medium">이름</label>
              <Input
                value={altName}
                onChange={(e) => setAltName(e.target.value)}
                placeholder="대안 시간표 이름"
              />
            </div>
            <div>
              <p className="text-sm text-muted-foreground">
                제외할 과목: {excluded.size}개
              </p>
              <ul className="text-sm mt-2">
                {Array.from(excluded).map((courseId) => {
                  const item = timetable.items.find((i) => i.courseId === courseId);
                  return item ? <li key={courseId}>- {item.courseName}</li> : null;
                })}
              </ul>
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
