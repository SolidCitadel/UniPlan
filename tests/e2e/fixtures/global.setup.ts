import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config({ path: path.resolve(__dirname, '../.env') });

/**
 * Playwright globalSetup: 테스트 실행 전 카탈로그 강의 데이터를 seed합니다.
 *
 * Integration 테스트의 test_course(scope="session") fixture와 동일한 패턴.
 * catalog-service에 직접 접근하여 강의 데이터를 생성합니다.
 * 이미 데이터가 존재하면 추가 생성하지 않습니다.
 */

function requireEnv(key: string): string {
  const val = process.env[key];
  if (!val) {
    throw new Error(
      `Required env var '${key}' is not set. Copy tests/e2e/.env.example to tests/e2e/.env`
    );
  }
  return val;
}

async function seedCourseData(catalogServiceUrl: string): Promise<void> {
  // 이미 classTimes가 있는 강의가 존재하면 seed 불필요
  const checkRes = await fetch(`${catalogServiceUrl}/courses?page=0&size=5`);
  if (checkRes.ok) {
    const data = await checkRes.json();
    const content: Array<{ classTimes?: unknown[] }> = data.content ?? [];
    const exists = content.some((c) => c.classTimes && c.classTimes.length > 0);
    if (exists) {
      console.log('[global-setup] 강의 데이터 확인됨 — seed 생략');
      return;
    }
  }

  console.log('[global-setup] 강의 데이터 없음 — seed 시작');

  const uid = Date.now().toString(36).slice(-4); // 짧은 고유 ID

  // 1. 메타데이터 import (단과대학, 학과, 과목유형)
  const metadataRes = await fetch(`${catalogServiceUrl}/metadata/import`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      year: 2026,
      semester: 1,
      crawled_at: '2026-01-17T00:00:00',
      colleges: {
        [`TC${uid}`]: { code: `TC${uid}`, name: `테스트단과대학_${uid}`, nameEn: `Test College ${uid}` },
      },
      departments: {
        [`TD${uid}`]: {
          code: `TD${uid}`,
          name: `테스트학과_${uid}`,
          nameEn: `Test Department ${uid}`,
          collegeCode: `TC${uid}`,
          level: '학부',
        },
      },
      courseTypes: {
        [`TT${uid}`]: { code: `TT${uid}`, nameKr: `테스트과목유형_${uid}`, nameEn: `Test Course Type ${uid}` },
      },
    }),
  });
  if (!metadataRes.ok) {
    throw new Error(`[global-setup] 메타데이터 import 실패: ${metadataRes.status} ${await metadataRes.text()}`);
  }

  // 2. 강의 import (classTimes 포함)
  const courseRes = await fetch(`${catalogServiceUrl}/courses/import`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify([
      {
        openingYear: 2026,
        semester: '1학기',
        targetGrade: 1,
        courseCode: `E2E${uid}`,
        section: '01',
        courseName: `E2E테스트과목_${uid}`,
        professor: '테스트교수',
        credits: 3,
        classroom: '테스트관 101',
        campus: '서울',
        departmentCodes: [`TD${uid}`],
        courseTypeCode: `TT${uid}`,
        notes: 'E2E 테스트용 과목',
        classTime: [
          { day: '월', startTime: '09:00', endTime: '10:30' },
          { day: '수', startTime: '09:00', endTime: '10:30' },
        ],
        universityId: 1,
      },
    ]),
  });
  if (!courseRes.ok) {
    throw new Error(`[global-setup] 강의 import 실패: ${courseRes.status} ${await courseRes.text()}`);
  }

  console.log(`[global-setup] 강의 seed 완료 (courseCode: E2E${uid})`);
}

export default async function globalSetup(): Promise<void> {
  const catalogServiceUrl = requireEnv('CATALOG_SERVICE_URL');
  await seedCourseData(catalogServiceUrl);
}
