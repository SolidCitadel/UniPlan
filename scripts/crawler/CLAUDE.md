# Course Data Crawler

Python-based crawler for fetching course data from university registration systems.

## Architecture: 3-Step Workflow

### Step 1: Metadata (~1 second)

```bash
python crawl_metadata.py --year 2025 --semester 1
→ output/metadata_2025_1.json
```

Extracts colleges, departments, courseTypes from data.js (no hardcoded mappings).

### Step 2: Courses (~4 minutes, run once!)

```bash
python run_crawler.py --year 2025 --semester 1
→ output/courses_raw_2025_1.json
```

Saves raw API responses. Each course references department via `class_cd`.

### Step 3: Transformation (~1 second, repeatable!)

```bash
python transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json
→ output/transformed_2025_1.json
```

Transforms to catalog-service format:
- Structured `classTime`: `[{"day":"월","startTime":"15:00","endTime":"16:15"}]`
- Auto-mapped: college, department, courseType from metadata

## Design Principles

1. **Metadata Separation**: Extract from data.js, no hardcoding
2. **Crawl Once**: Minimize server load (~4 min → run once)
3. **Transform Repeatedly**: Modify data_parser.py → re-run Step 3 (~1 sec)
4. **Service Simplicity**: catalog-service stores data as-is (no transformation)
5. **DB-Friendly**: Structured classTime for easy storage

## Output Format

Code-based, DB normalized:

```json
{
  "openingYear": 2025,
  "semester": "1학기",
  "courseCode": "CSE302",
  "courseName": "컴퓨터네트워크",
  "professor": "이성원",
  "credits": 3,
  "classTime": [
    {"day": "월", "startTime": "15:00", "endTime": "16:15"},
    {"day": "수", "startTime": "15:00", "endTime": "16:15"}
  ],
  "classroom": "B01",
  "courseTypeCode": "04",
  "departmentCode": "A10627",
  "campus": "국제"
}
```

Uses codes for normalization. Metadata mapping via join queries.

## Import to catalog-service

```bash
curl -X POST http://localhost:8080/api/courses/import \
  -H "Content-Type: application/json" \
  -d @output/transformed_2025_1.json
```

## Setup

```bash
cd scripts/crawler

# Virtual environment (first time)
python -m venv venv
venv\Scripts\activate       # Windows
# source venv/bin/activate  # Mac/Linux

# Install dependencies
pip install -r requirements.txt

# Run (example with limit for testing)
python crawl_metadata.py --year 2025 --semester 1
python run_crawler.py --year 2025 --semester 1 --limit 5
python transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json
```

## Reference Docs

- Main Guide: `README.md`
- Transformation Details: `TRANSFORMATION_GUIDE.md`
- Field Mapping: `FIELD_MAPPING.md`
