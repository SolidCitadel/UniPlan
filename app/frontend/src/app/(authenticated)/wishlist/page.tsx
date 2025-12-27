'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { wishlistApi } from '@/lib/api';
import { toast } from 'sonner';

export default function WishlistPage() {
  const queryClient = useQueryClient();

  const { data: items, isLoading } = useQuery({
    queryKey: ['wishlist'],
    queryFn: wishlistApi.getAll,
  });

  const removeMutation = useMutation({
    mutationFn: wishlistApi.remove,
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['wishlist'] });
      toast.success('삭제되었습니다');
    },
  });

  const updatePriority = useMutation({
    mutationFn: ({ id, priority }: { id: number; priority: number }) =>
      wishlistApi.updatePriority(id, priority),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['wishlist'] });
      toast.success('우선순위가 변경되었습니다');
    },
  });

  const groupedByPriority = items?.reduce(
    (acc, item) => {
      const priority = item.priority;
      if (!acc[priority]) acc[priority] = [];
      acc[priority].push(item);
      return acc;
    },
    {} as Record<number, typeof items>
  );

  if (isLoading) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">위시리스트</h1>

      {!items?.length ? (
        <div className="text-center py-8 text-muted-foreground">
          위시리스트가 비어있습니다. 강의 검색에서 과목을 추가해주세요.
        </div>
      ) : (
        [1, 2, 3, 4, 5].map((priority) => {
          const priorityItems = groupedByPriority?.[priority];
          if (!priorityItems?.length) return null;

          return (
            <div key={priority}>
              <h2 className="text-lg font-semibold mb-3">
                우선순위 {priority}
                <Badge variant="secondary" className="ml-2">
                  {priorityItems.length}
                </Badge>
              </h2>
              <div className="space-y-2">
                {priorityItems.map((item) => (
                  <Card key={item.id} className="p-4">
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium">{item.courseName}</p>
                        <p className="text-sm text-muted-foreground">
                          {item.professor} · {item.classroom || '강의실 미정'}
                        </p>
                        <p className="text-xs text-muted-foreground">
                          {item.classTimes
                            ?.map((t) => `${t.day} ${t.startTime}-${t.endTime}`)
                            .join(' / ') || '시간 미정'}
                        </p>
                      </div>
                      <div className="flex items-center gap-2">
                        <select
                          value={priority}
                          onChange={(e) =>
                            updatePriority.mutate({
                              id: item.id,
                              priority: Number(e.target.value),
                            })
                          }
                          className="border rounded px-2 py-1 text-sm"
                        >
                          {[1, 2, 3, 4, 5].map((p) => (
                            <option key={p} value={p}>
                              {p}
                            </option>
                          ))}
                        </select>
                        <Button
                          variant="destructive"
                          size="sm"
                          onClick={() => removeMutation.mutate(item.id)}
                        >
                          삭제
                        </Button>
                      </div>
                    </div>
                  </Card>
                ))}
              </div>
            </div>
          );
        })
      )}
    </div>
  );
}
