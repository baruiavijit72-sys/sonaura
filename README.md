# 🎵 Sonaura — Free Music Streaming

**No Ads. No Subscriptions. Ever.**

Welcome to Sonaura — a complete, production-grade music streaming platform built with Flutter and NestJS.

## 📱 Features

- 🎉 Music streaming with progressive buffering
- 📅 Offline downloads with AES-256 encryption
- 🎊 Lossless FLAC audio quality
- 🎑 Timed LRC lyrics with synced highlighting
- 🎭 AI-powered recommendations and smart shuffle
- 📌 Personalized insights and listening analytics
- 🌄 Dark / Light / AMOLED theme
- 📌 Cloud sync across devices
- 🚀 CI/CD pipeline for automatic APK builds

## 📱 Build APK

### Option 1: GitHub Actions (Easiest — from your phone!)

1. Go to Actions tab
2. Tap Build Android APK → Run workflow
3. Wait 15 minutes
4. Scroll down → Artifacts → download APK

### Option 2: Local Build

```
cd apps/mobile_desktop
flutter pub get
flutter build apk --release
```

## 🔑 Admin Credentials

| Role | Email | Password |
|------|-------|----------|
| Super Admin | admin@sonaura.dev | SonauraAdmin2024! |
| Demo User | demo@sonaura.dev | DemoUser123! |

## 🔧 Tech Stack

| Layer | Technology |
|-------|------------|
| Mobile | Flutter 3.22+ (flutter_bloc, go_router, dio) |
| Backend | NestJS + PostgreSQL |
| AI/ML | Custom recommendation engine |
| Audio | just_audio + audio_service |
| Security | Argon2id hashing, AES-256 encryption |
| CI/CD | GitHub Actions |
| Hosting | Railway (backend) + Supabase (DB) |

## 👨‍💻 Development

```
git clone https://github.com/baruiavijit72-sys/sonaura.git
cd sonaura/apps/mobile_desktop
flutter pub get
flutter run
```

## 🇮🇳 Created by Avishek Barui
