# What Should I Eat Today

`What Should I Eat Today` is a Flutter recipe discovery app built to reduce a simple everyday friction: deciding what to cook with the ingredients already available at home.

The product centers on fast recipe discovery, lightweight kitchen planning, and resilient offline behavior. Users can save pantry ingredients, filter recipes, favorite meals they want to revisit, and keep those favorites accessible even when the device is offline.

This is my second mobile application project, and I treated it as a deliberate step toward more production-ready Flutter engineering: better UI consistency, clearer app architecture, stronger offline UX, and a real automated test pipeline.

## Product Goal

The app is designed around one core question:

`What can I cook right now with what I already have?`

Instead of starting from a recipe and then shopping backward, the experience starts from the user's kitchen. The app helps users:

- save frequently used ingredients
- discover matching recipes quickly
- keep favorite recipes on-device for offline access
- navigate a localized Turkish/English experience

## Key Features

- Ingredient-based recipe discovery
- Saved kitchen ingredients for faster repeat searches
- Favorites with local device caching
- Offline favorites browsing and recovery-friendly UX
- Turkish / English localization
- Onboarding flow for first-time users
- Version gating / force update support
- Connectivity-aware UI states
- Sharing support for both recipes and the app itself

## Technical Focus

This repository is intentionally structured like an app I would want reviewed in a hiring process, not just a demo that happens to run.

Highlights:

- `Flutter` + `Dart`
- `Provider`-based view model structure
- `go_router` navigation
- `Freezed` + `json_serializable` model generation
- `Supabase` for remote data access
- local persistence with `SQLite`
- offline-friendly favorites cache
- unit, widget, and integration smoke tests
- GitHub Actions CI for analyze + test workflows

## Architecture Overview

The codebase follows a layered, pragmatic structure:

```text
lib/
  core/        routing, services, utilities, network and platform helpers
  database/    local storage models and db helpers
  enums/       strongly typed app enums
  global/      app theme, globals, shared configuration
  models/      recipe, onboarding, bootstrap, and favorites models
  providers/   screen/view state and business logic
  screens/     user-facing pages
  widgets/     reusable UI components
  gen/         generated assets
```

Additional technical documentation:

- [System Overview](docs/SYSTEM_OVERVIEW.md)
- [Data Source](docs/DATA_SOURCE.md)
- [ODbL 1.0 License](docs/LICENSE-ODbL-1.0.txt)

## Quality and Testing

The project includes:

- `flutter analyze`
- unit tests for models, services, utilities, and stores
- widget tests for key screens and offline states
- integration smoke coverage for the main screen flow
- CI workflow under [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml)

## Getting Started

1. Install Flutter on the stable channel.
2. Fetch dependencies:

```bash
flutter pub get
```

3. Configure Supabase using `supabase.env` and `lib/core/configs/supabase_config.dart`.
4. Run the app:

```bash
flutter run
```

## Localization

Translations live in `assets/translations/` and currently support:

- Turkish
- English

When adding new copy, update both translation files together.

## Data Source and Licensing

Recipe data is based on the Culinary Recipes Dataset and distributed under `ODbL 1.0`.

For details, see:

- [docs/DATA_SOURCE.md](docs/DATA_SOURCE.md)
- [docs/LICENSE-ODbL-1.0.txt](docs/LICENSE-ODbL-1.0.txt)

## Repository Notes

This is a public portfolio repository. The goal is not only to ship a working app, but to show clear product thinking, maintainable Flutter structure, and iterative improvement from feature delivery to engineering quality.

## Contributing and Security

- [Contributing Guide](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)
