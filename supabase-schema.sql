-- 家計簿ライフプラン: Supabaseテーブル定義
-- SupabaseダッシュボードのSQL Editorに貼り付けて Run してください。

-- ライフプランの前提条件（1ユーザー1行、JSONまるごと保存）
create table public.plans (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null,
  updated_at timestamptz not null default now()
);
alter table public.plans enable row level security;
create policy "own plan" on public.plans
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 家計簿の明細
create table public.entries (
  id text primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  kind text not null check (kind in ('expense','income')),
  category text not null,
  amount integer not null,
  memo text default '',
  deleted boolean not null default false,
  updated_at timestamptz not null default now()
);
alter table public.entries enable row level security;
create policy "own entries" on public.entries
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create index entries_user_updated on public.entries (user_id, updated_at);
