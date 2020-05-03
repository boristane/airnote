# airnote

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Generate Json Annotations
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Local Dev

Android: `10.0.2.2`

## Screen video recording

```bash
xcrun simctl io booted recordVideo --mask=black --display=internal --force  appVideo.mov
```

## Create an android keystore

```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

## Release

[Android](https://flutter.dev/docs/deployment/android)
