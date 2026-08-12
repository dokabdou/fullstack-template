--liquibase formatted sql

--changeset dokabdou:initial-user-schema

-- liquidebase are important to create the database schema and tables for the application
CREATE TABLE public.roles (
    "id" uuid NOT NULL,
    "role_name" varchar NOT NULL,
    CONSTRAINT roles_pkey PRIMARY KEY ("id"),
    CONSTRAINT "roles_role_name_key" UNIQUE ("role_name")
);

CREATE TABLE public.users (
    "id" uuid NOT NULL,
    "firstname" varchar NOT NULL,
    "lastname" varchar NOT NULL,
    "birthdate" date NULL,
    "email" varchar NOT NULL,
    "password" varchar NOT NULL,
    "created_at" timestamp NOT NULL DEFAULT now(),
    "updated_at" timestamp NOT NULL DEFAULT now(),
    CONSTRAINT users_pkey PRIMARY KEY ("id"),
    CONSTRAINT users_email_key UNIQUE ("email")
);

CREATE TABLE public.user_role (
    "user_id" uuid NOT NULL,
    "role_id" uuid NOT NULL,
    CONSTRAINT user_role_roles_fk FOREIGN KEY ("role_id") REFERENCES public.roles("id"),
    CONSTRAINT user_role_users_fk FOREIGN KEY ("user_id") REFERENCES public.users("id")
);