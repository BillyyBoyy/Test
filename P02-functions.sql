-- Funcion que recibe los datos de un cliente y lo inserta en la tabla public.customer 
CREATE OR REPLACE FUNCTION insertar_cliente(
    store_id smallint, -- ID de la tienda en la que se registra
    first_name character varying, -- Nombre del cliente
    last_name character varying, -- Apellido del cliente
    email character varying, -- Correo del cliente
    address_id smallint -- Direccion del cliente
) RETURNS VOID AS
$$
BEGIN
    BEGIN
		-- Intenta realizar la inserción
        INSERT INTO public.customer (store_id, first_name, last_name, email, address_id)
        VALUES (store_id, first_name, last_name, email, address_id);
    EXCEPTION
		-- Maneja la excepción en caso de que falle la inserción
        WHEN others THEN
            RAISE EXCEPTION 'Error al insertar en la tabla customer: %', SQLERRM;
    END;
END;
$$
LANGUAGE plpgsql;

SELECT insertar_cliente(1::smallint, 'A'::character varying, 'B'::character varying, 'C'::character varying, 1::smallint);

SELECT * FROM public.customer

-- Funcion que recibe los datos de un alquiler y hace su registro en la tabla public.rental y retorna su ID
CREATE OR REPLACE FUNCTION registrar_alquiler(
    rental_date timestamp without time zone, -- Fecha de la renta
    inventory_id integer, -- ID del grupo de peliculas que renta
    customer_id smallint, -- ID del cliente que renta
    staff_id smallint -- ID del funcionario que realiza la renta
) RETURNS integer AS
$$
DECLARE
    v_rental_id integer;
BEGIN
	BEGIN
        -- Intenta insertar un nuevo registro en la tabla de alquiler
       	INSERT INTO public.rental (rental_date, inventory_id, customer_id, staff_id)
        VALUES (rental_date, inventory_id, customer_id, staff_id)
        RETURNING rental_id INTO v_rental_id;
    EXCEPTION
        -- Maneja la excepción en caso de que falle la inserción
        WHEN others THEN
            RAISE EXCEPTION 'Error al registrar el alquiler: %', SQLERRM;
    END;

    -- Retorna el ID del alquiler recién registrado
    RETURN v_rental_id;
END;
$$
LANGUAGE plpgsql;

SELECT registrar_alquiler('2023-10-11 10:00:00'::timestamp, 2::integer, 2::smallint, 1::smallint);
SELECT * from public.rental 

-- Funcion que recibe las palabras clave de una pelicula y retorna las filas que coincidan  
CREATE OR REPLACE FUNCTION buscar_pelicula(pelicula_a_buscar character varying(255)) RETURNS SETOF public.film AS
$$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.film
    WHERE LOWER(title) @@ LOWER(pelicula_a_buscar);
    RETURN;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM buscar_pelicula('truman');

-- Funcion que recibe el ID de una renta y la fecha en la que se devuelve para registrar la devolucion 
CREATE OR REPLACE FUNCTION registrar_devolucion(
	p_rental_id integer, -- ID de la renta a finalizar
	fecha_devolucion timestamp -- Fecha de finalizacion 
) RETURNS void AS
$$
BEGIN
    -- Verificar si el rental_id existe 
    IF NOT EXISTS (SELECT 1 FROM public.rental r WHERE r.rental_id = p_rental_id) THEN
        -- Lanzar una excepción personalizada si el rental_id no existe
        RAISE EXCEPTION 'El rental_id % no existe', p_rental_id;
    END IF;
    -- Actualizar el campo return_date en la tabla de alquiler
    UPDATE public.rental r
    SET return_date = fecha_devolucion
    WHERE r.rental_id = p_rental_id;
   
EXCEPTION
    WHEN others THEN
		-- Maneja la excepción en caso de que falle el update
        RAISE EXCEPTION 'Error al registrar la devolución: %', SQLERRM;
END;
$$
LANGUAGE plpgsql;

SELECT registrar_devolucion(16051, '2023-11-11 10:00:00'::timestamp)

SELECT * FROM public.rental ORDER BY rental_id desc