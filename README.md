# Notification & SMS Background Logger

This Flutter project is an application that listens to **all incoming notifications** (from any app) and **SMS messages** on Android devices.  
The app saves notifications and SMS messages into a local database, even when running in the **background**.
<img width="500" height="1050" alt="изображение" src="https://github.com/user-attachments/assets/f834aeee-7be2-4621-9290-5c26e4051d09" /> **HomePage**
<img width="500" height="166" alt="изображение" src="https://github.com/user-attachments/assets/2cfabf5f-e3d9-4697-8ad3-9e1b82682499" /> **On tapping you get package name of notification place incomer**
<img width="500" height="1050" alt="изображение" src="https://github.com/user-attachments/assets/4bed8dc8-2f3a-4936-ac16-deeb11184d36" /> **Bottom sheet as menu**



⚠️ **Note**:  
This functionality is only supported on **Android** due to system restrictions.  
On iOS, only push notifications from your own app can be handled. (I dont added iOS capturing)

---

## Features
- Capture all incoming **push notifications** from installed apps.
- Capture **SMS messages** in real time.
- Works in the **background** (not when app is FULL killed).
- Clean Architecture + BLoC for state management.
- Local database storage (Hive).
- Extensible structure for future features.

---

## Requirements
1. Check my AndroidManifest.xml
⚠️ Check for permissions and service initialization. 
  
2. Use the local plugin. ⚠️ Only local ⚠️ (but if you had better version, its up to you)

This project uses a modified version of flutter_notification_listener, stored in the plugins/ directory.
Instead of using the published package, point to the local plugin in your pubspec.yaml:

dependencies:
  flutter:
    sdk: flutter

  notification_handler:
    path: plugins/flutter_notification_listener

  ⚠️ Make sure you do not use flutter_notification_listener from pub.dev. Use the local plugin only.
