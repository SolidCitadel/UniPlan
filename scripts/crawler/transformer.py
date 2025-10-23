#!/usr/bin/env python3
"""
Raw 데이터 → catalog-service 형식 변환

메타데이터 + Raw 강의 데이터를 결합하여 catalog-service 형식으로 변환합니다.

Usage:
    python transformer.py --metadata metadata_2025_1.json --courses courses_raw_2025_1.json
    python transformer.py --metadata metadata_2025_1.json --courses courses_raw_2025_1.json --output transformed.json
"""

import argparse
import json
import sys
import os

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from crawler.data_parser import KHUDataParser


def main():
    parser = argparse.ArgumentParser(description='Raw 데이터 변환')
    parser.add_argument('--metadata', type=str, required=True, help='메타데이터 JSON 파일 (metadata_YYYY_S.json)')
    parser.add_argument('--courses', type=str, required=True, help='Raw 강의 JSON 파일 (courses_raw_YYYY_S.json)')
    parser.add_argument('--output', type=str, help='출력 파일명 (기본: transformed_YYYY_S.json)')

    args = parser.parse_args()

    # 입력 파일 확인
    if not os.path.exists(args.metadata):
        print(f"ERROR: Metadata file not found: {args.metadata}")
        return 1

    if not os.path.exists(args.courses):
        print(f"ERROR: Courses file not found: {args.courses}")
        return 1

    # 기본 출력 파일명
    if not args.output:
        # courses_raw_2025_1.json → transformed_2025_1.json
        basename = os.path.basename(args.courses)
        if basename.startswith('courses_raw_'):
            basename = basename.replace('courses_raw_', 'transformed_', 1)
        else:
            basename = 'transformed_' + basename
        args.output = os.path.join('output', basename)

    print("=" * 60)
    print(f"Raw Data Transformer")
    print(f"Metadata: {args.metadata}")
    print(f"Courses: {args.courses}")
    print(f"Output: {args.output}")
    print("=" * 60)
    print()

    try:
        # 1. 메타데이터 로드
        print("Step 1: Loading metadata...")
        with open(args.metadata, 'r', encoding='utf-8') as f:
            metadata = json.load(f)

        colleges = metadata.get('colleges', {})
        departments = metadata.get('departments', {})
        course_types = metadata.get('courseTypes', {})
        year = metadata.get('year')
        semester = metadata.get('semester')

        print(f"Loaded metadata:")
        print(f"  - {len(colleges)} colleges")
        print(f"  - {len(departments)} departments")
        print(f"  - {len(course_types)} course types")
        print(f"  - Year: {year}, Semester: {semester}")
        print()

        # 2. Raw 강의 데이터 로드
        print("Step 2: Loading raw courses...")
        with open(args.courses, 'r', encoding='utf-8') as f:
            courses_data = json.load(f)

        raw_courses = courses_data.get('courses', [])
        print(f"Loaded {len(raw_courses)} raw courses")
        print()

        # 3. 변환
        print("Step 3: Transforming courses...")
        transformed_courses = KHUDataParser.parse_courses(
            raw_courses=raw_courses,
            year=year,
            semester=semester,
            metadata={
                'colleges': colleges,
                'departments': departments,
                'courseTypes': course_types
            }
        )

        print(f"Transformed {len(transformed_courses)} courses")
        print()

        # 4. 저장
        print(f"Step 4: Saving to {args.output}...")
        os.makedirs(os.path.dirname(args.output) or '.', exist_ok=True)

        with open(args.output, 'w', encoding='utf-8') as f:
            json.dump(transformed_courses, f, ensure_ascii=False, indent=2)

        print()
        print("=" * 60)
        print("SUCCESS!")
        print(f"Saved {len(transformed_courses)} transformed courses")
        print()
        print("Next step:")
        print(f"  Upload to catalog-service:")
        print(f"  curl -X POST http://localhost:8080/api/courses/import \\")
        print(f"    -H 'Content-Type: application/json' \\")
        print(f"    -d @{args.output}")
        print()
        print("Tip: 변환 결과가 만족스럽지 않으면")
        print("     data_parser.py 수정 후 이 명령만 다시 실행하세요!")
        print("=" * 60)

        return 0

    except Exception as e:
        print(f"\nERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
