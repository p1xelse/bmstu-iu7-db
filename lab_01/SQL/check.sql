ALTER TABLE public.products ADD CONSTRAINT w_constr CHECK (weight > 0);
ALTER TABLE public.products ADD CONSTRAINT p_constr CHECK (price > 0);
ALTER TABLE public.products ADD CONSTRAINT y_constr CHECK (prod_year > 0);

ALTER TABLE public.orders  ADD CONSTRAINT p_constr CHECK (price > 0);
ALTER TABLE public.orders  ADD CONSTRAINT d_of_issue_constr CHECK (date_of_issue > '01.01.1950');
ALTER TABLE public.orders  ADD CONSTRAINT d_deliv_constr CHECK (delivery_date > '01.01.1950');
