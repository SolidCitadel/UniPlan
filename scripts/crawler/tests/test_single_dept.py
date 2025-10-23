#!/usr/bin/env python3
"""
단일 학과 크롤링 테스트 스크립트
빠른 테스트 및 디버깅용
"""

import sys
import os
import json

sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from crawler.khu_crawler import KHUCrawler


def main():
    print("=" * 60)
    print("🧪 Single Department Crawling Test")
    print("=" * 60)
    print()

    # 학과 코드 입력
    dept_code = input("Enter department code (e.g., A10627): ").strip()
    if not dept_code:
        print("❌ No department code provided")
        return 1

    year = 2025
    semester = 1

    print(f"\n📋 Parameters:")
    print(f"   Year: {year}")
    print(f"   Semester: {semester}")
    print(f"   Department: {dept_code}")
    print()

    crawler = KHUCrawler()

    try:
        print("📡 Fetching courses...")
        print("-" * 60)

        result = crawler.fetch_courses(
            year=year,
            semester=semester,
            major_code=dept_code
        )

        if not result:
            print("❌ Failed to fetch data")
            return 1

        print()
        print("=" * 60)
        print("📊 Result Summary")
        print("=" * 60)

        if 'rows' in result:
            courses = result['rows']
            print(f"✅ Total courses: {len(courses)}")

            if len(courses) > 0:
                print("\n📝 First course:")
                print(json.dumps(courses[0], indent=2, ensure_ascii=False))

                print("\n📝 Field names:")
                for key in courses[0].keys():
                    print(f"   - {key}")

                # 결과 저장
                output_file = f"output/test_{dept_code}_{year}_{semester}.json"
                os.makedirs('output', exist_ok=True)

                with open(output_file, 'w', encoding='utf-8') as f:
                    json.dump(courses, f, ensure_ascii=False, indent=2)

                print(f"\n💾 Saved to: {output_file}")
            else:
                print("⚠️  No courses found")
        else:
            print("⚠️  Unexpected response structure")
            print(f"Keys: {result.keys()}")

        return 0

    except Exception as e:
        print(f"\n❌ Error: {str(e)}")
        import traceback
        traceback.print_exc()
        return 1

    finally:
        crawler.close()


if __name__ == "__main__":
    sys.exit(main())
