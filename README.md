# fov_fall2024_waiter_mobile_app

A new Flutter project.

## Project structure (credit: https://github.com/JCKodel/eva)
```
📁 lib
├─ 📁 assets
├─ 📁 app
│  ├─ 📁 contracts (interfaces)
│  ├─ 📁 domain
│  │  └─ 📄 some_domain.dart
│  ├─ 📁 entities
│  │  └─ 📄 freezed_entity.dart
│  ├─ 📁 presentation
│  │  ├─ 📁 pages
│  │  │  └─ 📄 home_page_widget.dart
│  │  └─ 📄 your_app.dart
│  ├─ 📁 repositories
│  │  ├─ 📁 data
└── main.dart
```
## Task checklist (Mobile Application for Waiter of branch):
 - [ ]	Login/Logout; (partially done, need api)
 - [ ]	Confirm customer orders;
 - [ ]	Order status management;
 - [ ]	Checkout customer orders;
 - [ ]	Scan QR + get location to check attendance;

## Sub-task
 - [X]	Main screen with bottom navigation bar
 - [ ]	Main screen 1: Waiter basic info (name, role; attendance status and check attendance)
 - [ ]	Main screen 2: Load current orders from tables
 - [ ]	Main screen 3: Settings

## Misc. task:
 - [ ]	Get location of user via GPS or network
 - [X]	Receive notification using Firebase Cloud Message (current nitpick bug: notification while app is running in background or terminated not pop down from status bar)
 - [ ]	Access camera for scanning QR