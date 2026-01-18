#!/usr/bin/env python3
"""
UniPlan Course Crawler - Unified CLI

Usage:
    # Crawl metadata
    python run.py metadata --university khu --year 2026 --semester 1

    # Crawl courses
    python run.py courses --university khu --year 2026 --semester 1

    # Transform and upload
    python run.py upload --university khu --year 2026 --semester 1

    # Full pipeline (metadata + courses + transform + upload)
    python run.py full --university khu --year 2026 --semester 1
"""
import argparse
import json
import os
import sys
import time
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent))

from common.uploader import upload_courses, upload_metadata


def get_output_dir() -> Path:
    """Get output directory path."""
    output_dir = Path(__file__).parent / "output"
    output_dir.mkdir(exist_ok=True)
    return output_dir


def get_university_module(university: str):
    """Dynamically import university-specific module."""
    if university.lower() == "khu":
        from universities.khu import KHUCrawler, KHUParser, UNIVERSITY_ID
        return KHUCrawler, KHUParser, UNIVERSITY_ID
    else:
        raise ValueError(f"Unknown university: {university}. Available: khu")


def cmd_metadata(args):
    """Crawl and save metadata."""
    print("=" * 60)
    print(f"Crawling metadata: {args.university.upper()} {args.year} semester {args.semester}")
    print("=" * 60)

    Crawler, Parser, _ = get_university_module(args.university)
    output_dir = get_output_dir()

    with Crawler() as crawler:
        # Fetch data.js
        print("\nFetching metadata source...")
        js_content = crawler.fetch_data_js(args.year)
        if not js_content:
            print("ERROR: Failed to fetch metadata")
            return 1

        # Save raw file
        raw_file = output_dir / f"raw_{args.university}_{args.year}_{args.semester}.js"
        raw_file.write_text(js_content, encoding='utf-8')
        print(f"Saved raw file: {raw_file}")

        # Parse metadata
        print("\nParsing metadata...")
        metadata = Parser.parse_metadata(js_content, args.year, args.semester)

        print(f"  Colleges: {len(metadata['colleges'])}")
        print(f"  Departments: {len(metadata['departments'])}")
        print(f"  Course Types: {len(metadata['courseTypes'])}")

        # Save metadata
        metadata_file = output_dir / f"metadata_{args.university}_{args.year}_{args.semester}.json"
        with open(metadata_file, 'w', encoding='utf-8') as f:
            json.dump(metadata, f, ensure_ascii=False, indent=2)

        print(f"\nSaved: {metadata_file}")
        print("=" * 60)

    return 0


def cmd_courses(args):
    """Crawl courses."""
    print("=" * 60)
    print(f"Crawling courses: {args.university.upper()} {args.year} semester {args.semester}")
    print("=" * 60)

    Crawler, Parser, _ = get_university_module(args.university)
    output_dir = get_output_dir()

    # Load metadata
    metadata_file = output_dir / f"metadata_{args.university}_{args.year}_{args.semester}.json"
    if not metadata_file.exists():
        print(f"ERROR: Metadata file not found: {metadata_file}")
        print("Run 'python run.py metadata' first.")
        return 1

    with open(metadata_file, 'r', encoding='utf-8') as f:
        metadata = json.load(f)

    departments = metadata.get('departments', {})
    print(f"Loaded {len(departments)} departments from metadata\n")

    # Apply limits
    if args.departments:
        selected = [c.strip() for c in args.departments.split(',')]
        departments = {k: v for k, v in departments.items() if k in selected}
        print(f"Selected {len(departments)} departments: {list(departments.keys())}\n")

    if args.limit:
        departments = dict(list(departments.items())[:args.limit])
        print(f"Limited to {len(departments)} departments\n")

    # Crawl
    with Crawler() as crawler:
        all_courses = []
        success_count = 0
        fail_count = 0

        for idx, (dept_code, dept_info) in enumerate(departments.items(), 1):
            dept_name = dept_info.get('name', dept_code) if isinstance(dept_info, dict) else dept_info
            print(f"[{idx}/{len(departments)}] {dept_code} - {dept_name}")

            try:
                data = crawler.fetch_courses(args.year, args.semester, major_code=dept_code)
                if data and 'rows' in data:
                    courses = data['rows']
                    all_courses.extend(courses)
                    success_count += 1
                    print(f"   -> {len(courses)} courses")
                else:
                    fail_count += 1
                    print(f"   -> No data")
            except Exception as e:
                fail_count += 1
                print(f"   -> Error: {e}")

            if idx < len(departments):
                time.sleep(0.5)

        # Save raw courses
        raw_file = output_dir / f"courses_raw_{args.university}_{args.year}_{args.semester}.json"
        with open(raw_file, 'w', encoding='utf-8') as f:
            json.dump({
                'year': args.year,
                'semester': args.semester,
                'total_courses': len(all_courses),
                'departments': {k: {'courses': []} for k in departments}  # Simplified
            }, f, ensure_ascii=False, indent=2)

        # Transform courses
        print(f"\nTransforming {len(all_courses)} courses...")
        from universities.khu import UNIVERSITY_ID
        transformed = Parser.parse_courses(all_courses, args.year, args.semester, UNIVERSITY_ID)

        # Save transformed
        transformed_file = output_dir / f"transformed_{args.university}_{args.year}_{args.semester}.json"
        with open(transformed_file, 'w', encoding='utf-8') as f:
            json.dump(transformed, f, ensure_ascii=False, indent=2)

        print(f"\n{'=' * 60}")
        print("SUCCESS!")
        print(f"  Departments: {success_count} success, {fail_count} failed")
        print(f"  Raw courses: {len(all_courses)}")
        print(f"  Unique courses: {len(transformed)}")
        print(f"  Saved: {transformed_file}")
        print("=" * 60)

    return 0


def cmd_upload(args):
    """Upload to catalog-service."""
    print("=" * 60)
    print(f"Uploading: {args.university.upper()} {args.year} semester {args.semester}")
    print("=" * 60)

    output_dir = get_output_dir()

    # Upload metadata
    metadata_file = output_dir / f"metadata_{args.university}_{args.year}_{args.semester}.json"
    if metadata_file.exists():
        print("\nStep 1: Uploading metadata...")
        with open(metadata_file, 'r', encoding='utf-8') as f:
            metadata = json.load(f)
        if not upload_metadata(metadata, host=args.host, port=args.port):
            print("ERROR: Metadata upload failed")
            return 1
    else:
        print(f"WARNING: Metadata file not found: {metadata_file}")

    # Upload courses
    transformed_file = output_dir / f"transformed_{args.university}_{args.year}_{args.semester}.json"
    if not transformed_file.exists():
        print(f"ERROR: Transformed file not found: {transformed_file}")
        print("Run 'python run.py courses' first.")
        return 1

    print("\nStep 2: Uploading courses...")
    with open(transformed_file, 'r', encoding='utf-8') as f:
        courses = json.load(f)

    success = upload_courses(courses, host=args.host, port=args.port)
    return 0 if success else 1


def cmd_full(args):
    """Full pipeline: metadata + courses + upload."""
    print("=" * 60)
    print(f"Full pipeline: {args.university.upper()} {args.year} semester {args.semester}")
    print("=" * 60)

    # Step 1: Metadata
    print("\n[Step 1/3] Crawling metadata...")
    result = cmd_metadata(args)
    if result != 0:
        return result

    # Step 2: Courses
    print("\n[Step 2/3] Crawling courses...")
    result = cmd_courses(args)
    if result != 0:
        return result

    # Step 3: Upload
    print("\n[Step 3/3] Uploading to catalog-service...")
    result = cmd_upload(args)
    if result != 0:
        return result

    print("\n" + "=" * 60)
    print("FULL PIPELINE COMPLETE!")
    print("=" * 60)
    return 0


def main():
    parser = argparse.ArgumentParser(
        description='UniPlan Course Crawler',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    subparsers = parser.add_subparsers(dest='command', help='Commands')

    # Common arguments
    common = argparse.ArgumentParser(add_help=False)
    common.add_argument('--university', '-u', required=True, help='University code (e.g., khu)')
    common.add_argument('--year', '-y', type=int, required=True, help='Year (e.g., 2026)')
    common.add_argument('--semester', '-s', type=int, required=True, choices=[1, 2], help='Semester (1 or 2)')

    # metadata command
    metadata_parser = subparsers.add_parser('metadata', parents=[common], help='Crawl metadata')

    # courses command
    courses_parser = subparsers.add_parser('courses', parents=[common], help='Crawl courses')
    courses_parser.add_argument('--limit', type=int, help='Limit number of departments (for testing)')
    courses_parser.add_argument('--departments', type=str, help='Specific departments (comma-separated)')

    # upload command
    upload_parser = subparsers.add_parser('upload', parents=[common], help='Upload to catalog-service')
    upload_parser.add_argument('--host', default='localhost', help='catalog-service host')
    upload_parser.add_argument('--port', type=int, default=8083, help='catalog-service port')

    # full command
    full_parser = subparsers.add_parser('full', parents=[common], help='Full pipeline')
    full_parser.add_argument('--limit', type=int, help='Limit number of departments')
    full_parser.add_argument('--departments', type=str, help='Specific departments')
    full_parser.add_argument('--host', default='localhost', help='catalog-service host')
    full_parser.add_argument('--port', type=int, default=8083, help='catalog-service port')

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    commands = {
        'metadata': cmd_metadata,
        'courses': cmd_courses,
        'upload': cmd_upload,
        'full': cmd_full,
    }

    return commands[args.command](args)


if __name__ == "__main__":
    sys.exit(main())
