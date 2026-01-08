<<<<<<< HEAD
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
=======
💸 SaveFlow

SaveFlow is a smart monthly budget and savings tracking application that helps users manage expenses, automatically calculate savings, and handle overspending by deducting from accumulated savings — all with clear history and visual insights.

🚀 What is SaveFlow?

SaveFlow is built around a simple but powerful idea:

Every month has a fixed budget.
If you spend less → you save money.
If you spend more → savings are used automatically.

It removes confusion and helps users clearly see where their money goes and how much they actually save over time.

✨ Key Features

✅ Monthly budget management (editable anytime)

🧾 Add expenses with amount, reason, and auto-saved date

🔁 Automatic savings carry-forward every month

⚠️ Overspending automatically deducted from savings

📉 Debt tracking when savings are exhausted

📆 Month-wise expense history

📊 Visual analytics (expenses vs budget, savings growth)

🔐 Secure authentication (JWT-based)

☁️ Cloud-backed storage (PostgreSQL)

📱 Mobile-first, responsive UI

🧠 Core Concept

Each month works like a container:

Budget is fixed (e.g. ₹1000)

Expenses are added during the month

At month end:

Unused money → Savings

Overspent money → Deducted from Savings

Savings persist month-to-month

History is never modified retroactively
<img width="858" height="519" alt="image" src="https://github.com/user-attachments/assets/f2b7e0e2-1efb-4f2f-b171-e56f213bd65a" />


🛠️ Setup Instructions (Coming Soon)

Detailed setup steps will be added once backend and frontend scaffolding is complete.

Planned:

Environment variables

Database migrations

Local development commands

Production deployment guide

🎨 Branding

Name: SaveFlow

Theme: Minimal, calm, finance-friendly

Colors: Green (savings), Blue (trust), White (clarity)

🔮 Future Enhancements

Offline-first support with sync

Category-wise expense analysis

Budget goals

Export reports (PDF/CSV)

AI-powered spending insights

Mobile app (React Native)

🤝 Contributing

Contributions are welcome once the base MVP is complete.

📄 License

MIT License

📌 Status

🚧 In active development
MVP build in progress.
>>>>>>> 9922934550432e235ffd1fb24f8d5f4899162756
