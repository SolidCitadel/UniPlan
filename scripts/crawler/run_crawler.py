#!/usr/bin/env python3
"""
경희대 강의 크롤러 - Raw 데이터 저장

Raw API 응답을 그대로 저장합니다.
변환이 필요하면 transformer.py를 사용하세요.

전제조건: metadata 파일이 먼저 생성되어야 합니다.
  python crawl_metadata.py --year 2025 --semester 1

Usage:
    python run_crawler.py --year 2025 --semester 1
    python run_crawler.py --year 2025 --semester 1 --limit 5
    python run_crawler.py --year 2025 --semester 1 --departments A10451,A00430
"""

import argparse
import json
import sys
import os
import datetime

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from crawler.khu_crawler import KHUCrawler


def main():
    parser = argparse.ArgumentParser(description='경희대 강의 크롤러 (Raw)')
    parser.add_argument('--year', type=int, required=True, help='년도 (예: 2025)')
    parser.add_argument('--semester', type=int, required=True, choices=[1, 2], help='학기 (1 또는 2)')
    parser.add_argument('--output', type=str, help='출력 파일명 (기본: courses_raw_YYYY_S.json)')
    parser.add_argument('--metadata', type=str, help='메타데이터 파일 (기본: metadata_YYYY_S.json)')
    parser.add_argument('--limit', type=int, help='학과 수 제한 (테스트용)')
    parser.add_argument('--departments', type=str, help='특정 학과만 크롤링 (쉼표 구분, 예: A10451,A00430)')

    args = parser.parse_args()

    # 기본 출력 파일명
    if not args.output:
        args.output = f"output/courses_raw_{args.year}_{args.semester}.json"

    # 기본 메타데이터 파일명
    if not args.metadata:
        args.metadata = f"output/metadata_{args.year}_{args.semester}.json"

    # output 디렉토리 생성
    os.makedirs('output', exist_ok=True)

    print("=" * 60)
    print(f"KHU Course Crawler")
    print(f"Year: {args.year}, Semester: {args.semester}")
    print("=" * 60)
    print()

    crawler = KHUCrawler()

    try:
        # 1. 메타데이터에서 학과 목록 가져오기
        print("Step 1: Loading department list from metadata...")
        if not os.path.exists(args.metadata):
            print(f"ERROR: Metadata file not found: {args.metadata}")
            print()
            print("Please run metadata crawler first:")
            print(f"  python crawl_metadata.py --year {args.year} --semester {args.semester}")
            return 1

        with open(args.metadata, 'r', encoding='utf-8') as f:
            metadata = json.load(f)

        all_departments = metadata.get('departments', {})

        # {code: name} 형식으로 변환 (간단한 매핑용)
        departments = {code: dept['name'] for code, dept in all_departments.items()}

        if not departments:
            print("ERROR: No departments found in metadata!")
            return 1

        print(f"Loaded {len(departments)} departments from metadata")
        print()

        # 특정 학과만 선택
        if args.departments:
            selected_codes = [c.strip() for c in args.departments.split(',')]
            departments = {code: departments[code] for code in selected_codes if code in departments}
            print(f"Selected {len(departments)} departments: {list(departments.keys())}")
            print()

        # 테스트용 제한
        if args.limit:
            dept_items = list(departments.items())[:args.limit]
            departments = dict(dept_items)
            print(f"(Limited to {len(departments)} departments for testing)")
            print()

        # 2. 학과별로 강의 가져오기 (학과 코드별로 그룹화)
        print("Step 2: Fetching courses from all departments...")
        print()

        departments_data = {}
        total_courses = 0
        success_count = 0
        fail_count = 0

        for idx, (dept_code, dept_name) in enumerate(departments.items(), 1):
            print(f"[{idx}/{len(departments)}] {dept_code} - {dept_name}")

            try:
                data = crawler.fetch_courses(args.year, args.semester, major_code=dept_code)

                if data and 'rows' in data:
                    courses = data['rows']
                    course_count = len(courses)
                    total_courses += course_count
                    success_count += 1

                    # 학과 코드별로 데이터 저장
                    departments_data[dept_code] = {
                        "name": dept_name,
                        "course_count": course_count,
                        "courses": courses
                    }

                    print(f"   -> {course_count} courses")
                else:
                    fail_count += 1
                    print(f"   -> No data")

            except Exception as e:
                fail_count += 1
                print(f"   -> Error: {str(e)}")

            # Rate limiting (서버 부하 방지)
            if idx < len(departments):
                import time
                time.sleep(0.5)

            print()

        if not departments_data:
            print("ERROR: No courses found!")
            return 1

        print(f"Total raw courses: {total_courses}")
        print()

        # 3. Raw 데이터 저장 (학과별로 그룹화)
        output_data = {
            "year": args.year,
            "semester": args.semester,
            "crawled_at": datetime.datetime.now().isoformat(),
            "total_courses": total_courses,
            "total_departments": len(departments_data),
            "departments": departments_data  # 학과 코드별로 그룹화된 데이터
        }

        print(f"Step 3: Saving raw courses to {args.output}...")
        with open(args.output, 'w', encoding='utf-8') as f:
            json.dump(output_data, f, ensure_ascii=False, indent=2)

        print()
        print("=" * 60)
        print("SUCCESS!")
        print(f"Crawling Statistics:")
        print(f"  - Success: {success_count} departments")
        print(f"  - Failed: {fail_count} departments")
        print(f"  - Total courses: {total_courses}")
        print(f"  - Saved to: {args.output}")
        print()
        print("Next step:")
        print(f"  python transformer.py \\")
        print(f"    --metadata {args.metadata} \\")
        print(f"    --courses {args.output}")
        print()
        print("Tip: 크롤링은 1회만, 변환은 만족할 때까지 반복 가능!")
        print("=" * 60)

        return 0

    except KeyboardInterrupt:
        print("\n\nInterrupted by user")
        return 1
    except Exception as e:
        print(f"\nERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return 1
    finally:
        crawler.close()


if __name__ == "__main__":
    sys.exit(main())
