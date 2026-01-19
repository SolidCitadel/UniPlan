"""
OpenAPI 스펙에서 Pydantic 모델을 생성하는 스크립트.

사용법:
    # 백엔드가 실행 중일 때
    cd tests/integration
    uv run python scripts/generate_models.py

    # 또는 특정 서비스만
    uv run python scripts/generate_models.py --service user
"""
import argparse
import subprocess
import sys
import os
from pathlib import Path

# 프로젝트 루트 기준으로 경로 설정
SCRIPT_DIR = Path(__file__).parent
MODELS_DIR = SCRIPT_DIR.parent / "models" / "generated"

# 서비스별 OpenAPI 스펙 URL (API Gateway 경유)
SERVICES = {
    "user": "http://localhost:8080/user-service/v3/api-docs",
    "planner": "http://localhost:8080/planner-service/v3/api-docs",
    "catalog": "http://localhost:8080/catalog-service/v3/api-docs",
}


def generate_models(service_name: str, url: str) -> bool:
    """서비스의 OpenAPI 스펙에서 Pydantic 모델을 생성합니다."""
    output_file = MODELS_DIR / f"{service_name}_models.py"

    cmd = [
        "datamodel-codegen",
        "--url", url,
        "--output", str(output_file),
        "--output-model-type", "pydantic_v2.BaseModel",
        "--use-standard-collections",
        "--use-union-operator",
        "--target-python-version", "3.11",
        "--input-file-type", "openapi",
        "--extra-fields", "forbid",  # 엄격한 검증: 스펙에 없는 필드 오면 에러
    ]

    print(f"Generating {service_name} models from {url}...")
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        
        # 후처리: AwareDatetime -> datetime (백엔드가 타임존 없는 LocalDateTime을 보내는 경우 대응)
        if output_file.exists():
            content = output_file.read_text(encoding="utf-8")
            if "AwareDatetime" in content:
                print(f"  ℹ Replacing AwareDatetime with datetime in {output_file.name}")
                # 1. datetime import 추가 (from __future__ 뒤에 넣어야 함)
                if "from __future__ import annotations" in content:
                    content = content.replace("from __future__ import annotations", "from __future__ import annotations\nfrom datetime import datetime")
                else:
                    content = "from datetime import datetime\n" + content
                
                # 2. 타입 힌트만 변경 (Import 구문은 건드리지 않음 - unused import로 남음)
                content = content.replace(": AwareDatetime", ": datetime")
                content = content.replace("[AwareDatetime", "[datetime") # List[AwareDatetime] 등
                content = content.replace("| AwareDatetime", "| datetime") # Union 타입
                
                output_file.write_text(content, encoding="utf-8")
        
        print(f"  ✓ Generated: {output_file}")
        return True
    except subprocess.CalledProcessError as e:
        print(f"  ✗ Failed: {e.stderr}", file=sys.stderr)
        return False
    except FileNotFoundError:
        print("  ✗ Error: datamodel-codegen not found. Run 'uv sync' first.", file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(description="Generate Pydantic models from OpenAPI specs")
    parser.add_argument(
        "--service",
        choices=list(SERVICES.keys()),
        help="Generate models for a specific service only",
    )
    parser.add_argument(
        "--base-url",
        default=os.getenv("API_BASE_URL", "http://localhost:8080"),
        help="API Gateway base URL (default: env API_BASE_URL or http://localhost:8080)",
    )
    args = parser.parse_args()

    # 출력 디렉토리 생성
    MODELS_DIR.mkdir(parents=True, exist_ok=True)

    # 서비스 URL 업데이트 (base-url 옵션 적용)
    services = SERVICES.copy()
    if args.base_url != "http://localhost:8080":
        services = {
            name: url.replace("http://localhost:8080", args.base_url)
            for name, url in SERVICES.items()
        }

    # 생성할 서비스 결정
    if args.service:
        targets = {args.service: services[args.service]}
    else:
        targets = services

    # 모델 생성
    success_count = 0
    for name, url in targets.items():
        if generate_models(name, url):
            success_count += 1

    # __init__.py 생성
    init_file = MODELS_DIR / "__init__.py"
    init_content = '"""Auto-generated Pydantic models from OpenAPI specs."""\n'
    for name in SERVICES.keys():
        init_content += f"from .{name}_models import *  # noqa: F401, F403\n"
    init_file.write_text(init_content)

    print(f"\nCompleted: {success_count}/{len(targets)} services")
    return success_count == len(targets)


if __name__ == "__main__":
    sys.exit(0 if main() else 1)
