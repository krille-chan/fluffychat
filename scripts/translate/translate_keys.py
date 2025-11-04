#!/usr/bin/env python3
"""
Translate a specific set of keys in the ARB files.

This script accepts a list of keys and:
1. Finds the value in the source ARB file (intl_en.arb)
2. Finds each instance of the value in the target ARB files (intl_*.arb)
3. Translates the value using OpenAI (reusing translate.py model)
4. Replaces the value in the target ARB files with the translated value

Usage:
    python translate_keys.py --keys key1 key2 key3
    python translate_keys.py --keys-file keys.txt


WARNING: Has not been tested extensively. Has not been tested with pluralization or
complex placeholders. Verify results before committing.
"""

import argparse
import sys
from pathlib import Path
from typing import Any, List

try:
    from openai import OpenAI
except ImportError:
    print("Error: openai package not found. Please install it with: pip install openai")
    sys.exit(1)

# We'll implement all necessary functions locally to avoid path issues

# Get the client root directory (where this script is run from when called as module)
client_root = (
    Path.cwd() if Path.cwd().name == "client" else Path(__file__).parent.parent.parent
)
l10n_dir = client_root / "lib" / "l10n"


def load_translations(lang_code: str) -> dict[str, str]:
    """Load translations for a language code using the correct path."""
    import json

    path_to_translations = l10n_dir / f"intl_{lang_code}.arb"
    if not path_to_translations.exists():
        translations = {}
    else:
        with open(path_to_translations, encoding="utf-8") as f:
            translations = json.loads(f.read())

    return translations


def load_supported_languages() -> List[tuple[str, str]]:
    """Load the supported languages from the languages.json file with correct path."""
    import json

    languages_path = client_root / "scripts" / "languages.json"
    with open(languages_path, "r", encoding="utf-8") as f:
        raw_languages = json.load(f)

    languages: List[tuple[str, str]] = []
    for lang in raw_languages:
        assert isinstance(lang, dict), "Each language entry must be a dictionary."
        language_code = lang.get("language_code", None)
        language_name = lang.get("language_name", None)
        assert (
            language_code and language_name
        ), f"Each language must have a 'language_code' and 'language_name'. Found: {lang}"
        languages.append((language_code, language_name))
    return languages


def save_translations(lang_code: str, translations: dict[str, str]) -> None:
    """Save translations for a language code using the correct path."""
    import json
    from collections import OrderedDict
    from datetime import datetime

    path_to_translations = l10n_dir / f"intl_{lang_code}.arb"

    translations["@@locale"] = lang_code
    translations["@@last_modified"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")

    # Load existing data to preserve order if exists.
    if path_to_translations.exists():
        with open(path_to_translations, "r", encoding="utf-8") as f:
            try:
                existing_data = json.load(f, object_pairs_hook=OrderedDict)
            except json.JSONDecodeError:
                existing_data = OrderedDict()
    else:
        existing_data = OrderedDict()

    # Update existing keys and append new keys (preserving existing order).
    for key, value in translations.items():
        if key in existing_data:
            existing_data[key] = value  # update value; order remains unchanged
        else:
            existing_data[key] = value  # new key appended at the end

    with open(path_to_translations, "w", encoding="utf-8") as f:
        f.write(json.dumps(existing_data, indent=2, ensure_ascii=False))


def reconcile_metadata(
    lang_code: str,
    translation_keys: List[str],
    english_translations_dict: dict[str, Any],
) -> None:
    """
    For each translation key, update its metadata (the key prefixed with '@') by merging
    any existing metadata with computed metadata. For basic translations, if no metadata exists,
    add it; otherwise, leave it as is.
    """
    translations = load_translations(lang_code)

    for key in translation_keys:
        # Skip keys that weren't successfully translated
        if key not in translations:
            continue

        translation = translations[key]
        meta_key = f"@{key}"
        existing_meta = translations.get(meta_key, {})
        assert isinstance(translation, str)

        # Case 1: Basic translations, no placeholders.
        if "{" not in translation:
            if not existing_meta:
                translations[meta_key] = {"type": "String", "placeholders": {}}
            # if metadata exists, leave it as is.

        # Case 2: Translations with placeholders (no pluralization).
        elif (
            "{" in translation
            and "plural," not in translation
            and "other{" not in translation
        ):
            # Compute placeholders.
            computed_placeholders = {}
            for placeholder in translation.split("{")[1:]:
                placeholder_name = placeholder.split("}")[0]
                computed_placeholders[placeholder_name] = {}
                # Obtain placeholder type from english translation or default to {}
                placeholder_type = (
                    english_translations_dict.get(meta_key, {})
                    .get("placeholders", {})
                    .get(placeholder_name, {})
                    .get("type")
                )
                if placeholder_type:
                    computed_placeholders[placeholder_name]["type"] = placeholder_type
            if existing_meta:
                # Merge computed placeholders into existing metadata.
                existing_meta.setdefault("type", "String")
                existing_meta["placeholders"] = computed_placeholders
                translations[meta_key] = existing_meta
            else:
                # Obtain type from english translation or default to "String".
                translation_type = english_translations_dict.get(meta_key, {}).get(
                    "type", "String"
                )
                translations[meta_key] = {
                    "type": translation_type,
                    "placeholders": computed_placeholders,
                }

        # Case 3: Translations with pluralization.
        elif (
            "{" in translation and "plural," in translation and "other{" in translation
        ):
            # Extract placeholders appearing before the plural part.
            prefix = translation.split("plural,")[0].split("{")[1]
            placeholders_list = [
                p.strip() for p in prefix.split(",") if p.strip() != ""
            ]
            computed_placeholders = {ph: {} for ph in placeholders_list}
            for ph in placeholders_list:
                # Obtain placeholder type from english translation or default to {}
                placeholder_type = (
                    english_translations_dict.get(meta_key, {})
                    .get("placeholders", {})
                    .get(ph, {})
                    .get("type")
                )
                if placeholder_type:
                    computed_placeholders[ph]["type"] = placeholder_type
            if existing_meta:
                existing_meta.setdefault("type", "String")
                existing_meta["placeholders"] = computed_placeholders
                translations[meta_key] = existing_meta
            else:
                # Obtain type from english translation or default to "String".
                translation_type = english_translations_dict.get(meta_key, {}).get(
                    "type", "String"
                )
                translations[meta_key] = {
                    "type": "String",
                    "placeholders": computed_placeholders,
                }

    save_translations(lang_code, translations)


def get_all_target_language_files() -> List[Path]:
    """Get all target ARB files (excluding intl_en.arb)."""
    arb_files = list(l10n_dir.glob("intl_*.arb"))
    # Filter out the English source file
    return [f for f in arb_files if f.name != "intl_en.arb"]


def extract_language_code_from_filename(arb_path: Path) -> str:
    """Extract language code from ARB filename (e.g., intl_es.arb -> es)."""
    filename = arb_path.stem  # Get filename without extension
    return filename.replace("intl_", "")


def translate_batch_with_openai(
    translation_requests: dict[str, str],
    target_language: str,
    source_language: str = "English",
) -> dict[str, str]:
    """
    Translate a batch of texts using OpenAI API.

    Args:
        translation_requests: Dictionary of {key: text} to translate
        target_language: Target language name (e.g., "Spanish", "French")
        source_language: Source language name (default: "English")

    Returns:
        Dictionary of {key: translated_text}
    """
    import json

    client = OpenAI()

    # Create a batch translation prompt
    prompt = f"""
    Translate the following JSON object from {source_language} to {target_language}.
    Preserve any placeholders (text within curly braces like {{username}}) exactly as they are.
    Preserve any special formatting or ICU message format syntax.
    Return only a JSON object with the same keys but translated values.
    
    JSON to translate: {json.dumps(translation_requests, indent=2)}
    """

    try:
        chat_completion = client.chat.completions.create(
            messages=[
                {
                    "role": "system",
                    "content": "You are a professional translator. You translate text accurately while preserving any placeholders and special formatting. Always respond with valid JSON only.",
                },
                {
                    "role": "user",
                    "content": prompt,
                },
            ],
            model="gpt-4o-mini",
            temperature=0.0,
        )

        response = chat_completion.choices[0].message.content.strip()

        # Clean up common JSON formatting issues
        if response.startswith("```json"):
            response = response[7:]
        if response.endswith("```"):
            response = response[:-3]
        response = response.strip()

        # Parse the JSON response
        translated_batch = json.loads(response)
        return translated_batch

    except json.JSONDecodeError as e:
        print(f"JSON parsing error when translating batch to {target_language}: {e}")
        print(f"Response was: {response[:200]}...")
        # Fallback to original texts if parsing fails
        return translation_requests
    except (ConnectionError, TimeoutError) as e:
        print(f"Network error translating batch to {target_language}: {e}")
        return translation_requests  # Return original texts if translation fails
    except ValueError as e:
        print(f"API error translating batch to {target_language}: {e}")
        return translation_requests  # Return original texts if translation fails


def get_language_display_name(lang_code: str) -> str:
    """Get the display name for a language code."""
    supported_languages = load_supported_languages()
    for code, display_name in supported_languages:
        if code == lang_code:
            return display_name

    # Fallback mapping for common language codes
    fallback_names = {
        "es": "Spanish",
        "fr": "French",
        "de": "German",
        "it": "Italian",
        "pt": "Portuguese",
        "pt_PT": "Portuguese",
        "ja": "Japanese",
        "ko": "Korean",
        "zh": "Chinese",
        "zh_Hant": "Traditional Chinese",
        "ru": "Russian",
        "ar": "Arabic",
        "hi": "Hindi",
        "nl": "Dutch",
        "sv": "Swedish",
        "da": "Danish",
        "no": "Norwegian",
        "nb": "Norwegian",
        "fi": "Finnish",
        "pl": "Polish",
        "cs": "Czech",
        "sk": "Slovak",
        "hu": "Hungarian",
        "ro": "Romanian",
        "bg": "Bulgarian",
        "hr": "Croatian",
        "sl": "Slovenian",
        "et": "Estonian",
        "lv": "Latvian",
        "lt": "Lithuanian",
        "el": "Greek",
        "tr": "Turkish",
        "th": "Thai",
        "vi": "Vietnamese",
        "id": "Indonesian",
        "ms": "Malay",
        "fil": "Filipino",
        "he": "Hebrew",
        "uk": "Ukrainian",
        "be": "Belarusian",
        "ca": "Catalan",
        "gl": "Galician",
        "eu": "Basque",
    }

    return fallback_names.get(lang_code, lang_code.title())


def translate_keys(keys_to_translate: List[str]) -> None:
    """
    Translate specific keys in all target ARB files using batch translation.

    Args:
        keys_to_translate: List of keys to translate
    """
    # Load English translations (source)
    english_translations = load_translations("en")

    # Validate that all keys exist in English
    missing_keys = [key for key in keys_to_translate if key not in english_translations]
    if missing_keys:
        print(
            f"Error: The following keys were not found in intl_en.arb: {missing_keys}"
        )
        return

    # Filter out metadata keys
    keys_to_translate = [key for key in keys_to_translate if not key.startswith("@")]

    # Get all target ARB files
    target_files = get_all_target_language_files()

    print(f"Found {len(target_files)} target language files")
    print(f"Translating {len(keys_to_translate)} keys: {keys_to_translate}")

    # Process keys in batches of 10
    batch_size = 10

    for arb_file in target_files:
        lang_code = extract_language_code_from_filename(arb_file)
        lang_display_name = get_language_display_name(lang_code)

        print(f"\nProcessing {lang_display_name} ({lang_code})...")

        # Load current translations for this language
        current_translations = load_translations(lang_code)

        # Track which keys were actually updated
        updated_keys = []

        # Process keys in batches
        for i in range(0, len(keys_to_translate), batch_size):
            batch = keys_to_translate[i : i + batch_size]

            # Prepare translation requests for this batch
            translation_requests = {}
            for key in batch:
                english_text = english_translations[key]
                translation_requests[key] = english_text

            print(
                f"  Translating batch {i//batch_size + 1} ({len(batch)} keys): {batch}"
            )

            # Translate the batch
            translated_batch = translate_batch_with_openai(
                translation_requests, lang_display_name
            )

            # Update translations and track updated keys
            for key in batch:
                if key in translated_batch:
                    translated_text = translated_batch[key]
                    current_translations[key] = translated_text
                    updated_keys.append(key)
                    print(
                        f"    {key}: '{english_translations[key]}' -> '{translated_text}'"
                    )
                else:
                    print(f"    Warning: Key '{key}' not found in translation response")

        # Save the updated translations
        if updated_keys:
            save_translations(lang_code, current_translations)

            # Reconcile metadata for updated keys
            reconcile_metadata(lang_code, updated_keys, english_translations)

            print(f"  ✓ Updated {len(updated_keys)} keys in {lang_code}")
        else:
            print(f"  - No keys updated in {lang_code}")


def read_keys_from_file(file_path: Path) -> List[str]:
    """Read keys from a text file (one key per line)."""
    if not file_path.exists():
        raise FileNotFoundError(f"Keys file not found: {file_path}")

    with open(file_path, "r", encoding="utf-8") as f:
        keys = [
            line.strip()
            for line in f
            if line.strip() and not line.strip().startswith("#")
        ]

    return keys


def main():
    parser = argparse.ArgumentParser(
        description="Translate specific keys in ARB files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
    Examples:
  python translate_keys.py --keys about accept account
  python -m scripts.translate.translate_keys.py --keys-file scripts.translate.keys_to_translate.txt
        """,
    )

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--keys", nargs="+", help="List of keys to translate")
    group.add_argument(
        "--keys-file",
        type=Path,
        help="File containing keys to translate (one per line)",
    )

    args = parser.parse_args()

    # Get the keys to translate
    if args.keys:
        keys_to_translate = args.keys
    else:
        keys_to_translate = read_keys_from_file(args.keys_file)

    if not keys_to_translate:
        print("Error: No keys to translate")
        sys.exit(1)

    # Change to the client directory so relative paths work
    original_cwd = Path.cwd()
    client_dir = Path(__file__).parent.parent.parent

    try:
        import os

        os.chdir(client_dir)
        translate_keys(keys_to_translate)
    finally:
        os.chdir(original_cwd)

    print("\n✓ Translation complete!")


if __name__ == "__main__":
    main()
