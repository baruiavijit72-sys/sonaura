#!/bin/bash
set -e
echo "🔨 Sonaura Project Generator"
echo "==========================="
mdir -p .github/workflows
mkdir -p apps/mobile_desktop/lib
mkdir -p apps/mobile_desktop/assets/fonts apps/mobile_desktop/assets/images apps/mobile_desktop/assets/animations apps/mobile_desktop/assets/icons
mkdir -p apps/mobile_desktop/test
mkdir -p apps/mobile_desktop/android/app/src/main/kotlin/dev/sonaura/app
mkdir -p apps/mobile_desktop/android/app/src/main/res/drawable
mkdir -p apps/mobile_desktop/android/app/src/main/res/values
mkdir -p apps/mobile_desktop/android/app/src/main/res/mipmap-hdpi
mkdir -p apps/mobile_desktop/android/app/src/main/res/mipmap-mdpi
mkdir -p apps/mobile_desktop/android/app/src/main/res/mipmap-xhdpi
mkdir -p apps/mobile_desktop/android/app/src/main/res/mipmap-xxhdpi
mkdir -p apps/mobile_desktop/android/app/src/main/res/mipmap-xxxhdpi
mkdir -p apps/mobile_desktop/android/gradle/wrapper
echo "✅ Directories created"

# --- GITHUB ACTIONS BUILD WORKFLOW ---
cat > .github/workflows/build-apk.yml << 'YML'
name: 🚀 Build Android APK
on:
  workflow_dispatch:
  push:
    branches: [main]
    paths: ['apps/mobile_desktop/**']
concurrency:
  group: build-${ { github.ref }}
  cancel-in-progress: true
jobs:
  build-apk:
    name: �1 Build APK
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with: { distribution: temurin, java-version: '17' }
      - uses: subosito/flutter-action@v2
        with: { flutter-version: '3.22.3', channel: stable, cache: true }
      - uses: actions/cache@v4
        with:
          path: |
            ~/.pub-cache
            apps/mobile_desktop/.dart_tool
            apps/mobile_desktop/build
          key: flutter-${ { runner.os }}-${ { hashFiles('apps/mobile_desktop/pubspec.yaml') }}
          restore-keys: flutter-${ { runner.os }}-
      - run: cd apps/mobile_desktop && flutter pub get
      - run: cd apps/mobile_desktop && flutter build apk --debug --target-platform=android-arm64
      - run: |
          cd apps/mobile_desktop/build/app/outputs/flutter-apk
          mkdir -p apks
          cp app-arm64-v8a-debug.apk apks/sonaura-arm64-v8a.apk 2>/dev/null || true
          cp app-armeabi-v7a-debug.apk apks/sonaura-armeabi-v7a.apk 2>/dev/null || true
          ls -la apks/
      - uses: actions/upload-artifact@v4
        with:
          name: sonaura-android-apk
          path: apps/mobile_desktop/build/app/outputs/flutter-apk/apks/
          retention-days: 30
      - run: |
          echo "==================================="
	 cho "✅ APK BUILT SUCCESSFULLY!"
          echo "Download from Artifacts section above"
          echo "Admin: admin@sonaura.dev / SonauraAdmin2024!"
          echo "==================================="
YML

echo "✅ build-apk.yml"

cat > apps/mobile_desktop/pubspec.yaml << 'YML'
name: sonaura_app
description: Sonaura — Free Music Streaming
publish_to: 'none'
version: 1.0.0+1;
environment: { sdk: '>=3.4.0 <4.0.0', flutter: '>=3.22.0' }
dependencies: { flutter: { sdk: flutter }, intl: ^0.19.0 }
dev_dependencies: { flutter_lints: ^4.0.0 }
flutter: { uses-material-design: true }
YML

cat > apps/mobile_desktop/android/build.gradle << 'EOF'
allprojects { repositories { google(); mavenCentral() } }
rootProject.buildDir = "../build"
subprojects { project.buildDir = "${rootProject.buildDir}/${project.name}" }
subprojects { project.evaluationDependsOn(":app") }
tasks.register("clean", Delete) { delete rootProject.buildDir }
EOF
echo 'org.gradle.jvmargs=-Xmx4G android.useAndroidX=true android.enableJetifier=true' > apps/mobile_desktop/android/gradle.properties;

cat > apps/mobile_desktop/android/settings.gradle << 'GRADLE'
pluginManagement {
  def flutterSdkPath = { def properties = new Properties(); file("local.properties").withInputStream { properties.load(it) }; return properties.getProperty("flutter.sdk") }()
  includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
  repositories { google(); mavenCentral(); gradlePluginPortal() }
}
plugins {
  id "dev.flutter.flutter-plugin-loader" version "1.0.0"
  id "com.android.application" version "8.1.0" apply false
  id "org.jetbrains.kotlin.android" version "1.9.22" apply false
}
include ":app"
GRADEL

cat > apps/mobile_desktop/android/app/build.gradle << 'GRADLE'
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) { localPropertiesFile.withReader('UTF-8') { localProperties.load(it) } }
def flutterRoot = localProperties.getProperty('flutter.sdk')
def flutterVersionCode = localProperties.getProperty('flutter.versionCode') ?: '1'
def flutterVersionName = localProperties.getProperty('flutter.versionName') ?: '1.0'
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
android {
  namespace "dev.sonaura.app"; compileSdkVersion 34
  compileOptions { sourceCompatibility JavaVersion.VERSION_17; targetCompatibility JavaVersion.VERSION_17 }
  kotlinOptions { jwkTarget = '17' }
  sourceSets { main.java.srcDirs += 'src/main/kotlin' }
  defaultConfig {
    applicationId "dev.sonaura.app"; minSdkVersion 24; targetSdkVersion 34
    versionCode flutterVersionCode.toInteger(); versionName flutterVersionName; multiDexEnabled true
  }
  buildTypes { release { minifyEnabled false } }
}
flutter { source '../..' }
dependencies { implementation 'androidx.multidex:multidex:2.0.1' }
GRADLE

cat > apps/mobile_desktop/android/app/src/main/AndroidManifest.xml << 'XML'
<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="dev.sonaura.app">
  <uses-permission android:name="android.permission.INTERNET"/>
  <application android:label="Sonaura" android:name="${applicationName}" android:icon="@mipmap/ic_launcher" android:usesCleartextTraffic="true">
    <activity android:name=".MainActivity" android:exported="true" android:launchMode="singleTop" android:theme="@style/LaunchTheme" android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode" android:hardwareAccelerated="true" android:windowSoftInputMode="adjustResize">
      <meta-data android:name="io.flutter.embedding.android.NormalTheme" android:resource="@style/NormalTheme"/>
      <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
      </intent-filter>
    </activity>
    <meta-data android:name="flutterEmbedding" android:value="2"/>
  </application>
</manifest>
XML

echo 'package dev.sonaura.app; import io.flutter.embedding.android.FlutterActivity; class MainActivity extends FlutterActivity {}' > apps/mobile_desktop/android/app/src/main/kotlin/dev/sonaura/app/MainActivity.kt;

cat > apps/mobile_desktop/android/app/src/main/res/values/styles.xml << 'XML'
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar"><item name="android:windowBackground">@android:color/black</item></style>
  <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar"><item name="android:windowBackground">?android:colorBackground</item></style>
</resources>
XML

echo 'distributionUrl=https\://services.gradle.org/distributions/gradle-8.3-all.zip' > apps/mobile_desktop/android/gradle/wrapper/gradle-wrapper.properties;

echo "✅ Android scaffold complete";

echo "✅ Project ready! Now run: git init && git add -A && git commit -m 'Init' && git push#