CREATE VIEW public.donation_transactions
AS
SELECT d.id AS donation_id,
    COALESCE(c.id, d.cached_community_id) AS community_id,
    w.id AS widget_id,
    m.id AS mobilization_id,
    b.id AS block_id,
    d.activist_id,
    d.email AS donation_email,
    d.amount / 100 AS donation_amount,
    d.local_subscription_id AS subscription_id,
    d.transaction_status,
    COALESCE((d.gateway_data ->> 'date_created'::text)::timestamp without time zone, d.created_at) AS payment_date,
    pd.payable_date,
    pd.payable_value AS payable_amount,
    pd.payable_status,
    s.status AS subscription_status
   FROM donations d
     JOIN widgets w ON w.id = d.widget_id
     LEFT JOIN blocks b ON b.id = w.block_id
     LEFT JOIN mobilizations m ON m.id = b.mobilization_id
     LEFT JOIN communities c ON c.id = m.community_id OR c.id = d.cached_community_id
     LEFT JOIN subscriptions s ON s.id = d.local_subscription_id
     LEFT JOIN payable_details pd ON pd.donation_id = d.id
  WHERE d.transaction_id IS NOT NULL;
