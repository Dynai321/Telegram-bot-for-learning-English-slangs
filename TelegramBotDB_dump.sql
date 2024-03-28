--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: learned_words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.learned_words (
    user_id bigint NOT NULL,
    word_id bigint NOT NULL
);


ALTER TABLE public.learned_words OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    username character varying(255),
    rating integer DEFAULT 0,
    rank character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: words; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.words (
    word_id bigint NOT NULL,
    slang_word character varying(255),
    definition text
);


ALTER TABLE public.words OWNER TO postgres;

--
-- Name: words_word_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.words_word_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.words_word_id_seq OWNER TO postgres;

--
-- Name: words_word_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.words_word_id_seq OWNED BY public.words.word_id;


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: words word_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words ALTER COLUMN word_id SET DEFAULT nextval('public.words_word_id_seq'::regclass);


--
-- Data for Name: learned_words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.learned_words (user_id, word_id) FROM stdin;
5087941972	1
5087941972	2
5087941972	10
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, rating, rank) FROM stdin;
5087941972	Unknown	3	Новичок
\.


--
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.words (word_id, slang_word, definition) FROM stdin;
1	bruh	Выражение презрения или недовольства.
2	lit	Что-то потрясающее, волнующее или крутое.
3	bae	Термин привязанности к романтическому партнеру.
4	savage	Бесстрашное, настойчивое или беспощадное поведение.
5	woke	Осведомленность о социальных и политических вопросах.
6	chill	Расслабленный или беззаботный.
7	flex	Показать или хвастаться.
8	thirsty	Отчаянный или жаждущий внимания.
9	YOLO	Живешь только один раз; используется как обоснование для совершения чего-то рискованного или необычного.
10	sus	Подозрительный или сомнительный.
11	stan	Быть огромным поклонником кого-то или чего-то.
12	GOAT	Круче их всех; используется для описания кого-то или чего-то как лучшего из лучших.
\.


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: words_word_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.words_word_id_seq', 12, true);


--
-- Name: learned_words learned_words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learned_words
    ADD CONSTRAINT learned_words_pkey PRIMARY KEY (user_id, word_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: words words_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.words
    ADD CONSTRAINT words_pkey PRIMARY KEY (word_id);


--
-- Name: learned_words learned_words_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learned_words
    ADD CONSTRAINT learned_words_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: learned_words learned_words_word_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.learned_words
    ADD CONSTRAINT learned_words_word_id_fkey FOREIGN KEY (word_id) REFERENCES public.words(word_id);


--
-- PostgreSQL database dump complete
--

