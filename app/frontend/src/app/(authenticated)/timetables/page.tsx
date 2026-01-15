'use client';

import { useState } from 'react';
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
import { timetableApi } from '@/lib/api';
import { toast } from 'sonner';
import { getErrorMessage } from '@/lib/error';
import Link from 'next/link';

export default function TimetablesPage() {
  const queryClient = useQueryClient();
  const [showCreate, setShowCreate] = useState(false);
  const [newName, setNewName] = useState('');

  const { data: timetables, isLoading } = useQuery({
    queryKey: ['timetables'],
    queryFn: timetableApi.getAll,
  });

  const createMutation = useMutation({
    mutationFn: timetableApi.create,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['timetables'] });
      toast.success('시간표가 생성되었습니다');
      setShowCreate(false);
      setNewName('');
    },
    onError: (error) => {
      toast.error(getErrorMessage(error, '시간표 생성 실패'));
    },
  });

  const deleteMutation = useMutation({
    mutationFn: timetableApi.delete,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['timetables'] });
      toast.success('시간표가 삭제되었습니다');
    },
    onError: (error) => {
      toast.error(getErrorMessage(error, '시간표 삭제 실패'));
    },
  });

  const handleCreate = (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;
    createMutation.mutate({
      name: newName,
      openingYear: new Date().getFullYear(),
      semester: '1',
    });
  };

  if (isLoading) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">시간표</h1>
        <Button onClick={() => setShowCreate(true)}>+ 새 시간표</Button>
      </div>

      {!timetables?.length ? (
        <div className="text-center py-8 text-muted-foreground">
          시간표가 없습니다. 새 시간표를 만들어보세요.
        </div>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {timetables.map((tt) => (
            <Card key={tt.id} className="p-4">
              <div className="flex items-start justify-between">
                <div>
                  <Link
                    href={`/timetables/${tt.id}`}
                    className="font-semibold hover:underline"
                  >
                    {tt.name}
                  </Link>
                  <p className="text-sm text-muted-foreground">
                    {tt.openingYear}년 {tt.semester}학기
                  </p>
                  <p className="text-sm text-muted-foreground">
                    {tt.items.length}개 과목
                  </p>
                </div>
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => deleteMutation.mutate(tt.id)}
                >
                  삭제
                </Button>
              </div>
            </Card>
          ))}
        </div>
      )}

      <Dialog open={showCreate} onOpenChange={setShowCreate}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>새 시간표 만들기</DialogTitle>
          </DialogHeader>
          <form onSubmit={handleCreate} className="space-y-4">
            <Input
              placeholder="시간표 이름"
              value={newName}
              onChange={(e) => setNewName(e.target.value)}
            />
            <Button type="submit" className="w-full">
              생성
            </Button>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  );
}
