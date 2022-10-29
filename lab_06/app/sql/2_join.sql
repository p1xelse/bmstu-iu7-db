SELECT * FROM public.warehouse_companies wc1
JOIN public.products AS p ON p.warehouse_id = wc1.id
join public.products_orders as po on po.products_id = p.id;