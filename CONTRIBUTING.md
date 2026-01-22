# Contributing

Thanks for your interest in contributing!

## Quick Start

1. Fork the repo and create your branch:

   ```bash
   git checkout -b feature/your-change
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run checks before submitting:

   ```bash
   flutter analyze
   flutter test
   ```

## Guidelines

- Keep changes focused and incremental.
- Use the existing feature-based folder structure under `lib/features/`.
- Update localization files for user-facing strings.
- Avoid committing generated files unless required by the project (Freezed/json_serializable outputs are committed here).

## Pull Requests

- Describe the problem and solution.
- Include screenshots for UI changes when possible.
- Ensure there are no breaking changes without a clear migration note.
