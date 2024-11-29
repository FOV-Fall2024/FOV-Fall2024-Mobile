# fov_fall2024_waiter_mobile_app

A new Flutter project.

## Project structure (credit: https://github.com/JCKodel/eva)
```
📁 lib
├─ 📁 assets
├─ 📁 app
│  ├─ 📁 commands
│  │  └─ 📄 some_command.dart
│  ├─ 📁 contracts
│  │  └─ 📄 i_repo_interface.dart
│  ├─ 📁 entities
│  │  └─ 📄 freezed_entity.dart
│  ├─ 📁 enviroments
│  │  └─ 📄 base_enviroment.dart
│  ├─ 📁 permissions
│  │  └─ 📄 permission.dart
│  ├─ 📁 presentation
│  │  ├─ 📁 pages
│  │  │  └─ 📄 home_page_widget.dart
│  │  └─ 📄 your_app.dart
│  ├─ 📁 repositories
│  │  ├─ 📁 data
│  ├─ 📁 services
│  │  ├─ 📁 data
└── main.dart
```
## Task checklist (Mobile Application for Waiter of branch):
 - [X]	Login/Logout;
 - [X]	Confirm customer orders;
 - [X]	Order status management;
 - [X]	Checkout customer orders;
 - [ ]	Scan QR + get location to check attendance;

## Sub-task
 - [X]	Cancel order
 - [X]	Cancel add more order
 - [X]	Pay by cash (not tested)

## Misc. task:
 - [X]	Get location of user via GPS or network
 - [X]	Receive notification using Firebase Cloud Message (current nitpick bug: notification while app is running in background or terminated not pop down from status bar)
 - [X]	Access camera for scanning QR

## DI implementation status:
 - [X]	Login page
 - [ ]	Main menu page
 - [ ]	Order page
 - [ ]	Schedule page
 - [ ]	Setting page
 - [ ]	Take attendance page
 - [ ]	Notification page
 - [ ]	Order detail page
 - [ ]	

## Todos
 - [ ]	Login flow: Login page - check attendance status, if status == false -> attendance page (scan qr + location)
 - [ ]	Order flow: if item.isAddMore == true -> show button for waiter to services (partially done, need testing)
 - [ ]	Order flow: if item.status == cooked -> show button for waiter to services (partially done, need testing)
 - [X]  Order item: display note from customer (done, rebuilding whole item card)