-- Baseline for the existing production schema.
-- This migration is schema-only: it intentionally contains no recipe,
-- ingredient, feedback, storage-object, or other production data.

create sequence public."Feedback_id_seq";
create sequence public."Recipes_Id_seq";

create table public."Feedback" (
  "RecipeId" bigint,
  "Email" text,
  "Message" text,
  "Created_at" timestamp with time zone,
  id integer not null default nextval('public."Feedback_id_seq"'::regclass),
  constraint "Feedback_pkey" primary key (id)
);

alter sequence public."Feedback_id_seq" owned by public."Feedback".id;

create table public."Ingredients" (
  "Id" bigint not null,
  "Ingredients" text,
  "Ingredients_tr" text,
  constraint "Ingredients_pkey" primary key ("Id")
);

create table public."Recipes" (
  "Id" bigint not null default nextval('public."Recipes_Id_seq"'::regclass),
  "Name" text not null,
  "Name_tr" text not null,
  "Rating Value" text,
  "Rating Count" double precision,
  "Preparation Time" double precision,
  "Cooking Time" double precision,
  "Category" text,
  "Cuisine" text,
  "Ingredients" jsonb not null default '[]'::jsonb,
  "Ingredients_tr" jsonb not null default '[]'::jsonb,
  "Ingredients_Raw" text,
  "Ingredients_Raw_tr" text,
  "Instructions" text,
  "Instructions_tr" text,
  "Cooking Methods" text,
  "Implements" text,
  "Number of steps" double precision,
  "Servings" text,
  "Servings_tr" text,
  "Nutrition" jsonb not null default '{}'::jsonb,
  "URL" text,
  ingredients_tokens text[],
  constraint "Recipes_pkey" primary key ("Id")
);

alter sequence public."Recipes_Id_seq" owned by public."Recipes"."Id";

create table public.app_maintenance (
  id integer not null default 1,
  is_active boolean not null default false,
  constraint app_maintenance_pkey primary key (id)
);

create table public.current_version (
  id integer not null,
  version text not null,
  constraint current_version_pkey primary key (id),
  constraint current_version_id_check check (id = 1)
);

create table public.keep_alive (
  id bigint not null,
  created_at timestamp with time zone not null default now(),
  constraint keep_alive_pkey primary key (id)
);

create index idx_recipes_ingredients_tokens_gin
  on public."Recipes" using gin (ingredients_tokens);
create index recipes_ingredients_gin_idx
  on public."Recipes" using gin ("Ingredients");
create index recipes_ingredients_tr_gin_idx
  on public."Recipes" using gin ("Ingredients_tr");

create or replace function public.normalize_recipe_tokens(ingredients jsonb)
returns text[]
language sql
immutable
as $$
  select array(
    select distinct lower(trim(val))
    from (
      select elem->>'ingredient' as val
      from jsonb_array_elements(coalesce(ingredients, '[]'::jsonb)) elem
      where elem ? 'ingredient'
    ) source
    where trim(coalesce(val, '')) <> ''
  );
$$;

create or replace function public.normalize_recipe_tokens(
  ingredients jsonb,
  ingredients_tr jsonb,
  ingredients_raw jsonb,
  ingredients_raw_tr jsonb
)
returns text[]
language sql
immutable
as $$
  with source as (
    select
      coalesce(ingredients, '[]'::jsonb) as ingredients,
      coalesce(ingredients_tr, '[]'::jsonb) as ingredients_tr
  )
  select array(
    select distinct lower(trim(value))
    from (
      select elem->>'ingredient' as value from source, jsonb_array_elements(source.ingredients) elem
      union all
      select elem->>'Ingredient' as value from source, jsonb_array_elements(source.ingredients) elem
      union all
      select elem->>'ingredient_tr' as value from source, jsonb_array_elements(source.ingredients_tr) elem
      union all
      select elem->>'Ingredient_tr' as value from source, jsonb_array_elements(source.ingredients_tr) elem
    ) values_source
    where trim(coalesce(value, '')) <> ''
  );
$$;

create or replace function public.trg_set_ingredients_tokens()
returns trigger
language plpgsql
as $$
begin
  new.ingredients_tokens := public.normalize_recipe_tokens(new."Ingredients");
  return new;
end;
$$;

create trigger set_ingredients_tokens
before insert or update on public."Recipes"
for each row execute function public.trg_set_ingredients_tokens();

create or replace function public.get_recipes_by_food_type(ingredients text[])
returns setof public."Recipes"
language sql
stable
security definer
set search_path = public, pg_temp
set statement_timeout = '12s'
as $$
  with normalized as (
    select array(
      select lower(trim(value))
      from unnest(ingredients) value
      where trim(value) <> ''
    ) as values
  )
  select recipes.*
  from public."Recipes" recipes
  join normalized on true
  where not exists (
    select 1
    from unnest(recipes.ingredients_tokens) token
    where token <> '' and not (token = any (normalized.values))
  );
$$;

create or replace function public.get_recipes_count(ingredients text[])
returns bigint
language sql
stable
security definer
set search_path = public, pg_temp
set statement_timeout = '12s'
as $$
  with normalized as (
    select array(
      select lower(trim(value))
      from unnest(ingredients) value
      where trim(value) <> ''
    ) as values
  )
  select count(*)
  from public."Recipes" recipes
  join normalized on true
  where not exists (
    select 1
    from unnest(recipes.ingredients_tokens) token
    where token <> '' and not (token = any (normalized.values))
  );
$$;

create or replace function public.backfill_ingredients_tokens(
  batch_size integer default 2000,
  max_ms integer default 60000
)
returns integer
language plpgsql
as $$
declare
  rows_updated integer;
  total_updated integer := 0;
  started_at timestamptz := clock_timestamp();
begin
  loop
    update public."Recipes" recipes
    set ingredients_tokens = public.normalize_recipe_tokens(recipes."Ingredients")
    where recipes.ctid in (
      select ctid
      from public."Recipes"
      where ingredients_tokens is null or ingredients_tokens = '{}'
      limit batch_size
    );
    get diagnostics rows_updated = row_count;
    total_updated := total_updated + rows_updated;
    exit when rows_updated = 0;
    exit when clock_timestamp() - started_at > (max_ms || ' milliseconds')::interval;
    perform pg_sleep(0.02);
  end loop;
  return total_updated;
end;
$$;

create or replace function public.try_parse_jsonb_array(value jsonb)
returns jsonb
language plpgsql
immutable
as $$
declare
  text_value text;
  parsed jsonb;
begin
  if value is null or value = 'null'::jsonb then return '[]'::jsonb; end if;
  if jsonb_typeof(value) = 'array' then return value; end if;
  if jsonb_typeof(value) = 'string' then
    text_value := value #>> '{}';
    begin
      parsed := text_value::jsonb;
      if jsonb_typeof(parsed) = 'array' then return parsed; end if;
    exception when others then
      begin
        parsed := regexp_replace(text_value, '''', '"', 'g')::jsonb;
        if jsonb_typeof(parsed) = 'array' then return parsed; end if;
      exception when others then
        return jsonb_build_array(text_value);
      end;
    end;
  end if;
  return jsonb_build_array(value);
end;
$$;

alter table public."Feedback" enable row level security;
alter table public."Ingredients" enable row level security;
alter table public."Recipes" enable row level security;
alter table public.app_maintenance enable row level security;
alter table public.current_version enable row level security;
alter table public.keep_alive enable row level security;

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

-- RecipeImages is intentionally public-read. No write policy is defined.
create policy recipeimages_public_read on storage.objects
for select to public using (bucket_id = 'RecipeImages');

grant usage on schema public to anon, authenticated;
grant select on public."Recipes", public."Ingredients", public.app_maintenance,
  public.current_version, public.keep_alive to anon, authenticated;
grant insert on public."Feedback" to anon, authenticated;
grant select on public."Feedback" to authenticated;
grant usage, select on sequence public."Feedback_id_seq" to anon, authenticated;
grant all on public."Feedback", public."Ingredients", public."Recipes",
  public.app_maintenance, public.current_version, public.keep_alive to service_role;
grant usage, select on sequence public."Feedback_id_seq", public."Recipes_Id_seq"
  to service_role;
grant select on storage.objects to public;

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
revoke all on function public.get_recipes_by_food_type(text[])
  from public, anon, authenticated, service_role;
revoke all on function public.get_recipes_count(text[])
  from public, anon, authenticated, service_role;
grant execute on function public.get_recipes_by_food_type(text[])
  to anon, authenticated, service_role;
grant execute on function public.get_recipes_count(text[])
  to anon, authenticated, service_role;

alter default privileges in schema public
  revoke all on tables from anon, authenticated;
alter default privileges in schema public
  revoke all on sequences from anon, authenticated;
alter default privileges in schema public
  revoke execute on functions from public, anon, authenticated;
