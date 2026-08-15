-- Safe API hardening for the existing production schema.
-- This migration changes privileges/policies and removes only repository-
-- confirmed stale RPCs. It does not update or delete recipe/image data.

begin;

-- Add database-level feedback validation after confirming production currently
-- has no rows that would violate it.
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public."Feedback"'::regclass
      and conname = 'feedback_message_valid'
  ) then
    alter table public."Feedback"
      add constraint feedback_message_valid check (
        "Message" is not null
        and char_length(btrim("Message")) between 1 and 5000
      );
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conrelid = 'public."Feedback"'::regclass
      and conname = 'feedback_email_valid'
  ) then
    alter table public."Feedback"
      add constraint feedback_email_valid check (
        "Email" is null or char_length("Email") between 3 and 254
      );
  end if;
end;
$$;

-- Remove duplicated permissive policies and keep the app's intended public
-- reads and anonymous feedback insertion only.
drop policy if exists "Enable read access for all users" on public."Ingredients";
drop policy if exists "Ingredients anon read" on public."Ingredients";
drop policy if exists "Ingredients anon select" on public."Ingredients";
drop policy if exists "Recipes anon select" on public."Recipes";
drop policy if exists "allow anon read recipes" on public."Recipes";
drop policy if exists "Allow anonymous feedback insertion" on public."Feedback";
drop policy if exists "Feedback anon insert" on public."Feedback";
drop policy if exists "Allow only admin to see feedback" on public."Feedback";
drop policy if exists "Allow anon read maintenance" on public.app_maintenance;
drop policy if exists "app_maintenance anon read" on public.app_maintenance;
drop policy if exists "app_maintenance anon select" on public.app_maintenance;
drop policy if exists "current_version_admin_write" on public.current_version;
drop policy if exists "current_version_select_public" on public.current_version;
drop policy if exists "recipeimages public read" on storage.objects;

drop policy if exists recipes_public_read on public."Recipes";
drop policy if exists ingredients_public_read on public."Ingredients";
drop policy if exists feedback_public_insert on public."Feedback";
drop policy if exists feedback_admin_read on public."Feedback";
drop policy if exists maintenance_public_read on public.app_maintenance;
drop policy if exists version_public_read on public.current_version;
drop policy if exists keep_alive_public_read on public.keep_alive;
drop policy if exists recipeimages_public_read on storage.objects;

create policy recipes_public_read on public."Recipes"
for select to anon, authenticated using (true);
create policy ingredients_public_read on public."Ingredients"
for select to anon, authenticated using (true);
create policy feedback_public_insert on public."Feedback"
for insert to anon, authenticated
with check (
  "Message" is not null
  and char_length(btrim("Message")) between 1 and 5000
  and ("Email" is null or char_length("Email") between 3 and 254)
);
create policy feedback_admin_read on public."Feedback"
for select to authenticated using (auth.email() = 'bugraksaglam@gmail.com');
create policy maintenance_public_read on public.app_maintenance
for select to anon, authenticated using (id = 1);
create policy version_public_read on public.current_version
for select to anon, authenticated using (id = 1);
create policy keep_alive_public_read on public.keep_alive
for select to anon using (id = 1);
create policy recipeimages_public_read on storage.objects
for select to public using (bucket_id = 'RecipeImages');

-- Make table privileges match the RLS contract instead of relying on RLS to
-- compensate for broad direct grants.
revoke all on public."Recipes", public."Ingredients",
  public.app_maintenance, public.current_version, public.keep_alive
  from anon, authenticated;
grant select on public."Recipes", public."Ingredients",
  public.app_maintenance, public.current_version, public.keep_alive
  to anon, authenticated;

revoke all on public."Feedback" from anon, authenticated;
grant insert on public."Feedback" to anon, authenticated;
grant select on public."Feedback" to authenticated;
grant usage, select on sequence public."Feedback_id_seq" to anon, authenticated;
revoke all on sequence public."Recipes_Id_seq" from public, anon, authenticated;

-- Public image reads remain available; direct client writes are not.
revoke insert, update, delete, truncate, references, trigger
  on table storage.objects from anon, authenticated;
grant select on table storage.objects to public;

-- The app never calls these data-changing/internal helpers.
revoke all on function public.backfill_ingredients_tokens(integer, integer)
  from public, anon, authenticated, service_role;
revoke all on function public.normalize_recipe_tokens(jsonb)
  from public, anon, authenticated, service_role;
revoke all on function public.normalize_recipe_tokens(jsonb, jsonb, jsonb, jsonb)
  from public, anon, authenticated, service_role;
revoke all on function public.trg_set_ingredients_tokens()
  from public, anon, authenticated, service_role;
revoke all on function public.try_parse_jsonb_array(jsonb)
  from public, anon, authenticated, service_role;

-- Pin every remaining helper/trigger function to a controlled search path.
-- The RPCs below already set this explicitly; keep the internal functions
-- equally resistant to search_path hijacking when called by a server role.
alter function public.normalize_recipe_tokens(jsonb)
  set search_path = public, pg_temp;
alter function public.normalize_recipe_tokens(jsonb, jsonb, jsonb, jsonb)
  set search_path = public, pg_temp;
alter function public.trg_set_ingredients_tokens()
  set search_path = public, pg_temp;
alter function public.backfill_ingredients_tokens(integer, integer)
  set search_path = public, pg_temp;
alter function public.try_parse_jsonb_array(jsonb)
  set search_path = public, pg_temp;

revoke all on function public.get_recipes_by_food_type(text[])
  from public, anon, authenticated, service_role;
revoke all on function public.get_recipes_count(text[])
  from public, anon, authenticated, service_role;
grant execute on function public.get_recipes_by_food_type(text[])
  to anon, authenticated, service_role;
grant execute on function public.get_recipes_count(text[])
  to anon, authenticated, service_role;
alter function public.get_recipes_by_food_type(text[])
  set search_path = public, pg_temp;
alter function public.get_recipes_count(text[])
  set search_path = public, pg_temp;

-- Confirmed unused by the repository and reference removed legacy tables.
drop function if exists public.filterre(text[]);
drop function if exists public.get_recipes_with_any_ingredient(text[]);

-- Stop future public tables/sequences/functions from inheriting broad client
-- privileges. Future API exposure must be an explicit migration decision.
alter default privileges in schema public
  revoke all on tables from anon, authenticated;
alter default privileges in schema public
  revoke all on sequences from anon, authenticated;
alter default privileges in schema public
  revoke execute on functions from public, anon, authenticated;

-- Supabase-managed objects can be created by either owner. Keep future API
-- exposure explicit for both default-privilege owners when available.
alter default privileges for role postgres in schema public
  revoke all on tables from anon, authenticated;
alter default privileges for role postgres in schema public
  revoke all on sequences from anon, authenticated;
alter default privileges for role postgres in schema public
  revoke execute on functions from public, anon, authenticated;
alter default privileges for role supabase_admin in schema public
  revoke all on tables from anon, authenticated;
alter default privileges for role supabase_admin in schema public
  revoke all on sequences from anon, authenticated;
alter default privileges for role supabase_admin in schema public
  revoke execute on functions from public, anon, authenticated;

-- Preserve server-side access while removing client write privileges.
grant all on public."Feedback", public."Ingredients", public."Recipes",
  public.app_maintenance, public.current_version, public.keep_alive to service_role;

commit;
