create extension if not exists pgcrypto;

create type public.user_role as enum ('admin', 'patient');
create type public.appointment_status as enum ('Pendente', 'Confirmado', 'Concluído', 'Cancelado');

create table public.profiles (
    id uuid primary key references auth.users(id) on delete cascade,
    email text not null unique,
    name text not null check (char_length(trim(name)) >= 2),
    phone text,
    role public.user_role not null default 'patient',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.services (
    id uuid primary key default gen_random_uuid(),
    title text not null check (char_length(trim(title)) >= 2),
    description text not null default '',
    duration_minutes integer not null check (duration_minutes > 0),
    price numeric(10, 2) not null check (price >= 0),
    active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table public.availability_slots (
    id uuid primary key default gen_random_uuid(),
    slot_time time not null unique,
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create table public.appointments (
    id uuid primary key default gen_random_uuid(),
    patient_id uuid not null references public.profiles(id) on delete cascade,
    service_id uuid not null references public.services(id) on delete restrict,
    appointment_date date not null,
    appointment_time time not null,
    status public.appointment_status not null default 'Pendente',
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint appointment_date_in_future check (appointment_date >= current_date)
);

create unique index appointments_active_slot_idx
    on public.appointments (appointment_date, appointment_time)
    where status <> 'Cancelado';

create table public.gallery_items (
    id uuid primary key default gen_random_uuid(),
    title text not null,
    description text not null default '',
    image_url text not null,
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create table public.reviews (
    id uuid primary key default gen_random_uuid(),
    patient_name text not null,
    rating integer not null check (rating between 1 and 5),
    comment text not null,
    verified boolean not null default false,
    active boolean not null default true,
    created_at timestamptz not null default now()
);

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
    select exists (
        select 1 from public.profiles
        where id = auth.uid() and role = 'admin'
    );
$$;

grant execute on function public.is_admin() to anon, authenticated;

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
    insert into public.profiles (id, email, name, phone)
    values (
        new.id,
        new.email,
        coalesce(new.raw_user_meta_data ->> 'name', split_part(new.email, '@', 1)),
        new.raw_user_meta_data ->> 'phone'
    );
    return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
    new.updated_at = now();
    return new;
end;
$$;

create trigger profiles_set_updated_at before update on public.profiles
for each row execute procedure public.set_updated_at();
create trigger services_set_updated_at before update on public.services
for each row execute procedure public.set_updated_at();
create trigger appointments_set_updated_at before update on public.appointments
for each row execute procedure public.set_updated_at();

alter table public.profiles enable row level security;
alter table public.services enable row level security;
alter table public.availability_slots enable row level security;
alter table public.appointments enable row level security;
alter table public.gallery_items enable row level security;
alter table public.reviews enable row level security;

create policy "public reads active services" on public.services
for select to anon, authenticated using (active or public.is_admin());
create policy "admins manage services" on public.services
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "public reads active slots" on public.availability_slots
for select to anon, authenticated using (active or public.is_admin());
create policy "admins manage slots" on public.availability_slots
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "users read own profile" on public.profiles
for select to authenticated using (id = auth.uid() or public.is_admin());
create policy "users update own profile" on public.profiles
for update to authenticated using (id = auth.uid()) with check (id = auth.uid());
create policy "admins manage profiles" on public.profiles
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "patients read own appointments" on public.appointments
for select to authenticated using (patient_id = auth.uid() or public.is_admin());
create policy "patients create own appointments" on public.appointments
for insert to authenticated with check (patient_id = auth.uid());
create policy "patients cancel own appointments" on public.appointments
for update to authenticated
using (patient_id = auth.uid() or public.is_admin())
with check (patient_id = auth.uid() or public.is_admin());
create policy "admins manage appointments" on public.appointments
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "public reads active gallery" on public.gallery_items
for select to anon, authenticated using (active or public.is_admin());
create policy "admins manage gallery" on public.gallery_items
for all to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "public reads active reviews" on public.reviews
for select to anon, authenticated using (active or public.is_admin());
create policy "admins manage reviews" on public.reviews
for all to authenticated using (public.is_admin()) with check (public.is_admin());
