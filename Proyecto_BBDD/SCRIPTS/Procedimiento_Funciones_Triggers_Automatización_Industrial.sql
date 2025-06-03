
-- FUNCIONES ALMACENADAS



-- 1. Calculo de antiguedad en la empresa desde año de contratación introducido por teclado;

DELIMITER //
CREATE FUNCTION calcular_antiguedad(p_fecha DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_fecha, CURDATE());
END
//
DELIMITER ;

select calcular_antiguedad('2018-03-23');

-- 2. Creacion de el nombre completo de los empleados con su nombre y su apellido

DELIMITER //
CREATE FUNCTION nombre_completo(p_nombre VARCHAR(50), p_apellidos VARCHAR(50))
RETURNS VARCHAR(101)
DETERMINISTIC
BEGIN
    RETURN CONCAT(p_nombre, ' ', p_apellidos);
END
//
DELIMITER ;

SELECT nombre_completo('María', 'Pérez García') AS NombreCompleto;

-- 3. Función que devolve un resumo da información dun empregado.

DELIMITER //
CREATE FUNCTION resumen_empleado(p_ID INT)
RETURNS TEXT
DETERMINISTIC
BEGIN
  DECLARE v_nombre VARCHAR(50);
  DECLARE v_apellidos VARCHAR(50);
  DECLARE v_email VARCHAR(100);
  DECLARE v_fecha DATE;
  DECLARE v_antiguedad INT;
  DECLARE v_resultado TEXT;

  SELECT Nombre, Apellidos, Email, Fecha_Contratacion
  INTO v_nombre, v_apellidos, v_email, v_fecha
  FROM EMPLEADOS
  WHERE ID_Empleado = p_ID;

  SET v_antiguedad = TIMESTAMPDIFF(YEAR, v_fecha, CURDATE());

  SET v_resultado = CONCAT('Empregado: ', v_nombre, ' ', v_apellidos,
                           ', Email: ', v_email,
                           ', Antigüidade: ', v_antiguedad, ' anos');

  RETURN v_resultado;
END //

DELIMITER ;

SELECT resumen_empleado(1);

-- PROCEDIMIENTOS ALMACENADOS

-- 1. Procedimiento para insercción de nuevos empleados

DELIMITER //
CREATE PROCEDURE insertar_empleado(
    IN p_ID_Empleado INT,
    IN p_Nombre VARCHAR(50),
    IN p_Apellidos VARCHAR(50),
    IN p_DNI VARCHAR(15),
    IN p_Especialidad VARCHAR(50),
    IN p_Telefono VARCHAR(20),
    IN p_Email VARCHAR(100),
    IN p_Fecha_Contratacion DATE
)
BEGIN
    INSERT INTO EMPLEADOS (ID_Empleado, Nombre, Apellidos, DNI, Especialidad, Telefono, Email, Fecha_Contratacion)
    VALUES (p_ID_Empleado, p_Nombre, p_Apellidos, p_DNI, p_Especialidad, p_Telefono, p_Email, p_Fecha_Contratacion);
END
//
DELIMITER ;

CALL insertar_empleado(
  9, 'Ana', 'López García', '12345678A', 'Electricista',
  '600111222', 'ana.lopez@example.com', '2020-01-15'
);

-- 2. Procedimiento para actualizar el contacto de un empleado

DELIMITER //
CREATE PROCEDURE actualizar_contacto(
    IN p_ID_Empleado INT,
    IN p_Telefono VARCHAR(20),
    IN p_Email VARCHAR(100)
)
BEGIN
    UPDATE EMPLEADOS
    SET Telefono = p_Telefono,
        Email = p_Email
    WHERE ID_Empleado = p_ID_Empleado;
END
//
DELIMITER ;

CALL actualizar_contacto(1, '666999000', 'ana.actualizado@example.com');

SELECT * FROM EMPLEADOS WHERE ID_Empleado = 1;

-- 3. procedemento almacenado que elimina empregados con máis de X anos de antigüidade (con backup previo).

-- Primeiro crease unha táboa de backup:

CREATE TABLE IF NOT EXISTS EMPLEADOS_ELIMINADOS AS
SELECT * FROM EMPLEADOS WHERE 1=0;

DELIMITER //

CREATE PROCEDURE eliminar_empregados_antigos(IN p_anhos INT)
BEGIN
  DECLARE v_data_limite DATE;

  SET v_data_limite = DATE_SUB(CURDATE(), INTERVAL p_anhos YEAR);

  INSERT INTO EMPLEADOS_ELIMINADOS
  SELECT * FROM EMPLEADOS WHERE Fecha_Contratacion < v_data_limite;

  DELETE FROM EMPLEADOS WHERE Fecha_Contratacion < v_data_limite;
END //

DELIMITER ;

CALL eliminar_empregados_antigos(5);

-- TRIGGERS

-- 1. Trigger BEFORE INSERT: Validar que el DNI no esté vacío ni nulo; si lo está, cancelar la inserción.

DELIMITER //
CREATE TRIGGER validar_DNI_before_insert
BEFORE INSERT ON EMPLEADOS
FOR EACH ROW
BEGIN
    IF NEW.DNI IS NULL OR NEW.DNI = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DNI no puede estar vacío';
    END IF;
END
//
DELIMITER ;

INSERT INTO EMPLEADOS (ID_Empleado, Nombre, Apellidos, DNI, Especialidad, Telefono, Email, Fecha_Contratacion)
VALUES (2, 'Juan', 'Rodríguez', '', 'Programador', '611223344', 'juan@example.com', '2021-06-01');



-- 2. Trigger AFTER UPDATE: Registrar cambios en teléfono o email en una tabla de auditoría

CREATE TABLE auditoria_contacto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ID_Empleado INT,
    Telefono_antiguo VARCHAR(20),
    Telefono_nuevo VARCHAR(20),
    Email_antiguo VARCHAR(100),
    Email_nuevo VARCHAR(100),
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER auditar_cambios_contacto_after_update
AFTER UPDATE ON EMPLEADOS
FOR EACH ROW
BEGIN
    IF OLD.Telefono <> NEW.Telefono OR OLD.Email <> NEW.Email THEN
        INSERT INTO auditoria_contacto (ID_Empleado, Telefono_antiguo, Telefono_nuevo, Email_antiguo, Email_nuevo)
        VALUES (NEW.ID_Empleado, OLD.Telefono, NEW.Telefono, OLD.Email, NEW.Email);
    END IF;
END
//
DELIMITER ;

CALL actualizar_contacto(1, '699888777', 'ana.cambio2@example.com');

SELECT * FROM auditoria_contacto;

-- 3. Un trigger que evita eliminar empregados da especialidade “Director”.

DELIMITER //

CREATE TRIGGER evitar_eliminar_director
BEFORE DELETE ON EMPLEADOS
FOR EACH ROW
BEGIN
  IF OLD.Especialidad = 'Director' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Non se pode eliminar un Director.';
  END IF;
END //

DELIMITER ;

INSERT INTO EMPLEADOS VALUES (10, 'Laura', 'Santos', '99887766A', 'Director',
                              '600000001', 'laura@example.com', '2010-03-01');

-- Isto lanzará erro:
DELETE FROM EMPLEADOS WHERE ID_Empleado = 10;

