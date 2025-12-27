# UniPlan Scripts

크롤러 및 유틸리티 스크립트.

## 설치

```bash
cd scripts
uv sync
```

## 크롤러

경희대학교 강의 데이터 크롤링:

```bash
# 메타데이터 크롤링 (학과, 캠퍼스 등)
uv run python crawler/crawl_metadata.py --year 2025 --semester 1

# 강의 크롤링
uv run python crawler/run_crawler.py --year 2025 --semester 1

# 변환 (catalog-service 형식)
uv run python crawler/transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json
```

## 코드 메트릭

```bash
# 전체 분석
uv run python code_metrics.py

# 서버만
uv run python code_metrics.py --category server

# JSON 출력
uv run python code_metrics.py --json
```
