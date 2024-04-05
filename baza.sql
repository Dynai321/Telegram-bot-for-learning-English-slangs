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
    definition text,
    video_url character varying(255)
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
5087941972	2
383943019	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, rating, rank) FROM stdin;
5087941972	Parfunchec	1	Новичок
383943019	juuliadubrovina	1	Новичок
\.


--
-- Data for Name: words; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.words (word_id, slang_word, definition, video_url) FROM stdin;
1	I screwed up	Фраза "I screwed up" в английском языке является неформальным выражением, которое означает признание собственной ошибки или недоразумения. Оно часто используется для выражения сожаления или раскаяния по поводу совершенной ошибки.	https://www.youtube.com/watch?v=nArIOhNjHME
2	Give it a shot	Фраза "Фраза "Give it a shot" в английском языке означает призыв к попытке выполнить какое-то действие или задание. Она выражает поддержку и мотивацию попробовать что-то новое или сделать попытку решить проблему.	https://www.youtube.com/watch?v=Ad7l9xvRu_M
3	Im ower it	Фраза "Im over it" является английским выражением, которое обозначает, что человек закончил думать или беспокоиться о чем-то, что произошло в прошлом, и готов двигаться дальше. Она часто используется в разговорной речи в ситуациях, когда человек пережил какое-то неприятное событие или разочарование, и теперь готов отпустить это и идти вперед.	https://www.youtube.com/watch?v=wdfiFGTPt0w
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

