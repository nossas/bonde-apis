CREATE OR REPLACE VIEW "public"."plips_by_state" AS
    select
        widget_id,
        sum(expected_signatures) as expected_signatures,
        sum(confirmed_signatures) as confirmed_signatures,
        state,
        count(*) as subscribers
    from (
        select
            p.widget_id as widget_id,
            sum(p.expected_signatures) as expected_signatures,
            p.unique_identifier as unique_identifier,
            p.state,
            (
                select sum(ps.confirmed_signatures)
                from plip_signatures ps
                where ps.unique_identifier = p.unique_identifier
            ) as confirmed_signatures
        from plips p
        group by p.widget_id, p.unique_identifier, p.state
    ) as subquery
    group by subquery.state, subquery.widget_id
;
