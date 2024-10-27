1
Tema 6 - Tratamiento de Datos -
EjerciciosEjecutar primero estas sentencias para crear dos nuevas tablas, departamentos
y empleados, donde realizar los ejercicios desde el usuario alumno

create table departamentos
as select * from depart;
create table empleados
as select * from emple;



INSERT
1. Insertar un nuevo departamento en DEPARTAMENTOS con código 55, nombre RECURSOS y localidad MADRID.

--COMO ES PARA TODOS LOS VALORES DE LA TABLA SIMPLEMENTE HAY QUE RESPERAR EL ORDEN DE INSERCCIÓN DE LOS DATOS.
INSERT INTO  DEPARTAMENTOS
VALUES(55,'RECURSOS','MADRID'); 


--2. Insertar un empleado en el departamento 55 con número de empleado 8000, apellido ESCUDERO, salario 1230€, oficio EMPLEADO y fecha de alta la del sistema.
--LA TABLA TIENE 8 COLUMNAS Y NOS PIDEN 6 INSERCCIONES, HABRÁ QUE UTILIZAR DECLARACION DE COLUMNAS

INSERT INTO EMPLEADOS (EMP_NO, APELLIDO, SALARIO, OFICIO, FECHA_ALT,DEPT_NO)
VALUES (8000,'ESCUDERO',1230, 'EMPLEADO',SYSDATE,55); 
ROLLBACK; 

--3. Insertar un empleado con número 8001, apellido ROJO, fecha de alta ayer y el resto de datos los del empleado 7654.

INSERT INTO EMPLEADOS
SELECT 8001,'ROJO',OFICIO, DIR,SYSDATE-1, SALARIO, COMISION, DEPT_NO 
FROM EMPLE
WHERE EMP_NO = 7654; 
ROLLBACK; 

--4. Insertar un empleado en Empleados con el número 9050, apellido el tuyo, oficio Becario, dir el número de empleado de SALA, fecha de alta
--el lunes de la semana que viene, salario la mitad del de SALA, comisión nula y departamento el de SALA.

INSERT INTO EMPLEADOS
SELECT 9050, 'DEL SAZ', 'BECARIO', DIR, NEXT_DAY( SYSDATE, 'LUNES') , SALARIO / 2, NULL, DEPT_NO
FROM EMPLE
WHERE UPPER(APELLIDO) = 'SALA'; 

ROLLBACK; 
 

--5. Insertar un nuevo departamento en DEPARTAMENTOS con código 65, nombre ‘I+D’ y localidad la del departamento con menos empleados.

INSERT INTO DEPARTAMENTOS
SELECT 65, 'I+D', LOC
FROM DEPARTAMENTOS
WHERE DEPT_NO IN (SELECT DEPT_NO FROM EMPLEADOS GROUP BY DEPT_NO HAVING COUNT(EMP_NO) =
                (SELECT MIN(COUNT(EMP_NO)) FROM EMPLEADOS GROUP BY DEPT_NO)); 
ROLLBACK; 

--6. Insertar una avería en Averias_Parque para la atracción Enterprise con  fecha_falla el día de ayer, fecha_arreglo y coste a nulo y dni_emple el
--encargado de la zona de la atracción.
--DIFICIL

INSERT INTO CAVERIAS_PARQUE
SELECT COD_ATRACCION, SYSDATE -1, NULL, NULL, Z.DNI_ENCARGADO --QUIERE EL ENCARGADO DE LA ZONA, NO QUIEN LO ARREGLA
--SELECIONAMOS LA TABLA ATRACCIONES PORQUE ES DONDE SE UBUCA EL NOMBRE DE LA ATRACCION.
FROM ATRACCIONES A JOIN ZONAS Z ON Z.NOM_ZONA = A.NOM_ZONA--PARA SACAR EL DNI_ENCARGADO
WHERE UPPER(A.NOM_ATRACCION) = 'ENTERPRISE'; 
ROLLBACK; 


--7. Insertar en ATRACCIONES una nueva atracción con el código ‘A140’, nombre ‘Que Miedo’, fecha de inauguración dentro de 30 días, capacidad
--40 y nombre de zona la zona que menos atracciones tiene
--DIFICIL

INSERT INTO ATRACCIONES
SELECT DISTINCT 'A140', 'QUE MIEDO', SYSDATE + 30,40, NOM_ZONA
FROM ATRACCIONES
WHERE NOM_ZONA = (SELECT NOM_ZONA FROM ATRACCIONES GROUP BY NOM_ZONA HAVING COUNT(COD_ATRACCION)
                =(SELECT MIN(COUNT(COD_ATRACCION)) FROM ATRACCIONES GROUP BY NOM_ZONA)); 
ROLLBACK;


UPDATE

--EJEMPLO DIAPOSITIVA

--AUMENTA 100 EUROS EL SALARIO Y 10 EUROS LA COMISION A TODOS LOS EMPLEADOS DE DEPARTAMENTO 10 EN LA TABLA EMPLEADOS


--CON COMISIONES NULL NO PUEDES SUMAR. HAY QUE IGUALAR A 0 Y DESPUES SUMAR.
UPDATE EMPLEADOS 
SET SALARIO = SALARIO + 100,COMISION= NVL(COMISION,0)+10 -- NO ES LO MISMO ESTO, QUE COMISION = NVL(COMISION , 10), YA QUE ESTE CODIGO SOLO SERÍA VÁLIDO SI EL ENUNCIADO SOLO QUISIERA SUBIR LA COMISION
                                                            --A LOS QUE TIENEN COMISION NULL, SIN EMBARGO CON EL + 10, FUERA DEL NVL, SE LA SUBES A TODOS LOS EMPLEADOS, INCLUIDOS LOS NULL Y NOT NULL.
WHERE DEPT_NO = 10; 

ROLLBACK; 


--modifica el numero de depart de MUÑOZ() al numero de departamento donde hay mas empleados cuyo oficio sea 'EMPLEADO' 
--DIFICIL


UPDATE EMPLEADOS
SET DEPT_NO = (SELECT DEPT_NO FROM EMPLEADOS WHERE UPPER(OFICIO) = 'EMPLEADO' GROUP BY DEPT_NO HAVING COUNT(*) =
            (SELECT MAX(COUNT(*))  FROM EMPLEADOS  WHERE UPPER(OFICIO) = 'EMPLEADO' GROUP BY DEPT_NO))
WHERE UPPER(APELLIDO) = 'MUÑOZ'; 

ROLLBACK; 

UPDATE 
DROP TABLE CALUMNOS CASCADE CONSTRAINT; 

create table  CALUMNOS
as select * from ALUMNOS;

create table 
as select * from emple;

--8. Modificar la dirección del alumno que se apellida Cerrato con ‘c/ Valbuena 87 1A’.
--RESULTADOS CORRECTOS

UPDATE CALUMNOS 
SET DIREC = 'C/VALBUENA 87 1A'
WHERE UPPER(APENOM) LIKE '%CERRATO%'; 


--9. Modificar en la tabla averias_parque la avería de la atracción ‘C100’ que tiene la fecha de arreglo a nulo poniendo dicha fecha al día de hoy y el
--coste de la avería a 1200.

create table CAVERIAS_PARQUE
as select * from AVERIAS_PARQUE;

UPDATE CAVERIAS_PARQUE
SET FECHA_ARREGLO = SYSDATE, COSTE_AVERIA = 1200
WHERE COD_ATRACCION = 'C100' AND FECHA_ARREGLO IS NULL; 
rollback;

--10.  Modificar la comisión de los empleados de departamentos de Barcelona poniéndoles 300€ a los que no tienen nada..
--COMPILA RESULTADOS COMPROBADOS

UPDATE EMPLEADOS 
SET COMISION = NVL(COMISION,0)+300
WHERE  DEPT_NO = (SELECT DEPT_NO FROM DEPARTAMENTOS WHERE UPPER(LOC) = 'BARCELONA'); 


--11. Cambiarle el oficio y el salario a TOVAR por el de ALONSO
--VA A PASAR DE VENDEDOR A EMPLEADO
--RESULTADOS COMPROBADOS

UPDATE EMPLEADOS
SET (OFICIO, SALARIO) = (SELECT OFICIO, SALARIO FROM EMPLEADOS WHERE UPPER(APELLIDO) ='ALONSO')
WHERE UPPER (APELLIDO) = 'TOVAR'; 
ROLLBACK; 


--12. Subir 150€ a todos los empleados que empezaron a trabajar en la empresa antes del año 2006.
--SANCHEZ PASARA DE 1040 1190
--CORRECTO RESULTADOS COMPROBADOS

UPDATE EMPLEADOS
SET SALARIO = SALARIO +150
WHERE TO_CHAR(FECHA_ALT,'YYYY')< 2006;


--13. Subir 100€ a los empleados que ganan el mínimo salario en la empresa
--ES SANCHEZ CON 1190, TIEENE QUE PASADOR A 1290
--CORRECTO RESULTADOS COMPROBADOS

UPDATE EMPLEADOS
SET SALARIO = SALARIO +100
WHERE SALARIO = (SELECT MIN(SALARIO) FROM EMPLEADOS); 

--14. Subir un 10% el salario a los empleados que ganan el mínimo salario de su oficio

--MEDIA
UPDATE EMPLEADOS
SET SALARIO = SALARIO * 1.10
WHERE (SALARIO,OFICIO) IN (SELECT MIN(SALARIO)AS SALARIO, OFICIO  FROM EMPLEADOS GROUP BY OFICIO); 

rollback; 
--15. Subir 50€ a los empleados del departamento de INVESTIGACION que ganan menos de la media del departamento de INVESTIGACION
--DIFICIL

UPDATE EMPLEADOS
SET SALARIO = SALARIO + 50
WHERE DEPT_NO = (SELECT DEPT_NO FROM DEPARTAMENTOS WHERE UPPER(DNOMBRE) = 'INVESTIGACION')
--NO SE PUEDE ENCHUFAR ESTA CONDICIÓN EN LA PRIMERA SUBCONSULTA(ES LO QUE HICISTE) 
AND SALARIO < (SELECT AVG(SALARIO) FROM EMPLEADOS E JOIN DEPARTAMENTOS D ON E.DEPT_NO = D.DEPT_NO WHERE UPPER(DNOMBRE)= 'INVESTIGACION'); 

rollback;                             

--DELETE
--BORRAR TODOS LOS DEPARTAMENTO DE LA TABLA  DEPART PARA LOS CUALES NO ESXISTAN EMPLEADOS EN EMPLE
--SERIA BORRAR EL DEPARTAMENTO 40
--PENSAMIENTO INVERSO
--CORRECTO
DELETE DEPARTAMENTOS 
WHERE DEPT_NO NOT IN (SELECT DEPT_NO FROM EMPLEADOS) ; 
ROLLBACK; 

(CADA VEZ QUE REALICES UN BORRADO COMPRUEBA QUE LO HAS HECHO
CORRECTAMENTE Y HA BORRADO LO QUE TIENE QUE BORRAR Y DESPUÉS HAZ
ROLLBACK)

--16. Borrar todos los empleados.

DELETE EMPLEADOS; 
ROLLBACK; 

--17. Borrar los empleados de oficio Analista.
--CORRECTO RESULTADOS COMPROBADOS

DELETE EMPLEADOS
WHERE UPPER(OFICIO) = 'ANALISTA';
ROLLBACK;

--18. Borrar los empleados del departamento de VENTAS
--CORRECTO RESULTADOS COMPROBADOS

DELETE EMPLEADOS
WHERE DEPT_NO =(SELECT DEPT_NO FROM DEPARTAMENTOS WHERE UPPER(DNOMBRE) = 'VENTAS');
ROLLBACK; 

--19. Borrar los empleados del departamento que menos empleados tiene.
--ES DECIR DEPT=10, CEREZO REY Y MUÑOZ
--NO ME SALE
--SALE MUCHISMIMAS VECES ESTA CONSULTA

DELETE EMPLEADOS
WHERE DEPT_NO = (SELECT DEPT_NO FROM EMPLEADOS GROUP BY DEPT_NO  HAVING COUNT(*) =
                (SELECT MIN(COUNT(*)) FROM EMPLEADOS GROUP BY DEPT_NO));

DELETE EMPLEADOS
WHERE DEPT_NO = (SELECT DEPT_NO  FROM EMPLEADOS GROUP_BY DEPT_NO HAVING COUNT(*)= (SELECT MIN(COUNT(*)) FROM EMPLEADOS GROUP BY DEPT_NO));

ROLLBACK; 

--20. Borrar los departamentos que no tienen empleados.
--PENSAMIENTO INVERSO (CREO QUE CAERA EN EL EXÁMEN)
--LA SUBCONSULTA SACA LOS QUE SI TIENE EMPLEADOS Y LA CONSULTA ELIMINA LOS QUE NO TIENEN.

DELETE DEPARTAMENTOS
WHERE DEPT_NO NOT IN (SELECT DEPT_NO FROM EMPLEADOS); 
ROLLBACK; 

--21. Borrar al empleado más antiguo de la empresa (ES DECIR, CEREZO)

DELETE EMPLEADOS
WHERE FECHA_ALT IN (SELECT MIN(FECHA_ALT) FROM EMPLEADOS); 




--EXTRAS SACADAS DE LAS SUBCONSULTAS

--11 Elimnina  los nombres de alumnos que tengan en Programación la misma nota que tiene Luis en Programación

DELETE CALUMNOS
WHERE DNI IN (SELECT DNI FROM NOTAS N JOIN ASIGNATURAS A ON A.COD = N.COD 
            WHERE NOTA = (SELECT N.NOTA FROM NOTAS N  JOIN ASIGNATURAS A ON A.COD = N.COD JOIN ALUMNOS A ON A.DNI = N.DNI WHERE UPPER(APENOM) LIKE '%LUIS%' AND UPPER(A.NOMBRE) = 'PROGRAMACION') 
            AND UPPER(A.NOMBRE)='PROGRAMACION'
            AND UPPER(APENOM) NOT LIKE '%LUIS%');


--ELIMINA AL ALUMNO QUE que tengan la misma nota que tiene María en  Marcas en cualquier asignatura
DELETE CALUMNOS
WHERE DNI = (SELECT AL.DNI FROM NOTAS N JOIN ALUMNOS AL ON AL.DNI = N.DNI WHERE NOTA =
            (SELECT NOTA FROM NOTAS N JOIN ALUMNOS AL ON AL.DNI = N.DNI JOIN ASIGNATURAS A ON A.COD = N.COD WHERE UPPER(APENOM) LIKE '%MARIA%' AND UPPER(NOMBRE) = 'MARCAS')
            AND UPPER(APENOM) NOT LIKE '%MARIA%');


ROLLBACK;  

ROLLBACK; 

ROLLBACK; 

--COMMIT; CONFIRMA LOS CAMBIOS REALIZADOS EN LAS INSERCCIONES DE FORMA IRREVERSIBLE
--ROLLBACK; DESHACE TODOS LOS CAMBIOS SOLO HASTA EL ULTIMO COMMIT. (RECUERDA QUE ES IRREVERSIBLE)
--SHOW AUTOCOMMIT: nos muestra si los cambios van a validarse automáticamente después de cada operación de manipulación de datos ON) 
--o si es el usuario el que llevará el control de las transacciones con los comandos anteriores (OFF).

--SET AUTOCOMMIT  [ON/OFF]: Sirve para especificar la opción deseada.



--NO HACER ES CORRELACIONADA
--22. Borrar los empleados que ganan menos de la media del salario de su departamento  
