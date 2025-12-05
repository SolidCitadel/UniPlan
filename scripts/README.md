# UniPlan Scripts

Utility scripts for the UniPlan project.

## Setup

This directory uses [Poetry](https://python-poetry.org/) for dependency management.

### Installation

```bash
# Install dependencies
cd scripts
poetry install
```

### Running Scripts

```bash
# Option 1: Use poetry run
poetry run python code_metrics.py --category all

# Option 2: Activate virtual environment
poetry shell
python code_metrics.py --category all
```

## Available Scripts

### code_metrics.py

Analyzes source code metrics for the project.

**Usage:**
```bash
poetry run python code_metrics.py [options]

Options:
  --category {all,server,client}  Which category to analyze (default: all)
  --server-roots [ROOTS ...]      Override server roots (default: app/backend)
  --client-roots [ROOTS ...]      Override client roots (default: app/frontend app/cli-client)
  --json                          Output JSON instead of text
```

**Examples:**
```bash
# Analyze all code
poetry run python code_metrics.py

# Server only
poetry run python code_metrics.py --category server

# JSON output
poetry run python code_metrics.py --json
```

### crawler/

Crawls course data from Kyung Hee University.

**Setup:**
```bash
# Create .env file in crawler/
cd crawler
cp .env.example .env  # Edit with your settings
```

**Usage:**
```bash
# Crawl metadata
poetry run python crawler/crawl_metadata.py --year 2025 --semester 1

# Crawl courses
poetry run python crawler/run_crawler.py --year 2025 --semester 1

# Transform data
poetry run python crawler/transformer.py \
  --metadata output/metadata_2025_1.json \
  --courses output/courses_raw_2025_1.json
```

## Dependencies

- **requests**: HTTP client for API calls
- **beautifulsoup4**: HTML parsing
- **lxml**: XML/HTML parser
- **python-dotenv**: Environment variable management

## Development

### Adding Dependencies

```bash
poetry add package-name
```

### Updating Dependencies

```bash
poetry update
```

### Checking Dependencies

```bash
poetry show
```