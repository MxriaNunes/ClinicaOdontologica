alter table public.appointments
    drop constraint if exists appointment_date_in_future;

create or replace function public.ensure_appointment_date_not_in_past()
returns trigger
language plpgsql
set search_path = public
as $$
begin
    if new.appointment_date < current_date then
        raise exception 'Appointment date must be today or later'
            using errcode = '23514',
                  constraint = 'appointment_date_in_future';
    end if;

    return new;
end;
$$;

drop trigger if exists appointments_check_date_on_insert on public.appointments;
create trigger appointments_check_date_on_insert
before insert on public.appointments
for each row execute function public.ensure_appointment_date_not_in_past();

drop trigger if exists appointments_check_date_on_date_change on public.appointments;
create trigger appointments_check_date_on_date_change
before update of appointment_date on public.appointments
for each row execute function public.ensure_appointment_date_not_in_past();