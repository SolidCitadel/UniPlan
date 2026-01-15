'use client';

import { useQuery } from '@tanstack/react-query';
import { Card } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { registrationApi } from '@/lib/api';
import Link from 'next/link';

const statusLabels: Record<string, string> = {
  IN_PROGRESS: '진행 중',
  COMPLETED: '완료',
  CANCELLED: '취소됨',
};

const statusColors: Record<string, 'default' | 'secondary' | 'destructive'> = {
  IN_PROGRESS: 'default',
  COMPLETED: 'secondary',
  CANCELLED: 'destructive',
};

export default function RegistrationsPage() {
  const { data: registrations, isLoading } = useQuery({
    queryKey: ['registrations'],
    queryFn: registrationApi.getAll,
  });

  if (isLoading) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">수강신청</h1>

      {!registrations?.length ? (
        <div className="text-center py-8 text-muted-foreground">
          수강신청 세션이 없습니다. 시나리오에서 수강신청을 시작해보세요.
        </div>
      ) : (
        <div className="space-y-4">
          {registrations.map((reg) => (
            <Card key={reg.id} className="p-4">
              <div className="flex items-center justify-between">
                <div>
                  <Link
                    href={`/registrations/${reg.id}`}
                    className="font-semibold hover:underline"
                  >
                    {reg.name || `수강신청 #${reg.id}`}
                  </Link>
                  <p className="text-sm text-muted-foreground">
                    시작 시나리오: {reg.startScenario.name}
                  </p>
                  <p className="text-sm text-muted-foreground">
                    현재 시나리오: {reg.currentScenario.name}
                  </p>
                </div>
                <div className="text-right">
                  <Badge variant={statusColors[reg.status]}>
                    {statusLabels[reg.status]}
                  </Badge>
                  <div className="mt-2 text-sm">
                    <span className="text-green-600">
                      성공 {reg.succeededCourses.length}
                    </span>
                    {' / '}
                    <span className="text-red-600">
                      실패 {reg.failedCourses.length}
                    </span>
                  </div>
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
