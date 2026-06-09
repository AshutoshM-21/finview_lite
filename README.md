# FinView Lite

**Investment Insights Dashboard** — a Flutter mobile/web app that visualizes portfolio value, asset allocation, and holding-level returns using local mock JSON data.

Built as a frontend assignment demonstrating clean architecture, responsive UI, and production-quality state management.

---

## Features

### Core (Assignment Requirements)

| Feature | Implementation |
|---------|----------------|
| Local JSON data source | `assets/portfolio.json` loaded via `PortfolioLocalDataSource` |
| Portfolio summary | Total value and gain/loss in header card |
| Holdings list | Symbol, name, units, invested value, current value, gain/loss |
| Asset allocation chart | `fl_chart` pie chart with dynamic legend |
| Return toggle | Switch gain display between **Amount** and **Percentage** |
| Sort holdings | By name, current value (default ↓), or gain |
| Empty / zero-investment handling | Graceful empty state UI and safe parsing |
| Responsive layout | Single column on mobile; summary + chart side-by-side on tablet/web |

### Bonus Features

| Feature | Implementation |
|---------|----------------|
| Dark mode toggle | Persisted via `shared_preferences`, available on login & dashboard |
| Mock login | Any valid email/password; session persisted across restarts |
| Manual refresh | App bar button + pull-to-refresh simulates ±3% price updates |

---

## Screenshots

> Add screenshots to `docs/screenshots/` before submission.

| Login | Dashboard (Light) | Dashboard (Dark) |
|-------|-------------------|------------------|
| _Add `login.png`_ | _Add `dashboard_light.png`_ | _Add `dashboard_dark.png`_ |

---

## Demo Recording

> Replace with your screen recording link before submission.

**Demo video:** [Add your Loom / YouTube / Drive link here](https://example.com)

---

## Tech Stack

- **Flutter** 3.x (Dart SDK `^3.9.2`)
- **flutter_bloc** — state management
- **fl_chart** — pie chart visualization
- **shared_preferences** — login & theme persistence
- **equatable** — value equality for bloc states

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App colors
│   ├── enums/           # Sort & return display modes
│   ├── services/        # SharedPreferences wrapper
│   ├── theme/           # Material 3 light/dark themes
│   └── utils/           # Currency & percentage formatters
├── data/
│   ├── datasource/      # Local JSON loader + price simulation
│   ├── models/          # HoldingModel, PortfolioModel
│   └── repository/      # Repository abstraction
├── presentation/
│   ├── app/             # Root app & auth gate
│   ├── auth/            # Mock login flow
│   ├── dashboard/       # Cubit, screen, widgets
│   └── settings/        # Theme cubit
└── main.dart
assets/
└── portfolio.json       # Mock portfolio data
```

---

## Getting Started

### Prerequisites

- Flutter SDK **3.24+** (stable channel recommended)
- Xcode (iOS) / Android Studio (Android) / Chrome (web)

Verify installation:

```bash
flutter --version
flutter doctor
```

### Install Dependencies

```bash
git clone <your-repo-url>
cd finview_lite
flutter pub get
```

### Run the App

**Mobile (debug):**

```bash
flutter run
```

**Web:**

```bash
flutter run -d chrome
```

**iOS Simulator / Android Emulator:**

```bash
flutter devices        # list available devices
flutter run -d <device_id>
```

### Run Tests

```bash
flutter test
flutter analyze
```

---

## Usage Guide

1. **Sign in** with any email and password (e.g. `aarav@finview.app` / `demo123`).
2. View the **portfolio summary** — greeting, total value, and combined gain/loss.
3. Inspect the **asset allocation** pie chart and legend.
4. Toggle **Amount / Percentage** to change how holding gains are displayed.
5. Use the **Sort by** dropdown to reorder holdings.
6. Tap **Refresh** or pull down to simulate live price updates.
7. Toggle **dark mode** from the app bar (or login screen).
8. Tap **Sign out** to return to the login screen.

---

## Mock Data

`assets/portfolio.json`:

```json
{
  "user": "Aarav Patel",
  "portfolio_value": 150000,
  "total_gain": 12000,
  "holdings": [
    {
      "symbol": "TCS",
      "name": "Tata Consultancy",
      "units": 5,
      "avg_cost": 3200,
      "current_price": 3400
    },
    {
      "symbol": "INFY",
      "name": "Infosys Ltd",
      "units": 10,
      "avg_cost": 1400,
      "current_price": 1500
    }
  ]
}
```

> Portfolio totals are **computed from holdings** at runtime. JSON `portfolio_value` and `total_gain` fields are informational; the app derives values from `units`, `avg_cost`, and `current_price`.

**Computed totals (sample data):**

- Portfolio value: **₹32,000**
- Total gain: **+₹2,000 (+6.67%)**

---

## Error & Edge-Case Handling

- Empty or malformed JSON → user-friendly error with retry
- Missing JSON fields → safe defaults (no crashes)
- Invalid numeric strings → parsed as `0`
- Zero invested value → gain percentage returns `0`
- Empty holdings list → illustrated empty state

---

## Architecture

Clean architecture with three layers:

```
Presentation (Cubit + Widgets)
        ↓
Repository (PortfolioRepository)
        ↓
Data Source (PortfolioLocalDataSource → assets/portfolio.json)
```

---

## Submission Checklist

- [x] Flutter project source
- [x] `assets/portfolio.json` with mock data
- [x] README with setup steps
- [ ] Public GitHub repository
- [ ] Screenshots in `docs/screenshots/`
- [ ] Demo screen recording link

---

## License

This project was created for a frontend assignment submission.
