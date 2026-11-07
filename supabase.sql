-- دفتر الديون: جدول القيود + حماية RLS (كل مستخدم يشوف بياناته فقط)

create table if not exists public.entries (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null default auth.uid() references auth.users(id) on delete cascade,
  data       jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists entries_user_created_idx on public.entries (user_id, created_at);

alter table public.entries enable row level security;

drop policy if exists "entries_select_own" on public.entries;
drop policy if exists "entries_insert_own" on public.entries;
drop policy if exists "entries_delete_own" on public.entries;

create policy "entries_select_own" on public.entries
  for select to authenticated using (user_id = (select auth.uid()));

create policy "entries_insert_own" on public.entries
  for insert to authenticated with check (user_id = (select auth.uid()));

create policy "entries_delete_own" on public.entries
  for delete to authenticated using (user_id = (select auth.uid()));

grant select, insert, delete on public.entries to authenticated;
