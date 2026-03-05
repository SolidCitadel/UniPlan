import type { Page } from '@playwright/test';
import * as fs from 'fs';
import * as path from 'path';
import { API_BASE_URL, AUTH_FILE, BASE_URL } from '../fixtures/constants';

/**
 * 현재 날짜 기준으로 학기를 계산합니다 (semester-provider.tsx와 동일한 로직).
 * 3월~8월: '1' (1학기), 9월~2월: '2' (2학기)
 */
function getCurrentSemester(): { openingYear: number; semester: string } {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth() + 1;
  const semester = month >= 3 && month <= 8 ? '1' : '2';
  const openingYear = month >= 1 && month <= 2 ? year - 1 : year;
  return { openingYear, semester };
}

/**
 * API 직접 호출로 테스트 데이터를 생성/삭제하는 헬퍼.
 * UI 조작 없이 빠른 before/afterEach 설정을 위해 사용.
 *
 * 인증: storageState(.auth/user.json)의 localStorage에서 accessToken을 지연 추출.
 */
export class ApiHelper {
  private token: string | null = null;

  constructor(private readonly page: Page) {}

  private async getToken(): Promise<string> {
    if (!this.token) {
      // about:blank에서는 localStorage 접근이 SecurityError를 유발하므로
      // storageState 파일에서 직접 토큰을 읽는 폴백을 사용합니다.
      const url = this.page.url();
      if (url && url !== 'about:blank') {
        const raw = await this.page.evaluate(() => localStorage.getItem('accessToken')).catch(() => null);
        if (raw) {
          this.token = raw;
          return this.token;
        }
      }
      // 폴백: .auth/user.json(storageState)에서 직접 읽기
      const authFile = path.join(__dirname, '..', AUTH_FILE);
      const storageState = JSON.parse(fs.readFileSync(authFile, 'utf-8'));
      const origin = storageState.origins?.find((o: { origin: string }) => o.origin === BASE_URL);
      const entry = origin?.localStorage?.find((e: { name: string }) => e.name === 'accessToken');
      if (!entry?.value) {
        throw new Error(
          'accessToken not found in localStorage or storageState. auth.setup.ts가 정상 완료되지 않았습니다.'
        );
      }
      this.token = entry.value;
    }
    return this.token;
  }

  private async authHeaders(): Promise<Record<string, string>> {
    return {
      Authorization: `Bearer ${await this.getToken()}`,
      'Content-Type': 'application/json',
    };
  }

  // ─── 강의 (읽기 전용) ───────────────────────────────────────────────────────

  /**
   * classTimes가 있는 첫 번째 강의 ID를 반환합니다.
   * 카탈로그에 강의 데이터가 없으면 즉시 실패합니다 (skip 금지).
   */
  async getFirstCourseWithClassTimes(): Promise<{ id: number; courseName: string }> {
    const headers = await this.authHeaders();
    const res = await fetch(`${API_BASE_URL}/api/v1/courses?page=0&size=20`, { headers });
    if (!res.ok) throw new Error(`강의 목록 조회 실패: ${res.status}`);
    const data = await res.json();
    if (!data.content?.length) {
      throw new Error('카탈로그에 강의 데이터가 없습니다. 테스트 환경의 강의 데이터를 확인하세요.');
    }
    const course = data.content.find((c: { classTimes?: unknown[] }) => c.classTimes && (c.classTimes as unknown[]).length > 0);
    if (!course) {
      throw new Error('classTimes가 있는 강의가 없습니다. 테스트 환경의 강의 데이터를 확인하세요.');
    }
    return { id: course.id, courseName: course.courseName };
  }

  // ─── 위시리스트 ─────────────────────────────────────────────────────────────

  async addToWishlist(courseId: number, priority: number): Promise<{ id: number }> {
    const headers = await this.authHeaders();
    const res = await fetch(`${API_BASE_URL}/api/v1/wishlist`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ courseId, priority }),
    });
    if (!res.ok) throw new Error(`위시리스트 추가 실패: ${res.status}`);
    return res.json();
  }

  async clearWishlist(): Promise<void> {
    const headers = await this.authHeaders();
    const listRes = await fetch(`${API_BASE_URL}/api/v1/wishlist`, { headers });
    if (!listRes.ok) return;
    const items: Array<{ id: number }> = await listRes.json();
    await Promise.all(
      items.map((item) =>
        fetch(`${API_BASE_URL}/api/v1/wishlist/${item.id}`, { method: 'DELETE', headers })
      )
    );
  }

  // ─── 시간표 ─────────────────────────────────────────────────────────────────

  async createTimetable(name: string): Promise<{ id: number; name: string }> {
    const headers = await this.authHeaders();
    const { openingYear, semester } = getCurrentSemester();
    const res = await fetch(`${API_BASE_URL}/api/v1/timetables`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ name, openingYear, semester }),
    });
    if (!res.ok) throw new Error(`시간표 생성 실패: ${res.status}`);
    return res.json();
  }

  async deleteTimetable(id: number): Promise<void> {
    const headers = await this.authHeaders();
    await fetch(`${API_BASE_URL}/api/v1/timetables/${id}`, {
      method: 'DELETE',
      headers,
    });
  }

  /**
   * 시간표에 강의를 추가합니다.
   * @returns 추가된 TimetableItem (courseName 포함)
   */
  async addCourseToTimetable(
    timetableId: number,
    courseId: number
  ): Promise<{ id: number; courseName: string }> {
    const headers = await this.authHeaders();
    const res = await fetch(`${API_BASE_URL}/api/v1/timetables/${timetableId}/courses`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ courseId }),
    });
    if (!res.ok) throw new Error(`시간표 강의 추가 실패: ${res.status}`);
    return res.json();
  }

  // ─── 시나리오 ───────────────────────────────────────────────────────────────

  async createScenario(
    name: string,
    existingTimetableId: number
  ): Promise<{ id: number; name: string }> {
    const headers = await this.authHeaders();
    const res = await fetch(`${API_BASE_URL}/api/v1/scenarios`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ name, existingTimetableId }),
    });
    if (!res.ok) throw new Error(`시나리오 생성 실패: ${res.status}`);
    return res.json();
  }

  async deleteScenario(id: number): Promise<void> {
    const headers = await this.authHeaders();
    await fetch(`${API_BASE_URL}/api/v1/scenarios/${id}`, {
      method: 'DELETE',
      headers,
    });
  }

  // ─── 수강신청 ───────────────────────────────────────────────────────────────

  async createRegistration(
    scenarioId: number,
    name?: string
  ): Promise<{ id: number; name: string }> {
    const headers = await this.authHeaders();
    const res = await fetch(`${API_BASE_URL}/api/v1/registrations`, {
      method: 'POST',
      headers,
      body: JSON.stringify({ scenarioId, name }),
    });
    if (!res.ok) throw new Error(`수강신청 생성 실패: ${res.status}`);
    return res.json();
  }

  async deleteRegistration(id: number): Promise<void> {
    const headers = await this.authHeaders();
    await fetch(`${API_BASE_URL}/api/v1/registrations/${id}`, {
      method: 'DELETE',
      headers,
    });
  }
}
