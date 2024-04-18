--Rol EMP 
CREATE ROLE EMP;

GRANT EXECUTE ON FUNCTION registrar_alquiler(timestamp, integer, smallint, smallint) TO EMP;
GRANT EXECUTE ON FUNCTION buscar_pelicula(character varying) TO EMP;
GRANT EXECUTE ON FUNCTION registrar_devolucion(integer, timestamp) TO EMP;

--Rol ADMIN 
CREATE ROLE ADMIN;
GRANT EMP TO ADMIN;

GRANT EXECUTE ON FUNCTION insertar_cliente(smallint, character varying, character varying, character varying, smallint) TO ADMIN;

--User Video
CREATE USER video WITH NOLOGIN ;
GRANT ALL ON ALL TABLES IN SCHEMA public TO video;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO video;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO video;
--User empleado1
CREATE USER empleado1 WITH ROLE emp;
--User administrador1
CREATE USER administrador1 WITH ROLE admin;