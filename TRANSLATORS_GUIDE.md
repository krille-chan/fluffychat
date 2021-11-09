# Translators Guide

There are 3 main types of strings to be translated.

## Simple
```
Add new friend
```
They are just plain text and are to be translated in full.

## Placeholder
```
{username} changed their avatar
```
Contains one or more words surrounded by curly brackets "`{}`" anything outside of the curly brackets is to be translated as normal but the words in the curly brackets are **NOT** to be translated. In the above example "`{username}`" will be replaced by the users actual username by fluffychat.

## Plural

- {count,plural, =1{**1 more event**} other{{count} **more events**}}

This is the most complicated string type, the parts in bold are the only parts that need translating in this string. You can identify plural strings by seeing the pattern `{word,plural,` at the start. `=1` and `other` are "selectors" so you can have multiple different translations for different quantities `other` is the only required selector and will be chosen if the count does not match any other selectors.

Selector | Matches
---|---
=0 | a count of exactly 0
=1 | a count of exactly 1
=2 | a count of exactly 2
other | any number unless it matches a more specific rule

There is also "few" and "many" but they seem to have language specific meaning.

Also the selectors do not need to match the english version such as your language may not even use different words for when there is more than one of something so:
 - {count,plural, other{{count} \<insert translation here\>}} 

could be a perfectly resonable way to translate.
