'use client';

import { useEffect } from 'react';
import { useRouter, usePathname } from 'next/navigation';
import Link from 'next/link';
import { useAuth } from '@/providers/auth-provider';
import { useSemester } from '@/providers/semester-provider';
import { Button } from '@/components/ui/button';
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from '@/components/ui/select';
import { Avatar, AvatarFallback } from '@/components/ui/avatar';

const navItems = [
  { href: '/courses', label: '강의 검색' },
  { href: '/wishlist', label: '위시리스트' },
  { href: '/timetables', label: '시간표' },
  { href: '/scenarios', label: '시나리오' },
  { href: '/registrations', label: '수강신청' },
];

// 학기 선택 옵션 생성 (현재 연도 기준 ±1년)
function getSemesterOptions() {
  const now = new Date();
  const currentYear = now.getFullYear();
  const options: { year: number; semester: string; label: string }[] = [];

  for (let year = currentYear + 1; year >= currentYear - 1; year--) {
    options.push({ year, semester: '2', label: `${year}년 2학기` });
    options.push({ year, semester: '1', label: `${year}년 1학기` });
  }

  return options;
}

export default function AuthenticatedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { user, isLoading, logout } = useAuth();
  const { semester, setSemester } = useSemester();
  const router = useRouter();
  const pathname = usePathname();
  const semesterOptions = getSemesterOptions();

  useEffect(() => {
    if (!isLoading && !user) {
      router.push('/login');
    }
  }, [user, isLoading, router]);

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-lg">로딩 중...</div>
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <header className="border-b bg-white sticky top-0 z-50">
        <div className="container mx-auto px-4 h-14 flex items-center justify-between">
          <div className="flex items-center gap-8">
            <Link href="/courses" className="text-xl font-bold">
              UniPlan
            </Link>
            <nav className="hidden md:flex items-center gap-1">
              {navItems.map((item) => (
                <Link key={item.href} href={item.href}>
                  <Button
                    variant={pathname === item.href ? 'secondary' : 'ghost'}
                    size="sm"
                  >
                    {item.label}
                  </Button>
                </Link>
              ))}
            </nav>
          </div>

          <div className="flex items-center gap-3">
            {/* 학기 선택 */}
            <Select
              value={`${semester.openingYear}-${semester.semester}`}
              onValueChange={(value) => {
                const [year, sem] = value.split('-');
                setSemester({ openingYear: Number(year), semester: sem });
              }}
            >
              <SelectTrigger className="w-[130px] h-8">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                {semesterOptions.map((opt) => (
                  <SelectItem
                    key={`${opt.year}-${opt.semester}`}
                    value={`${opt.year}-${opt.semester}`}
                  >
                    {opt.label}
                  </SelectItem>
                ))}
              </SelectContent>
            </Select>

            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" className="relative h-8 w-8 rounded-full">
                  <Avatar className="h-8 w-8">
                    <AvatarFallback>
                      {user.name?.charAt(0).toUpperCase() || 'U'}
                    </AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <div className="px-2 py-1.5 text-sm">
                  <p className="font-medium">{user.name}</p>
                  <p className="text-muted-foreground">{user.email}</p>
                  <p className="text-xs text-muted-foreground">{user.universityName}</p>
                </div>
                <DropdownMenuItem onClick={logout}>
                  로그아웃
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>

        {/* Mobile Navigation */}
        <nav className="md:hidden border-t overflow-x-auto">
          <div className="flex px-4 py-2 gap-1">
            {navItems.map((item) => (
              <Link key={item.href} href={item.href}>
                <Button
                  variant={pathname === item.href ? 'secondary' : 'ghost'}
                  size="sm"
                  className="whitespace-nowrap"
                >
                  {item.label}
                </Button>
              </Link>
            ))}
          </div>
        </nav>
      </header>

      {/* Main Content */}
      <main className="flex-1 container mx-auto px-4 py-6">
        {children}
      </main>
    </div>
  );
}
