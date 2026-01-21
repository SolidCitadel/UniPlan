'use client';

import { useState } from 'react';
import { useQueryClient } from '@tanstack/react-query';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { scenarioApi, registrationApi } from '@/lib/api';
import { useQuery } from '@tanstack/react-query';
import { toast } from 'sonner';

import { useSemester } from '@/providers/semester-provider';

interface StartRegistrationDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
}

export function StartRegistrationDialog({
    open,
    onOpenChange,
}: StartRegistrationDialogProps) {
    const { semester: currentSemester } = useSemester();
    const queryClient = useQueryClient();
    const [name, setName] = useState('');
    const [scenarioId, setScenarioId] = useState<string>('');
    const [isSubmitting, setIsSubmitting] = useState(false);

    // 시나리오 목록 조회 (루트 시나리오만 선택 가능하게 할지, 전체 가능하게 할지 고민되지만 API는 전체 목록을 줄 것임)
    // 기획상 루트 시나리오로 시작하는게 맞겠지만, API가 getAll을 쓰므로 전체가 나옴. 일단 그대로 사용.
    const { data: allScenarios = [] } = useQuery({
        queryKey: ['scenarios'],
        queryFn: scenarioApi.getAll,
    });

    const scenarios = allScenarios.filter(
        (s) =>
            s.timetable.openingYear === currentSemester.openingYear &&
            s.timetable.semester === currentSemester.semester
    );

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!scenarioId) return;

        try {
            setIsSubmitting(true);
            await registrationApi.create({
                name: name || undefined, // 이름은 선택사항일 수 있음
                scenarioId: parseInt(scenarioId),
            });
            toast.success('수강신청 세션이 시작되었습니다.');
            queryClient.invalidateQueries({ queryKey: ['registrations'] });
            onOpenChange(false);
            setName('');
            setScenarioId('');
        } catch (error) {
            toast.error('수강신청 세션 시작에 실패했습니다.');
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>수강신청 시작</DialogTitle>
                    <DialogDescription>
                        시나리오를 선택하여 수강신청 시뮬레이션을 시작합니다.
                    </DialogDescription>
                </DialogHeader>
                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <label htmlFor="name" className="text-sm font-medium">
                            세션 이름 (선택)
                        </label>
                        <Input
                            id="name"
                            placeholder="예: 2025-1 실전 연습"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                        />
                    </div>
                    <div className="space-y-2">
                        <label htmlFor="scenario" className="text-sm font-medium">
                            시나리오 선택
                        </label>
                        <Select value={scenarioId} onValueChange={setScenarioId} required>
                            <SelectTrigger>
                                <SelectValue placeholder="시나리오 선택" />
                            </SelectTrigger>
                            <SelectContent>
                                {scenarios.map((scenario) => (
                                    <SelectItem key={scenario.id} value={scenario.id.toString()}>
                                        {scenario.name}
                                    </SelectItem>
                                ))}
                            </SelectContent>
                        </Select>
                    </div>
                    <DialogFooter>
                        <Button
                            type="button"
                            variant="outline"
                            onClick={() => onOpenChange(false)}
                            disabled={isSubmitting}
                        >
                            취소
                        </Button>
                        <Button type="submit" disabled={isSubmitting || !scenarioId}>
                            {isSubmitting ? '시작 중...' : '시작'}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
