#!/usr/bin/env python3
"""
경희대 메타데이터 크롤러

data_YYYY.js에서 메타데이터 추출:
- colleges (daehak_YYYYSS)
- departments (major_YYYYSS)
- courseTypes (gradIsuCd_YYYY)

Usage:
    python crawl_metadata.py --year 2025 --semester 1
    python crawl_metadata.py --year 2025 --semester 1 --output metadata_2025_1.json
"""

import argparse
import json
import sys
import os
import re
import datetime

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from config.khu_config import get_semester_code_full, DATA_JS_URL
import requests


def fetch_data_js(year: int):
    """data_YYYY.js 파일 다운로드"""
    url = DATA_JS_URL.format(year=year)
    print(f"Fetching metadata from: {url}")

    response = requests.get(url, timeout=30)
    response.raise_for_status()

    print(f"Successfully fetched data.js ({len(response.text)} bytes)")
    return response.text


def parse_var(js_content: str, var_name: str):
    """
    JavaScript 변수 파싱

    var varName = { "rows": [...] }
    형식의 데이터를 파싱
    """
    # var varName = 부터 다음 var 또는 파일 끝까지 추출
    pattern = rf'var\s+{re.escape(var_name)}\s*=\s*(\{{[^}}]*"rows"\s*:\s*\[.*?\]\s*\}})'
    match = re.search(pattern, js_content, re.DOTALL)

    if not match:
        return {"rows": []}

    json_str = match.group(1)

    # JavaScript 객체를 JSON으로 변환 (작은따옴표 → 큰따옴표 등)
    # 이미 올바른 JSON 형식이므로 직접 파싱
    try:
        data = json.loads(json_str)
        return data
    except json.JSONDecodeError as e:
        print(f"Warning: Failed to parse {var_name}: {e}")
        return {"rows": []}


def extract_colleges(js_content: str, year: int, semester: int):
    """대학(College) 목록 추출"""
    semester_code = get_semester_code_full(year, semester)
    var_name = f"daehak_{semester_code}"

    print(f"Parsing colleges from {var_name}...")
    data = parse_var(js_content, var_name)

    colleges = {}
    for row in data.get("rows", []):
        code = row.get("cd")
        name = row.get("nm")
        if code and name:
            colleges[code] = {
                "name": name,
                "nameEn": row.get("enm", ""),
                "code": code
            }

    print(f"   Found {len(colleges)} colleges")
    return colleges


def extract_departments(js_content: str, year: int, semester: int):
    """학과/학부(Department/Major) 목록 추출"""
    semester_code = get_semester_code_full(year, semester)
    var_name = f"major_{semester_code}"

    print(f"Parsing departments from {var_name}...")
    data = parse_var(js_content, var_name)

    departments = {}
    for row in data.get("rows", []):
        code = row.get("cd")
        name = row.get("nm")
        if code and name:
            departments[code] = {
                "name": name,
                "nameEn": row.get("enm", ""),
                "code": code,
                "collegeCode": row.get("dh", ""),  # 소속 대학 코드
                "level": row.get("orgnz_lvl_se_code", "")  # 11: 대학, 20: 학부, 30: 학과
            }

    print(f"   Found {len(departments)} departments")
    return departments


def extract_course_types(js_content: str, year: int):
    """이수구분 코드 추출"""
    var_name = f"gradIsuCd_{year}"

    print(f"Parsing course types from {var_name}...")
    data = parse_var(js_content, var_name)

    course_types = {}
    for row in data.get("rows", []):
        code = row.get("cd")
        name_kr = row.get("nmk")
        if code and name_kr:
            course_types[code] = {
                "nameKr": name_kr,
                "nameEn": row.get("nme", ""),
                "code": code
            }

    print(f"   Found {len(course_types)} course types")
    return course_types


def main():
    parser = argparse.ArgumentParser(description='경희대 메타데이터 크롤러')
    parser.add_argument('--year', type=int, required=True, help='년도 (예: 2025)')
    parser.add_argument('--semester', type=int, required=True, choices=[1, 2], help='학기 (1 또는 2)')
    parser.add_argument('--output', type=str, help='출력 파일명 (기본: metadata_YYYY_S.json)')

    args = parser.parse_args()

    # 기본 출력 파일명
    if not args.output:
        args.output = f"output/metadata_{args.year}_{args.semester}.json"

    # output 디렉토리 생성
    os.makedirs('output', exist_ok=True)

    print("=" * 60)
    print(f"KHU Metadata Crawler")
    print(f"Year: {args.year}, Semester: {args.semester}")
    print("=" * 60)
    print()

    try:
        # 1. data.js 다운로드
        print("Step 1: Fetching data.js...")
        js_content = fetch_data_js(args.year)
        print()

        # 2. 메타데이터 추출
        print("Step 2: Parsing metadata...")
        colleges = extract_colleges(js_content, args.year, args.semester)
        departments = extract_departments(js_content, args.year, args.semester)
        course_types = extract_course_types(js_content, args.year)
        print()

        # 3. JSON으로 저장
        metadata = {
            "year": args.year,
            "semester": args.semester,
            "crawled_at": datetime.datetime.now().isoformat(),
            "colleges": colleges,
            "departments": departments,
            "courseTypes": course_types
        }

        print(f"Step 3: Saving to {args.output}...")
        with open(args.output, 'w', encoding='utf-8') as f:
            json.dump(metadata, f, ensure_ascii=False, indent=2)

        print()
        print("=" * 60)
        print("SUCCESS!")
        print(f"Saved metadata:")
        print(f"  - {len(colleges)} colleges")
        print(f"  - {len(departments)} departments")
        print(f"  - {len(course_types)} course types")
        print()
        print("Next step:")
        print(f"  python run_crawler.py --year {args.year} --semester {args.semester}")
        print("=" * 60)

        return 0

    except Exception as e:
        print(f"\nERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return 1


if __name__ == "__main__":
    sys.exit(main())
