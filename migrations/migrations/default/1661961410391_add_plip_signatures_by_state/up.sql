CREATE TABLE IF NOT EXISTS plip_signatures_by_state_result(
	state TEXT,
	confirmed_signatures NUMERIC,
	expected_signatures NUMERIC
);

CREATE OR REPLACE FUNCTION plip_signatures_by_state(widget_id INT)
RETURNS SETOF plip_signatures_by_state_result AS $$
	SELECT
		subquery.state AS state,
		SUM(subquery.confirmed_signatures) AS confirmed_signatures,
		SUM(subquery.expected_signatures) AS expected_signatures
	FROM (
		SELECT
			ps.widget_id,
			ps.state,
			ps.unique_identifier,
			ps.confirmed_signatures,
			p.expected_signatures
		FROM (
			SELECT
				ps.widget_id,
				ps.state,
				ps.unique_identifier,
				SUM(ps.confirmed_signatures) AS confirmed_signatures
			FROM plip_signatures ps
			WHERE ps.widget_id = widget_id
			GROUP BY ps.widget_id, ps.state, ps.unique_identifier
		) AS ps
		INNER JOIN (
			SELECT
				p.widget_id,
				p.unique_identifier,
				SUM(p.expected_signatures) AS expected_signatures
			FROM plips p
			WHERE p.widget_id = widget_id
			GROUP BY p.widget_id, p.unique_identifier
		) AS p ON p.unique_identifier = ps.unique_identifier
	) AS subquery
	GROUP BY subquery.state
$$ LANGUAGE sql STABLE;
