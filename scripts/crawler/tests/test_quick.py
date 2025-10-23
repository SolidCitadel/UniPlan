"""Quick test of the crawler functionality"""

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from crawler.data_js_parser import DataJsParser

print("=" * 60)
print("Testing DataJsParser with semester code fix")
print("=" * 60)
print()

# Test 2025년 1학기
metadata = DataJsParser.parse_metadata(2025, 1)

print()
print("=" * 60)
print("Results:")
print("=" * 60)
print(f"Departments found: {len(metadata['departments'])}")
print(f"Campuses found: {len(metadata['campuses'])}")

if metadata['departments']:
    print()
    print("Sample departments (first 5):")
    for code, name in list(metadata['departments'].items())[:5]:
        print(f"  {code}: {name}")
else:
    print()
    print("ERROR: No departments found!")
