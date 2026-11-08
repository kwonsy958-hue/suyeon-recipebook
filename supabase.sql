-- Supabase SQL Editor에서 한 번 실행하세요.
create table if not exists public.recipes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 150),
  category text not null default '기타',
  ingredients text not null default '',
  steps text not null default '',
  notes text not null default '',
  minutes integer check (minutes is null or minutes between 0 and 10000),
  servings integer check (servings is null or servings between 1 and 1000),
  photo_path text,
  favorite boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index if not exists recipes_user_updated_idx on public.recipes(user_id, updated_at desc);
alter table public.recipes enable row level security;
create policy "read own recipes" on public.recipes for select to authenticated using ((select auth.uid()) = user_id);
create policy "insert own recipes" on public.recipes for insert to authenticated with check ((select auth.uid()) = user_id);
create policy "update own recipes" on public.recipes for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "delete own recipes" on public.recipes for delete to authenticated using ((select auth.uid()) = user_id);
-- Private bucket: 사진은 소유자만 접근합니다.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('recipe-photos','recipe-photos',false,5242880,array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do nothing;
create policy "read own photos" on storage.objects for select to authenticated using (bucket_id='recipe-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "upload own photos" on storage.objects for insert to authenticated with check (bucket_id='recipe-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
create policy "delete own photos" on storage.objects for delete to authenticated using (bucket_id='recipe-photos' and (storage.foldername(name))[1] = (select auth.uid())::text);
