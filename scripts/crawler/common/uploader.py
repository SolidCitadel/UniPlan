"""
Upload crawled data to catalog-service.
"""
import json
import os
from typing import List, Dict, Optional
import requests


DEFAULT_HOST = 'localhost'
DEFAULT_PORT = 8083


def upload_metadata(
    metadata: Dict,
    host: str = DEFAULT_HOST,
    port: int = DEFAULT_PORT,
    use_https: bool = False
) -> bool:
    """
    Upload metadata to catalog-service.

    Args:
        metadata: Metadata dict with colleges, departments, courseTypes
        host: catalog-service host
        port: catalog-service port
        use_https: Use HTTPS

    Returns:
        Success status
    """
    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/metadata/import"

    print("=" * 60)
    print("Uploading metadata to catalog-service")
    print(f"URL: {url}")
    print("=" * 60)

    try:
        print(f"Sending {len(metadata.get('colleges', {}))} colleges, "
              f"{len(metadata.get('departments', {}))} departments, "
              f"{len(metadata.get('courseTypes', {}))} course types...")

        response = requests.post(
            url,
            json=metadata,
            headers={'Content-Type': 'application/json'},
            timeout=60
        )

        if response.status_code == 200:
            result = response.json()
            print(f"SUCCESS: {result.get('message', 'Metadata imported')}")
            return True
        else:
            print(f"ERROR: Status {response.status_code}")
            print(f"Response: {response.text[:500]}")
            return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Cannot reach {url}")
        print("   Is catalog-service running?")
        return False
    except Exception as e:
        print(f"ERROR: {str(e)}")
        return False


def upload_courses(
    courses: List[Dict],
    host: str = DEFAULT_HOST,
    port: int = DEFAULT_PORT,
    use_https: bool = False
) -> bool:
    """
    Upload courses to catalog-service.

    Args:
        courses: List of course dicts
        host: catalog-service host
        port: catalog-service port
        use_https: Use HTTPS

    Returns:
        Success status
    """
    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/courses/import"

    print("=" * 60)
    print("Uploading courses to catalog-service")
    print(f"URL: {url}")
    print(f"Courses: {len(courses)}")
    print("=" * 60)

    try:
        response = requests.post(
            url,
            json=courses,
            headers={'Content-Type': 'application/json'},
            timeout=300  # 5 min timeout for large uploads
        )

        if response.status_code == 200:
            result = response.json()
            print("=" * 60)
            print("SUCCESS!")
            print(f"   Total: {result.get('totalCount', 'N/A')}")
            print(f"   Success: {result.get('successCount', 'N/A')}")
            print(f"   Failure: {result.get('failureCount', 'N/A')}")
            print("=" * 60)
            return True
        else:
            print(f"ERROR: Status {response.status_code}")
            print(f"Response: {response.text[:500]}")
            return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Cannot reach {url}")
        print("   Is catalog-service running?")
        return False
    except requests.exceptions.Timeout:
        print("ERROR: Request timed out")
        return False
    except Exception as e:
        print(f"ERROR: {str(e)}")
        return False


def delete_all_courses(
    host: str = DEFAULT_HOST,
    port: int = DEFAULT_PORT,
    use_https: bool = False
) -> bool:
    """
    Delete all courses from catalog-service.

    Args:
        host: catalog-service host
        port: catalog-service port
        use_https: Use HTTPS

    Returns:
        Success status
    """
    protocol = "https" if use_https else "http"
    url = f"{protocol}://{host}:{port}/courses"

    print("=" * 60)
    print("Deleting all courses")
    print(f"URL: {url}")
    print("=" * 60)

    try:
        response = requests.delete(url, timeout=60)

        if response.status_code == 200:
            result = response.json()
            print(f"SUCCESS: Deleted {result.get('totalCount', 'N/A')} courses")
            return True
        else:
            print(f"ERROR: Status {response.status_code}")
            return False

    except requests.exceptions.ConnectionError:
        print(f"ERROR: Cannot reach {url}")
        return False
    except Exception as e:
        print(f"ERROR: {str(e)}")
        return False
