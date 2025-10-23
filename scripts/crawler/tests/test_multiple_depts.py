"""Test crawler with multiple departments to find one with courses"""

import sys
import os
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from crawler.khu_crawler import KHUCrawler

print("=" * 60)
print("Testing Multiple Departments")
print("=" * 60)
print()

crawler = KHUCrawler()

try:
    # Get department list
    departments = crawler.fetch_department_list(2025, 1)
    print(f"Found {len(departments)} departments")
    print()

    if departments:
        # Test first 10 departments
        test_codes = list(departments.keys())[:10]

        for idx, code in enumerate(test_codes, 1):
            print(f"\n[{idx}/10] Testing {code}...")

            result = crawler.fetch_courses(year=2025, semester=1, major_code=code)

            if result and 'rows' in result:
                courses = result['rows']
                print(f"  -> {len(courses)} courses")

                if courses:
                    print(f"  Sample course: {courses[0].get('subjt_name', 'N/A')}")
                    break  # Found one with courses!
            else:
                print(f"  -> No data")

finally:
    crawler.close()
    print()
    print("=" * 60)
    print("Test complete!")
    print("=" * 60)
