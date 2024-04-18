-- Creación de la tabla alquiler_fact
CREATE TABLE alquiler_fact (
    alquiler_id serial PRIMARY KEY,
    fecha_id varchar(12),
    pelicula_id integer,
    lugar_id integer,
    sucursal_id integer,
    numero_alquileres integer,
    monto_total numeric(10, 2)
);

-- Creación de la tabla pelicula_dimension
CREATE TABLE pelicula_dimension (
    pelicula_id serial PRIMARY KEY,
    titulo varchar(255),
    categoria varchar(50),
    actores text[]
);

-- Creación de la tabla lugar_dimension
CREATE TABLE lugar_dimension (
    lugar_id serial PRIMARY KEY,
    pais varchar(64),
    ciudad varchar(64)
);

-- Creación de la tabla fecha_dimension
CREATE TABLE fecha_dimension (
    fecha_id varchar(12) PRIMARY KEY,
    anio smallint,
    mes smallint,
    dia smallint
);

-- Creación de la tabla sucursal_dimension
CREATE TABLE sucursal_dimension (
    sucursal_id serial PRIMARY KEY,
    direccion varchar(50)
);
