SELECT *
FROM limpieza
LIMIT 10;


SET sql_safe_updates = 0;

/*STORE PROCEDURE QUE USÉ CON MUCHA FRECUENCIA*/
DELIMITER //
CREATE PROCEDURE limp()
BEGIN
	SELECT *
	FROM limpieza;
END //
DELIMITER ; 
   
CALL limp();

/* CAMBIAMOS LOS ENCABEZADOS PARA QUE SEAN MAS LEGIBLES */
ALTER TABLE limpieza CHANGE COLUMN `ï»¿Id?empleado` Id_emp VARCHAR(20) null;
ALTER TABLE limpieza CHANGE COLUMN gÃ©nero gender VARCHAR(20) null;

/* ELIMINANDO DUPLICADOS*/
-- PRIMERO SE IDENTIFICAN EL NUMERO DE DUPLICADOS
SELECT COUNT(*) as cantidad_duplicados
FROM (
	SELECT Id_emp, COUNT(*) as cantidad_duplicados
	FROM LIMPIEZA
	GROUP BY Id_emp
	HAVING COUNT(*) >1
) AS subquery;

-- DESPUÉS RENOMBRAMOS LA TABLA ORIGINAL
RENAME TABLE limpieza to conduplicados;

-- CREAMOS UNA TABLA TEMPORAL CON BASE AL RESULTADO DE UNA CONSULTA
CREATE TEMPORARY TABLE Temp_limpieza AS 
	SELECT DISTINCT *
    FROM conduplicados;

-- VERIFICAMOS NUMERO DE REGISTROS DE conduplicados y Temp_limpieza
SELECT COUNT(*) as tabla_original
FROM conduplicados;

SELECT COUNT(*) as tabla_sin_repetidos	
FROM Temp_limpieza;

-- CONVERTIMOS LA TABLA TEMPORAL A TABLA 
CREATE TABLE limpieza as 
	SELECT * FROM Temp_limpieza;
    
/* LA TABLA conduplicados AL TENER LA INFORMACIÓN ORIGINAL SE PUEDE OPTAR POR ELIMINARLA O DEJARLA, EN ESTE CASO LA DEJARÉ */    


/* MODIFICAMOS LOS ENCABEZADOS DE LAS COLUMNAS Apellido Y star_date*/
ALTER TABLE limpieza CHANGE COLUMN Apellido Last_name varchar(50) null;
ALTER TABLE limpieza CHANGE COLUMN star_date start_date varchar(50) null;

-- VEMOS LOS METADATOS PARA VERIFICAR QUE SE TENGA EL TIPO DE DATO CORRECTO PARA CADA COLUMNA
DESCRIBE limpieza;

/*VERIFICAMOS CUALES NOMBRES TIENEN ESPACIOS INDESEADOS */
SELECT Name 
FROM limpieza	
WHERE length(name) - length(trim(name)) > 0;

SELECT Name, trim(name) as Name
FROM limpieza
WHERE length(name) - length(trim(name)) > 0;

-- ACTUALIZAMOS LA TABLA EN BASE A LA CONSULTA ANTERIOR
UPDATE limpieza SET Name = trim(Name)
WHERE length(name) - length(trim(name)) > 0; 

-- HACEMOS LO MISMO CON LAS COLUMNAS FALTANTES
SELECT Last_name, trim(Last_name) as Last_Name
FROM limpieza
WHERE length(Last_name) - length(trim(Last_name)) > 0;

UPDATE limpieza SET Last_name = trim(Last_name)
WHERE length(Last_name) - length(trim(Last_name)) > 0; 

/* NOS ASEGURAMOS QUE LA COLUMNA area NO TENGA ESPACIOS INDESEADOS*/
SELECT area, trim(regexp_replace(area, '\\s+',' ')) as prueba-- Esto busca 2 o mas espacios entre palabras
FROM limpieza;

UPDATE limpieza SET area = trim(regexp_replace(area, '\\s+',' '));
call limp();

/* AHORA CAMBIEMOS LA COLUMNA gender */
SELECT gender,
CASE 
	WHEN gender = 'hombre' then 'male'
    WHEN gender = 'mujer' then 'female'
    ELSE 'other'
END as gender_prueba
FROM limpieza; 

UPDATE limpieza SET gender = 
	CASE 
	WHEN gender = 'hombre' then 'male'
    WHEN gender = 'mujer' then 'female'
    ELSE 'other'
END;
call limp();

/*POR EL CONTEXTO DEL DATASET LA COLUMNA type SE REFIERE AL TIPO DE CONTRATO DE CADA PERSONA:
	0 - HIBRIDO
    1 - REMOTO
  EN EL SIGUIENTE PASO LE DAREMOS MAS SENTIDO A ESTA COLUMNA  
*/
DESCRIBE limpieza;

ALTER TABLE limpieza MODIFY COLUMN type VARCHAR(20);

SELECT type,
	CASE 
		WHEN type = 1 THEN 'REMOTE'
        WHEN type = 0 THEN 'HYBRID'
        ELSE 'OTHER'
    END AS type_prueba
FROM limpieza; 

UPDATE limpieza SET type = 
	CASE 
		WHEN type = 1 THEN 'REMOTE'
        WHEN type = 0 THEN 'HYBRID'
        ELSE 'OTHER'
    END;
call limp();

/*AHORA SE DEBE CORREGIR LA COLUMNA salary, COMO YA VIMOS TIENE FORMATO TEXTO*/

SELECT salary AS salary_antes,
       CAST(TRIM(REPLACE(REPLACE(salary, '$', ''), ',', '')) AS DECIMAL(15,2)) AS salary_despues
FROM limpieza;

UPDATE limpieza SET salary =  CAST(TRIM(REPLACE(REPLACE(salary, '$', ''), ',', '')) AS DECIMAL(15,2));
call limp();

ALTER TABLE limpieza MODIFY COLUMN salary INT NULL;
DESCRIBE limpieza;

/*AHORA REVISAREMOS LAS COLUMNAS QUE CONTENGAN FECHAS*/

SELECT birth_date
FROM limpieza;

SELECT birth_date,
    CASE 
        WHEN birth_date LIKE '%/%' THEN date_format(str_to_date(birth_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN birth_date LIKE '%-%' THEN date_format(str_to_date(birth_date, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE null
    END AS birth_date_prueba
FROM limpieza;

UPDATE limpieza SET birth_date =  
		CASE 
        WHEN birth_date LIKE '%/%' THEN date_format(str_to_date(birth_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN birth_date LIKE '%-%' THEN date_format(str_to_date(birth_date, '%m-%d-%Y'), '%Y-%m-%d')
        ELSE null
    END;
call limp();
ALTER TABLE limpieza MODIFY COLUMN birth_date DATE;

SELECT start_date,
	CASE 
		WHEN start_date LIKE '%/%' THEN date_format(str_to_date(start_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN start_date LIKE '%-%' THEN date_format(str_to_date(start_date, '%m/%d/%Y'), '%Y-%m-%d')
        ELSE null
    END AS start_date_prueba
FROM limpieza;

UPDATE limpieza SET start_date = 
		CASE 
		WHEN start_date LIKE '%/%' THEN date_format(str_to_date(start_date, '%m/%d/%Y'), '%Y-%m-%d')
        WHEN start_date LIKE '%-%' THEN date_format(str_to_date(start_date, '%m/%d/%Y'), '%Y-%m-%d')
        ELSE null
    END;
    
 ALTER TABLE limpieza MODIFY COLUMN start_date DATE;
 call limp();

/*SE CREA UNA FUNCIONALIDAD PARA GENERAR CORREOS AUTOMATICAMENTE*/
SELECT concat(substring_index(Name, ' ', 1),'_', substring(Last_name, 1, 2), '.', substring(type, 1 , 1), '@example.com') as email
FROM limpieza;

ALTER TABLE limpieza ADD COLUMN email VARCHAR(50); 

UPDATE limpieza SET email = concat(substring_index(Name, ' ', 1),'_', substring(Last_name, 1, 2), '.', substring(type, 1 , 1), '@example.com');
call limp();

/* ORDENAMOS LA TABLA PARA DARLE FORMA DE UN REPORTE DESEADO  */

SELECT Id_emp, Name, Last_name, birth_date, gender, area, salary, email, type
FROM limpieza
WHERE finish_date <= curdate() OR finish_date is null
ORDER BY Last_name, area;

-- CONTABILIZACION DE TRABAJADORES POR AREA
SELECT area, COUNT(*) AS Numero_empleados
FROM limpieza
GROUP BY area
ORDER BY Numero_empleados desc;