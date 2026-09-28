# Aerogram APK Build Guide

## Предварительные требования

### Системные требования
- Flutter SDK 3.13.x или выше
- Java Development Kit (JDK) 11 или выше
- Android SDK (API level 21+)
- Gradle

### Установка

#### 1. Установить Flutter
```bash
# Скачать Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Добавить Flutter в PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Проверить установку
flutter doctor
```

#### 2. Установить JDK
```bash
# Ubuntu/Debian
sudo apt-get install openjdk-11-jdk

# macOS
brew install openjdk@11

# Проверить версию
java -version
```

#### 3. Настроить Android SDK
```bash
# Установить Android SDK командной строки
# https://developer.android.com/studio/command-line/sdkmanager

# Установить необходимые компоненты
sdkmanager "platforms;android-33"
sdkmanager "build-tools;33.0.0"
sdkmanager "ndk;23.1.7779620"
```

## Подготовка к сборке

### 1. Получить зависимости
```bash
cd Aerogram
flutter pub get
```

### 2. Запустить генерацию кода
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Проверить окружение
```bash
flutter doctor
```

## Сборка APK

### Сборка debug APK (для тестирования)
```bash
flutter build apk --debug
# Выход: build/app/outputs/flutter-apk/app-debug.apk
```

### Сборка release APK (для распространения)
```bash
# Универсальный APK
flutter build apk --release
# Выход: build/app/outputs/flutter-apk/app-release.apk

# APK для каждой архитектуры (меньший размер)
flutter build apk --release --split-per-abi
# Выход:
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### Сборка AAB (Android App Bundle для Google Play)
```bash
flutter build appbundle --release
# Выход: build/app/outputs/bundle/release/app-release.aab
```

## Подписание APK

### Создать ключ подписи (один раз)
```bash
keytool -genkey -v -keystore ~/aerogram-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias aerogram-key
```

### Конфигурация подписи
Создать файл `android/key.properties`:
```properties
storePassword=<your_store_password>
keyPassword=<your_key_password>
keyAlias=aerogram-key
storeFile=/path/to/aerogram-release-key.jks
```

### Сборка с подписанием
```bash
flutter build apk --release
# Flutter автоматически применит подписание из key.properties
```

## Оптимизация размера

### Включить code shrinking
В `android/app/build.gradle`:
```gradle
buildTypes {
  release {
    signingConfig signingConfigs.release
    minifyEnabled true
    shrinkResources true
    proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
  }
}
```

### Результаты сборки
- **Универсальный APK**: ~50-100MB
- **APK per ABI**: ~20-40MB каждый
- **AAB**: Оптимизировано для Google Play

## Тестирование APK

### На физическом устройстве
```bash
# Установить APK
adb install build/app/outputs/flutter-apk/app-release.apk

# Удалить приложение
adb uninstall im.fluffychat

# Запустить логи
adb logcat
```

### На эмуляторе
```bash
# Запустить эмулятор
emulator -avd <avd_name>

# Установить APK
adb install build/app/outputs/flutter-apk/app-release.apk
```

## Загрузка на Google Play

### 1. Подготовить релиз
- Скопировать подписанный AAB
- Подготовить скриншоты (5-8 штук, 1080x1920px)
- Написать описание приложения
- Установить цену (free/paid)
- Выбрать регионы распространения

### 2. В Google Play Console
1. Перейти в "Выпуск" → "Создание выпуска"
2. Загрузить AAB файл
3. Добавить примечания к выпуску
4. Проверить все детали
5. Отправить на рецензию

### Сроки рецензии
- Первый выпуск: 24-48 часов
- Обновления: 1-2 часа

## Автоматизация с GitHub Actions

Используется `.github/workflows/build-apk.yml` для автоматической сборки при:
- Push в `main` или `develop`
- Pull requests
- Ручной запуск

### Артефакты
Собранные APK доступны в разделе "Artifacts" workflow.

## Возможные проблемы

### Ошибка: "Unable to find bundled Java version"
```bash
export JAVA_HOME=/path/to/java
# Проверить: java -version
```

### Ошибка: "Platform not found"
```bash
flutter pub get
flutter pub upgrade
```

### Ошибка при сборке: "AndroidX required"
В `android/gradle.properties`:
```properties
android.useAndroidX=true
android.enableJetifier=true
```

### Ошибка подписи
```bash
# Проверить ключ
keytool -list -v -keystore ~/aerogram-release-key.jks

# Пересоздать если нужно
rm ~/aerogram-release-key.jks
```

## Дополнительные ресурсы

- [Flutter Build Documentation](https://flutter.dev/docs/deployment/android)
- [Google Play Console Help](https://support.google.com/googleplay)
- [Android App Bundle](https://developer.android.com/guide/app-bundle)
- [Keytool Documentation](https://docs.oracle.com/en/java/javase/11/docs/specs/man/keytool.html)

## Чек-лист перед выпуском

- [ ] Все тесты пройдены
- [ ] Проверен код анализатором (flutter analyze)
- [ ] Версия обновлена в pubspec.yaml
- [ ] Обновлен CHANGELOG.md
- [ ] Скриншоты готовы
- [ ] Описание приложения актуально
- [ ] APK протестирован на устройстве
- [ ] Подписание настроено корректно
- [ ] Размер APK оптимизирован
