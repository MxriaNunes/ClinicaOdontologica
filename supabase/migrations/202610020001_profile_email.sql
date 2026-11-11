alter table public.profiles
add column if not exists email text;

update public.profiles as profile
set email = auth_user.email
from auth.users as auth_user
where profile.id = auth_user.id
  and profile.email is null;

alter table public.profiles
alter column email set not null;

create unique index if not exists profiles_email_key
on public.profiles (email);

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
