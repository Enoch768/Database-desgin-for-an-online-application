
BEGIN;


CREATE TABLE IF NOT EXISTS public.address
(
    id integer NOT NULL DEFAULT nextval('address_id_seq'::regclass),
    name character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    state_id integer,
    CONSTRAINT address_pkey PRIMARY KEY (id),
    CONSTRAINT address_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.administrator
(
    user_id integer,
    password uuid
);

CREATE TABLE IF NOT EXISTS public.all_users
(
    id integer NOT NULL DEFAULT nextval('all_users_id_seq'::regclass),
    firstname character varying(128) COLLATE pg_catalog."default",
    lastname character varying(128) COLLATE pg_catalog."default",
    address_id integer,
    email character varying(500) COLLATE pg_catalog."default",
    CONSTRAINT all_users_pkey PRIMARY KEY (id),
    CONSTRAINT all_users_email_key UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS public.banned_services
(
    service_id integer
);

CREATE TABLE IF NOT EXISTS public.canceled_work
(
    started_on timestamp with time zone,
    reason text COLLATE pg_catalog."default",
    work_id integer,
    canceled_on timestamp with time zone,
    CONSTRAINT canceled_work_work_id_key UNIQUE (work_id)
);

CREATE TABLE IF NOT EXISTS public.completed_work
(
    started_on timestamp with time zone,
    completed_on timestamp with time zone,
    work_id integer,
    CONSTRAINT completed_work_work_id_key UNIQUE (work_id)
);

CREATE TABLE IF NOT EXISTS public.country
(
    id integer NOT NULL DEFAULT nextval('country_id_seq'::regclass),
    name character varying(500) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT country_pkey PRIMARY KEY (id),
    CONSTRAINT country_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.customer_review
(
    content text COLLATE pg_catalog."default",
    customer_id integer,
    work_details_id integer,
    created_at timestamp with time zone,
    CONSTRAINT customer_review_content_created_at_customer_id_work_details_key UNIQUE (content, created_at, customer_id, work_details_id)
);

CREATE TABLE IF NOT EXISTS public.customers
(
    id integer NOT NULL DEFAULT nextval('customers_id_seq'::regclass),
    username character varying(500) COLLATE pg_catalog."default" NOT NULL,
    user_id integer,
    CONSTRAINT customers_pkey PRIMARY KEY (id),
    CONSTRAINT customers_username_key UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS public.provider_rating
(
    rating integer,
    provider_id integer,
    CONSTRAINT provider_rating_provider_id_key UNIQUE (provider_id)
);

CREATE TABLE IF NOT EXISTS public.providers
(
    id integer NOT NULL DEFAULT nextval('providers_id_seq'::regclass),
    username character varying(500) COLLATE pg_catalog."default" NOT NULL,
    user_id integer,
    CONSTRAINT providers_pkey PRIMARY KEY (id),
    CONSTRAINT providers_username_key UNIQUE (username)
);

CREATE TABLE IF NOT EXISTS public.reply_to_post
(
    post_id integer,
    user_id integer,
    created_at timestamp with time zone,
    content text COLLATE pg_catalog."default"
);

CREATE TABLE IF NOT EXISTS public.reports
(
    content text COLLATE pg_catalog."default",
    user_id integer,
    created_at timestamp with time zone
);

CREATE TABLE IF NOT EXISTS public.service_and_provider
(
    service_id integer,
    provider_id integer,
    CONSTRAINT service_and_provider_service_id_provider_id_key UNIQUE (service_id, provider_id)
);

CREATE TABLE IF NOT EXISTS public.services_list
(
    id integer NOT NULL DEFAULT nextval('services_list_id_seq'::regclass),
    name character varying(1500) COLLATE pg_catalog."default",
    CONSTRAINT services_list_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.state
(
    id integer NOT NULL DEFAULT nextval('state_id_seq'::regclass),
    name character varying(1000) COLLATE pg_catalog."default" NOT NULL,
    country_id integer,
    CONSTRAINT state_pkey PRIMARY KEY (id),
    CONSTRAINT state_name_key UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS public.user_post
(
    id integer NOT NULL DEFAULT nextval('user_post_id_seq'::regclass),
    user_id integer,
    content text COLLATE pg_catalog."default",
    created_at timestamp with time zone,
    CONSTRAINT user_post_pkey PRIMARY KEY (id),
    CONSTRAINT user_post_user_id_content_created_at_key UNIQUE (user_id, content, created_at)
);

CREATE TABLE IF NOT EXISTS public.work_address
(
    work_id integer,
    address_id integer
);

CREATE TABLE IF NOT EXISTS public.work_cost
(
    cost numeric,
    work_id integer,
    CONSTRAINT work_cost_work_id_key UNIQUE (work_id)
);

CREATE TABLE IF NOT EXISTS public.work_details
(
    id integer NOT NULL DEFAULT nextval('work_details_id_seq'::regclass),
    description text COLLATE pg_catalog."default",
    booked_date timestamp with time zone,
    customer_id integer,
    provider_id integer,
    service_id integer,
    CONSTRAINT work_details_pkey PRIMARY KEY (id)
);

ALTER TABLE IF EXISTS public.address
    ADD CONSTRAINT address_state_id_fkey FOREIGN KEY (state_id)
    REFERENCES public.state (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.administrator
    ADD CONSTRAINT administrator_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.all_users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.all_users
    ADD CONSTRAINT all_users_address_id_fkey FOREIGN KEY (address_id)
    REFERENCES public.address (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.banned_services
    ADD CONSTRAINT banned_services_service_id_fkey FOREIGN KEY (service_id)
    REFERENCES public.services_list (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.canceled_work
    ADD CONSTRAINT canceled_work_work_id_fkey FOREIGN KEY (work_id)
    REFERENCES public.work_details (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS canceled_work_work_id_key
    ON public.canceled_work(work_id);


ALTER TABLE IF EXISTS public.completed_work
    ADD CONSTRAINT completed_work_work_id_fkey FOREIGN KEY (work_id)
    REFERENCES public.work_details (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS completed_work_work_id_key
    ON public.completed_work(work_id);


ALTER TABLE IF EXISTS public.customer_review
    ADD CONSTRAINT customer_review_customer_id_fkey FOREIGN KEY (customer_id)
    REFERENCES public.customers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.customer_review
    ADD CONSTRAINT customer_review_work_details_id_fkey FOREIGN KEY (work_details_id)
    REFERENCES public.work_details (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.customers
    ADD CONSTRAINT customers_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.all_users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.provider_rating
    ADD CONSTRAINT provider_rating_provider_id_fkey FOREIGN KEY (provider_id)
    REFERENCES public.providers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS provider_rating_provider_id_key
    ON public.provider_rating(provider_id);


ALTER TABLE IF EXISTS public.providers
    ADD CONSTRAINT providers_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.all_users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.reply_to_post
    ADD CONSTRAINT reply_to_post_post_id_fkey FOREIGN KEY (post_id)
    REFERENCES public.user_post (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.reply_to_post
    ADD CONSTRAINT reply_to_post_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.all_users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.reports
    ADD CONSTRAINT reports_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.all_users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.service_and_provider
    ADD CONSTRAINT service_and_provider_provider_id_fkey FOREIGN KEY (provider_id)
    REFERENCES public.providers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.service_and_provider
    ADD CONSTRAINT service_and_provider_service_id_fkey FOREIGN KEY (service_id)
    REFERENCES public.services_list (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.state
    ADD CONSTRAINT state_country_id_fkey FOREIGN KEY (country_id)
    REFERENCES public.country (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.user_post
    ADD CONSTRAINT user_post_user_id_fkey FOREIGN KEY (user_id)
    REFERENCES public.all_users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.work_address
    ADD CONSTRAINT work_address_address_id_fkey FOREIGN KEY (address_id)
    REFERENCES public.address (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.work_address
    ADD CONSTRAINT work_address_work_id_fkey FOREIGN KEY (work_id)
    REFERENCES public.work_details (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;


ALTER TABLE IF EXISTS public.work_cost
    ADD CONSTRAINT work_cost_work_id_fkey FOREIGN KEY (work_id)
    REFERENCES public.work_details (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE CASCADE;
CREATE INDEX IF NOT EXISTS work_cost_work_id_key
    ON public.work_cost(work_id);


ALTER TABLE IF EXISTS public.work_details
    ADD CONSTRAINT work_details_customer_id_fkey FOREIGN KEY (customer_id)
    REFERENCES public.customers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.work_details
    ADD CONSTRAINT work_details_provider_id_fkey FOREIGN KEY (provider_id)
    REFERENCES public.providers (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;


ALTER TABLE IF EXISTS public.work_details
    ADD CONSTRAINT work_details_service_id_fkey FOREIGN KEY (service_id)
    REFERENCES public.services_list (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION;

END;