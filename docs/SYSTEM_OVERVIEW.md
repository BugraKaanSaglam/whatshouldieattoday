# Yemek Tarifi App System Overview

This document explains how the app is wired together, which files do what, and where each screen gets its data. It is meant to help a new developer understand the system quickly.

---

## 1) Directory map (high level)

- `lib/main.dart` - app entry point, initializes localization, ads, local DB, and Supabase.
- `lib/app.dart` - app root, bootstrap controller, deep link handling, and router wiring.
- `lib/global/app_globals.dart` - global runtime values (database instance, screen metrics, feature flags).
- `lib/core/configs/router/` - GoRouter setup, routes, and redirection logic.
- `lib/core/network/` - Supabase-backed services and onboarding storage.
- `lib/providers/` - Provider viewmodels (bootstrap, home, recipes, favorites, onboarding).
- `lib/models/` - typed domain models and JSON/map conversion.
- `lib/screens/` - top-level pages (splash, onboarding, home, recipes, settings, etc).
- `lib/widgets/` - reusable UI building blocks.
- `lib/database/` - local SQLite storage for app preferences.
- `lib/enums/` - enums for language, categories, cuisines, cooking methods, implements.
- `lib/global/app_theme.dart` - global theme, colors, gradients.
- `lib/core/utils/` - shared helpers (forms, localization, formatting, sizing).

---

## 2) App boot and global state

### Entry point

- `lib/main.dart`:
  - Initializes Flutter bindings and EasyLocalization.
  - Initializes Google Mobile Ads.
  - Detects device language (`core/utils/locale_utils.dart`).
  - Loads cached local database from SQLite (`database/db_helper.dart`).
  - Creates initial DB state if missing (`global/default_ingredients.dart`).
  - Initializes Supabase (`core/configs/supabase_config.dart`).
  - Wraps the app with `EasyLocalization` and runs `FoodApp`.

### App root

- `lib/app.dart`:
  - Creates `AppBootstrapController` (maintenance, version, onboarding).
  - Builds `MaterialApp.router` with `AppRouter`.
  - Listens to app lifecycle and refreshes bootstrap on resume.
  - Handles deep links using `app_links` and forwards `/recipe/:id` to the router.

### Globals

- `lib/global/app_globals.dart` holds:
  - `globalDataBase` - local settings object (language, favorites, pantry).
  - `screenHeight`, `screenWidth`, `appBarHeight` - UI metrics.
  - `recipesTableName`, `recipeSearchFunctionName` - Supabase constants.
  - `isFirstLaunch` - used for first-run UX.

---

## 3) Routing and navigation

### Route names

Defined in `lib/core/configs/router/app_routes.dart`. Examples:

- `/splash`, `/force-update`, `/onboarding`
- `/` (home)
- `/recipes`, `/recipe/:id`
- `/favorites`, `/kitchen`, `/settings`, `/credits`, `/feedback`

### Router

- `lib/core/configs/router/app_router.dart` builds `GoRouter`:
  - Defines all routes and builders.
  - Resolves route params for recipe detail.
  - Injects maintenance and onboarding logic through bootstrap data.

### Redirect logic

- `AppRouter.redirect`:
  - While loading -> `/splash`.
  - If update required -> `/force-update`.
  - If onboarding not seen -> `/onboarding`.
  - Otherwise -> `/`.

---

## 4) Storage and backend

### Supabase

Configured in `lib/core/configs/supabase_config.dart`.

Tables and RPCs used:

- `Recipes` table
  - Fetch by `RecipeId` or `Id`.
  - Fallback search when RPC fails.
- `Ingredients` table
  - Search by `Ingredients` / `Ingredients_tr` columns.
- RPC: `get_recipes_by_food_type` (`recipeSearchFunctionName`)
  - Primary recipe search.
- RPC: `get_recipes_count`
  - Count for search results.
- `Feedback` table
  - User feedback submissions.
- `current_version` table
  - Min version enforcement.
- `app_maintenance` table
  - Maintenance flag.
- Storage bucket `RecipeImages`
  - Public URLs for recipe images.

### Local SQLite

- `lib/database/food_application_database.dart` - local settings model.
- `lib/database/db_helper.dart` - SQLite helper (table `foodAppTable`).

Stored fields:

- `Ver`, `LanguageCode`, `InitialIngredients`, `Favorites`.

### SharedPreferences

- `lib/core/network/onboarding_service.dart`
  - Key `has_seen_onboarding`.
  - Used by onboarding and bootstrap controller.

---

## 5) State management (Provider viewmodels)

### Bootstrap

- `lib/providers/bootstrap/app_bootstrap_controller.dart`
  - Loads maintenance status (`MaintenanceService`).
  - Loads required version (`VersionService`).
  - Loads onboarding flag (`OnboardingService`).
  - Exposes `requiresUpdate` and `hasSeenOnboarding` for router redirects.

### Home

- `lib/providers/home/main_viewmodel.dart`
  - Fetches total recipe count from Supabase.
  - Exposes `isBlinking` based on first launch.

### Recipes

- `lib/providers/recipes/food_selection_viewmodel.dart`
  - Manages selected ingredients and filter state.
  - Fetches recipes and count via `BackendService`.
  - Handles pagination and refresh.

### Favorites

- `lib/providers/favorites/favorites_viewmodel.dart`
  - Loads favorites from local DB.
  - Fetches recipe details for each favorite from Supabase.

### Onboarding

- `lib/providers/onboarding/onboarding_viewmodel.dart`
  - Holds onboarding steps and page controller.
  - Marks onboarding as completed via `OnboardingService`.

---

## 6) Models and enums

### Models

- `lib/models/recipe/food.dart` - Freezed model, JSON + CSV map parsing.
- `lib/models/recipe/ingredient.dart` - Freezed model for ingredients.
- `lib/models/favorites/favorite.dart` - Freezed model for favorites.
- `lib/models/onboarding/onboarding_step.dart` - onboarding UI model.
- `lib/models/bootstrap/app_bootstrap_data.dart` - app bootstrap payload.
- `lib/models/recipe/food_type.dart`, `food_selection_dto.dart` - filter helpers.

### Enums

- `lib/enums/language_enum.dart`
- `lib/enums/categories_enum.dart`
- `lib/enums/cuisines_enum.dart`
- `lib/enums/cooking_methods_enum.dart`
- `lib/enums/implements_enum.dart`

---

## 7) Shared UI building blocks

- `lib/widgets/app_scaffold.dart`
  - Gradient background scaffold with safe areas.
- `lib/widgets/main_app_bar.dart`
  - App-wide gradient AppBar.
- `lib/widgets/force_update_page.dart`
  - Update-required screen UI.
- `lib/widgets/recipes/food_image.dart`
  - Cached recipe images (memory + disk cache).
- `lib/widgets/recipes/food_selection_helpers.dart`
  - Ingredient search dropdown (Supabase-backed).

---

## 8) Screen by screen data flow

### SplashScreen

File: `lib/screens/splash/splash_screen.dart`

- Simple loading state while bootstrap resolves.

### OnboardingScreen

File: `lib/screens/onboarding/onboarding_screen.dart`

- Uses `OnboardingViewModel` + `OnboardingService`.
- On completion, marks onboarding and navigates to home.

### MainScreen (home)

File: `lib/screens/home/main_screen.dart`

- Uses `MainViewModel` to show recipe count.
- Uses maintenance status from bootstrap to show banner.
- Routes to recipes, favorites, kitchen, settings, credits.

### FoodSelectionScreen

File: `lib/screens/recipes/food_selection_screen.dart`

- Uses `FoodSelectionViewModel`.
- Ingredient selection uses `IngredientSearchDropdown` (Supabase search).
- Fetches recipe list via `BackendService.fetchRecipes` and count.

### SelectedFoodScreen

File: `lib/screens/recipes/selected_food_screen.dart`

- Loads recipe details (by id or from route extra).
- Shows image via `FoodImage` + Supabase storage URL.
- Favorites are stored locally in SQLite.
- Share uses `share_plus`, fallback copies link to clipboard.
- Feedback button routes to `FeedbackScreen`.

### FavoritesScreen

File: `lib/screens/favorites/favorites_screen.dart`

- Uses `FavoritesViewModel` (local favorites + Supabase fetch).
- Tapping a favorite opens recipe detail.

### KitchenScreen

File: `lib/screens/kitchen/kitchen_screen.dart`

- Edits saved pantry ingredients.
- Saves/removes ingredients in local SQLite.

### SettingsScreen

File: `lib/screens/settings/settings_screen.dart`

- Updates language preference in local SQLite.
- Applies locale via EasyLocalization.

### FeedbackScreen

File: `lib/screens/feedback/feedback_screen.dart`

- Submits user feedback to Supabase `Feedback` table.

### CreditsScreen

File: `lib/screens/credits/credits_screen.dart`

- Shows data source attribution and license link.

### ForceUpdateScreen

File: `lib/screens/force_update/force_update_screen.dart`

- Enforces minimum version and directs to store.

---

## 9) Key flows (end to end)

## Onboarding

1) App loads `OnboardingService.hasSeenOnboarding` in bootstrap.
2) Router redirects to `/onboarding` if not seen.
3) On completion, flag is written and router returns home.

### Recipe discovery

1) User selects ingredients.
2) `FoodSelectionViewModel` calls `BackendService.fetchRecipes` (RPC or fallback).
3) Results are paged and rendered.

## Favorites

1) User toggles favorite on recipe detail.
2) Favorite list saved in SQLite.
3) Favorites screen loads details from Supabase.

### Deep links

1) AppLinks receives `.../recipe/:id`.
2) Router pushes recipe detail with id + optional category.

### Feedback

1) User submits feedback in `FeedbackScreen`.
2) `BackendService.submitFeedback` inserts into Supabase.

---

## 10) Helpful references

- Entry point: `lib/main.dart`
- Router: `lib/core/configs/router/app_router.dart`
- Global theme: `lib/global/app_theme.dart`
- Supabase config: `lib/core/configs/supabase_config.dart`
- Local DB: `lib/database/db_helper.dart`
- Recipe model: `lib/models/recipe/food.dart`
- Ingredient model: `lib/models/recipe/ingredient.dart`

---

If you add new screens or providers, update this doc to keep the data flow map accurate.
