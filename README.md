# SaveFlow

SaveFlow is a fully offline Flutter application for tracking daily expenses, managing monthly budgets, and calculating savings automatically.

## Features
- **Offline First**: All data is stored locally using Hive. No internet required.
- **Budget Tracking**: Set a monthly budget and track your spending progress.
- **Auto Calculation**: Automatically closes the month and updates savings or debt history.
- **Charts**: Visual breakdown of your monthly expenses.
- **History**: View past months' summaries and detailed transactions.

## Tech Stack
- **Framework**: Flutter (Material 3)
- **State Management**: Flutter Riverpod
- **Local Database**: Hive
- **Charts**: fl_chart

## Project Structure
```
lib/
├── core/           # Constants, Theme, Utils
├── data/           # Hive Models, Repositories, Services
├── logic/          # Riverpod Notifiers, Month Closing Logic
├── presentation/   # UI Screens and Widgets
└── main.dart       # Entry point
```

## Setup Instructions

1. **Prerequisites**: Ensure you have Flutter installed (`flutter doctor`).
2. **Clone/Open**: Open this project in your IDE.
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run Code Generation**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
5. **Run App**:
   ```bash
   flutter run
   ```

## Key Decisions
- **Hive vs SQLite**: Chosen Hive for simplicity and speed with NoSQL object storage, perfect for this hierarchical data structure.
- **Riverpod**: Used for dependency injection (Repositories) and state management (Notifiers).
- **Architecture**: Separated Data, Logic, and Presentation layers for maintainability.

## Deliverables Checklist
- [x] Flutter project structure
- [x] Hive box definitions
- [x] State management (Riverpod)
- [x] Business logic for month closing
- [x] UI Screens (Dashboard, History, Settings)
- [x] Charts
- [x] README
