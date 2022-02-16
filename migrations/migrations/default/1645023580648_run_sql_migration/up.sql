CREATE FUNCTION plips_confirmed_signatures(plips_row plips)
RETURNS BIGINT AS $$
  SELECT sum(ps.confirmed_signatures)
    FROM plip_signatures as ps
    WHERE ps.widget_id = plips_row.widget_id
    AND ps.unique_identifier = plips_row.unique_identifier
$$ LANGUAGE sql STABLE;
