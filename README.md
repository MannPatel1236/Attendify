<div align="center">
  
# 📘 Attendify

**A sleek, modern attendance tracking and management application built with Flutter.**

[![Flutter Version](https://img.shields.io/badge/Flutter-%5E3.11.1-02569B?logo=flutter)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-%5E3.0.0-0175C2?logo=dart)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

</div>

## ✨ Overview
Attendify is an intuitive, role-based attendance management system designed to bridge the gap between teachers and students. It offers a seamless, cross-platform experience with specialized dashboards that bring real-time tracking, editing, and subject metrics to everything from mobile devices to the web.

---

## 🚀 Key Features

* 🔐 **Role-Based Workflows**: Separate, optimized interfaces for both **Students** and **Teachers**.
* 📊 **Smart Dashboards**: Real-time attendance calculation, low-attendance alerts, and subject-wise breakdowns.
* 📅 **Timetable Integration**: Built-in support for daily schedules, helping users easily track what classes are next.
* ✏️ **Manual Adjustments**: Flexible self-service options allowing students to request structural overrides to match official records.
* 🌓 **Dynamic Themes**: Beautifully crafted Light and Dark modes adapting to system preferences.
* 💾 **Offline-first Architecture**: Persisted state management using `shared_preferences` allowing seamless workflow interruptions.

## 🛠 Tech Stack

* **Framework:** [Flutter](https://flutter.dev/) (Cross-platform support for iOS, Android, macOS, Windows, Linux, and Web).
* **Language:** [Dart](https://dart.dev/)
* **State Management:** [Provider](https://pub.dev/packages/provider)
* **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
* **Media Management:** [Image Picker](https://pub.dev/packages/image_picker)

## 💻 Getting Started

### Prerequisites
Before you begin, ensure you have the following installed:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.11.1 or higher)
* An IDE like **VS Code** or **Android Studio**.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/MannPatel1236/Attendify.git
   cd Attendify
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the Application:**
Connect your phone via USB (with debugging enabled) or start an emulator/simulator, then run:
   ```bash
   # Run on the default connected device or simulator
   flutter run
   ```

## 📂 Project Structure

```text
lib/
├── models/         # Core data models (student_model.dart, timetable_model.dart)
├── screens/        # UI Views (Dashboards, Login, Timetable screens)
├── state/          # Provider state files
└── main.dart       # App entry point & root widget
```

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

<div align="center">
  <sub>Built with ❤️ by Mann Patel.</sub>
</div>