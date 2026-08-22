#!/usr/bin/env python3
"""Ensure every static localization key used by C++ and QML has a translation."""

import json
import re
import sys
from pathlib import Path


PROJECT_ROOT = Path(__file__).resolve().parents[1]
SOURCE_ROOT = PROJECT_ROOT / "client-side" / "src"
TRANSLATION_ROOT = PROJECT_ROOT / "client-side" / "resources" / "translation"
KEY_PATTERN = re.compile(r'Localization\.(?:string|strCpp)\("((?:[^"\\]|\\.)*)"')


def source_keys() -> set[str]:
    keys: set[str] = set()
    for source_file in SOURCE_ROOT.rglob("*"):
        if source_file.suffix not in {".cpp", ".h", ".qml"}:
            continue

        text = source_file.read_text(encoding="utf-8")
        keys.update(
            key
            for match in KEY_PATTERN.findall(text)
            if (key := json.loads(f'"{match}"'))
        )

    return keys


def check_catalog(catalog_path: Path, keys: set[str]) -> list[str]:
    with catalog_path.open(encoding="utf-8") as catalog_file:
        catalog = json.load(catalog_file)

    return sorted(keys.difference(catalog))


def main() -> int:
    keys = source_keys()
    catalog_paths = sorted(TRANSLATION_ROOT.glob("local_strings_*.json"))
    failures = False

    for catalog_path in catalog_paths:
        if catalog_path.stem == "local_strings_en_US":
            continue

        missing_keys = check_catalog(catalog_path, keys)
        if missing_keys:
            failures = True
            print(f"{catalog_path.name} is missing {len(missing_keys)} key(s):")
            print("\n".join(f"  {key}" for key in missing_keys))

    if failures:
        return 1

    print(f"All {len(keys)} static localization keys are covered.")
    return 0


if __name__ == "__main__":
    sys.exit(main())