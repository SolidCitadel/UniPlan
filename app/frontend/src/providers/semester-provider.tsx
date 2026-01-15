'use client';

import { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import type { SemesterContext } from '@/types';

const STORAGE_KEY = 'uniplan_semester_context';

// 현재 날짜 기준으로 기본 학기 계산
function getDefaultSemester(): SemesterContext {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1; // 0-indexed

  // 3월~8월: 1학기, 9월~2월: 2학기
  const semester = month >= 3 && month <= 8 ? '1' : '2';
  const openingYear = month >= 1 && month <= 2 ? year - 1 : year;

  return { openingYear, semester };
}

interface SemesterContextValue {
  semester: SemesterContext;
  setSemester: (semester: SemesterContext) => void;
}

const SemesterContextInstance = createContext<SemesterContextValue | null>(null);

export function SemesterProvider({ children }: { children: ReactNode }) {
  const [semester, setSemesterState] = useState<SemesterContext>(getDefaultSemester);
  const [isInitialized, setIsInitialized] = useState(false);

  // Load from localStorage on mount
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const stored = localStorage.getItem(STORAGE_KEY);
      if (stored) {
        try {
          const parsed = JSON.parse(stored) as SemesterContext;
          setSemesterState(parsed);
        } catch {
          // Invalid stored data, use default
        }
      }
      setIsInitialized(true);
    }
  }, []);

  // Save to localStorage when semester changes
  const setSemester = (newSemester: SemesterContext) => {
    setSemesterState(newSemester);
    if (typeof window !== 'undefined') {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(newSemester));
    }
  };

  // Prevent hydration mismatch by not rendering until initialized
  if (!isInitialized) {
    return null;
  }

  return (
    <SemesterContextInstance.Provider value={{ semester, setSemester }}>
      {children}
    </SemesterContextInstance.Provider>
  );
}

export function useSemester() {
  const context = useContext(SemesterContextInstance);
  if (!context) {
    throw new Error('useSemester must be used within a SemesterProvider');
  }
  return context;
}
