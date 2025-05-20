# Overview

[Pangea Chat](https://pangea.chat) is a web and mobile platform which lets students ‘learn a language while texting their friends.’ Addressing the gap in communicative language teaching, especially for beginners lacking skill and confidence, Pangea Chat provides a low-stress, high-support environment for language learning through authentic conversations. By integrating human and artificial intelligence, the app enhances communicative abilities and supports educators. Pangea Chat has been grant funded by the National Science Foundation and Virginia Innovation Partnership Corporation based on its technical innovation and potential for broad social impact. Our mission is to build a global, decentralized learning network supporting intercultural learning and exchange.

# Pangea Chat Client Setup

* Download VSCode if you do not already have it installed. This is the preferred IDE for development with Pangea Chat.
* Download flutter on your device using this guide: https://docs.flutter.dev/get-started/install
* Test to make sure that flutter is properly installed by running “flutter –version”
    * You may need to add flutter to your path manually. Instructions can be found here: https://docs.flutter.dev/get-started/install/macos/mobile-ios?tab=download#add-flutter-to-your-path
* Ensure that Google Chrome is installed
* Install the latest version of XCode
    * After downloading XCode, ensure that the iOS simulator runtime is installed. To do this, after initially downloading XCode, a screen will open where you can select the platforms you wish to develop for. Selected iOS and download from there.
* Install the latest version of Android Studio
    * After downloading Android Studio, open Android Studio and go through setup wizard
* In Android Studio, open settings -> Android SDK -> SDK tools, then click “Android SDK Command Line Tools” and click OK to run the download
* If you do not have homebrew install on your device, install homebrew by follow the instructions here: https://brew.sh/
* Run “brew install cocoapods” to install cocoapods
* Run “flutter doctor” and for any missing components, follow the instructions from the print out to install / setup
* Clone the client repo
* Uncomment the lines in the pubspec.yaml file in the assets section with paths to .env file
* To run on iOS:
    * Run “flutter precache --ios”
    * Go to the iOS folder and run “pod install”
* To run on Android:
    * Download Android File Transfer here: ​​https://www.android.com/filetransfer/
* To run the app from VSCode terminal:
    * On web, run `flutter run -d chrome –hot`
    * Or as a web server (Usage with WSL or remote connect) `flutter run --release -d web-server -web-port=3000`
    * On mobile device or simulator, run `flutter run –hot -d <DEVICE_NAME>`

# Special thanks

* Pangea Chat is a fork of [FluffyChat](https://fluffychat.im) which is a [[matrix](https://matrix.org)] client written in [Flutter](https://flutter.dev). You can [support the primary maker of FluffyChat directly here.](https://ko-fi.com/C1C86VN53)

* <a href="https://github.com/fabiyamada">Fabiyamada</a> is a graphics designer and has made the fluffychat logo and the banner. Big thanks for her great designs.

* <a href="https://github.com/advocatux">Advocatux</a> has made the Spanish translation with great love and care. He always stands by my side and supports my work with great commitment.

* Thanks to MTRNord and Sorunome for developing.

* Also thanks to all translators and testers! With your help, fluffychat is now available in more than 12 languages.

* <a href="https://github.com/madsrh/WoodenBeaver">WoodenBeaver</a> sound theme for the notification sound.

* The Matrix Foundation for making and maintaining the [emoji translations](https://github.com/matrix-org/matrix-spec/blob/main/data-definitions/sas-emoji.json) used for emoji verification, licensed Apache 2.0
