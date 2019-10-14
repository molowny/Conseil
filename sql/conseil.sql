--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA IF NOT EXISTS tezos;
ALTER ROLE conseiluser SET search_path TO tezos,public;
ALTER DATABASE "conseil-local" SET search_path TO tezos,public;

--
-- Name: truncate_tables(character varying); Type: FUNCTION; Schema: tezos; Owner: -
--

CREATE FUNCTION tezos.truncate_tables(username character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    statements CURSOR FOR
        SELECT tablename FROM pg_tables
        WHERE tableowner = username AND schemaname = 'tezos';
BEGIN
    FOR stmt IN statements LOOP
        EXECUTE 'TRUNCATE TABLE ' || quote_ident(stmt.tablename) || ' CASCADE;';
    END LOOP;
END;
$$;

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.accounts (
    account_id character varying NOT NULL,
    block_id character varying NOT NULL,
    manager character varying NOT NULL,
    spendable boolean NOT NULL,
    delegate_setable boolean NOT NULL,
    delegate_value character varying,
    counter integer NOT NULL,
    script character varying,
    storage character varying,
    balance numeric NOT NULL,
    block_level numeric DEFAULT '-1'::integer NOT NULL
);


--
-- Name: accounts_checkpoint; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.accounts_checkpoint (
    account_id character varying NOT NULL,
    block_id character varying NOT NULL,
    block_level integer DEFAULT '-1'::integer NOT NULL
);


--
-- Name: balance_updates; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.balance_updates (
    id integer NOT NULL,
    source character varying NOT NULL,
    source_id integer,
    source_hash character varying,
    kind character varying NOT NULL,
    contract character varying,
    change numeric NOT NULL,
    level numeric,
    delegate character varying,
    category character varying,
    operation_group_hash character varying
);


--
-- Name: balance_updates_id_seq; Type: SEQUENCE; Schema: tezos; Owner: -
--

CREATE SEQUENCE tezos.balance_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: balance_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: tezos; Owner: -
--

ALTER SEQUENCE tezos.balance_updates_id_seq OWNED BY tezos.balance_updates.id;

--
-- Name: blocks; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.blocks (
    level integer NOT NULL,
    proto integer NOT NULL,
    predecessor character varying NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    validation_pass integer NOT NULL,
    fitness character varying NOT NULL,
    context character varying,
    signature character varying,
    protocol character varying NOT NULL,
    chain_id character varying,
    hash character varying NOT NULL,
    operations_hash character varying,
    period_kind character varying,
    current_expected_quorum integer,
    active_proposal character varying,
    baker character varying,
    nonce_hash character varying,
    consumed_gas numeric,
    meta_level integer,
    meta_level_position integer,
    meta_cycle integer,
    meta_cycle_position integer,
    meta_voting_period integer,
    meta_voting_period_position integer,
    expected_commitment boolean,
    priority integer
);


--
-- Name: delegated_contracts; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.delegated_contracts (
    account_id character varying NOT NULL,
    delegate_value character varying
);


--
-- Name: delegates; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.delegates (
    pkh character varying NOT NULL,
    block_id character varying NOT NULL,
    balance numeric,
    frozen_balance numeric,
    staking_balance numeric,
    delegated_balance numeric,
    deactivated boolean NOT NULL,
    grace_period integer NOT NULL,
    block_level integer DEFAULT '-1'::integer NOT NULL
);


--
-- Name: delegates_checkpoint; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.delegates_checkpoint (
    delegate_pkh character varying NOT NULL,
    block_id character varying NOT NULL,
    block_level integer DEFAULT '-1'::integer NOT NULL
);


--
-- Name: fees; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.fees (
    low integer NOT NULL,
    medium integer NOT NULL,
    high integer NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    kind character varying NOT NULL,
    cycle integer,
    level integer
);


--
-- Name: operation_groups; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.operation_groups (
    protocol character varying NOT NULL,
    chain_id character varying,
    hash character varying NOT NULL,
    branch character varying NOT NULL,
    signature character varying,
    block_id character varying NOT NULL,
    block_level integer NOT NULL
);


--
-- Name: operations; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.operations (
    branch character varying,
    number_of_slots integer,
    cycle integer,
    operation_id integer NOT NULL,
    operation_group_hash character varying NOT NULL,
    kind character varying NOT NULL,
    level integer,
    delegate character varying,
    slots character varying,
    nonce character varying,
    pkh character varying,
    secret character varying,
    source character varying,
    fee numeric,
    counter numeric,
    gas_limit numeric,
    storage_limit numeric,
    public_key character varying,
    amount numeric,
    destination character varying,
    parameters character varying,
    manager_pubkey character varying,
    balance numeric,
    proposal character varying,
    spendable boolean,
    delegatable boolean,
    script character varying,
    storage character varying,
    status character varying,
    consumed_gas numeric,
    storage_size numeric,
    paid_storage_size_diff numeric,
    originated_contracts character varying,
    block_hash character varying NOT NULL,
    block_level integer NOT NULL,
    ballot character varying,
    internal boolean NOT NULL,
    period integer,
    "timestamp" timestamp without time zone NOT NULL
);


--
-- Name: operations_operation_id_seq; Type: SEQUENCE; Schema: tezos; Owner: -
--

CREATE SEQUENCE tezos.operations_operation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operations_operation_id_seq; Type: SEQUENCE OWNED BY; Schema: tezos; Owner: -
--

ALTER SEQUENCE tezos.operations_operation_id_seq OWNED BY tezos.operations.operation_id;

--
-- Name: rolls; Type: TABLE; Schema: tezos; Owner: -
--

CREATE TABLE tezos.rolls (
    pkh character varying NOT NULL,
    rolls integer NOT NULL,
    block_id character varying NOT NULL,
    block_level integer NOT NULL
);


CREATE TABLE public.baking_rights (
    block_hash character varying NOT NULL,
    level integer NOT NULL,
    delegate character varying NOT NULL,
    priority integer NOT NULL,
    estimated_time timestamp without time zone NOT NULL,
    PRIMARY KEY(level, delegate)
);

CREATE INDEX baking_rights_level_idx ON public.baking_rights (level);

CREATE TABLE public.endorsing_rights (
    block_hash character varying NOT NULL,
    level integer NOT NULL,
    delegate character varying NOT NULL,
    slot integer NOT NULL,
    estimated_time timestamp without time zone NOT NULL,
    PRIMARY KEY(level, delegate, slot)
);


CREATE INDEX endorsing_rights_level_idx ON public.endorsing_rights (level);

--
-- Name: balance_updates id; Type: DEFAULT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.balance_updates ALTER COLUMN id SET DEFAULT nextval('tezos.balance_updates_id_seq'::regclass);


--
-- Name: operations operation_id; Type: DEFAULT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.operations ALTER COLUMN operation_id SET DEFAULT nextval('tezos.operations_operation_id_seq'::regclass);


--
-- Name: operation_groups OperationGroups_pkey; Type: CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE tezos.operation_groups
    ADD CONSTRAINT "OperationGroups_pkey" PRIMARY KEY (block_id, hash);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- Name: balance_updates balance_updates_key; Type: CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.balance_updates
    ADD CONSTRAINT balance_updates_key PRIMARY KEY (id);


--
-- Name: blocks blocks_hash_key; Type: CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.blocks
    ADD CONSTRAINT blocks_hash_key UNIQUE (hash);


--
-- Name: delegates delegates_pkey; Type: CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.delegates
    ADD CONSTRAINT delegates_pkey PRIMARY KEY (pkh);


--
-- Name: operations operationId; Type: CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.operations
    ADD CONSTRAINT "operationId" PRIMARY KEY (operation_id);


--
-- Name: fki_block; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX fki_block ON tezos.operation_groups USING btree (block_id);


--
-- Name: fki_fk_blockhashes; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX fki_fk_blockhashes ON tezos.operations USING btree (block_hash);


--
-- Name: ix_accounts_block_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_accounts_block_level ON tezos.accounts USING btree (block_level);


--
-- Name: ix_accounts_checkpoint_account_id; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_accounts_checkpoint_account_id ON tezos.accounts_checkpoint USING btree (account_id);


--
-- Name: ix_accounts_checkpoint_block_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_accounts_checkpoint_block_level ON tezos.accounts_checkpoint USING btree (block_level);


--
-- Name: ix_accounts_manager; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_accounts_manager ON tezos.accounts USING btree (manager);


--
-- Name: ix_blocks_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_blocks_level ON tezos.blocks USING btree (level);


--
-- Name: ix_delegates_checkpoint_block_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_delegates_checkpoint_block_level ON tezos.delegates_checkpoint USING btree (block_level);


--
-- Name: ix_operation_groups_block_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_operation_groups_block_level ON tezos.operation_groups USING btree (block_level);


--
-- Name: ix_operations_block_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_operations_block_level ON tezos.operations USING btree (block_level);


--
-- Name: ix_operations_destination; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_operations_destination ON tezos.operations USING btree (destination);


--
-- Name: ix_operations_source; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_operations_source ON tezos.operations USING btree (source);


--
-- Name: ix_operations_timestamp; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_operations_timestamp ON tezos.operations USING btree ("timestamp");


--
-- Name: ix_operations_delegate; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_operations_delegate ON tezos.operations USING btree ("delegate");

--
-- Name: ix_rolls_block_id; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_rolls_block_id ON tezos.rolls USING btree (block_id);

--
-- Name: ix_rolls_block_level; Type: INDEX; Schema: tezos; Owner: -
--

CREATE INDEX ix_rolls_block_level ON tezos.rolls USING btree (block_level);

--
-- Name: accounts accounts_block_id_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.accounts
    ADD CONSTRAINT accounts_block_id_fkey FOREIGN KEY (block_id) REFERENCES tezos.blocks(hash);

--
-- Name: operation_groups block; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.operation_groups
    ADD CONSTRAINT block FOREIGN KEY (block_id) REFERENCES tezos.blocks(hash);


--
-- Name: accounts_checkpoint checkpoint_block_id_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.accounts_checkpoint
    ADD CONSTRAINT checkpoint_block_id_fkey FOREIGN KEY (block_id) REFERENCES tezos.blocks(hash);


--
-- Name: delegated_contracts contracts_account_id_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.delegated_contracts
    ADD CONSTRAINT contracts_account_id_fkey FOREIGN KEY (account_id) REFERENCES tezos.accounts(account_id);


--
-- Name: delegated_contracts contracts_delegate_pkh_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.delegated_contracts
    ADD CONSTRAINT contracts_delegate_pkh_fkey FOREIGN KEY (delegate_value) REFERENCES tezos.delegates(pkh);


--
-- Name: delegates_checkpoint delegate_checkpoint_block_id_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.delegates_checkpoint
    ADD CONSTRAINT delegate_checkpoint_block_id_fkey FOREIGN KEY (block_id) REFERENCES tezos.blocks(hash);


--
-- Name: delegates delegates_block_id_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.delegates
    ADD CONSTRAINT delegates_block_id_fkey FOREIGN KEY (block_id) REFERENCES tezos.blocks(hash);


--
-- Name: operations fk_blockhashes; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.operations
    ADD CONSTRAINT fk_blockhashes FOREIGN KEY (block_hash) REFERENCES tezos.blocks(hash);

--
-- Name: operations fk_opgroups; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.operations
    ADD CONSTRAINT fk_opgroups FOREIGN KEY (operation_group_hash, block_hash) REFERENCES tezos.operation_groups(hash, block_id);

--
-- Name: rolls rolls_block_id_fkey; Type: FK CONSTRAINT; Schema: tezos; Owner: -
--

ALTER TABLE ONLY tezos.rolls
    ADD CONSTRAINT rolls_block_id_fkey FOREIGN KEY (block_id) REFERENCES tezos.blocks(hash);


--
-- PostgreSQL database dump complete
--