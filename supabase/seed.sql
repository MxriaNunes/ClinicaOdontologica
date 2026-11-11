insert into public.services (title, description, duration_minutes, price, specialty)
values
    ('Avaliação Inicial & Limpeza', 'Diagnóstico completo com radiografia digital e remoção de tártaro e placa.', 45, 150.00, 'Clínico Geral'),
    ('Clareamento Dental a Laser', 'Tratamento estético para branqueamento seguro e rápido dos dentes.', 60, 600.00, 'Dentística'),
    ('Restauração Estética', 'Reparo de cáries ou fraturas com resina da cor natural do dente.', 50, 220.00, 'Dentística'),
    ('Tratamento de Canal (Endodontia)', 'Procedimento para salvar dentes danificados ou infectados sem dor.', 90, 850.00, 'Endodontia');

insert into public.availability_slots (slot_time)
values ('08:00'), ('09:00'), ('10:00'), ('11:00'), ('14:00'), ('15:00'), ('16:00'), ('17:00');

insert into public.gallery_items (title, description, image_url, active)
values
    ('Lentes de Contato Dental', 'Transformação completa do sorriso utilizando lâminas superfinas de porcelana.', 'https://images.unsplash.com/photo-1606811841689-23dfddce3e95?auto=format&fit=crop&w=800&q=80', true),
    ('Clareamento de Consultório', 'Resultado de 2 sessões de clareamento a laser com ganho de 4 tons.', 'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=800&q=80', true),
    ('Reabilitação Oral', 'Restauração da função mastigatória e estética através de próteses fixas.', 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=800&q=80', true);

insert into public.reviews (patient_name, rating, comment, verified, active)
values
    ('Carlos Eduardo', 5, 'Atendimento impecável! O doutor é extremamente atencioso e o consultório super moderno.', false, true),
    ('Ana Paula Souza', 5, 'Fiz meu clareamento e adorei o resultado. Procedimento sem dor e ambiente acolhedor.', false, true),
    ('Roberto Lima', 5, 'Sempre tive medo de dentista, mas a equipe da OdontoVida me deixou super tranquilo.', false, true);
