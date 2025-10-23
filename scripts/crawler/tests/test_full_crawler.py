"""Test full crawler with single department"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from crawler.khu_crawler import KHUCrawler
from crawler.data_parser import KHUDataParser

print("=" * 60)
print("Testing Full Crawler (Single Department)")
print("=" * 60)
print()

crawler = KHUCrawler()

try:
    # Get department list
    print("Step 1: Fetching department list...")
    departments = crawler.fetch_department_list(2025, 1)
    print(f"Found {len(departments)} departments")
    print()

    if departments:
        # Test with first department
        test_code = list(departments.keys())[0]
        test_name = departments[test_code]
        print(f"Step 2: Testing with {test_code}")
        print()

        # Fetch courses
        result = crawler.fetch_courses(year=2025, semester=1, major_code=test_code)

        if result and 'rows' in result:
            courses = result['rows']
            print(f"Fetched {len(courses)} courses")
            print()

            if courses:
                # Parse first course
                print("Step 3: Parsing first course...")
                parsed = KHUDataParser.parse_course(courses[0], year=2025, semester_code="20")

                print("Parsed course:")
                import json
                print(json.dumps(parsed, indent=2, ensure_ascii=False))
        else:
            print("ERROR: No courses fetched")
    else:
        print("ERROR: No departments found")

finally:
    crawler.close()
    print()
    print("=" * 60)
    print("Test complete!")
    print("=" * 60)
