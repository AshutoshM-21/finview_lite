# FinView Lite

**Investment Insights Dashboard** — a Flutter mobile/web app that visualizes portfolio value, asset allocation, and holding-level returns using local mock JSON data.

Repository: **https://github.com/AshutoshM-21/finview_lite**

---

## Assignment Requirements Coverage

| # | Requirement | Status | Implementation |
|---|-------------|--------|----------------|
| 1 | Local JSON data source (no backend) | ✅ | `assets/portfolio.json` → `PortfolioLocalDataSource` |
| 2 | Portfolio summary (total value, gain/loss) | ✅ | `PortfolioSummaryCard` — uses `portfolio_value` & `total_gain` from JSON |
| 3 | Holdings list (name, units, cost, current value, gain/loss) | ✅ | `HoldingCard` with computed metrics per stock |
| 4 | Pie/bar chart — asset allocation | ✅ | `AllocationChartCard` using `fl_chart` donut chart + legend |
| 5 | Return toggle (amount / percentage) | ✅ | `ReturnToggle` segmented pill control |
| 6 | Sort holdings (value, gain, name) | ✅ | `SortDropdown` — default: Current Value ↓ |
| 7 | Empty / zero-investment handling | ✅ | `EmptyPortfolioWidget` + safe JSON parsing in models |
| 8 | Flutter (Dart) only | ✅ | No native business logic outside Flutter |
| 9 | Free chart library (`fl_chart`) | ✅ | `fl_chart: ^1.2.0` |
| 10 | Compiles in local debug mode | ✅ | Standard Flutter project, minimal dependencies |
| 11 | Responsive mobile + web layout | ✅ | `LayoutBuilder` — single column mobile, side-by-side tablet/web |
| 12 | Error & edge-case handling | ✅ | Loading / error / retry states; null-safe parsing |
| 13 | Clean architecture | ✅ | Data → Repository → Cubit → UI |
| 14 | Reusable widget decomposition | ✅ | Separate widgets under `presentation/dashboard/widgets/` |

### Bonus Features

| Bonus | Status | Implementation |
|-------|--------|----------------|
| Dark mode toggle | ✅ | `ThemeCubit` + `shared_preferences`, toggle on login & dashboard |
| Mock login with persistence | ✅ | `AuthCubit` + `LoginScreen` — any valid email/password |
| Manual refresh (simulated prices) | ✅ | Refresh button + pull-to-refresh; ±3% price simulation |
| Visual polish (animations) | ✅ | Shimmer loading, staggered entries, animated value text |

---

## Screenshots

> Add screenshots to `docs/screenshots/` and update links below before final evaluation.

| Screen | Description |
|--------|-------------|
| Login | Mock sign-in with theme toggle |
| Dashboard (Light) | Portfolio summary, allocation chart, holdings |
| Dashboard (Dark) | Dark mode variant |

---

## Demo Recording

> Replace the placeholder with your screen recording link before submission.

**Demo video:** [Add your Loom / YouTube / Drive link here](https://example.com)

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| Flutter 3.x (Dart SDK `^3.9.2`) | UI framework |
| `flutter_bloc` | State management |
| `fl_chart` | Pie / donut chart |
| `shared_preferences` | Login & theme persistence |
| `equatable` | Bloc state equality |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/          # Colors, spacing
│   ├── enums/              # Sort option, return display mode
│   ├── services/           # SharedPreferences wrapper
│   ├── theme/              # Material 3 light/dark themes
│   └── utils/              # Currency & percentage formatters
├── data/
│   ├── datasource/         # Local JSON loader + price simulation
│   ├── models/             # HoldingModel, PortfolioModel
│   └── repository/         # Repository abstraction + impl
├── presentation/
│   ├── app/                # Root app & auth gate
│   ├── auth/               # Mock login (cubit + screen)
│   ├── dashboard/
│   │   ├── cubit/          # PortfolioCubit & states
│   │   ├── screen/         # DashboardScreen
│   │   └── widgets/        # Summary, chart, holdings, toggles, shared
│   └── settings/           # ThemeCubit
└── main.dart
assets/
└── portfolio.json          # Mock API response
test/
├── models_test.dart        # JSON parsing & edge-case tests
└── widget_test.dart        # Dashboard widget test
```

---

## Getting Started

### Prerequisites

- **Flutter SDK 3.24+** (stable channel recommended)
- Xcode (iOS) / Android Studio (Android) / Chrome (web)

```bash
flutter --version
flutter doctor
```

### Clone & Install

```bash
git clone https://github.com/AshutoshM-21/finview_lite.git
cd finview_lite
flutter pub get
```

### Run

```bash
# Mobile (pick connected device)
flutter run

# Web
flutter run -d chrome

# List devices
flutter devices
```

### Test & Analyze

```bash
flutter test
flutter analyze
```

---

## Usage Guide

1. **Sign in** with any email and password (demo: `aarav@finview.app` / `demo123`).
2. View **portfolio summary** — current value, gain/loss, invested amount.
3. Inspect **asset allocation** donut chart (listed holdings + "Other" for unlisted assets).
4. Review **portfolio insights** — top gainer, largest holding, etc.
5. Toggle **Amount / Percentage** on holding gain badges.
6. **Sort** holdings by name, current value, or gain.
7. Tap a holding card to open the **detail bottom sheet**.
8. **Refresh** (icon or pull-down) to simulate live price updates.
9. Toggle **dark mode** from the dashboard header.
10. **Sign out** to return to login (session cleared).

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

### How values are derived

| Field | Source |
|-------|--------|
| Portfolio value (₹1,50,000) | `portfolio_value` from JSON |
| Total gain (₹12,000) | `total_gain` from JSON |
| Invested (₹1,38,000) | `portfolio_value − total_gain` |
| Per-holding metrics | Computed: `units × avg_cost` / `units × current_price` |
| Listed holdings total | TCS + INFY = **₹32,000** |
| "Other" in chart | ₹1,18,000 (portfolio not fully listed in holdings array) |

### Refresh behaviour

Refresh simulates market movement (assignment bonus):

- Each holding `current_price` shifts by **±3%** randomly.
- Summary totals scale proportionally with listed holdings.

---

## Error & Edge-Case Handling

| Scenario | Behaviour |
|----------|-----------|
| Empty JSON file | Returns empty portfolio, shows empty state |
| Missing fields | Safe defaults (`0`, empty string, `"Investor"`) |
| Invalid numeric values | Parsed as `0` via `double.tryParse` |
| Zero investment | Gain percentage returns `0` (no division error) |
| Malformed JSON | Error screen with **Retry** button |
| Invalid holding entries | Skipped silently during parse |
| No holdings | `EmptyPortfolioWidget` with illustration |

---

## Architecture

```
┌─────────────────────────────────────────┐
│  Presentation (Screens, Widgets, Cubit) │
├─────────────────────────────────────────┤
│  Repository (PortfolioRepository)       │
├─────────────────────────────────────────┤
│  Data Source (PortfolioLocalDataSource) │
├─────────────────────────────────────────┤
│  assets/portfolio.json                  │
└─────────────────────────────────────────┘
```

**State management:** `flutter_bloc` with separate cubits for auth, theme, and portfolio.

---

## Evaluation Rubric Alignment

| Criteria | Points | Coverage |
|----------|--------|----------|
| UI/UX clarity & visual hierarchy | 25 | Groww-inspired cards, gradient hero, clear sections |
| Code organization & widget decomposition | 20 | Clean architecture, 15+ reusable widgets |
| Data handling & parsing | 20 | JSON totals + computed holdings, unit tests |
| Responsiveness (mobile/web) | 10 | `LayoutBuilder` breakpoint at 700px |
| Error & edge-case handling | 10 | Safe parsing, loading/error/empty states |
| Code readability & comments | 10 | Doc comments on models, cubits, widgets |
| Bonus visual polish | 5 | Shimmer, animations, dark mode, detail sheet |

---

## Submission Checklist

- [x] Flutter project source
- [x] `assets/portfolio.json` with mock data
- [x] README with setup steps, dependencies, run instructions
- [x] Public GitHub repository
- [ ] Screenshots in `docs/screenshots/` *(add before evaluation)*
- [ ] Demo screen recording link *(add before evaluation)*

---

## Author

Built as a **Frontend Assignment — Investment Insights Dashboard (Flutter)**.

## License

Created for academic / assignment submission purposes.
