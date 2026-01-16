# UniPlan Scripts

유틸리티 스크립트 모음.

## 구조

```
scripts/
└── crawler/          # 강의 데이터 크롤러 (Python, uv)
    └── README.md     # 크롤러 상세 문서
```

## 크롤러

다중 대학 강의 데이터 크롤링. 상세 사용법은 [crawler/README.md](crawler/README.md) 참조.

```bash
cd scripts/crawler
uv sync
uv run python run.py full -u khu -y 2026 -s 1
```
