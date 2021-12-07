CREATE OR REPLACE VIEW plips_by_state AS
SELECT
    widget_id,
    count(id) as subscribers,
    state as state,
    sum(confirmed_signatures) as confirmed_signatures,
    sum(expected_signatures) as expected_signatures
    FROM plips
    GROUP BY widget_id, state
;
