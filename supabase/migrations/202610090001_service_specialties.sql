alter table public.services
    add column specialty text not null default 'Clínico Geral',
    add column professional_name text,
    alter column price drop not null;

alter table public.services
    add constraint services_specialty_check check (
        specialty in (
            'Clínico Geral',
            'Ortodontia',
            'Endodontia',
            'Dentística',
            'Periodontia',
            'Prótese',
            'Harmonização Facial',
            'Cirurgia Bucomaxilofacial',
            'Implantodontia'
        )
    );