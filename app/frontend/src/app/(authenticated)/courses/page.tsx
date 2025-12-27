'use client';

import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog';
import { courseApi, wishlistApi } from '@/lib/api';
import type { Course, CourseSearchParams } from '@/types';
import { toast } from 'sonner';

export default function CoursesPage() {
  const queryClient = useQueryClient();
  const [filters, setFilters] = useState<CourseSearchParams>({
    query: '',
    professor: '',
    departmentName: '',
    campus: '',
  });
  const [page, setPage] = useState(0);
  const [priorityModal, setPriorityModal] = useState<Course | null>(null);

  const { data, isLoading, error } = useQuery({
    queryKey: ['courses', filters, page],
    queryFn: () => courseApi.search({ ...filters, page, size: 20 }),
  });

  const addWishlist = useMutation({
    mutationFn: ({ courseId, priority }: { courseId: number; priority: number }) =>
      wishlistApi.add({ courseId, priority }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['wishlist'] });
      toast.success('위시리스트에 추가되었습니다');
      setPriorityModal(null);
    },
    onError: () => {
      toast.error('추가 실패. 다시 시도해주세요.');
    },
  });

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    setPage(0);
  };

  const handleReset = () => {
    setFilters({
      query: '',
      professor: '',
      departmentName: '',
      campus: '',
    });
    setPage(0);
  };

  const formatClassTimes = (course: Course) => {
    if (!course.classTimes?.length) return '시간 미정';
    return course.classTimes
      .map((t) => `${t.day} ${t.startTime}-${t.endTime}`)
      .join(' / ');
  };

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">강의 검색</h1>

      {/* Filters */}
      <Card className="p-4">
        <form onSubmit={handleSearch}>
          <div className="flex flex-wrap gap-2">
            <Input
              placeholder="캠퍼스"
              value={filters.campus || ''}
              onChange={(e) => setFilters((f) => ({ ...f, campus: e.target.value }))}
              className="w-full sm:w-32"
            />
            <Input
              placeholder="학과명"
              value={filters.departmentName || ''}
              onChange={(e) => setFilters((f) => ({ ...f, departmentName: e.target.value }))}
              className="w-full sm:flex-1"
            />
            <Input
              placeholder="교수명"
              value={filters.professor || ''}
              onChange={(e) => setFilters((f) => ({ ...f, professor: e.target.value }))}
              className="w-full sm:w-32"
            />
            <Input
              placeholder="과목명"
              value={filters.query || ''}
              onChange={(e) => setFilters((f) => ({ ...f, query: e.target.value }))}
              className="w-full sm:flex-1"
            />
            <Input
              placeholder="학년"
              type="number"
              min={1}
              max={4}
              value={filters.targetGrade || ''}
              onChange={(e) =>
                setFilters((f) => ({
                  ...f,
                  targetGrade: e.target.value ? Number(e.target.value) : undefined,
                }))
              }
              className="w-full sm:w-20"
            />
            <Input
              placeholder="학점"
              type="number"
              min={1}
              max={6}
              value={filters.credits || ''}
              onChange={(e) =>
                setFilters((f) => ({
                  ...f,
                  credits: e.target.value ? Number(e.target.value) : undefined,
                }))
              }
              className="w-full sm:w-20"
            />
            <Button type="submit">검색</Button>
            <Button type="button" variant="outline" onClick={handleReset}>
              초기화
            </Button>
          </div>
        </form>
      </Card>

      {/* Results */}
      {isLoading ? (
        <div className="text-center py-8">로딩 중...</div>
      ) : error ? (
        <div className="text-center py-8 text-red-500">오류가 발생했습니다</div>
      ) : !data?.content.length ? (
        <div className="text-center py-8 text-muted-foreground">
          검색 결과가 없습니다
        </div>
      ) : (
        <>
          <div className="flex justify-between text-sm text-muted-foreground">
            <span>총 {data.totalElements}건</span>
            <span>
              페이지 {data.number + 1} / {data.totalPages || 1}
            </span>
          </div>

          <div className="divide-y border rounded-lg bg-white">
            {data.content.map((course) => (
              <div
                key={course.id}
                className="p-4 flex flex-col sm:flex-row sm:items-center justify-between gap-2"
              >
                <div className="flex-1 min-w-0">
                  <p className="font-semibold truncate">{course.courseName}</p>
                  <p className="text-sm text-muted-foreground">
                    {course.professor ?? '담당 교수 미정'} · {course.courseCode} ·{' '}
                    {course.campus}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {formatClassTimes(course)}
                  </p>
                </div>
                <div className="flex items-center gap-3">
                  <div className="text-right">
                    <p className="font-medium">{course.credits}학점</p>
                    {course.classroom && (
                      <p className="text-xs text-muted-foreground">
                        {course.classroom}
                      </p>
                    )}
                  </div>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => setPriorityModal(course)}
                  >
                    + 위시리스트
                  </Button>
                </div>
              </div>
            ))}
          </div>

          {/* Pagination */}
          <div className="flex justify-center items-center gap-4">
            <Button
              variant="outline"
              disabled={page === 0}
              onClick={() => setPage((p) => p - 1)}
            >
              이전
            </Button>
            <span className="text-sm">
              Page {page + 1} / {data.totalPages || 1}
            </span>
            <Button
              variant="outline"
              disabled={page + 1 >= data.totalPages}
              onClick={() => setPage((p) => p + 1)}
            >
              다음
            </Button>
          </div>
        </>
      )}

      {/* Priority Modal */}
      <Dialog open={!!priorityModal} onOpenChange={() => setPriorityModal(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>위시리스트 우선순위 선택</DialogTitle>
          </DialogHeader>
          <p className="text-sm text-muted-foreground mb-4">
            {priorityModal?.courseName}
          </p>
          <div className="flex gap-2 justify-center">
            {[1, 2, 3, 4, 5].map((priority) => (
              <Button
                key={priority}
                variant="outline"
                size="lg"
                onClick={() =>
                  addWishlist.mutate({
                    courseId: priorityModal!.id,
                    priority,
                  })
                }
                disabled={addWishlist.isPending}
              >
                {priority}
              </Button>
            ))}
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
