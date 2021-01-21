# How to create your own FluffyChat fork

## 1. License
FluffyChat is licensed under AGPL. Read the license
(https://gitlab.com/ChristianPauly/fluffychat-flutter/-/blob/main/LICENSE) and 
make sure that your fork is open source under the same license and that you
fulfill all requirements. Maybe you should consider contacting a lawyer **before**
you publish your fork.

## 2. Disable end-to-end encryption!
Due to US export regulations you are not allowed to publish your app in
a store or anywhere on a US server before you have removed everything regarding
the encryption or fulfill the regulations. This means you have to remove:

* Olm/Megolm end-to-end encryption
* The sqlcipher database encryption
* File encryption

Learn more:
https://www.bis.doc.gov/index.php/policy-guidance/encryption

If you need help from us with using E2EE in your fork read more below under the 
topic "**Official Support and Pricing**".

## 3. Stay up to date!
FluffyChat contains security related stuff. If we find a security bug, we will
try to fix it as soon as possible and ship it with a new version. But this
means that your fork is out of date and a security risk. You can't be awake
24 hours a day so you must decide how you protect your users by chosing one
of the following methods:

1. Make your fork as minimal as possible and enable repository mirroring. Set
up a CI which publishes new versions automatically if FluffyChat publishes a
bug fix.
2. Never sleep and pay a big team where one guy at least is never sleeping.
3. Contact [famedly.com](https://famedly.com) to buy official support.

## 4. Official Support and Pricing
FluffyChat is free as in free speech and not free beer! Please contact
my company [famedly.com](https://famedly.com) for offers and official support
and take in mind that it costs a lot of work and time to maintain FluffyChat
or the Famedly Matrix SDK. So we can't give you support for free. So please
expect around 1$ per month per user of your fork.
