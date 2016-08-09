--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: democ_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE democ_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    current_policy_status character varying,
    current_policy_status_effective_date date,
    policy_year integer,
    policy_year_rating_plan character varying,
    claim_indicator character varying,
    claim_number character varying,
    claim_injury_date date,
    claim_combined character varying,
    combined_into_claim_number character varying,
    claim_rating_plan_indicator character varying,
    claim_status character varying,
    claim_status_effective_date date,
    claim_manual_number integer,
    claim_sub_manual_number character varying,
    claim_type character varying,
    claimant_date_of_death date,
    claim_activity_status character varying,
    claim_activity_status_effective_date date,
    settled_claim character varying,
    settlement_type character varying,
    medical_settlement_date date,
    indemnity_settlement_date date,
    maximum_medical_improvement_date date,
    last_paid_medical_date date,
    last_paid_indemnity_date date,
    average_weekly_wage double precision,
    full_weekly_wage double precision,
    claim_handicap_percent character varying,
    claim_handicap_percent_effective_date date,
    claim_mira_ncci_injury_type character varying,
    claim_medical_paid integer,
    claim_mira_medical_reserve_amount integer,
    claim_mira_non_reducible_indemnity_paid integer,
    claim_mira_reducible_indemnity_paid integer,
    claim_mira_indemnity_reserve_amount integer,
    industrial_commission_appeal_indicator character varying,
    claim_mira_non_reducible_indemnity_paid_2 integer,
    claim_total_subrogation_collected integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: democ_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE democ_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: democ_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE democ_detail_records_id_seq OWNED BY democ_detail_records.id;


--
-- Name: democs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE democs (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: democs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE democs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: democs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE democs_id_seq OWNED BY democs.id;


--
-- Name: mrcl_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrcl_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    manual_reclassifications character varying,
    re_classed_from_manual_number integer,
    re_classed_to_manual_number integer,
    reclass_manual_coverage_type character varying,
    reclass_creation_date date,
    reclassed_payroll_information character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    re_classed_to_manual_payroll_total double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: mrcl_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrcl_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mrcl_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrcl_detail_records_id_seq OWNED BY mrcl_detail_records.id;


--
-- Name: mrcls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mrcls (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: mrcls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mrcls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mrcls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mrcls_id_seq OWNED BY mrcls.id;


--
-- Name: mremps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremps (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: mremps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremps_id_seq OWNED BY mremps.id;


--
-- Name: pcombs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcombs (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: pcombs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pcombs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pcombs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pcombs_id_seq OWNED BY pcombs.id;


--
-- Name: phmgns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phmgns (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: phmgns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phmgns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phmgns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phmgns_id_seq OWNED BY phmgns.id;


--
-- Name: sc220s; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220s (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: sc220s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220s_id_seq OWNED BY sc220s.id;


--
-- Name: sc230s; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230s (
    id integer NOT NULL,
    single_rec character varying
);


--
-- Name: sc230s_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230s_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230s_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230s_id_seq OWNED BY sc230s.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY democ_detail_records ALTER COLUMN id SET DEFAULT nextval('democ_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY democs ALTER COLUMN id SET DEFAULT nextval('democs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcl_detail_records ALTER COLUMN id SET DEFAULT nextval('mrcl_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcls ALTER COLUMN id SET DEFAULT nextval('mrcls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremps ALTER COLUMN id SET DEFAULT nextval('mremps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs ALTER COLUMN id SET DEFAULT nextval('pcombs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgns ALTER COLUMN id SET DEFAULT nextval('phmgns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220s ALTER COLUMN id SET DEFAULT nextval('sc220s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230s ALTER COLUMN id SET DEFAULT nextval('sc230s_id_seq'::regclass);


--
-- Name: democ_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY democ_detail_records
    ADD CONSTRAINT democ_detail_records_pkey PRIMARY KEY (id);


--
-- Name: democs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY democs
    ADD CONSTRAINT democs_pkey PRIMARY KEY (id);


--
-- Name: mrcl_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcl_detail_records
    ADD CONSTRAINT mrcl_detail_records_pkey PRIMARY KEY (id);


--
-- Name: mrcls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mrcls
    ADD CONSTRAINT mrcls_pkey PRIMARY KEY (id);


--
-- Name: mremps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremps
    ADD CONSTRAINT mremps_pkey PRIMARY KEY (id);


--
-- Name: pcombs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs
    ADD CONSTRAINT pcombs_pkey PRIMARY KEY (id);


--
-- Name: phmgns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgns
    ADD CONSTRAINT phmgns_pkey PRIMARY KEY (id);


--
-- Name: sc220s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220s
    ADD CONSTRAINT sc220s_pkey PRIMARY KEY (id);


--
-- Name: sc230s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230s
    ADD CONSTRAINT sc230s_pkey PRIMARY KEY (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20160728185130');

INSERT INTO schema_migrations (version) VALUES ('20160802135624');

INSERT INTO schema_migrations (version) VALUES ('20160808140315');

INSERT INTO schema_migrations (version) VALUES ('20160808140430');

INSERT INTO schema_migrations (version) VALUES ('20160808140646');

INSERT INTO schema_migrations (version) VALUES ('20160808140724');

INSERT INTO schema_migrations (version) VALUES ('20160808140739');

INSERT INTO schema_migrations (version) VALUES ('20160808140800');

INSERT INTO schema_migrations (version) VALUES ('20160808184958');

