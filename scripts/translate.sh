#!/bin/bash

# 1. Define DeepL credentials
DEEPL_AUTH_KEY=$(awk -F "=" '/DEEPL_AUTH_KEY/ {print $2}' ./.credentials)
DEEPL_API_URL="https://api.deepl.com/v2/translate"
TARGET_LANG="es"

# 2. Extract missing translation keys
MISSING_KEYS=$(jq -r '.es[]' ../needed-translations.txt)

# 3. Get English copy for missing keys and translate them
for key in $MISSING_KEYS; do
  EN_COPY=$(jq -r ".[\"$key\"]" ../assets/l10n/intl_en.arb)

  # 4. Call DeepL for the translations
  TRANSLATED_TEXT=$(curl -s -X POST "${DEEPL_API_URL}" \
    -H "Authorization: DeepL-Auth-Key ${DEEPL_AUTH_KEY}" \
    -d "text=${EN_COPY}" \
    -d "target_lang=${TARGET_LANG}" | jq -r '.translations[0].text')

  # 5. Save them to the Spanish translation file
  jq ".[\"$key\"] = \"$TRANSLATED_TEXT\"" ../assets/l10n/intl_es.arb > temp.json && mv temp.json ../assets/l10n/intl_$TARGET_LANG.arb
  echo "Translated $key: $TRANSLATED_TEXT"
done

echo "Translations saved to ../assets/l10n/intl_$TARGET_LANG.arb"