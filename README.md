# FinView Lite

A Flutter investment dashboard I built to visualize portfolio performance, asset allocation, and stock-level returns — powered entirely by local JSON, with no backend.

**Live repo:** https://github.com/AshutoshM-21/finview_lite

---

## What I Built

FinView Lite is a minimal wealth-management style app. Users sign in, view their portfolio at a glance, explore how assets are distributed, and drill into individual holdings with sortable lists and flexible gain/loss display.

I focused on three things while building this:

- **Clean architecture** — separated data, repository, and presentation layers with `flutter_bloc`
- **Production-quality UI** — responsive layout, dark mode, loading states, and smooth interactions
- **Defensive data handling** — the app never crashes on bad or incomplete JSON

---

## Features

### Dashboard
- Portfolio summary with total value, gain/loss, and invested amount
- Asset allocation donut chart (`fl_chart`) with per-stock breakdown and an "Other" slice for unlisted assets
- Holdings list showing symbol, company name, units, invested value, current value, and gain/loss
- Toggle returns between **amount** and **percentage**
- Sort holdings by name, current value, or gain (default: highest value first)
- Portfolio insights row — top gainer, largest holding, and more
- Tap any holding to open a detail bottom sheet

### App Experience
- Mock login (any valid email/password) with session persistence
- Dark / light theme toggle, saved across restarts
- Pull-to-refresh and header refresh button to simulate live price updates
- Shimmer loading, staggered list animations, and animated value transitions
- Empty state when no investments are found
- Error screen with retry on failed data load

### Responsive Design
- **Mobile** — single-column scroll layout
- **Tablet / Web** — portfolio summary and allocation chart side by side (`LayoutBuilder` at 700px)

---

## Screenshots

| Screen | Description |
|--------|-------------|
| Login | Sign-in screen with theme toggle |
| Dashboard (Light) | Portfolio summary, chart, and holdings |
| Dashboard (Dark) | Dark mode variant |

> Screenshots can be added to `docs/screenshots/`

---

## Demo

**Screen recording:** [Add your demo link here](https://example.com)

---

## Tech Stack

| Package | Why I used it |
|---------|---------------|
| Flutter 3.x | Cross-platform UI (mobile + web) |
| `flutter_bloc` | Predictable state management for auth, theme, and portfolio |
| `fl_chart` | Donut chart for asset allocation |
| `shared_preferences` | Persist login session and theme preference |
| `equatable` | Value equality for bloc states |

---

## Project Structure

```
lib/
├── core/                   # Colors, spacing, enums, formatters, theme, preferences
├── data/
│   ├── datasource/         # Loads portfolio.json, simulates price refresh
│   ├── models/             # HoldingModel, PortfolioModel
│   └── repository/         # Repository interface + implementation
├── presentation/
│   ├── app/                # Root widget and auth routing
│   ├── auth/               # Login screen and AuthCubit
│   ├── dashboard/          # Dashboard screen, cubit, and widgets
│   └── settings/           # ThemeCubit
└── main.dart

assets/
├── portfolio.json          # Mock API data
└── icon/app_icon.png       # App launcher icon source

test/
├── models_test.dart        # JSON parsing edge cases
└── widget_test.dart        # Dashboard smoke test
```

---

## Getting Started

### Prerequisites

- Flutter SDK **3.24+**
- Xcode (iOS) / Android Studio (Android) / Chrome (web)

```bash
flutter --version
flutter doctor
```

### Setup

```bash
git clone https://github.com/AshutoshM-21/finview_lite.git
cd finview_lite
flutter pub get
```

### Run

```bash
flutter run              # connected device / emulator
flutter run -d chrome    # web
```

### Test

```bash
flutter test
flutter analyze
```

---

## How to Use the App

1. Sign in with any email and password — e.g. `aarav@finview.app` / `demo123`
2. Review the portfolio summary card at the top
3. Check the allocation chart and insights section
4. Switch gain display between amount and percentage
5. Sort holdings using the dropdown
6. Tap a stock card for full details
7. Pull down or tap refresh to simulate updated prices
8. Toggle dark mode from the header
9. Sign out when done

---

## Mock Data

I used a local JSON file to simulate an API response:

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

### How I handle the numbers

| What you see | How it's calculated |
|---|---|
| Portfolio value — ₹1,50,000 | Read from `portfolio_value` in JSON |
| Total gain — ₹12,000 | Read from `total_gain` in JSON |
| Invested — ₹1,38,000 | `portfolio_value − total_gain` |
| Per-stock values | Computed from `units`, `avg_cost`, `current_price` |
| Listed holdings — ₹32,000 | Sum of TCS + INFY current values |
| "Other" in chart — ₹1,18,000 | Remaining portfolio not shown in the holdings array |

On refresh, I simulate market movement by shifting each stock price ±3% and scaling the summary totals proportionally.

---

## Architecture

```
Presentation  →  Screens, Widgets, Cubits (auth, theme, portfolio)
Repository    →  PortfolioRepository
Data Source   →  PortfolioLocalDataSource → assets/portfolio.json
```

I kept business logic out of widgets. All portfolio data flows through `PortfolioCubit`, auth through `AuthCubit`, and theme through `ThemeCubit`.

---

## Error Handling

I made sure the app handles real-world data issues gracefully:

- Empty or malformed JSON → error screen with retry
- Missing fields → safe defaults, no crash
- Invalid numbers → treated as `0`
- Zero investment → gain % returns `0`
- Empty holdings list → dedicated empty state UI

---

## Author

**Ashutosh M** — [GitHub](https://github.com/AshutoshM-21)

Built as part of a Flutter frontend assignment: *Investment Insights Dashboard*.
