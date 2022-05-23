CREATE TABLE public.mobilizations_themes (
    id integer NOT NULL,
    name character varying,
 );

CREATE TABLE public.mobilizations_subthemes (
    id integer NOT NULL,
    name character varying,
 );


ALTER TABLE public.mobilizations add column subtheme_tertiary integer;
ALTER TABLE public.mobilizations add column subtheme_secondary integer;
ALTER TABLE public.mobilizations add column theme integer;
ALTER TABLE public.mobilizations add column subtheme_primary integer;

ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_subtheme_primary_fkey FOREIGN KEY (subtheme_primary) REFERENCES postgraphql.mobilizations_subthemes(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_subtheme_secondary_fkey FOREIGN KEY (subtheme_secondary) REFERENCES postgraphql.mobilizations_subthemes(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_subtheme_tertiary_fkey FOREIGN KEY (subtheme_tertiary) REFERENCES postgraphql.mobilizations_subthemes(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.mobilizations
    ADD CONSTRAINT mobilizations_theme_fkey FOREIGN KEY (theme) REFERENCES postgraphql.mobilizations_themes(id) ON UPDATE RESTRICT ON DELETE RESTRICT;