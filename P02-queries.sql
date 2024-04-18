-- 4.1: Esta consulta obtiene la dirección de la sucursal, el mes, el número de alquileres y el monto total de alquileres por mes y sucursal.
SELECT 
    sd.direccion, 
    fd.mes, 
    SUM(numero_alquileres) AS numero_alquileres, 
    SUM(monto_total) AS monto_total
FROM public.alquiler_fact af
INNER JOIN public.fecha_dimension fd ON fd.fecha_id = af.fecha_id
INNER JOIN public.sucursal_dimension sd ON sd.sucursal_id = af.sucursal_id
GROUP BY 1, 2
ORDER BY 1, 2;

-- 4.2: Esta consulta obtiene el año, el mes y el número total de alquileres por mes y año.
SELECT 
    fd.anio, 
    fd.mes, 
    SUM(numero_alquileres) AS numero_alquileres
FROM public.alquiler_fact af
INNER JOIN public.fecha_dimension fd ON fd.fecha_id = af.fecha_id
GROUP BY 1, 2
ORDER BY 1, 2;

-- 4.3: Esta consulta obtiene la categoría de película, el año, el número de alquileres y el monto total de alquileres por categoría y año.
SELECT 
    pd.categoria, 
    fd.anio, 
    SUM(numero_alquileres) AS numero_alquileres, 
    SUM(monto_total) AS monto_total
FROM public.alquiler_fact af
INNER JOIN public.pelicula_dimension pd ON af.pelicula_id = pd.pelicula_id
INNER JOIN public.fecha_dimension fd ON fd.fecha_id = af.fecha_id
GROUP BY 1, 2
ORDER BY 1;

-- 4.4: Esta consulta obtiene el nombre del actor, el año y el monto total de alquileres para cada actor, desglosado por año.
SELECT 
    actor_name, 
    fd.anio AS year, 
    SUM(af.monto_total) AS total_rental_amount
FROM public.alquiler_fact af
INNER JOIN public.pelicula_dimension pd ON af.pelicula_id = pd.pelicula_id
CROSS JOIN UNNEST(pd.actores) AS actor_name
INNER JOIN public.fecha_dimension fd ON af.fecha_id = fd.fecha_id
GROUP BY actor_name, fd.anio
ORDER BY fd.anio, actor_name, total_rental_amount DESC
LIMIT 10;

-- 4.5: Esta consulta obtiene el año, la ciudad y el número total de alquileres por ciudad y año.
SELECT 
    fd.anio, 
    CONCAT(ld.ciudad, ', ', ld.pais) AS ciudad, 
    SUM(numero_alquileres) AS numero_alquileres
FROM alquiler_fact af
INNER JOIN public.fecha_dimension fd ON af.fecha_id = fd.fecha_id
INNER JOIN public.lugar_dimension ld ON af.lugar_id = ld.lugar_id
GROUP BY 1, 2;
