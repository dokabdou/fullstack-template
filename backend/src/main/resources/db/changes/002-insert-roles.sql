--liquibase formatted sql

--changeset dokabdou:insert-default-roles
INSERT INTO public.roles (id, role_name, created_at, updated_at)
VALUES
    ('322ee4eb-75bf-4d03-abc6-11d56f7b7e95', 'ADMIN', now(), now()),
    ('822ee4eb-75bf-4d03-abc6-11d56f7b7e97', 'USER', now(), now())
ON CONFLICT (role_name) DO NOTHING;