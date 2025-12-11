MuslimLife AI – Mobile App (Phase 1)

A modern Flutter-based Islamic lifestyle application providing prayer times, Quran reading, Qibla direction, and AI-powered spiritual insights.

📱 Overview

MuslimLife AI is a cross-platform Flutter application designed to serve as a daily Muslim companion, combining beautiful UI, accurate prayer utilities, and a privacy-first AI guidance system.

This repository contains the full implementation of Phase 1 of the app, including:

Prayer Times (GPS → API)

Quran Module (Offline Uthmani Script)

AI Insight Engine (Google Gemini via Firebase Cloud Functions)

AI Chat (Noor)

Dashboard UI & Carousel Cards

Authentication (Firebase)

Minimal navigation + structure for future phases

🚀 Features Implemented in Phase 1
1. Firebase Authentication

Email + Password login

Session handling via FirebaseAuth

2. Prayer Times Engine

Multi-layer location logic:

Mobile GPS → Web IP → Belmont VA fallback

Next prayer detection

Clean prayer times model

3. Quran Module (Offline Uthmani Script)

Uthmani JSON stored in assets/quran/

Loaded using background isolate (compute)

High-quality Mushaf-style Arabic font:

KFGQPC-Uthmanic-Script-HAFS.otf

Surah list + verse reading mode

4. AI Insight Card (Horeen)

Cloud Function: generateInsight

Uses Google Gemini (Flash model)

Fully isolated, safe spiritual messaging

2–3 sentence maximum

No fatwas or political topics

5. AI Chat (Noor)

Cloud Function: aiChat

Persona-based responses

Safety rules enforced server-side

Simple, Phase-1 interface

6. Dashboard UI

Prayer overview

AI Insight carousel

Tiles for Quran, Qibla, Community, Analytics, Mission

🧩 Technology Stack
Frontend

Flutter 3.x

Dart

Provider (state)

Custom glass UI components

Google Fonts + Uthmani Fonts

Flutter Isolates for heavy JSON parsing

Backend

Firebase Authentication

Firebase Cloud Functions (Node.js)

Google Gemini API

IP-to-Location fallback for Web

APIs

Prayer Times: AlAdhan API

Gemini AI: @google/generative-ai

🗂 Project Structure Highlights
lib/
  screens/
    dashboard_screen.dart
    prayer_times_screen.dart
    login_screen.dart
    quran_home_screen.dart
    quran_read_mode.dart
    chat_screen.dart
    landing_page.dart
  services/
    prayer_service.dart
    quran_local_service.dart
    ai_chat_service.dart
  models/
    prayer_times.dart
    quran_surah.dart
    quran_ayah.dart
  config/
    api_config.dart
assets/
  fonts/
  quran/
functions/
  index.js

🛠 Local Development Setup
1. Install Dependencies
flutter pub get

2. Run Firebase Emulator

From /functions:

npm install
firebase emulators:start

3. Run the App
Web:
flutter run -d chrome

Android Emulator:
flutter run -d emulator-5554


iOS builds require macOS + Xcode.

🔐 Security

API keys are not stored in source code or version control.

.gitignore protects:

google-services.json

GoogleService-Info.plist

build artifacts

Flutter tooling

All AI logic is performed server-side to ensure:

Safety rules

Logging

Abuse prevention

Persona consistency

📦 Phase 2 & Beyond (Upcoming Work)

This repo is prepared for Phase 2 additions:

Phase 2

Full Qibla Compass (real magnetometer needle)

Prayer habit tracking

Multi-day Quran reading analytics

Surah audio recitation

Composable AI tasks (structured insights)

Phase 3

MuslimLife marketplace

Learning modules

AI-based Islamic coaching

Daily habit automation

Avatars / voice interactions

🤝 Contributing

This repository is currently private.
Access is granted only to approved developers.
Standard branching model:

main → stable releases

dev → active development

feature branches: feature/<name>

📄 License

All rights reserved.
Not for public distribution.
