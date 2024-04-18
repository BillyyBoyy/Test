-- Procedure que carga datos de las tablas del sistema al modelo multidemensional
CREATE OR REPLACE PROCEDURE cargar_modelo() AS
$$
BEGIN
	TRUNCATE public.pelicula_dimension;
	-- Cargado de datos a la dimension pelicula
	INSERT INTO public.pelicula_dimension(
		pelicula_id, titulo, categoria, actores)
	SELECT 
		f.film_id,
		f.title,
		c.name AS category,
		ARRAY_AGG(CONCAT(a.first_name, ' ', a.last_name))
	FROM public.film f
	INNER JOIN public.film_category fc ON fc.film_id = f.film_id
	INNER JOIN public.category c ON c.category_id = fc.category_id
	INNER JOIN public.film_actor fa ON fa.film_id = f.film_id
	INNER JOIN public.actor a ON a.actor_id = fa.actor_id
	GROUP BY 1, 2, 3
	ORDER BY 1;

	TRUNCATE public.sucursal_dimension;
	-- Cargado de datos a la dimension sucursal
	INSERT INTO public.sucursal_dimension(
		sucursal_id, direccion)
	SELECT 
		s.store_id,
		a.address
	FROM public.store s
	INNER JOIN public.address a ON a.address_id = s.address_id;

	TRUNCATE public.lugar_dimension;
	-- Cargado de datos a la dimension lugar
	INSERT INTO public.lugar_dimension(
		lugar_id, pais, ciudad)
	SELECT DISTINCT 
		a.address_id,
		co.country,
		ci.city
	FROM public.address a
	INNER JOIN public.city ci ON ci.city_id = a.city_id
	INNER JOIN public.country co ON co.country_id = ci.country_id
	ORDER BY 2, 3;

	TRUNCATE public.fecha_dimension;
	-- Cargado de datos a la dimension fecha
	INSERT INTO public.fecha_dimension(
		fecha_id, anio, mes, dia)
	SELECT DISTINCT
		to_char(rental_date, 'dd/mm/yyyy'), -- Usamos el varchar dd/mm/yyyy como ID
		EXTRACT(year FROM rental_date),
		EXTRACT(month FROM rental_date),
		EXTRACT(day FROM rental_date)
	FROM public.rental
	ORDER BY 2, 3, 4;

	TRUNCATE public.alquiler_fact;
	-- Cargado de datos a la tabla de hechos
	INSERT INTO public.alquiler_fact(
		alquiler_id, fecha_id, pelicula_id, lugar_id, sucursal_id, numero_alquileres, monto_total)
	SELECT 
		r.rental_id AS alquiler_id,
		to_char(rental_date, 'dd/mm/yyyy') AS fecha_id,
		i.film_id AS pelicula_id,
		s.address_id AS lugar_id,
		s.store_id AS sucursal_id, 
		COUNT(*) AS numero_alquileres,
		SUM(p.amount) AS monto_total
	FROM public.rental r
	INNER JOIN public.inventory i ON i.inventory_id = r.inventory_id
	INNER JOIN public.payment p ON p.rental_id = r.rental_id
	INNER JOIN public.store s ON s.store_id = i.store_id
	GROUP BY 1, 2, 3, 4, 5;
END;
$$
LANGUAGE plpgsql;

CALL cargar_modelo()


