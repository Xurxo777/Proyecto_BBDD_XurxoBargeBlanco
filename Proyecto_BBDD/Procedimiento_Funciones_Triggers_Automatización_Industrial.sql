
-- FUNCIONES ALMACENADAS
-- Calculo de antiguedad en la empresa desde año de contratación introducido por teclado;

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

-- Creacion de el nombre completo de los empleados con su nombre y su apellido

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

-- PROCEDIMIENTOS ALMACENADOS

-- Procedimiento para insercción de nuevos empleados

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

-- Procedimiento para actualizar el contacto de un empleado

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


-- TRIGGERS

-- Trigger BEFORE INSERT: Validar que el DNI no esté vacío ni nulo; si lo está, cancelar la inserción.

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

-- Trigger AFTER UPDATE: Registrar cambios en teléfono o email en una tabla de auditoría

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


