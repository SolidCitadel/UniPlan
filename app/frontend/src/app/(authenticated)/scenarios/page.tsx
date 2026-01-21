'use client';

import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Plus } from 'lucide-react';
import { scenarioApi } from '@/lib/api';
import Link from 'next/link';
import { CreateScenarioDialog } from './create-scenario-dialog';
import { useSemester } from '@/providers/semester-provider';

export default function ScenariosPage() {
  const { semester: currentSemester } = useSemester();
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false);
  const { data: allScenarios, isLoading } = useQuery({
    queryKey: ['scenarios'],
    queryFn: scenarioApi.getAll,
  });

  const scenarios = allScenarios?.filter(
    (s) =>
      s.timetable.openingYear === currentSemester.openingYear &&
      s.timetable.semester === currentSemester.semester
  );

  if (isLoading) {
    return <div className="text-center py-8">로딩 중...</div>;
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">시나리오</h1>
        <Button onClick={() => setIsCreateDialogOpen(true)}>
          <Plus className="mr-2 h-4 w-4" />
          시나리오 추가
        </Button>
      </div>

      {!scenarios?.length ? (
        <div className="text-center py-8 text-muted-foreground">
          시나리오가 없습니다. 새 시나리오를 만들어보세요.
        </div>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {scenarios.map((scenario) => (
            <Card key={scenario.id} className="p-4 hover:shadow-md transition-shadow">
              <div className="space-y-2">
                <Link
                  href={`/scenarios/${scenario.id}`}
                  className="font-semibold hover:underline text-lg block"
                >
                  {scenario.name}
                </Link>
                <div className="space-y-1 text-sm text-muted-foreground">
                  <p>{scenario.description || '설명 없음'}</p>
                  <p>기준 시간표: {scenario.timetable.name}</p>
                  {scenario.childScenarios.length > 0 && (
                    <p>하위 시나리오 {scenario.childScenarios.length}개</p>
                  )}
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}

      <CreateScenarioDialog
        open={isCreateDialogOpen}
        onOpenChange={setIsCreateDialogOpen}
      />
    </div>
  );
}
