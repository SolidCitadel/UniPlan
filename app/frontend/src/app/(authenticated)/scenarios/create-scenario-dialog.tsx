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
import { timetableApi, scenarioApi } from '@/lib/api';
import { useQuery } from '@tanstack/react-query';
import { toast } from 'sonner';

import { useSemester } from '@/providers/semester-provider';

interface CreateScenarioDialogProps {
    open: boolean;
    onOpenChange: (open: boolean) => void;
}

export function CreateScenarioDialog({
    open,
    onOpenChange,
}: CreateScenarioDialogProps) {
    const { semester: currentSemester } = useSemester();
    const queryClient = useQueryClient();
    const [name, setName] = useState('');
    const [timetableId, setTimetableId] = useState<string>('');
    const [isSubmitting, setIsSubmitting] = useState(false);

    const { data: allTimetables = [] } = useQuery({
        queryKey: ['timetables'],
        queryFn: timetableApi.getAll,
    });

    const timetables = allTimetables.filter(
        (tt) =>
            tt.openingYear === currentSemester.openingYear &&
            tt.semester === currentSemester.semester
    );

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!name || !timetableId) return;

        try {
            setIsSubmitting(true);
            await scenarioApi.create({
                name,
                existingTimetableId: parseInt(timetableId),
            });
            toast.success('시나리오가 생성되었습니다.');
            queryClient.invalidateQueries({ queryKey: ['scenarios'] });
            onOpenChange(false);
            setName('');
            setTimetableId('');
        } catch (error) {
            toast.error('시나리오 생성에 실패했습니다.');
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>시나리오 생성</DialogTitle>
                    <DialogDescription>
                        새로운 시나리오를 만들고 수강신청 계획을 세워보세요.
                    </DialogDescription>
                </DialogHeader>
                <form onSubmit={handleSubmit} className="space-y-4">
                    <div className="space-y-2">
                        <label htmlFor="name" className="text-sm font-medium">
                            시나리오 이름
                        </label>
                        <Input
                            id="name"
                            placeholder="예: 1학기 수강신청 전략"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                            required
                        />
                    </div>
                    <div className="space-y-2">
                        <label htmlFor="timetable" className="text-sm font-medium">
                            기준 시간표
                        </label>
                        <Select value={timetableId} onValueChange={setTimetableId} required>
                            <SelectTrigger>
                                <SelectValue placeholder="시간표 선택" />
                            </SelectTrigger>
                            <SelectContent>
                                {timetables.map((timetable) => (
                                    <SelectItem key={timetable.id} value={timetable.id.toString()}>
                                        {timetable.name}
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
                        <Button type="submit" disabled={isSubmitting || !name || !timetableId}>
                            {isSubmitting ? '생성 중...' : '생성'}
                        </Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    );
}
