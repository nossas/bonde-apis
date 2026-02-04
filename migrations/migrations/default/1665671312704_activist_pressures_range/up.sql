-- public.activist_pressures_range source

CREATE OR REPLACE VIEW public.activist_pressures_range
AS SELECT ap.widget_id,
    date_trunc('day'::text, ap.created_at) AS created_at,
    count(*) AS total
   FROM activist_pressures ap
  GROUP BY (date_trunc('day'::text, ap.created_at)), ap.widget_id
  ORDER BY ap