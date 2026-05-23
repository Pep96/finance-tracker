# 💰 Finance Tracker

A complete personal finance tracker built with Flutter. Track income and expenses, visualize spending with interactive charts, navigate through months, and protect your data with biometric authentication.

## Features

- Add income and expense transactions with categories
- Pie chart: expense breakdown by category
- Bar chart: 6-month income vs expense comparison
- Monthly navigation (swipe between months)
- Balance, income, and expense summary cards
- Swipe to delete transactions
- Biometric / PIN authentication (optional)
- Offline-first with Hive local database
- Light and dark theme (system default)

## Architecture

```
lib/
├── models/
│   ├── transaction.dart     # Hive model
│   ├── transaction.g.dart   # Generated adapter
│   └── category.dart        # Category definitions & icons
├── providers/
│   └── transaction_provider.dart # Riverpod providers
├── screens/
│   ├── home_screen.dart         # Dashboard + tabs
│   ├── add_transaction_screen.dart
│   ├── settings_screen.dart
│   └── lock_screen.dart         # Biometric gate
├── services/
│   └── auth_service.dart        # local_auth wrapper
├── theme/
│   └── app_theme.dart
├── widgets/
│   ├── summary_cards.dart       # Balance + income/expense cards
│   ├── expense_pie_chart.dart   # fl_chart pie chart
│   ├── monthly_bar_chart.dart   # fl_chart bar chart
│   └── transaction_tile.dart
└── main.dart
```

## Tech Stack

| Package | Purpose |
|---|---|
| `flutter_riverpod` ^2.5.1 | State management |
| `fl_chart` ^0.68.0 | Pie and bar charts |
| `hive` + `hive_flutter` | Local database |
| `local_auth` | Biometric / PIN auth |
| `flutter_slidable` | Swipe-to-delete |
| `uuid` | Unique transaction IDs |
| `intl` | Currency and date formatting |

## Getting Started

```bash
git clone https://github.com/Pep96/finance_tracker.git
cd finance_tracker
flutter pub get
flutter run
```

> Requires Flutter 3.0+ and Dart 3.0+

## Biometric Authentication

Go to **Settings** → toggle **Biometric Authentication**. On next launch, the app will require fingerprint or PIN before showing your data.

### Android permissions required

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

### iOS — add to `Info.plist`

```xml
<key>NSFaceIDUsageDescription</key>
<string>Used to secure access to your financial data</string>
```

---

Built with Flutter by [@Pep96](https://github.com/Pep96)
