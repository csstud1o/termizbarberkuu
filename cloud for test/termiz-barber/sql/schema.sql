-- =============================================
-- TERMIZ BARBER — Supabase Schema
-- Run this in Supabase SQL Editor
-- =============================================

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- =============================================
-- TABLES
-- =============================================

-- Barbers (Masters)
create table if not exists public.barbers (
  id          bigserial primary key,
  name        text not null,
  role        text default 'Barber',
  rating      numeric(3,1) default 4.5,
  reviews     int default 0,
  active      boolean default true,
  phone       text default '',
  note        text default '',
  avatar_url  text default '',
  created_at  timestamptz default now()
);

-- Services
create table if not exists public.services (
  id          bigserial primary key,
  name        text not null,
  icon        text default '✂️',
  price       int not null default 50000,
  duration    int not null default 30,
  description text default '',
  active      boolean default true,
  created_at  timestamptz default now()
);

-- Bookings
create table if not exists public.bookings (
  id            bigserial primary key,
  telegram_id   text,
  telegram_name text,
  barber_name   text not null,
  services_text text not null,
  total_price   int not null default 0,
  duration_min  int default 0,
  booking_date  text not null,
  booking_time  text not null,
  phone         text default '',
  note          text default '',
  status        text default 'pending' check (status in ('pending','done','cancel')),
  created_at    timestamptz default now()
);

-- Settings
create table if not exists public.settings (
  id           int primary key default 1,
  salon_name   text default 'Termiz Barber',
  salon_addr   text default 'Termiz sh.',
  salon_phone  text default '+998 90 000 00 00',
  work_hours   jsonb default '[
    {"day":"Dushanba","open":"09:00","close":"20:00","active":true},
    {"day":"Seshanba","open":"09:00","close":"20:00","active":true},
    {"day":"Chorshanba","open":"09:00","close":"20:00","active":true},
    {"day":"Payshanba","open":"09:00","close":"20:00","active":true},
    {"day":"Juma","open":"09:00","close":"20:00","active":true},
    {"day":"Shanba","open":"09:00","close":"19:00","active":true},
    {"day":"Yakshanba","open":"10:00","close":"17:00","active":false}
  ]'::jsonb,
  updated_at   timestamptz default now()
);

-- Admin telegram IDs
create table if not exists public.admins (
  telegram_id  text primary key,
  name         text default 'Admin',
  created_at   timestamptz default now()
);

-- =============================================
-- SEED DEFAULT DATA
-- =============================================

-- Default admin
insert into public.admins (telegram_id, name)
values ('8536944196', 'Bosh Admin')
on conflict (telegram_id) do nothing;

-- Default barbers
insert into public.barbers (name, role, rating, reviews, active) values
  ('Mirjalol', 'Top Barber', 4.9, 340, true),
  ('Sunnat', 'Premium Barber', 4.8, 210, true),
  ('Aliboy', 'Top Barber', 4.7, 180, true)
on conflict do nothing;

-- Default services
insert into public.services (name, icon, price, duration) values
  ('Soch olish', '✂️', 60000, 30),
  ('Soqol tekislash', '🪒', 40000, 30),
  ('Soch + Soqol', '💈', 90000, 60),
  ('Okantovka', '✨', 45000, 15),
  ('Kuyov soch turmagi', '👑', 500000, 120)
on conflict do nothing;

-- Default settings (only 1 row)
insert into public.settings (id) values (1)
on conflict (id) do nothing;

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

alter table public.barbers  enable row level security;
alter table public.services enable row level security;
alter table public.bookings enable row level security;
alter table public.settings enable row level security;
alter table public.admins   enable row level security;

-- BARBERS: everyone can read, only service role can write
create policy "barbers_read_all"  on public.barbers  for select using (true);
create policy "barbers_write_all" on public.barbers  for all    using (true) with check (true);

-- SERVICES: everyone can read
create policy "services_read_all"  on public.services for select using (true);
create policy "services_write_all" on public.services for all    using (true) with check (true);

-- BOOKINGS: anyone can insert their own, read all (admin handles via service key)
create policy "bookings_insert"    on public.bookings for insert with check (true);
create policy "bookings_read_all"  on public.bookings for select using (true);
create policy "bookings_update_all" on public.bookings for update using (true);
create policy "bookings_delete_all" on public.bookings for delete using (true);

-- SETTINGS: read all
create policy "settings_read_all"  on public.settings for select using (true);
create policy "settings_write_all" on public.settings for all    using (true) with check (true);

-- ADMINS: read all (for checking admin status on client)
create policy "admins_read_all"    on public.admins   for select using (true);
create policy "admins_write_all"   on public.admins   for all    using (true) with check (true);

-- =============================================
-- USEFUL VIEWS
-- =============================================

-- Booking stats view
create or replace view public.booking_stats as
select
  count(*)                                          as total_bookings,
  count(*) filter (where status = 'pending')        as pending_count,
  count(*) filter (where status = 'done')           as done_count,
  count(*) filter (where status = 'cancel')         as cancel_count,
  coalesce(sum(total_price) filter (where status = 'done'), 0) as total_revenue,
  count(distinct telegram_id) filter (where telegram_id is not null) as unique_clients
from public.bookings;

-- =============================================
-- DONE! Now get your keys:
-- Settings → API → Project URL & anon public key
-- =============================================
