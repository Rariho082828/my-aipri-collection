-- Supabase SQL Editorで全体を実行してください
create table if not exists public.cards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  character text default '',
  series text default 'ひみつのアイプリ',
  release text default '',
  number text default '',
  rarity text default '',
  kind text default '通常',
  quantity integer not null default 0 check (quantity >= 0),
  memo text default '',
  image_url text,
  created_at timestamptz not null default now()
);
alter table public.cards enable row level security;
drop policy if exists "Users can view own cards" on public.cards;
create policy "Users can view own cards" on public.cards for select using (auth.uid() = user_id);
drop policy if exists "Users can insert own cards" on public.cards;
create policy "Users can insert own cards" on public.cards for insert with check (auth.uid() = user_id);
drop policy if exists "Users can update own cards" on public.cards;
create policy "Users can update own cards" on public.cards for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete own cards" on public.cards;
create policy "Users can delete own cards" on public.cards for delete using (auth.uid() = user_id);

-- 画像バケット。画像URLは公開URLになります。カード画像を非公開にしたい場合は別途Private bucket＋署名URL運用に変更してください。
insert into storage.buckets (id, name, public) values ('card-images','card-images',true)
on conflict (id) do nothing;
create policy "Users upload own card images" on storage.objects for insert to authenticated
with check (bucket_id = 'card-images' and (storage.foldername(name))[1] = auth.uid()::text);


-- 既存プロジェクトにも適用できる追加列
alter table public.cards add column if not exists favorite boolean not null default false;
alter table public.cards add column if not exists catalog_id text;
create unique index if not exists cards_user_catalog_id_unique on public.cards(user_id,catalog_id) where catalog_id is not null;
