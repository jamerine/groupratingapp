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
-- Name: bwc_codes_base_rates_exp_loss_rates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_base_rates_exp_loss_rates (
    id integer NOT NULL,
    class_code integer,
    base_rate double precision,
    expected_loss_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_base_rates_exp_loss_rates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_base_rates_exp_loss_rates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_base_rates_exp_loss_rates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_base_rates_exp_loss_rates_id_seq OWNED BY bwc_codes_base_rates_exp_loss_rates.id;


--
-- Name: bwc_codes_constant_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_constant_values (
    id integer NOT NULL,
    name character varying,
    value double precision,
    start_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_constant_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_constant_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_constant_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_constant_values_id_seq OWNED BY bwc_codes_constant_values.id;


--
-- Name: bwc_codes_credibility_max_losses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_credibility_max_losses (
    id integer NOT NULL,
    credibility_group integer,
    expected_losses integer,
    credibility_percent double precision,
    group_maximum_value integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_credibility_max_losses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_credibility_max_losses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_credibility_max_losses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_credibility_max_losses_id_seq OWNED BY bwc_codes_credibility_max_losses.id;


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_industry_group_savings_ratio_criteria (
    id integer NOT NULL,
    industry_group integer,
    ratio_criteria double precision,
    average_ratio double precision,
    actual_decimal double precision,
    percent_value double precision,
    em double precision,
    market_rate double precision,
    market_em_rate double precision,
    sponsor character varying,
    ac26_group_level character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_industry_group_savings_ratio_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_industry_group_savings_ratio_criteria_id_seq OWNED BY bwc_codes_industry_group_savings_ratio_criteria.id;


--
-- Name: bwc_codes_limited_loss_ratios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_limited_loss_ratios (
    id integer NOT NULL,
    industry_group integer,
    credibility_group integer,
    limited_loss_ratio double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_limited_loss_ratios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_limited_loss_ratios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_limited_loss_ratios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_limited_loss_ratios_id_seq OWNED BY bwc_codes_limited_loss_ratios.id;


--
-- Name: bwc_codes_ncci_manual_classes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_ncci_manual_classes (
    id integer NOT NULL,
    industry_group integer,
    ncci_manual_classification integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_ncci_manual_classes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_ncci_manual_classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_ncci_manual_classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_ncci_manual_classes_id_seq OWNED BY bwc_codes_ncci_manual_classes.id;


--
-- Name: bwc_codes_peo_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_peo_lists (
    id integer NOT NULL,
    policy_number integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_peo_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_peo_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_peo_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_peo_lists_id_seq OWNED BY bwc_codes_peo_lists.id;


--
-- Name: bwc_codes_policy_effective_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE bwc_codes_policy_effective_dates (
    id integer NOT NULL,
    policy_number integer,
    policy_original_effective_date date,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: bwc_codes_policy_effective_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bwc_codes_policy_effective_dates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bwc_codes_policy_effective_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bwc_codes_policy_effective_dates_id_seq OWNED BY bwc_codes_policy_effective_dates.id;


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
-- Name: mremp_employee_experience_claim_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremp_employee_experience_claim_levels (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    record_type integer,
    manual_number integer,
    sub_manual_number character varying,
    claim_reserve_code character varying,
    claim_number character varying,
    injury_date date,
    claim_indemnity_paid_using_mira_rules integer,
    claim_indemnity_mira_reserve integer,
    claim_medical_paid integer,
    claim_medical_reserve integer,
    claim_indemnity_handicap_paid_using_mira_rules integer,
    claim_indemnity_handicap_mira_reserve integer,
    claim_medical_handicap_paid integer,
    claim_medical_handicap_reserve integer,
    claim_surplus_type character varying,
    claim_handicap_percent character varying,
    claim_over_policy_max_value_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mremp_employee_experience_claim_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremp_employee_experience_claim_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremp_employee_experience_claim_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremp_employee_experience_claim_levels_id_seq OWNED BY mremp_employee_experience_claim_levels.id;


--
-- Name: mremp_employee_experience_manual_class_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremp_employee_experience_manual_class_levels (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    record_type integer,
    manual_number integer,
    sub_manual_number character varying,
    claim_reserve_code character varying,
    claim_number character varying,
    experience_period_payroll integer,
    manual_class_base_rate double precision,
    manual_class_expected_loss_rate double precision,
    manual_class_expected_losses integer,
    merit_rated_flag character varying,
    policy_manual_status character varying,
    limited_loss_ratio double precision,
    limited_losses integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mremp_employee_experience_manual_class_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremp_employee_experience_manual_class_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremp_employee_experience_manual_class_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremp_employee_experience_manual_class_levels_id_seq OWNED BY mremp_employee_experience_manual_class_levels.id;


--
-- Name: mremp_employee_experience_policy_levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE mremp_employee_experience_policy_levels (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    record_type integer,
    manual_number integer,
    sub_manual_number character varying,
    claim_reserve_code character varying,
    claim_number character varying,
    federal_id character varying,
    grand_total_modified_losses integer,
    grand_total_expected_losses integer,
    grand_total_limited_losses integer,
    policy_maximum_claim_size integer,
    policy_credibility double precision,
    policy_experience_modifier_percent double precision,
    employer_name character varying,
    doing_business_as_name character varying,
    referral_name character varying,
    address character varying,
    city character varying,
    state character varying,
    zip_code character varying,
    print_code character varying,
    policy_year integer,
    extract_date date,
    policy_year_exp_period_beginning_date date,
    policy_year_exp_period_ending_date date,
    green_year character varying,
    reserves_used_in_the_published_em character varying,
    risk_group_number character varying,
    em_capped_flag character varying,
    capped_em_percentage character varying,
    ocp_flag character varying,
    construction_cap_flag character varying,
    published_em_percentage double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mremp_employee_experience_policy_levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mremp_employee_experience_policy_levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mremp_employee_experience_policy_levels_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mremp_employee_experience_policy_levels_id_seq OWNED BY mremp_employee_experience_policy_levels.id;


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
-- Name: pcomb_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pcomb_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    policy_combinations character varying,
    predecessor_policy_type character varying,
    predecessor_policy_number integer,
    predecessor_filler character varying,
    predecessor_business_sequence_number character varying,
    successor_policy_type character varying,
    successor_policy_number integer,
    successor_filler character varying,
    successor_business_sequence_number character varying,
    transfer_type character varying,
    transfer_effective_date date,
    transfer_creation_date date,
    partial_transfer_due_to_labor_lease character varying,
    labor_lease_type character varying,
    partial_transfer_payroll_movement character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    payroll_reporting_period_from_date date,
    payroll_reporting_period_to_date date,
    manual_payroll double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pcomb_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pcomb_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pcomb_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pcomb_detail_records_id_seq OWNED BY pcomb_detail_records.id;


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
-- Name: phmgn_detail_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE phmgn_detail_records (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    record_type integer,
    requestor_number integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    valid_policy_number character varying,
    experience_payroll_premium_information character varying,
    industry_code character varying,
    ncci_manual_number integer,
    manual_coverage_type character varying,
    manual_payroll double precision,
    manual_premium double precision,
    premium_percentage double precision,
    upcoming_policy_year integer,
    policy_year_extracted_for_experience_payroll_determining_premiu integer,
    policy_year_extracted_beginning_date date,
    policy_year_extracted_ending_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: phmgn_detail_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE phmgn_detail_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: phmgn_detail_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE phmgn_detail_records_id_seq OWNED BY phmgn_detail_records.id;


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
-- Name: sc220_rec1_employer_demographics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec1_employer_demographics (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description_ar character varying,
    record_type integer,
    request_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    federal_identification_number character varying,
    business_name character varying,
    trading_as_name character varying,
    in_care_name_contact_name character varying,
    address_1 character varying,
    address_2 character varying,
    city character varying,
    state character varying,
    zip_code character varying,
    zip_code_plus_4 character varying,
    country_code character varying,
    county character varying,
    currently_assigned_representative_number integer,
    currently_assigned_representative_type character varying,
    successor_policy_number integer,
    successor_business_sequence_number integer,
    merit_rate double precision,
    group_code character varying,
    minimum_premium_percentage character varying,
    rate_adjust_factor character varying,
    em_effective_date date,
    n2nd_merit_rate double precision,
    n2nd_group_code character varying,
    n2nd_minimum_premium_percentage character varying,
    n2nd_rate_adjust_factor character varying,
    n2nd_em_effective_date date,
    n3rd_merit_rate double precision,
    n3rd_group_code character varying,
    n3rd_minimum_premium_percentage character varying,
    n3rd_rate_adjust_factor character varying,
    n3rd_em_effective_date date,
    n4th_merit_rate double precision,
    n4th_group_code character varying,
    n4th_minimum_premium_percentage character varying,
    n4th_rate_adjust_factor character varying,
    n4th_em_effective_date date,
    n5th_merit_rate double precision,
    n5th_group_code character varying,
    n5th_minimum_premium_percentage character varying,
    n5th_rate_adjust_factor character varying,
    n5th_em_effective_date date,
    n6th_merit_rate double precision,
    n6th_group_code character varying,
    n6th_minimum_premium_percentage character varying,
    n6th_rate_adjust_factor character varying,
    n6th_em_effective_date date,
    n7th_merit_rate double precision,
    n7th_group_code character varying,
    n7th_minimum_premium_percentage character varying,
    n7th_rate_adjust_factor character varying,
    n7th_em_effective_date date,
    n8th_merit_rate double precision,
    n8th_group_code character varying,
    n8th_minimum_premium_percentage character varying,
    n8th_rate_adjust_factor character varying,
    n8th_em_effective_date date,
    n9th_merit_rate double precision,
    n9th_group_code character varying,
    n9th_minimum_premium_percentage character varying,
    n9th_rate_adjust_factor character varying,
    n9th_em_effective_date date,
    n10th_merit_rate double precision,
    n10th_group_code character varying,
    n10th_minimum_premium_percentage character varying,
    n10th_rate_adjust_factor character varying,
    n10th_em_effective_date date,
    n11th_merit_rate double precision,
    n11th_group_code character varying,
    n11th_minimum_premium_percentage character varying,
    n11th_rate_adjust_factor character varying,
    n11th_em_effective_date date,
    n12th_merit_rate double precision,
    n12th_group_code character varying,
    n12th_minimum_premium_percentage character varying,
    n12th_rate_adjust_factor character varying,
    n12th_em_effective_date date,
    coverage_status character varying,
    coverage_effective_date date,
    coverage_end_date date,
    n2nd_coverage_status character varying,
    n2nd_coverage_effective_date date,
    n2nd_coverage_end_date date,
    n3rd_coverage_status character varying,
    n3rd_coverage_effective_date date,
    n3rd_coverage_end_date date,
    n4th_coverage_status character varying,
    n4th_coverage_effective_date date,
    n4th_coverage_end_date date,
    n5th_coverage_status character varying,
    n5th_coverage_effective_date date,
    n5th_coverage_end_date date,
    n6th_coverage_status character varying,
    n6th_coverage_effective_date date,
    n6th_coverage_end_date date,
    regular_balance_amount double precision,
    attorney_general_balance_amount double precision,
    appealed_balance_amount double precision,
    pending_balance_amount double precision,
    advance_deposit_amount double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec1_employer_demographics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec1_employer_demographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec1_employer_demographics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec1_employer_demographics_id_seq OWNED BY sc220_rec1_employer_demographics.id;


--
-- Name: sc220_rec2_employer_manual_level_payrolls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec2_employer_manual_level_payrolls (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description_ar character varying,
    record_type integer,
    request_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    manual_number integer,
    manual_type character varying,
    year_to_date_payroll double precision,
    manual_class_rate double precision,
    year_to_date_premium_billed double precision,
    manual_effective_date date,
    n2nd_year_to_date_payroll double precision,
    n2nd_manual_class_rate double precision,
    n2nd_year_to_date_premium_billed double precision,
    n2nd_manual_effective_date date,
    n3rd_year_to_date_payroll double precision,
    n3rd_manual_class_rate double precision,
    n3rd_year_to_date_premium_billed double precision,
    n3rd_manual_effective_date date,
    n4th_year_to_date_payroll double precision,
    n4th_manual_class_rate double precision,
    n4th_year_to_date_premium_billed double precision,
    n4th_manual_effective_date date,
    n5th_year_to_date_payroll double precision,
    n5th_manual_class_rate double precision,
    n5th_year_to_date_premium_billed double precision,
    n5th_manual_effective_date date,
    n6th_year_to_date_payroll double precision,
    n6th_manual_class_rate double precision,
    n6th_year_to_date_premium_billed double precision,
    n6th_manual_effective_date date,
    n7th_year_to_date_payroll double precision,
    n7th_manual_class_rate double precision,
    n7th_year_to_date_premium_billed double precision,
    n7th_manual_effective_date date,
    n8th_year_to_date_payroll double precision,
    n8th_manual_class_rate double precision,
    n8th_year_to_date_premium_billed double precision,
    n8th_manual_effective_date date,
    n9th_year_to_date_payroll double precision,
    n9th_manual_class_rate double precision,
    n9th_year_to_date_premium_billed double precision,
    n9th_manual_effective_date date,
    n10th_year_to_date_payroll double precision,
    n10th_manual_class_rate double precision,
    n10th_year_to_date_premium_billed double precision,
    n10th_manual_effective_date date,
    n11th_year_to_date_payroll double precision,
    n11th_manual_class_rate double precision,
    n11th_year_to_date_premium_billed double precision,
    n11th_manual_effective_date date,
    n12th_year_to_date_payroll double precision,
    n12th_manual_class_rate double precision,
    n12th_year_to_date_premium_billed double precision,
    n12th_manual_effective_date date,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec2_employer_manual_level_payrolls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec2_employer_manual_level_payrolls_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec2_employer_manual_level_payrolls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec2_employer_manual_level_payrolls_id_seq OWNED BY sc220_rec2_employer_manual_level_payrolls.id;


--
-- Name: sc220_rec3_employer_ar_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec3_employer_ar_transactions (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    descriptionar character varying,
    record_type integer,
    request_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    trans_date date,
    invoice_number character varying,
    billing_trans_status_code character varying,
    trans_amount double precision,
    trans_type character varying,
    paid_amount double precision,
    n2nd_trans_date date,
    n2nd_invoice_number character varying,
    n2nd_billing_trans_status_code character varying,
    n2nd_trans_amount double precision,
    n2nd_trans_type character varying,
    n2nd_paid_amount double precision,
    n3rd_trans_date date,
    n3rd_invoice_number character varying,
    n3rd_billing_trans_status_code character varying,
    n3rd_trans_amount double precision,
    n3rd_trans_type character varying,
    n3rd_paid_amount double precision,
    n4th_trans_date date,
    n4th_invoice_number character varying,
    n4th_billing_trans_status_code character varying,
    n4th_trans_amount double precision,
    n4th_trans_type character varying,
    n4th_paid_amount double precision,
    n5th_trans_date date,
    n5th_invoice_number character varying,
    n5th_billing_trans_status_code character varying,
    n5th_trans_amount double precision,
    n5th_trans_type character varying,
    n5th_paid_amount double precision,
    n6th_trans_date date,
    n6th_invoice_number character varying,
    n6th_billing_trans_status_code character varying,
    n6th_trans_amount double precision,
    n6th_trans_type character varying,
    n6th_paid_amount double precision,
    n7th_trans_date date,
    n7th_invoice_number character varying,
    n7th_billing_trans_status_code character varying,
    n7th_trans_amount double precision,
    n7th_trans_type character varying,
    n7th_paid_amount double precision,
    n8th_trans_date date,
    n8th_invoice_number character varying,
    n8th_billing_trans_status_code character varying,
    n8th_trans_amount double precision,
    n8th_trans_type character varying,
    n8th_paid_amount double precision,
    n9th_trans_date date,
    n9th_invoice_number character varying,
    n9th_billing_trans_status_code character varying,
    n9th_trans_amount double precision,
    n9th_trans_type character varying,
    n9th_paid_amount double precision,
    n10th_trans_date date,
    n10th_invoice_number character varying,
    n10th_billing_trans_status_code character varying,
    n10th_trans_amount double precision,
    n10th_trans_type character varying,
    n10th_paid_amount double precision,
    n11th_trans_date date,
    n11th_invoice_number character varying,
    n11th_billing_trans_status_code character varying,
    n11th_trans_amount double precision,
    n11th_trans_type character varying,
    n11th_paid_amount double precision,
    n12th_trans_date date,
    n12th_invoice_number character varying,
    n12th_billing_trans_status_code character varying,
    n12th_trans_amount double precision,
    n12th_trans_type character varying,
    n12th_paid_amount double precision,
    n13th_trans_date date,
    n13th_invoice_number character varying,
    n13th_billing_trans_status_code character varying,
    n13th_trans_amount double precision,
    n13th_trans_type character varying,
    n13th_paid_amount double precision,
    n14th_trans_date date,
    n14th_invoice_number character varying,
    n14th_billing_trans_status_code character varying,
    n14th_trans_amount double precision,
    n14th_trans_type character varying,
    n14th_paid_amount double precision,
    n15th_trans_date date,
    n15th_invoice_number character varying,
    n15th_billing_trans_status_code character varying,
    n15th_trans_amount double precision,
    n15th_trans_type character varying,
    n15th_paid_amount double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec3_employer_ar_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec3_employer_ar_transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec3_employer_ar_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec3_employer_ar_transactions_id_seq OWNED BY sc220_rec3_employer_ar_transactions.id;


--
-- Name: sc220_rec4_policy_not_founds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc220_rec4_policy_not_founds (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    description character varying,
    record_type integer,
    request_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    error_message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc220_rec4_policy_not_founds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc220_rec4_policy_not_founds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc220_rec4_policy_not_founds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc220_rec4_policy_not_founds_id_seq OWNED BY sc220_rec4_policy_not_founds.id;


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
-- Name: sc230_claim_indemnity_awards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230_claim_indemnity_awards (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    claim_manual_number integer,
    record_type character varying,
    claim_number character varying,
    hearing_date date,
    injury_date date,
    from_date date,
    to_date date,
    award_type character varying,
    number_of_weeks character varying,
    awarded_weekly_rate double precision,
    award_amount double precision,
    payment_amount integer,
    claimant_name character varying,
    payee_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc230_claim_indemnity_awards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230_claim_indemnity_awards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230_claim_indemnity_awards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230_claim_indemnity_awards_id_seq OWNED BY sc230_claim_indemnity_awards.id;


--
-- Name: sc230_claim_medical_payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230_claim_medical_payments (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    claim_manual_number integer,
    record_type character varying,
    claim_number character varying,
    hearing_date date,
    injury_date date,
    from_date character varying,
    to_date character varying,
    award_type character varying,
    number_of_weeks character varying,
    awarded_weekly_rate character varying,
    award_amount integer,
    payment_amount double precision,
    claimant_name character varying,
    payee_name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc230_claim_medical_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230_claim_medical_payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230_claim_medical_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230_claim_medical_payments_id_seq OWNED BY sc230_claim_medical_payments.id;


--
-- Name: sc230_employer_demographics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE sc230_employer_demographics (
    id integer NOT NULL,
    representative_number integer,
    representative_type integer,
    policy_type integer,
    policy_number integer,
    business_sequence_number integer,
    claim_manual_number integer,
    record_type character varying,
    claim_number character varying,
    policy_name character varying,
    doing_business_as_name character varying,
    street_address character varying,
    city character varying,
    state character varying,
    zip_code integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sc230_employer_demographics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sc230_employer_demographics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sc230_employer_demographics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sc230_employer_demographics_id_seq OWNED BY sc230_employer_demographics.id;


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

ALTER TABLE ONLY bwc_codes_base_rates_exp_loss_rates ALTER COLUMN id SET DEFAULT nextval('bwc_codes_base_rates_exp_loss_rates_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_constant_values ALTER COLUMN id SET DEFAULT nextval('bwc_codes_constant_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_credibility_max_losses ALTER COLUMN id SET DEFAULT nextval('bwc_codes_credibility_max_losses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_industry_group_savings_ratio_criteria ALTER COLUMN id SET DEFAULT nextval('bwc_codes_industry_group_savings_ratio_criteria_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_limited_loss_ratios ALTER COLUMN id SET DEFAULT nextval('bwc_codes_limited_loss_ratios_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_ncci_manual_classes ALTER COLUMN id SET DEFAULT nextval('bwc_codes_ncci_manual_classes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_peo_lists ALTER COLUMN id SET DEFAULT nextval('bwc_codes_peo_lists_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_policy_effective_dates ALTER COLUMN id SET DEFAULT nextval('bwc_codes_policy_effective_dates_id_seq'::regclass);


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

ALTER TABLE ONLY mremp_employee_experience_claim_levels ALTER COLUMN id SET DEFAULT nextval('mremp_employee_experience_claim_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_manual_class_levels ALTER COLUMN id SET DEFAULT nextval('mremp_employee_experience_manual_class_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_policy_levels ALTER COLUMN id SET DEFAULT nextval('mremp_employee_experience_policy_levels_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremps ALTER COLUMN id SET DEFAULT nextval('mremps_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcomb_detail_records ALTER COLUMN id SET DEFAULT nextval('pcomb_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs ALTER COLUMN id SET DEFAULT nextval('pcombs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgn_detail_records ALTER COLUMN id SET DEFAULT nextval('phmgn_detail_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgns ALTER COLUMN id SET DEFAULT nextval('phmgns_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec1_employer_demographics ALTER COLUMN id SET DEFAULT nextval('sc220_rec1_employer_demographics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec2_employer_manual_level_payrolls ALTER COLUMN id SET DEFAULT nextval('sc220_rec2_employer_manual_level_payrolls_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec3_employer_ar_transactions ALTER COLUMN id SET DEFAULT nextval('sc220_rec3_employer_ar_transactions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec4_policy_not_founds ALTER COLUMN id SET DEFAULT nextval('sc220_rec4_policy_not_founds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220s ALTER COLUMN id SET DEFAULT nextval('sc220s_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_indemnity_awards ALTER COLUMN id SET DEFAULT nextval('sc230_claim_indemnity_awards_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_medical_payments ALTER COLUMN id SET DEFAULT nextval('sc230_claim_medical_payments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_employer_demographics ALTER COLUMN id SET DEFAULT nextval('sc230_employer_demographics_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230s ALTER COLUMN id SET DEFAULT nextval('sc230s_id_seq'::regclass);


--
-- Name: bwc_codes_base_rates_exp_loss_rates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_base_rates_exp_loss_rates
    ADD CONSTRAINT bwc_codes_base_rates_exp_loss_rates_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_constant_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_constant_values
    ADD CONSTRAINT bwc_codes_constant_values_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_credibility_max_losses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_credibility_max_losses
    ADD CONSTRAINT bwc_codes_credibility_max_losses_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_industry_group_savings_ratio_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_industry_group_savings_ratio_criteria
    ADD CONSTRAINT bwc_codes_industry_group_savings_ratio_criteria_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_limited_loss_ratios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_limited_loss_ratios
    ADD CONSTRAINT bwc_codes_limited_loss_ratios_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_ncci_manual_classes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_ncci_manual_classes
    ADD CONSTRAINT bwc_codes_ncci_manual_classes_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_peo_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_peo_lists
    ADD CONSTRAINT bwc_codes_peo_lists_pkey PRIMARY KEY (id);


--
-- Name: bwc_codes_policy_effective_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY bwc_codes_policy_effective_dates
    ADD CONSTRAINT bwc_codes_policy_effective_dates_pkey PRIMARY KEY (id);


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
-- Name: mremp_employee_experience_claim_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_claim_levels
    ADD CONSTRAINT mremp_employee_experience_claim_levels_pkey PRIMARY KEY (id);


--
-- Name: mremp_employee_experience_manual_class_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_manual_class_levels
    ADD CONSTRAINT mremp_employee_experience_manual_class_levels_pkey PRIMARY KEY (id);


--
-- Name: mremp_employee_experience_policy_levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremp_employee_experience_policy_levels
    ADD CONSTRAINT mremp_employee_experience_policy_levels_pkey PRIMARY KEY (id);


--
-- Name: mremps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mremps
    ADD CONSTRAINT mremps_pkey PRIMARY KEY (id);


--
-- Name: pcomb_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcomb_detail_records
    ADD CONSTRAINT pcomb_detail_records_pkey PRIMARY KEY (id);


--
-- Name: pcombs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pcombs
    ADD CONSTRAINT pcombs_pkey PRIMARY KEY (id);


--
-- Name: phmgn_detail_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgn_detail_records
    ADD CONSTRAINT phmgn_detail_records_pkey PRIMARY KEY (id);


--
-- Name: phmgns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY phmgns
    ADD CONSTRAINT phmgns_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec1_employer_demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec1_employer_demographics
    ADD CONSTRAINT sc220_rec1_employer_demographics_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec2_employer_manual_level_payrolls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec2_employer_manual_level_payrolls
    ADD CONSTRAINT sc220_rec2_employer_manual_level_payrolls_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec3_employer_ar_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec3_employer_ar_transactions
    ADD CONSTRAINT sc220_rec3_employer_ar_transactions_pkey PRIMARY KEY (id);


--
-- Name: sc220_rec4_policy_not_founds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220_rec4_policy_not_founds
    ADD CONSTRAINT sc220_rec4_policy_not_founds_pkey PRIMARY KEY (id);


--
-- Name: sc220s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc220s
    ADD CONSTRAINT sc220s_pkey PRIMARY KEY (id);


--
-- Name: sc230_claim_indemnity_awards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_indemnity_awards
    ADD CONSTRAINT sc230_claim_indemnity_awards_pkey PRIMARY KEY (id);


--
-- Name: sc230_claim_medical_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_claim_medical_payments
    ADD CONSTRAINT sc230_claim_medical_payments_pkey PRIMARY KEY (id);


--
-- Name: sc230_employer_demographics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230_employer_demographics
    ADD CONSTRAINT sc230_employer_demographics_pkey PRIMARY KEY (id);


--
-- Name: sc230s_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sc230s
    ADD CONSTRAINT sc230s_pkey PRIMARY KEY (id);


--
-- Name: index_bwc_codes_policy_effective_dates_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bwc_codes_policy_effective_dates_on_policy_number ON bwc_codes_policy_effective_dates USING btree (policy_number);


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

INSERT INTO schema_migrations (version) VALUES ('20160809110941');

INSERT INTO schema_migrations (version) VALUES ('20160809113231');

INSERT INTO schema_migrations (version) VALUES ('20160809113754');

INSERT INTO schema_migrations (version) VALUES ('20160809125215');

INSERT INTO schema_migrations (version) VALUES ('20160809131406');

INSERT INTO schema_migrations (version) VALUES ('20160809134044');

INSERT INTO schema_migrations (version) VALUES ('20160809142452');

INSERT INTO schema_migrations (version) VALUES ('20160809144921');

INSERT INTO schema_migrations (version) VALUES ('20160809151108');

INSERT INTO schema_migrations (version) VALUES ('20160809155448');

INSERT INTO schema_migrations (version) VALUES ('20160809160103');

INSERT INTO schema_migrations (version) VALUES ('20160809160550');

INSERT INTO schema_migrations (version) VALUES ('20160810174935');

INSERT INTO schema_migrations (version) VALUES ('20160811100413');

INSERT INTO schema_migrations (version) VALUES ('20160811112748');

INSERT INTO schema_migrations (version) VALUES ('20160811115912');

INSERT INTO schema_migrations (version) VALUES ('20160811124541');

INSERT INTO schema_migrations (version) VALUES ('20160811125428');

INSERT INTO schema_migrations (version) VALUES ('20160811134525');

INSERT INTO schema_migrations (version) VALUES ('20160811143921');

