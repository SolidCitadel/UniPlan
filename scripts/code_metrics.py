#!/usr/bin/env python3
"""
Lightweight code metrics helper for UniPlan.

Reports per-category counts for:
- source files
- total lines (all lines)
- class/interface/enum definitions
- methods on classes (constructors included)
- top-level functions (not inside a class)

Categories are pre-wired for server (app/backend) and client
(app/frontend, app/cli-client) but can be overridden with flags.

"""

from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Sequence, Set


PROJECT_ROOT = Path(__file__).resolve().parent.parent

# Skip generated / tooling output
IGNORE_DIRS: Set[str] = {
    ".git",
    ".idea",
    ".vscode",
    ".gradle",
    ".dart_tool",
    "build",
    "node_modules",
    ".next",
    "dist",
    "coverage",
    ".scannerwork",
    ".venv",
    "venv",
    ".pytest_cache",
    ".mypy_cache",
    ".firebase",
    ".fleet",
}

# Skip generated source files
IGNORE_FILE_PATTERNS: Set[str] = {
    ".freezed.dart",  # Freezed generated files
    ".g.dart",        # JSON serialization generated files
}


@dataclass
class LangRule:
    class_patterns: Sequence[re.Pattern[str]]
    interface_patterns: Sequence[re.Pattern[str]]
    enum_patterns: Sequence[re.Pattern[str]]
    function_patterns: Sequence[re.Pattern[str]]
    skip_first_words: Set[str]
    allow_top_level_functions: bool


LANG_RULES: Dict[str, LangRule] = {
    "java": LangRule(
        class_patterns=[
            re.compile(
                r"^\s*(?:public|protected|private|abstract|final|static|\s)*"
                r"(?:class|record)\s+[A-Za-z_][\w$]*"
            )
        ],
        interface_patterns=[
            re.compile(
                r"^\s*(?:public|protected|private|\s)*"
                r"interface\s+[A-Za-z_][\w$]*"
            )
        ],
        enum_patterns=[
            re.compile(
                r"^\s*(?:public|protected|private|\s)*"
                r"enum\s+[A-Za-z_][\w$]*"
            )
        ],
        function_patterns=[
            re.compile(
                r"^\s*(?:public|protected|private|static|final|native|synchronized|abstract|default|strictfp|\s)*"
                r"[A-Za-z_$][\w$<>\[\]]*\s+[A-Za-z_$][\w$]*\s*\([^;]*\)\s*(?:\{|throws|\s*$|;)"
            ),
            re.compile(
                r"^\s*(?:public|protected|private|static|final|native|synchronized|abstract|default|strictfp|\s)*"
                r"[A-Za-z_$][\w$]*\s*\([^;]*\)\s*(?:\{|throws|\s*$|;)"
            ),
        ],
        skip_first_words={"if", "for", "while", "switch", "catch", "try", "else", "case", "do"},
        allow_top_level_functions=False,
    ),
    "dart": LangRule(
        class_patterns=[
            re.compile(r"^\s*(?:abstract\s+|sealed\s+|base\s+|final\s+)?class\s+[A-Za-z_][\w<>$]*"),
            re.compile(r"^\s*mixin\s+[A-Za-z_][\w$]*"),
        ],
        interface_patterns=[],  # Dart doesn't have explicit interfaces
        enum_patterns=[
            re.compile(r"^\s*enum\s+[A-Za-z_][\w$]*"),
        ],
        function_patterns=[
            re.compile(
                r"^\s*(?:@[\w\.]+\s*)*(?:static\s+|factory\s+)?(?:async\s+)?"
                r"(?:[A-Za-z_<$>][\w<$>\?\s\.,]*\s+)?[A-Za-z_]\w*(?:\.[A-Za-z_]\w*)?\s*\([^;]*\)\s*(?:\{|=>)"
            ),
        ],
        skip_first_words={"if", "for", "while", "switch", "catch", "try", "else", "case", "do"},
        allow_top_level_functions=True,
    ),
    "ts": LangRule(
        class_patterns=[
            re.compile(r"^\s*(?:export\s+)?(?:abstract\s+)?class\s+[A-Za-z_][\w]*"),
        ],
        interface_patterns=[
            re.compile(r"^\s*(?:export\s+)?interface\s+[A-Za-z_][\w]*"),
        ],
        enum_patterns=[
            re.compile(r"^\s*(?:export\s+)?enum\s+[A-Za-z_][\w]*"),
        ],
        function_patterns=[
            re.compile(r"^\s*(?:export\s+)?function\s+[A-Za-z_]\w*\s*\([^;]*\)"),
            re.compile(
                r"^\s*(?:public|private|protected|readonly|static|abstract|async|override|get|set)\s+[A-Za-z_]\w*\s*\([^;=]*\)\s*\{?"
            ),
            re.compile(r"^\s*(?:constructor)\s*\([^;]*\)"),
            re.compile(
                r"^\s*(?:export\s+)?(?:const|let|var)\s+[A-Za-z_]\w*\s*=\s*(?:async\s+)?(?:\([^)]*\)|[A-Za-z_]\w*)\s*=>"
            ),
            re.compile(
                r"^\s*(?:public|private|protected|readonly|static|abstract|async|override)?\s*[A-Za-z_]\w*\s*="
                r"\s*(?:async\s+)?(?:\([^)]*\)|[A-Za-z_]\w*)\s*=>"
            ),
            re.compile(
                r"^\s*(?:public|private|protected|readonly|static|abstract|async|override)?\s*[A-Za-z_]\w*\s*\([^;=]*\)\s*\{"
            ),
        ],
        skip_first_words={"if", "for", "while", "switch", "catch", "try", "else", "case", "do", "type"},
        allow_top_level_functions=True,
    ),
}


EXT_TO_LANG: Dict[str, str] = {
    ".java": "java",
    ".dart": "dart",
    ".ts": "ts",
    ".tsx": "ts",
}


CategoryConfig = Dict[str, List[str]]


DEFAULT_CATEGORIES: Dict[str, CategoryConfig] = {
    "server": {"roots": ["app/backend"]},
    "client": {"roots": ["app/frontend", "app/cli-client"]},
}


def strip_comments(line: str, in_block_comment: bool) -> tuple[str, bool]:
    code = ""
    i = 0
    while i < len(line):
        if in_block_comment:
            end = line.find("*/", i)
            if end == -1:
                return "", True
            i = end + 2
            in_block_comment = False
        else:
            start = line.find("/*", i)
            if start == -1:
                code += line[i:]
                break
            code += line[i:start]
            i = start + 2
            in_block_comment = True
    code = re.split(r"//|///|#", code, maxsplit=1)[0]
    return code, in_block_comment


def should_skip_dir(path: Path) -> bool:
    return any(part in IGNORE_DIRS for part in path.parts)


def should_skip_file(path: Path) -> bool:
    """Check if file should be skipped based on generated file patterns."""
    return any(str(path).endswith(pattern) for pattern in IGNORE_FILE_PATTERNS)


def iter_source_files(root: Path, allowed_exts: Set[str]) -> Iterable[Path]:
    stack: List[Path] = [root]
    while stack:
        current = stack.pop()
        try:
            children = list(current.iterdir())
        except OSError:
            continue
        for child in children:
            if child.is_dir():
                if should_skip_dir(child):
                    continue
                stack.append(child)
            elif child.suffix in allowed_exts:
                if not should_skip_file(child):
                    yield child


def matches_any(patterns: Sequence[re.Pattern[str]], text: str) -> bool:
    return any(pat.match(text) for pat in patterns)


def analyze_file(path: Path, lang: str) -> Dict[str, int]:
    rules = LANG_RULES[lang]
    try:
        lines = path.read_text(encoding="utf-8", errors="ignore").splitlines()
    except OSError:
        return {"lines": 0, "classes": 0, "interfaces": 0, "enums": 0, "methods": 0, "top_level_functions": 0}

    brace_depth = 0
    class_stack: List[int] = []
    pending_classes = 0
    in_block_comment = False

    class_count = 0
    interface_count = 0
    enum_count = 0
    method_count = 0
    top_level_functions = 0

    for raw_line in lines:
        code_line, in_block_comment = strip_comments(raw_line, in_block_comment)
        stripped = code_line.strip()

        if stripped and matches_any(rules.class_patterns, stripped):
            class_count += 1
            pending_classes += 1

        if stripped and matches_any(rules.interface_patterns, stripped):
            interface_count += 1
            pending_classes += 1

        if stripped and matches_any(rules.enum_patterns, stripped):
            enum_count += 1
            pending_classes += 1

        function_hit = False
        if stripped:
            first_word_match = re.match(r"^([A-Za-z_][\w$]*)", stripped)
            first_word = first_word_match.group(1) if first_word_match else ""
            if first_word not in rules.skip_first_words:
                function_hit = matches_any(rules.function_patterns, stripped)

        in_class = bool(class_stack)
        if function_hit:
            if rules.allow_top_level_functions and not in_class:
                top_level_functions += 1
            else:
                method_count += 1

        opens = code_line.count("{")
        closes = code_line.count("}")

        for _ in range(opens):
            brace_depth += 1
            if pending_classes > 0:
                class_stack.append(brace_depth)
                pending_classes -= 1

        for _ in range(closes):
            if class_stack and class_stack[-1] == brace_depth:
                class_stack.pop()
            brace_depth = max(0, brace_depth - 1)

    return {
        "lines": len(lines),
        "classes": class_count,
        "interfaces": interface_count,
        "enums": enum_count,
        "methods": method_count,
        "top_level_functions": top_level_functions,
    }


def analyze_category(name: str, roots: Sequence[str]) -> Dict[str, int]:
    stats = {"files": 0, "lines": 0, "classes": 0, "interfaces": 0, "enums": 0, "methods": 0, "top_level_functions": 0}
    allowed_exts = set(EXT_TO_LANG.keys())
    for root in roots:
        root_path = (PROJECT_ROOT / root).resolve()
        if not root_path.exists():
            continue
        for file_path in iter_source_files(root_path, allowed_exts):
            lang = EXT_TO_LANG.get(file_path.suffix)
            if not lang:
                continue
            file_stats = analyze_file(file_path, lang)
            stats["files"] += 1
            stats["lines"] += file_stats["lines"]
            stats["classes"] += file_stats["classes"]
            stats["interfaces"] += file_stats["interfaces"]
            stats["enums"] += file_stats["enums"]
            stats["methods"] += file_stats["methods"]
            stats["top_level_functions"] += file_stats["top_level_functions"]
    return stats


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Code metrics summary for UniPlan.")
    parser.add_argument(
        "--category",
        choices=["all"] + list(DEFAULT_CATEGORIES.keys()),
        default="all",
        help="Which category to analyze (default: all).",
    )
    parser.add_argument(
        "--server-roots",
        nargs="*",
        default=None,
        help="Override server roots (default: app/backend).",
    )
    parser.add_argument(
        "--client-roots",
        nargs="*",
        default=None,
        help="Override client roots (default: app/frontend app/cli-client).",
    )
    parser.add_argument("--json", action="store_true", help="Output JSON instead of text.")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    categories = dict(DEFAULT_CATEGORIES)
    if args.server_roots is not None:
        categories["server"] = {"roots": args.server_roots}
    if args.client_roots is not None:
        categories["client"] = {"roots": args.client_roots}

    targets = categories.keys() if args.category == "all" else [args.category]
    results = {
        name: analyze_category(name, categories[name]["roots"])
        for name in targets
    }

    if args.json:
        print(json.dumps(results, indent=2))
        return

    for name in targets:
        stats = results[name]
        print(f"[{name}]")
        print(f"  source files          : {stats['files']}")
        print(f"  total lines           : {stats['lines']}")
        print(f"  classes               : {stats['classes']}")
        print(f"  interfaces            : {stats['interfaces']}")
        print(f"  enums                 : {stats['enums']}")
        print(f"  class methods (total) : {stats['methods']}")
        print(f"  top-level functions   : {stats['top_level_functions']}")
        print()


if __name__ == "__main__":
    main()
