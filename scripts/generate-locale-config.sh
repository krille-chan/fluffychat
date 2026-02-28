#!/bin/bash

# Directory containing the ARB files
l10n_dir="./lib/l10n"
# Target directory for the locale_config.xml file
xml_dir="./android/app/src/main/res/xml"

# Create the target directory if it does not exist
mkdir -p "$xml_dir"

# Output file name
xml_file="$xml_dir/locale_config.xml"

rm -rf "$xml_file"

# XML Header
echo '<?xml version="1.0" encoding="utf-8"?>' > "$xml_file"
echo '<locale-config xmlns:android="http://schemas.android.com/apk/res/android">' >> "$xml_file"

# Search for ARB files and extract language codes
for file in "$l10n_dir"/intl_*.arb; do
  # Extract language code
  language_code=$(basename "$file" | cut -d'_' -f2 | cut -d'.' -f1)
  # Write language code to the XML file
  echo "    <locale android:name=\"$language_code\"/>" >> "$xml_file"
done

# XML Footer
echo '</locale-config>' >> "$xml_file"

echo "locale_config.xml file has been successfully created in the $xml_dir directory."
