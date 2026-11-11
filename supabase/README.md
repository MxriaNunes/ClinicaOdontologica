# Supabase

1. Crie um projeto no Supabase.
2. Execute os arquivos da pasta `migrations` no SQL Editor em ordem de data.
3. Execute `seed.sql` para inserir tratamentos, horários, galeria e avaliações.
4. Ative o cadastro por e-mail em **Authentication > Providers**.
5. Crie o usuário administrador em **Authentication > Users > Add user**. Informe o e-mail e uma senha forte e confirme o usuário.
6. Promova o usuário para administrador no SQL Editor, substituindo o e-mail:

```sql
update public.profiles
set role = 'admin'
where id = (
    select id
    from auth.users
    where email = 'admin@seudominio.com'
);
```

7. Inicie o site com `npm run dev` e entre com o e-mail e a senha criados no Supabase Auth.

O cadastro público também usa Supabase Auth; os dados de perfil são salvos em `public.profiles`. Senhas nunca são armazenadas pelo aplicativo nem em `localStorage`. Não use a chave `service_role` no navegador ou no arquivo `.env` da aplicação; use apenas a chave anon/publishable.

Se o projeto já tinha apenas a migration inicial aplicada, execute agora `migrations/202610020001_profile_email.sql` no SQL Editor antes de publicar esta versão.

Execute também `migrations/202610090001_service_specialties.sql` para habilitar as especialidades, o profissional responsável e o preço opcional dos serviços.
