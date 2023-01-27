DROP VIEW IF EXISTS mapa_do_acolhimento.results_juridical_triage_1_form;
DROP VIEW IF EXISTS mapa_do_acolhimento.results_psychological_triage_1_form;
DROP VIEW IF EXISTS mapa_do_acolhimento.results_juridical_triage_2_form;
DROP VIEW IF EXISTS mapa_do_acolhimento.results_psychological_triage_2_form;
ALTER TABLE mapa_do_acolhimento.mda_forms_answers  SET SCHEMA public; 
DROP SCHEMA IF EXISTS "mapa_do_acolhimento";

