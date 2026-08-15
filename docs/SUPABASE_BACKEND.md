# Supabase Backend

The app uses the public Supabase client only. Runtime data access is
centralized in `lib/core/network/backend_service.dart`, and recipe identity is
the quoted `Recipes.Id` primary key. Client builds must receive
`SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY`; never use a `service_role` key
in Flutter, CI artifacts, or `tool/config/supabase.local.json`.

## Production invariants

The linked project currently contains the production recipe and ingredient
dataset. The modernization work does not seed, rewrite, renumber, or delete
those rows or their `RecipeImages` objects. Public recipe/ingredient reads,
public image reads, anonymous feedback inserts, and administrator-only
feedback reads are intentional API behavior.

## Backend boundary for this modernization

Supabase schema capture, migration reproducibility, migration-history
reconciliation, RLS/function/storage changes, and production data changes are
explicitly out of scope for this goal. The production backend is treated as a
working dependency and is left untouched: no Docker, `pg_dump`, `db pull`,
`db push`, migration repair, reset, or remote SQL migration is part of the
Flutter modernization workflow.

The checked-in client contract remains the source of truth for this work:
public recipe and ingredient reads, public `RecipeImages` reads, anonymous
feedback insertion, quoted `Recipes.Id` identity, and the
`RecipeImages/{recipeId}.jpg` object-path contract.

## Contract notes

- Recipes are read by `Id`; legacy `RecipeId` fallback is not part of the app
  data contract.
- Feedback input is bounded at the client and database layers.
- Client table grants are read-only except for feedback insertion.
- Sensitive helper functions are not executable by anonymous clients.
- Storage policy permits public reads from `RecipeImages` while denying client
  writes.
- `RecipeImages` is configured as a public bucket in `supabase/config.toml`;
  its production objects are never seeded into Git.
