#!/usr/bin/env python3
"""
크롤링된 JSON 파일을 catalog-service로 업로드

Usage:
    python upload_to_service.py output/courses_khu_2025_1.json
    python upload_to_service.py output/courses_khu_2025_1.json --host localhost --port 8083
"""

import argparse
import sys
import requests
import os


def upload_json_file(file_path: str, host: str, port: int, use_https: bool = False) -> bool:
    """
    JSON 파일을 catalog-service의 업로드 API로 전송

    Args:
        file_path: 업로드할 JSON 파일 경로
        host: catalog-service 호스트
        port: catalog-service 포트
        use_https: HTTPS 사용 여부

    Returns:
        성공 여부
    """
    # 파일 존재 여부 확인
    if not os.path.exists(file_path):
        print(f"❌ File not found: {file_path}")
        return False

    # API URL 구성
    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/api/v1/admin/courses/upload"

    print("=" * 60)
    print("📤 Uploading to catalog-service")
    print("=" * 60)
    print(f"📁 File: {file_path}")
    print(f"🌐 URL: {url}")
    print("=" * 60)
    print()

    try:
        # 파일 크기 확인
        file_size = os.path.getsize(file_path)
        file_size_mb = file_size / 1024 / 1024
        print(f"📦 File size: {file_size_mb:.2f} MB")
        print()

        # 파일 업로드
        print("📡 Uploading...")

        with open(file_path, 'rb') as f:
            files = {'file': (os.path.basename(file_path), f, 'application/json')}

            response = requests.post(
                url,
                files=files,
                timeout=300  # 5분 타임아웃 (대용량 파일 고려)
            )

        print()

        # 응답 처리
        if response.status_code == 200:
            print("=" * 60)
            print("✅ Upload Successful!")
            print("=" * 60)

            try:
                result = response.json()
                print(f"📊 Response:")
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
            print(f"❌ Upload Failed!")
            print("=" * 60)
            print(f"Status code: {response.status_code}")
            print(f"Response: {response.text[:500]}")
            print("=" * 60)
            return False

    except requests.exceptions.ConnectionError:
        print(f"❌ Connection error: Cannot reach {url}")
        print("   → Is catalog-service running?")
        return False

    except requests.exceptions.Timeout:
        print(f"❌ Timeout: Request took too long")
        print("   → Try uploading a smaller file or increase timeout")
        return False

    except Exception as e:
        print(f"❌ Unexpected error: {str(e)}")
        import traceback
        traceback.print_exc()
        return False


def main():
    parser = argparse.ArgumentParser(
        description='크롤링된 JSON을 catalog-service로 업로드',
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument(
        'file',
        type=str,
        help='업로드할 JSON 파일 경로'
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

    args = parser.parse_args()

    success = upload_json_file(
        file_path=args.file,
        host=args.host,
        port=args.port,
        use_https=args.https
    )

    return 0 if success else 1


if __name__ == "__main__":
    sys.exit(main())