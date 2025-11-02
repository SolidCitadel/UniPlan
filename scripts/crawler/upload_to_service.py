#!/usr/bin/env python3
"""
크롤링된 JSON 파일을 catalog-service로 업로드

Usage:
    # 간편 모드: year/semester만 입력 (자동으로 파일 찾기)
    python upload_to_service.py --year 2025 --semester 1

    # 직접 모드: 파일 경로 직접 지정
    python upload_to_service.py --file output/transformed_2025_1.json

    # 기존 데이터 삭제 후 업로드
    python upload_to_service.py --year 2025 --semester 1 --delete-first

    # 옵션 추가
    python upload_to_service.py --year 2025 --semester 1 --host localhost --port 8083
"""

import argparse
import sys
import requests
import os
import json
from pathlib import Path


def delete_all_courses(host: str, port: int, use_https: bool = False) -> bool:
    """
    catalog-service의 모든 과목 삭제

    Args:
        host: catalog-service 호스트 (기본: localhost)
        port: catalog-service 포트 (기본: 8083)
        use_https: HTTPS 사용 여부

    Returns:
        성공 여부
    """
    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/courses"

    print("=" * 60)
    print("DELETING ALL COURSES")
    print("=" * 60)
    print(f"URL: {url}")
    print("=" * 60)
    print()

    try:
        response = requests.delete(url, timeout=60)

        if response.status_code == 200:
            print("SUCCESS: All courses deleted!")
            try:
                result = response.json()
                print(f"   Message: {result.get('message', 'N/A')}")
                print(f"   Deleted: {result.get('totalCount', 'N/A')} courses")
            except Exception:
                print(response.text)
            print()
            return True
        else:
            print(f"ERROR: Delete failed! Status: {response.status_code}")
            print(f"Response: {response.text[:500]}")
            return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Cannot reach {url}")
        print("   -> Is catalog-service running?")
        return False
    except Exception as e:
        print(f"ERROR: {str(e)}")
        return False


def upload_metadata(metadata_file: str, host: str, port: int, use_https: bool = False) -> bool:
    """
    metadata.json을 catalog-service로 전송

    Args:
        metadata_file: 업로드할 metadata JSON 파일 경로
        host: catalog-service 호스트 (기본: localhost)
        port: catalog-service 포트 (기본: 8083)
        use_https: HTTPS 사용 여부

    Returns:
        성공 여부
    """
    if not os.path.exists(metadata_file):
        print(f"ERROR: Metadata file not found: {metadata_file}")
        return False

    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/metadata/import"

    print("=" * 60)
    print("Uploading metadata to catalog-service")
    print("=" * 60)
    print(f"File: {metadata_file}")
    print(f"URL: {url}")
    print("=" * 60)
    print()

    try:
        # JSON 파일 읽기
        print("Reading metadata file...")
        with open(metadata_file, 'r', encoding='utf-8') as f:
            metadata = json.load(f)

        print(f"Loaded metadata:")
        print(f"  - Colleges: {len(metadata.get('colleges', {}))}")
        print(f"  - Departments: {len(metadata.get('departments', {}))}")
        print(f"  - Course Types: {len(metadata.get('courseTypes', {}))}")
        print()

        # JSON body로 전송
        print("Sending metadata...")
        response = requests.post(
            url,
            json=metadata,
            headers={'Content-Type': 'application/json'},
            timeout=60
        )

        print()

        # 응답 처리
        if response.status_code == 200:
            print("=" * 60)
            print("SUCCESS: Metadata Import Successful!")
            print("=" * 60)

            try:
                result = response.json()
                print(f"Response:")
                print(f"   Message: {result.get('message', 'N/A')}")
                print(f"   Total: {result.get('totalCount', 'N/A')}")
                print(f"   Success: {result.get('successCount', 'N/A')}")
                print(f"   Failure: {result.get('failureCount', 'N/A')}")
            except Exception:
                print(response.text)

            print("=" * 60)
            return True

        else:
            print("=" * 60)
            print(f"ERROR: Metadata Import Failed!")
            print("=" * 60)
            print(f"Status code: {response.status_code}")
            print(f"Response: {response.text[:500]}")
            print("=" * 60)
            return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Connection error: Cannot reach {url}")
        print("   -> Is catalog-service running on port 8083?")
        return False

    except Exception as e:
        print(f"ERROR: Unexpected error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False


def upload_json_file(file_path: str, host: str, port: int, use_https: bool = False, delete_first: bool = False) -> bool:
    """
    JSON 파일을 catalog-service의 import API로 전송

    Args:
        file_path: 업로드할 JSON 파일 경로 (transformed_*.json)
        host: catalog-service 호스트 (기본: localhost)
        port: catalog-service 포트 (기본: 8083)
        use_https: HTTPS 사용 여부

    Returns:
        성공 여부
    """
    # 파일 존재 여부 확인
    if not os.path.exists(file_path):
        print(f"ERROR: File not found: {file_path}")
        return False

    # API URL 구성 (catalog-service 직접 연결)
    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/courses/import"

    print("=" * 60)
    print("Uploading to catalog-service")
    print("=" * 60)
    print(f"File: {file_path}")
    print(f"URL: {url}")
    print("=" * 60)
    print()

    try:
        # 파일 크기 확인
        file_size = os.path.getsize(file_path)
        file_size_mb = file_size / 1024 / 1024
        print(f"File size: {file_size_mb:.2f} MB")

        # JSON 파일 읽기
        print("Reading JSON file...")
        with open(file_path, 'r', encoding='utf-8') as f:
            courses_data = json.load(f)

        # 데이터 검증
        if not isinstance(courses_data, list):
            print("ERROR: Invalid JSON format: Expected a list of courses")
            return False

        print(f"Loaded {len(courses_data)} courses")
        print()

        # JSON body로 전송
        print("Sending data...")
        response = requests.post(
            url,
            json=courses_data,  # JSON body로 전송
            headers={'Content-Type': 'application/json'},
            timeout=300  # 5분 타임아웃 (대용량 데이터 고려)
        )

        print()

        # 응답 처리
        if response.status_code == 200:
            print("=" * 60)
            print("SUCCESS: Import Successful!")
            print("=" * 60)

            try:
                result = response.json()
                print(f"Response:")
                print(f"   Message: {result.get('message', 'N/A')}")
                print(f"   Total: {result.get('totalCount', 'N/A')}")
                print(f"   Success: {result.get('successCount', 'N/A')}")
                print(f"   Failure: {result.get('failureCount', 'N/A')}")
            except Exception:
                print(response.text)

            print("=" * 60)
            return True

        else:
            print("=" * 60)
            print(f"ERROR: Import Failed!")
            print("=" * 60)
            print(f"Status code: {response.status_code}")
            print(f"Response: {response.text[:500]}")
            print("=" * 60)
            return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Connection error: Cannot reach {url}")
        print("   -> Is catalog-service running on port 8083?")
        return False

    except requests.exceptions.Timeout:
        print(f"ERROR: Timeout: Request took too long")
        print("   -> Try uploading a smaller file or increase timeout")
        return False

    except json.JSONDecodeError as e:
        print(f"ERROR: Invalid JSON file: {str(e)}")
        return False

    except Exception as e:
        print(f"ERROR: Unexpected error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False


def find_transformed_file(year: int, semester: int) -> str:
    """
    year와 semester로 transformed 파일 경로 찾기
    스크립트 위치 기준으로 절대 경로 반환
    """
    # 스크립트 파일의 디렉토리 (절대 경로)
    script_dir = Path(__file__).resolve().parent
    output_dir = script_dir / "output"

    filename = f"transformed_{year}_{semester}.json"
    file_path = output_dir / filename

    if not file_path.exists():
        print(f"ERROR: File not found: {file_path}")
        print(f"   Expected location: {output_dir}")
        print(f"   Expected filename: {filename}")
        print()
        print("   Did you run the transformation step?")
        print(f"   -> python transformer.py --metadata output/metadata_{year}_{semester}.json \\")
        print(f"                            --courses output/courses_raw_{year}_{semester}.json")
        return None

    return str(file_path)


def main():
    parser = argparse.ArgumentParser(
        description='크롤링된 JSON을 catalog-service로 업로드',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # 간편 모드 (권장)
  python upload_to_service.py --year 2025 --semester 1

  # 직접 모드
  python upload_to_service.py --file output/transformed_2025_1.json

  # 커스텀 호스트/포트
  python upload_to_service.py --year 2025 --semester 1 --host localhost --port 8083
        """
    )

    # 파일 지정 방식: --year/--semester 또는 --file
    file_group = parser.add_mutually_exclusive_group(required=True)
    file_group.add_argument(
        '--year',
        type=int,
        help='개설년도 (예: 2025)'
    )
    file_group.add_argument(
        '--file',
        type=str,
        help='업로드할 JSON 파일 경로 (직접 지정)'
    )

    parser.add_argument(
        '--semester',
        type=int,
        choices=[1, 2],
        help='학기 (1: 1학기, 2: 2학기) - --year와 함께 사용'
    )

    parser.add_argument(
        '--host',
        type=str,
        default='localhost',
        help='catalog-service 호스트 (기본: localhost)'
    )

    parser.add_argument(
        '--port',
        type=int,
        default=8083,
        help='catalog-service 포트 (기본: 8083)'
    )

    parser.add_argument(
        '--https',
        action='store_true',
        help='HTTPS 사용 (기본: HTTP)'
    )

    parser.add_argument(
        '--delete-first',
        action='store_true',
        help='업로드 전에 모든 기존 과목 삭제'
    )

    args = parser.parse_args()

    # 파일 경로 결정
    metadata_file = None
    if args.year:
        # 간편 모드: year/semester로 파일 찾기
        if not args.semester:
            print("ERROR: --semester is required when using --year")
            return 1

        file_path = find_transformed_file(args.year, args.semester)
        if not file_path:
            return 1

        # metadata 파일 경로도 찾기
        script_dir = Path(__file__).resolve().parent
        metadata_file = str(script_dir / "output" / f"metadata_{args.year}_{args.semester}.json")

    else:
        # 직접 모드: 파일 경로 직접 지정
        file_path = args.file

        # 상대 경로면 절대 경로로 변환 (스크립트 위치 기준)
        if not os.path.isabs(file_path):
            script_dir = Path(__file__).resolve().parent
            file_path = str(script_dir / file_path)

    step_num = 1

    # 기존 데이터 삭제 (옵션)
    if args.delete_first:
        print(f"Step {step_num}: Deleting existing courses...")
        if not delete_all_courses(args.host, args.port, args.https):
            print("WARNING: Delete failed, but continuing with import...")
        print()
        step_num += 1

    # Metadata 업로드 (year/semester 모드일 때만)
    if metadata_file and os.path.exists(metadata_file):
        print(f"Step {step_num}: Importing metadata...")
        if not upload_metadata(metadata_file, args.host, args.port, args.https):
            print("WARNING: Metadata import failed, but continuing with courses import...")
        print()
        step_num += 1

    # 과목 업로드
    print(f"Step {step_num}: Importing courses...")
    success = upload_json_file(
        file_path=file_path,
        host=args.host,
        port=args.port,
        use_https=args.https,
        delete_first=args.delete_first
    )

    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())