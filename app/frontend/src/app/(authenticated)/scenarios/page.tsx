'use client';

import { useQuery } from '@tanstack/react-query';
import { Card } from '@/components/ui/card';
import { scenarioApi } from '@/lib/api';
import Link from 'next/link';

export default function ScenariosPage() {
  const { data: scenarios, isLoading } = useQuery({
    queryKey: ['scenarios'],
    queryFn: scenarioApi.getAll,
  });

  if (isLoading) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">시나리오</h1>

      {!scenarios?.length ? (
        <div className="text-center py-8 text-muted-foreground">
          시나리오가 없습니다. 시간표에서 시나리오를 만들어보세요.
        </div>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {scenarios.map((scenario) => (
            <Card key={scenario.id} className="p-4">
              <Link
                href={`/scenarios/${scenario.id}`}
                className="font-semibold hover:underline"
              >
                {scenario.name}
              </Link>
              <p className="text-sm text-muted-foreground">
                {scenario.description || '설명 없음'}
              </p>
              <p className="text-sm text-muted-foreground">
                기준 시간표: {scenario.timetable.name}
              </p>
              {scenario.childScenarios.length > 0 && (
                <p className="text-xs text-muted-foreground">
                  하위 시나리오 {scenario.childScenarios.length}개
                </p>
              )}
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
