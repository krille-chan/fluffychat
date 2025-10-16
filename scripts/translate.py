"""
Prerequiresite:
- Ensure you have an up-to-date `needed-translations.txt` file should you wish to translate only the missing translation keys. To generate an updated `needed-translations.txt` file, run:
```
flutter gen-l10n
```

- Ensure you have python `openai` package installed. If not, run:
```
pip install openai
```

- Ensure you have an OpenAI API key set in your environment variable `OPENAI_API_KEY`. If not, you can set it by running:
```
export OPENAI_API_KEY=your-api-key
```

- Ensure vi language translations are up-to-date. This script uses en->vi translations as an example on how to translate so it is necessary. If not, you can run:
```
python scripts/translate.py --lang vi --lang-display-name "Vietnamese" --mode append
```

3 modes:
- append mode (default): translate only the missing translation keys
- upsert mode (not implemented): translate everything (all keys from English)
- update mode (not implemented): specify keys to translate and update their metadata

Usage:
python scripts/translate.py
"""

import argparse
import json
import random
from collections import OrderedDict
from datetime import datetime
from pathlib import Path
from typing import Any

from openai import OpenAI

l10n_dir = Path(__file__).parent.parent / "lib" / "l10n"


def load_all_keys() -> list[str]:
    """
    Load all translation keys from intl_en.arb file.
    """
    path_to_en_translations = l10n_dir / "intl_en.arb"
    if not path_to_en_translations.exists():
        raise FileNotFoundError(
            f"File not found: {path_to_en_translations}. Please run `flutter gen-l10n` to generate the file."
        )
    with open(path_to_en_translations, encoding="utf-8") as f:
        translations = json.loads(f.read())
    return [key for key in translations.keys() if not key.startswith("@")]


def load_needed_translations() -> dict[str, list[str]]:
    path_to_needed_translations = (
        Path(__file__).parent.parent / "needed-translations.txt"
    )
    if not path_to_needed_translations.exists():
        raise FileNotFoundError(
            f"File not found: {path_to_needed_translations}. Please run `flutter gen-l10n` to generate the file."
        )
    with open(path_to_needed_translations, encoding="utf-8") as f:
        needed_translations = json.loads(f.read())

    supported_langs = load_supported_languages()
    all_keys = load_all_keys()
    for lang_code, _ in supported_langs:
        if lang_code not in needed_translations:
            needed_translations[lang_code] = all_keys

    return needed_translations


def load_translations(lang_code: str) -> dict[str, str]:
    path_to_translations = l10n_dir / f"intl_{lang_code}.arb"
    if not path_to_translations.exists():
        translations = {}
    else:
        with open(path_to_translations, encoding="utf-8") as f:
            translations = json.loads(f.read())

    return translations


def save_translations(lang_code: str, translations: dict[str, str]) -> None:

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
    translation_keys: list[str],
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
                    .get(placeholder_name, {})
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


def append_translate(lang_code: str, lang_display_name: str) -> None:
    """
    Translate the needed translations from English to the target language.
    """

    needed_translations = load_needed_translations()
    needed_translations = needed_translations.get(lang_code, [])
    english_translations_dict = load_translations("en")
    vietnamese_translations_dict = load_translations("vi")

    # there are 3 types of translation keys: basic, with placeholders, with pluralization. Read more: TRANSLATORS_GUIDE.md

    basic_translation_keys = [
        k
        for k in english_translations_dict.keys()
        if not k.startswith("@") and not english_translations_dict[k].startswith("{")
    ]
    example_basic_translation_keys = (
        random.sample(basic_translation_keys, 2)
        if len(basic_translation_keys) > 2
        else basic_translation_keys
    )

    placeholder_translation_keys = [
        k
        for k in english_translations_dict.keys()
        if not k.startswith("@")
        and "{" in english_translations_dict[k]
        and "plural," not in english_translations_dict[k]
        and "other{" not in english_translations_dict[k]
    ]
    example_placeholder_translation_keys = (
        random.sample(placeholder_translation_keys, 2)
        if len(placeholder_translation_keys) > 2
        else placeholder_translation_keys
    )
    plural_translation_keys = [
        k
        for k in english_translations_dict.keys()
        if not k.startswith("@")
        and "{" in english_translations_dict[k]
        and "plural," in english_translations_dict[k]
        and "other{" in english_translations_dict[k]
    ]
    example_plural_translation_keys = (
        random.sample(plural_translation_keys, 2)
        if len(plural_translation_keys) > 2
        else plural_translation_keys
    )

    # build example translations
    example_english_translations = {}
    for key in example_basic_translation_keys:
        example_english_translations[key] = english_translations_dict[key]
    for key in example_placeholder_translation_keys:
        example_english_translations[key] = english_translations_dict[key]
    for key in example_plural_translation_keys:
        example_english_translations[key] = english_translations_dict[key]

    example_vietnamese_translations = {}
    for key in example_basic_translation_keys:
        example_vietnamese_translations[key] = vietnamese_translations_dict[key]
    for key in example_placeholder_translation_keys:
        example_vietnamese_translations[key] = vietnamese_translations_dict[key]
    for key in example_plural_translation_keys:
        example_vietnamese_translations[key] = vietnamese_translations_dict[key]

    new_translations = {}
    progress = 0
    for i in range(0, len(needed_translations), 20):
        chunk = needed_translations[i : i + 20]
        translation_requests = {}
        for key in chunk:
            translation_requests[key] = english_translations_dict[key]

        prompt = f"""
        Please translate the following text from English to {lang_display_name}.
        Example:
        req: {json.dumps(example_english_translations, indent=2)}
        res: {json.dumps(example_vietnamese_translations, indent=2)}
        ========================
        req: {json.dumps(translation_requests, indent=2)}
        res:
        """

        client = OpenAI()
        chat_completion = client.chat.completions.create(
            messages=[
                {
                    "role": "system",
                    "content": "You are a translator that will only response to translation requests in json format without any additional information.",
                },
                {
                    "role": "user",
                    "content": prompt,
                },
            ],
            model="gpt-4.1-nano",
            temperature=0.0,
        )
        response = chat_completion.choices[0].message.content

        # Try to parse JSON with error handling and retry logic
        max_retries = 3
        retry_count = 0
        _new_translations = None
        messages = [
            {
                "role": "system",
                "content": "You are a translator that will only response to translation requests in json format without any additional information.",
            },
            {
                "role": "user",
                "content": prompt,
            },
            {
                "role": "assistant",
                "content": response,
            },
        ]

        while retry_count < max_retries and _new_translations is None:
            try:
                # Try to clean up common JSON formatting issues first
                cleaned_response = response.strip()
                if cleaned_response.startswith("```json"):
                    cleaned_response = cleaned_response[7:]
                if cleaned_response.endswith("```"):
                    cleaned_response = cleaned_response[:-3]
                cleaned_response = cleaned_response.strip()

                _new_translations = json.loads(cleaned_response)
                break
            except json.JSONDecodeError as e:
                retry_count += 1
                print(f"JSON parsing error (attempt {retry_count}/{max_retries}): {e}")
                print(f"Problematic response: {response[:200]}...")

                if retry_count < max_retries:
                    print("Asking LLM to fix the JSON error...")

                    # Append the error to the conversation and ask LLM to resolve it
                    error_message = f"The previous response caused a JSON parsing error: {str(e)}. The response was: {response}\n\nPlease provide a corrected response that is valid JSON format only, without any markdown formatting or additional text."

                    messages.append(
                        {
                            "role": "user",
                            "content": error_message,
                        }
                    )

                    chat_completion = client.chat.completions.create(
                        messages=messages,
                        model="gpt-4.1-nano",
                        temperature=0.0,
                        max_tokens=8000,
                    )
                    response = chat_completion.choices[0].message.content

                    # Add the new response to the conversation
                    messages.append(
                        {
                            "role": "assistant",
                            "content": response,
                        }
                    )

        if _new_translations is None:
            print(
                f"Failed to parse JSON after {max_retries} attempts. Skipping chunk {i//20 + 1}"
            )
            progress += len(chunk)
            continue

        new_translations.update(_new_translations)
        print(f"Translated {progress + len(chunk)}/{len(needed_translations)}")
        progress += len(chunk)

    # save translations
    current_translations = load_translations(lang_code)
    current_translations.update(new_translations)
    save_translations(lang_code, current_translations)

    # reconcile metadata
    reconcile_metadata(lang_code, needed_translations, english_translations_dict)


def load_supported_languages() -> list[tuple[str, str]]:
    """
    Load the supported languages from the languages.json file.
    """
    with open("languages.json", "r", encoding="utf-8") as f:
        raw_languages = json.load(f)
    languages: list[tuple[str, str]] = []
    for lang in raw_languages:
        assert isinstance(lang, dict), "Each language entry must be a dictionary."
        language_code = lang.get("language_code", None)
        language_name = lang.get("language_name", None)
        assert (
            language_code and language_name
        ), f"Each language must have a 'language_code' and 'language_name'. Found: {lang}"
        languages.append((language_code, language_name))
    return languages


"""
python scripts/translate.py --lang vi --lang-display-name "Vietnamese" --mode append

python scripts/translate.py --translate-all --mode append
"""
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Translate app strings.")

    parser.add_argument(
        "--lang",
        type=str,
        help="Language code to translate to (e.g. 'vi' for Vietnamese, 'en' for English).",
    )

    parser.add_argument(
        "--lang-display-name",
        type=str,
        help="Display name of the language (e.g. 'Vietnamese', 'English').",
    )

    parser.add_argument(
        "--mode",
        type=str,
        choices=["append", "upsert", "update"],
        default="append",
        help="Mode of translation: 'append' to translate only missing keys, 'upsert' to translate all keys, 'update' to specify keys to translate and update their metadata.",
    )

    parser.add_argument(
        "--translate-all",
        action="store_true",
        help="Translate all keys (overrides the mode).",
    )

    args = parser.parse_args()

    translate_all = args.translate_all

    lang_code = args.lang

    lang_display_name = args.lang_display_name

    mode = args.mode

    if not translate_all:
        assert (
            args.lang
        ), "Language code is required if translate all is not set. Use --lang to specify the language code."
        assert (
            args.lang_display_name
        ), "Language display name is required if translate all is not set. Use --lang-display-name to specify the language display name."

    if mode == "append":
        if not translate_all:
            append_translate(
                lang_code=lang_code,
                lang_display_name=lang_display_name,
            )
        else:
            languages = load_supported_languages()
            for i, (lang_code, lang_display_name) in enumerate(languages):
                print(f"Translating {i + 1}/{len(languages)}: {lang_display_name}")
                append_translate(
                    lang_code=lang_code,
                    lang_display_name=lang_display_name,
                )
    else:
        raise NotImplementedError(
            f"Mode '{mode}' is not implemented yet. Please use 'append' mode for now."
        )
