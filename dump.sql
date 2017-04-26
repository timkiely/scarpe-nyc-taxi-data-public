--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.6
-- Dumped by pg_dump version 9.5.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: trips; Type: TABLE; Schema: public; Owner: ubuntu
--

CREATE TABLE trips (
    id integer NOT NULL,
    cab_type_id integer,
    vendor_id character varying,
    pickup_datetime timestamp without time zone,
    dropoff_datetime timestamp without time zone,
    store_and_fwd_flag character(1),
    rate_code_id integer,
    pickup_longitude numeric,
    pickup_latitude numeric,
    dropoff_longitude numeric,
    dropoff_latitude numeric,
    passenger_count integer,
    trip_distance numeric,
    fare_amount numeric,
    extra numeric,
    mta_tax numeric,
    tip_amount numeric,
    tolls_amount numeric,
    ehail_fee numeric,
    improvement_surcharge numeric,
    total_amount numeric,
    payment_type character varying,
    trip_type integer,
    pickup_nyct2010_gid integer,
    dropoff_nyct2010_gid integer,
    pickup_location_id integer,
    dropoff_location_id integer,
    pickup geometry(Point,4326),
    dropoff geometry(Point,4326)
);


ALTER TABLE trips OWNER TO ubuntu;

--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: ubuntu
--

CREATE SEQUENCE trips_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE trips_id_seq OWNER TO ubuntu;

--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ubuntu
--

ALTER SEQUENCE trips_id_seq OWNED BY trips.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ubuntu
--

ALTER TABLE ONLY trips ALTER COLUMN id SET DEFAULT nextval('trips_id_seq'::regclass);


--
-- Name: trips_pkey; Type: CONSTRAINT; Schema: public; Owner: ubuntu
--

ALTER TABLE ONLY trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

