"""
Prerequiresite:
- Ensure you have an up-to-date `needed-translations.txt` file should you wish to translate only the missing translation keys. To generate an updated `needed-translations.txt` file, run `flutter gen-l10n`
- Ensure you have python `openai` package installed. If not, run `pip install openai`.
- Ensure you have an OpenAI API key set in your environment variable `OPENAI_API_KEY`. If not, you can set it by running `export OPENAI_API_KEY=your-api-key` on MacOS/Linux.

Usage:
python scripts/translate.py
"""


def load_needed_translations() -> dict[str, list[str]]:
    import json
    from pathlib import Path

    path_to_needed_translations = (
        Path(__file__).parent.parent / "needed-translations.txt"
    )
    if not path_to_needed_translations.exists():
        raise FileNotFoundError(
            f"File not found: {path_to_needed_translations}. Please run `flutter gen-l10n` to generate the file."
        )
    with open(path_to_needed_translations) as f:
        needed_translations = json.loads(f.read())

    return needed_translations


def load_translations(lang_code: str) -> dict[str, str]:
    import json
    from pathlib import Path

    path_to_translations = (
        Path(__file__).parent.parent / "assets" / "l10n" / f"intl_{lang_code}.arb"
    )
    if not path_to_translations.exists():
        raise FileNotFoundError(
            f"File not found: {path_to_translations}. Please run `flutter gen-l10n` to generate the file."
        )

    with open(path_to_translations) as f:
        translations = json.loads(f.read())

    return translations


def save_translations(lang_code: str, translations: dict[str, str]) -> None:
    import json
    from collections import OrderedDict
    from datetime import datetime
    from pathlib import Path

    path_to_translations = (
        Path(__file__).parent.parent / "assets" / "l10n" / f"intl_{lang_code}.arb"
    )

    translations["@@locale"] = lang_code
    translations["@@last_modified"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S.%f")

    # Load existing data to preserve order if exists.
    if path_to_translations.exists():
        with open(path_to_translations, "r") as f:
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

    with open(path_to_translations, "w") as f:
        f.write(json.dumps(existing_data, indent=2, ensure_ascii=False))


def reconcile_metadata(lang_code: str, translation_keys: list[str]) -> None:
    """
    For each translation key, update its metadata (the key prefixed with '@') by merging
    any existing metadata with computed metadata. For basic translations, if no metadata exists,
    add it; otherwise, leave it as is.
    """
    translations = load_translations(lang_code)

    for key in translation_keys:
        translation = translations[key]
        meta_key = f"@{key}"
        existing_meta = translations.get(meta_key, {})
        assert isinstance(translation, str)

        # Case 1: Basic translations, no placeholders.
        if "{" not in translation:
            if not existing_meta:
                translations[meta_key] = {"type": "text", "placeholders": {}}
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
            if existing_meta:
                # Merge computed placeholders into existing metadata.
                existing_meta.setdefault("type", "text")
                existing_meta["placeholders"] = computed_placeholders
                translations[meta_key] = existing_meta
            else:
                translations[meta_key] = {
                    "type": "text",
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
            if existing_meta:
                existing_meta.setdefault("type", "text")
                existing_meta["placeholders"] = computed_placeholders
                translations[meta_key] = existing_meta
            else:
                translations[meta_key] = {
                    "type": "text",
                    "placeholders": computed_placeholders,
                }

    save_translations(lang_code, translations)


def translate(lang_code: str, lang_display_name: str) -> None:
    """
    Translate the needed translations from English to the target language.
    """
    import json
    import random

    from openai import OpenAI

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
            model="gpt-4o-mini",
            temperature=0.0,
        )
        response = chat_completion.choices[0].message.content
        _new_translations = json.loads(response)
        new_translations.update(_new_translations)
        print(f"Translated {progress + len(chunk)}/{len(needed_translations)}")
        progress += len(chunk)

    # save translations
    current_translations = load_translations(lang_code)
    current_translations.update(new_translations)
    save_translations(lang_code, current_translations)

    # reconcile metadata
    reconcile_metadata(lang_code, needed_translations)


"""Example usage:
python scripts/translate.py
"""
if __name__ == "__main__":
    lang_code = input("Enter the language code (e.g. vi, en): ").strip()
    lang_display_name = input(
        "Enter the language display name (e.g. Vietnamese, English): "
    )
    translate(
        lang_code=lang_code,
        lang_display_name=lang_display_name,
    )
