#!/usr/bin/env python3
"""
Script to run translations for all languages that need translation keys.
This script reads needed-translations.txt and runs the translate.py script for each language.
"""

import json
import subprocess
import sys
from pathlib import Path


def load_language_mappings():
    """Load language code to display name mappings."""
    # First, load from languages.json
    languages_file = Path("languages.json")
    if not languages_file.exists():
        print("Error: languages.json not found")
        sys.exit(1)

    with open(languages_file, "r", encoding="utf-8") as f:
        languages = json.load(f)

    # Create mapping from languages.json
    lang_mapping = {}
    for lang in languages:
        lang_mapping[lang["language_code"]] = lang["language_name"]

    # Add manual mappings for codes not in languages.json
    manual_mappings = {
        "bo": "Tibetan",
        "ia": "Interlingua",
        "ie": "Interlingue",
        "pt_BR": "Portuguese (Brazil)",
        "pt_PT": "Portuguese (Portugal)",
        "zh_Hant": "Chinese (Traditional)",
    }

    lang_mapping.update(manual_mappings)
    return lang_mapping


def load_needed_translations():
    """Load the languages that need translation."""
    needed_file = Path("../needed-translations.txt")
    if not needed_file.exists():
        print("Error: needed-translations.txt not found")
        print("Please run 'flutter gen-l10n' first to generate this file")
        sys.exit(1)

    with open(needed_file, "r", encoding="utf-8") as f:
        return json.load(f)


def run_translation(lang_code, lang_name):
    """Run translation for a specific language."""
    print(f"\n{'='*60}")
    print(f"Translating {lang_code}: {lang_name}")
    print(f"{'='*60}")

    try:
        # Run the translation script using .venv
        cmd = [
            "../.venv/bin/python",
            "translate.py",
            "--lang",
            lang_code,
            "--lang-display-name",
            lang_name,
            "--mode",
            "append",
        ]

        print(f"Running: {' '.join(cmd)}")
        # Pass environment variables including OPENAI_API_KEY
        import os

        env = os.environ.copy()
        subprocess.run(cmd, check=True, capture_output=False, text=True, env=env)
        print(f"✅ Successfully translated {lang_code}")
        return True

    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to translate {lang_code}: {e}")
        return False
    except FileNotFoundError as e:
        print(f"❌ Error translating {lang_code}: {e}")
        return False


def verify_translations():
    """Verify translations by running flutter gen-l10n and checking needed-translations.txt."""
    print(f"\n{'='*60}")
    print("Verifying translations by regenerating needed-translations.txt")
    print(f"{'='*60}")

    try:
        # Run flutter gen-l10n to regenerate needed-translations.txt
        subprocess.run(
            ["flutter", "gen-l10n"], check=True, capture_output=True, text=True
        )
        print("✅ Successfully ran flutter gen-l10n")

        # Check the updated needed-translations.txt
        with open("needed-translations.txt", "r", encoding="utf-8") as f:
            updated_needed = json.load(f)

        remaining_langs = list(updated_needed.keys())
        if remaining_langs:
            print(f"⚠️ Languages still needing translation: {remaining_langs}")
            for lang in remaining_langs:
                count = len(updated_needed[lang])
                print(f"  - {lang}: {count} keys remaining")
        else:
            print("🎉 All languages have been translated!")

    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to run flutter gen-l10n: {e}")
        if e.stdout:
            print("STDOUT:", e.stdout)
        if e.stderr:
            print("STDERR:", e.stderr)


def main():
    """Main function to run translations for all needed languages."""
    print("Starting translation process for all languages...")

    # Change to the project directory
    project_dir = Path(__file__).parent
    import os

    os.chdir(project_dir)

    # Load mappings and needed translations
    lang_mapping = load_language_mappings()
    needed_translations = load_needed_translations()

    needed_langs = list(needed_translations.keys())
    print(f"\nFound {len(needed_langs)} languages needing translation:")
    for lang_code in sorted(needed_langs):
        lang_name = lang_mapping.get(lang_code, f"Unknown ({lang_code})")
        key_count = len(needed_translations[lang_code])
        print(f"  - {lang_code}: {lang_name} ({key_count} keys)")

    # Ask for confirmation
    response = input(
        f"\nProceed with translating all {len(needed_langs)} languages? (y/N): "
    )
    if response.lower() not in ["y", "yes"]:
        print("Translation cancelled.")
        sys.exit(0)

    # Run translations
    successful = 0
    failed = 0

    for i, lang_code in enumerate(sorted(needed_langs), 1):
        lang_name = lang_mapping.get(lang_code, f"Unknown ({lang_code})")
        print(f"\n[{i}/{len(needed_langs)}] Processing {lang_code}...")

        if run_translation(lang_code, lang_name):
            successful += 1
        else:
            failed += 1

    # Summary
    print(f"\n{'='*60}")
    print("TRANSLATION SUMMARY")
    print(f"{'='*60}")
    print(f"✅ Successful: {successful}")
    print(f"❌ Failed: {failed}")
    print(f"📊 Total: {successful + failed}")

    if successful > 0:
        print("\nRunning verification...")
        verify_translations()


if __name__ == "__main__":
    main()
