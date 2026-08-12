--liquibase formatted sql

--changeset dokabdou:add-roles-timestamps
ALTER TABLE public.roles
    ADD COLUMN created_at timestamp NOT NULL DEFAULT now(),
    ADD COLUMN updated_at timestamp NOT NULL DEFAULT now();