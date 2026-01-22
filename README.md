# What Should I Eat Today

A Flutter recipe discovery app that helps users find meals based on their pantry ingredients. It includes onboarding, favorites, localization, and Supabase-backed data access.

## Highlights

- Ingredient-based recipe discovery with filters
- Favorites and sharing
- Onboarding flow for first-time users
- Turkish/English localization
- Supabase data source + local SQLite cache
- Feature-based folder structure

## Tech Stack

- Flutter + Dart
- Provider for state management
- go_router for navigation
- Freezed + json_serializable for models
- Supabase for backend data

## Project Structure

```
lib/
  app/                 App bootstrap + router
  core/                Shared services, theme, db, utilities
  features/            Feature-based screens, models, viewmodels
```

## Getting Started

1. Install Flutter (stable channel).
2. Fetch dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Supabase (see `supabase.env` and `lib/core/config/supabase_config.dart`).
4. Run the app:

   ```bash
   flutter run
   ```

## Localization

Translation files live in `assets/translations/` (TR/EN). Add new keys in both files and use `tr()` in widgets.

## Data Source & Licensing

Recipe data is based on the Culinary Recipes Dataset (ODbL 1.0). See:

- `docs/DATA_SOURCE.md`
- `docs/LICENSE-ODbL-1.0.txt`

## Contributing

See `CONTRIBUTING.md` for development guidelines.

## Security

Report issues via `SECURITY.md`.
