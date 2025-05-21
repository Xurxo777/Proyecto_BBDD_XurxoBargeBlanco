CREATE DATABASE AUTOMATIZACION_INDUSTRIAL;

USE AUTOMATIZACION_INDUSTRIAL;

CREATE TABLE CLIENTES (
  ID_Cliente INT PRIMARY KEY,
  Nombre_Empresa VARCHAR(100),
  CIF VARCHAR(20),
  Direccion VARCHAR(200),
  Telefono VARCHAR(20),
  Email VARCHAR(100),
  Persona_Contacto VARCHAR(100)
);

CREATE TABLE PROYECTOS (
  ID_Proyecto INT PRIMARY KEY,
  ID_Cliente INT,
  Nombre_Proyecto VARCHAR(100),
  Fecha_Inicio DATE,
  Fecha_Fin_Prevista DATE,
  Fecha_Fin_Real DATE,
  Estado VARCHAR(50),
  Presupuesto DECIMAL(10,2),
  Descripcion TEXT,
  FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente)
    ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE EMPLEADOS (
  ID_Empleado INT PRIMARY KEY,
  Nombre VARCHAR(50),
  Apellidos VARCHAR(50),
  DNI VARCHAR(15),
  Especialidad VARCHAR(50),
  Telefono VARCHAR(20),
  Email VARCHAR(100),
  Fecha_Contratacion DATE
);

CREATE TABLE EMPLEADOS_PROYECTO (
  ID_Empleado INT,
  ID_Proyecto INT,
  Fecha_Asignacion DATE,
  Rol_Proyecto VARCHAR(50),
  Horas_Asignadas INT,
  PRIMARY KEY (ID_Empleado, ID_Proyecto),
  FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADOS(ID_Empleado)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ID_Proyecto) REFERENCES PROYECTOS(ID_Proyecto)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MAQUINAS (
  ID_Maquina INT PRIMARY KEY,
  ID_Cliente INT,
  Tipo_Maquina VARCHAR(50),
  Modelo VARCHAR(50),
  Fecha_Instalacion DATE,
  Estado VARCHAR(50),
  FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE COMPONENTES (
  ID_Componente INT PRIMARY KEY,
  Nombre VARCHAR(100),
  Descripcion TEXT,
  Stock INT,
  Precio_Unitario DECIMAL(10,2),
  Stock_Minimo INT,
  Stock_Maximo INT,
  ID_Proveedor_Principal INT,
  FOREIGN KEY (ID_Proveedor_Principal) REFERENCES PROVEEDORES(ID_Proveedor)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE COMPONENTES_MAQUINA (
  ID_Componente INT,
  ID_Maquina INT,
  Cantidad INT,
  Fecha_Instalacion DATE,
  PRIMARY KEY (ID_Componente, ID_Maquina),
  FOREIGN KEY (ID_Componente) REFERENCES COMPONENTES(ID_Componente)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ID_Maquina) REFERENCES MAQUINAS(ID_Maquina)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE MANTENIMIENTOS (
  ID_Mantenimiento INT PRIMARY KEY,
  ID_Maquina INT,
  ID_Empleado_Responsable INT,
  Fecha_Mantenimiento DATE,
  Tipo VARCHAR(50),
  Descripcion TEXT,
  Estado VARCHAR(50),
  FOREIGN KEY (ID_Maquina) REFERENCES MAQUINAS(ID_Maquina)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ID_Empleado_Responsable) REFERENCES EMPLEADOS(ID_Empleado)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE INCIDENCIAS (
  ID_Incidencia INT PRIMARY KEY,
  ID_Cliente INT,
  ID_Maquina INT,
  Fecha_Incidencia DATE,
  Descripcion TEXT,
  Estado VARCHAR(50),
  Prioridad VARCHAR(20),
  FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente)
    ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (ID_Maquina) REFERENCES MAQUINAS(ID_Maquina)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE DOCUMENTACION_TECNICA (
  ID_Documento INT PRIMARY KEY,
  ID_Proyecto INT,
  ID_Maquina INT,
  Tipo_Documento VARCHAR(50),
  Version VARCHAR(20),
  Fecha_Creacion DATE,
  Ubicacion_Archivo VARCHAR(255),
  FOREIGN KEY (ID_Proyecto) REFERENCES PROYECTOS(ID_Proyecto)
    ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (ID_Maquina) REFERENCES MAQUINAS(ID_Maquina)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE PRESUPUESTOS (
  ID_Presupuesto INT PRIMARY KEY,
  ID_Cliente INT,
  Fecha_Emision DATE,
  Validez DATE,
  Estado VARCHAR(50),
  Monto_Total DECIMAL(10,2),
  FOREIGN KEY (ID_Cliente) REFERENCES CLIENTES(ID_Cliente)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE FACTURAS (
  ID_Factura INT PRIMARY KEY,
  ID_Proyecto INT,
  Fecha_Emision DATE,
  Fecha_Vencimiento DATE,
  Estado_Pago VARCHAR(50),
  Monto_Total DECIMAL(10,2),
  FOREIGN KEY (ID_Proyecto) REFERENCES PROYECTOS(ID_Proyecto)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE PROVEEDORES (
  ID_Proveedor INT PRIMARY KEY,
  Nombre_Empresa VARCHAR(100),
  CIF VARCHAR(20),
  Dirección VARCHAR(200),
  Teléfono VARCHAR(20),
  Email VARCHAR(100),
  Persona_Contacto VARCHAR(100)
);

CREATE TABLE PEDIDOS (
  ID_Pedido INT PRIMARY KEY,
  ID_Proveedor INT,
  Fecha_Pedido DATE,
  Estado VARCHAR(50),
  Fecha_Entrega_Prevista DATE,
  Fecha_Entrega_Real DATE,
  Monto_Total DECIMAL(10,2),
  Numero_Factura_Proveedor VARCHAR(50),
  FOREIGN KEY (ID_Proveedor) REFERENCES PROVEEDORES(ID_Proveedor)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE PEDIDOS_COMPONENTES (
  ID_Pedido INT,
  ID_Componente INT,
  Cantidad INT,
  Precio_Unitario DECIMAL(10,2),
  Estado_Linea VARCHAR(50),
  PRIMARY KEY (ID_Pedido, ID_Componente),
  FOREIGN KEY (ID_Pedido) REFERENCES PEDIDOS(ID_Pedido)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ID_Componente) REFERENCES COMPONENTES(ID_Componente)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GARANTIAS (
  ID_Garantia INT PRIMARY KEY,
  ID_Maquina INT,
  Fecha_Inicio DATE,
  Fecha_Fin DATE,
  Condiciones TEXT,
  Estado VARCHAR(50),
  FOREIGN KEY (ID_Maquina) REFERENCES MAQUINAS(ID_Maquina)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FORMACIONES (
  ID_Formacion INT PRIMARY KEY,
  Nombre_Curso VARCHAR(100),
  Fecha_Inicio DATE,
  Fecha_Fin DATE,
  Instructor VARCHAR(100),
  Tipo_Formacion VARCHAR(50)
);

CREATE TABLE EMPLEADOS_FORMACION (
  ID_Empleado INT,
  ID_Formacion INT,
  Fecha_Completado DATE,
  Calificacion VARCHAR(20),
  PRIMARY KEY (ID_Empleado, ID_Formacion),
  FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADOS(ID_Empleado)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (ID_Formacion) REFERENCES FORMACIONES(ID_Formacion)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE CERTIFICACIONES (
  ID_Certificacion INT PRIMARY KEY,
  ID_Empleado INT,
  Nombre VARCHAR(100),
  Fecha_Emision DATE,
  Fecha_Vencimiento DATE,
  Entidad_Emisora VARCHAR(100),
  Estado VARCHAR(50),
  FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADOS(ID_Empleado)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE HORARIOS_SERVICIO_TECNICO (
  ID_Horario INT PRIMARY KEY,
  ID_Empleado INT,
  Fecha DATE,
  Turno VARCHAR(20),
  Disponibilidad VARCHAR(50),
  FOREIGN KEY (ID_Empleado) REFERENCES EMPLEADOS(ID_Empleado)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO CLIENTES (ID_Cliente, Nombre_Empresa, CIF, Dirección, Teléfono, Email, Persona_Contacto) VALUES
(1, 'Empresa 1', 'A00000001', 'Rúa Exemplo 1, Cidade', '+34 612345678', 'contacto1@empresa.com', 'Persoa 1'),
(2, 'Empresa 2', 'A00000002', 'Rúa Exemplo 2, Cidade', '+34 623456789', 'contacto2@empresa.com', 'Persoa 2'),
(3, 'Empresa 3', 'A00000003', 'Rúa Exemplo 3, Cidade', '+34 634567890', 'contacto3@empresa.com', 'Persoa 3'),
(4, 'Empresa 4', 'A00000004', 'Rúa Exemplo 4, Cidade', '+34 645678901', 'contacto4@empresa.com', 'Persoa 4'),
(5, 'Empresa 5', 'A00000005', 'Rúa Exemplo 5, Cidade', '+34 656789012', 'contacto5@empresa.com', 'Persoa 5');

INSERT INTO EMPLEADOS (ID_Empleado, Nombre, Apellidos, DNI, Especialidad, Teléfono, Email, Fecha_Contratación) VALUES
(1, 'Empregado1', 'Apelido1', '12345678X', 'Electrónica', '+34 600111222', 'empregado1@empresa.com', '2019-03-15'),
(2, 'Empregado2', 'Apelido2', '23456789Y', 'Mecánica', '+34 600222333', 'empregado2@empresa.com', '2018-07-10'),
(3, 'Empregado3', 'Apelido3', '34567890Z', 'Programación', '+34 600333444', 'empregado3@empresa.com', '2020-11-01'),
(4, 'Empregado4', 'Apelido4', '45678901W', 'Robótica', '+34 600444555', 'empregado4@empresa.com', '2021-02-20'),
(5, 'Empregado5', 'Apelido5', '56789012V', 'Electrónica', '+34 600555666', 'empregado5@empresa.com', '2022-09-05');

INSERT INTO PROVEEDORES (ID_Proveedor, Nombre_Empresa, CIF, Dirección, Teléfono, Email, Persona_Contacto) VALUES
(1, 'Proveedor 1', 'P0000001', 'Rúa Proveedor 1', '+34 912345678', 'contacto@proveedor1.com', 'Contacto 1'),
(2, 'Proveedor 2', 'P0000002', 'Rúa Proveedor 2', '+34 923456789', 'contacto@proveedor2.com', 'Contacto 2');

INSERT INTO COMPONENTES (ID_Componente, Nombre, Descripción, Stock, Precio_Unitario, Stock_Mínimo, Stock_Máximo, ID_Proveedor_Principal) VALUES
(1, 'Componente A', 'Componente para control', 50, 25.50, 10, 100, 1),
(2, 'Componente B', 'Componente eléctrico', 30, 12.75, 5, 50, 2);

INSERT INTO MÁQUINAS (ID_Máquina, ID_Cliente, Tipo_Máquina, Modelo, Fecha_Instalación, Estado) VALUES
(1, 1, 'Robot Industrial', 'Model X', '2023-01-15', 'Operativa'),
(2, 2, 'CNC', 'Model Y', '2022-11-10', 'Mantenimiento');

INSERT INTO PROYECTOS (ID_Proyecto, ID_Cliente, Nombre_Proyecto, Fecha_Inicio, Fecha_Fin_Prevista, Fecha_Fin_Real, Estado, Presupuesto, Descripción) VALUES
(1, 1, 'Automatización Línea 1', '2024-01-10', '2024-06-10', NULL, 'En Progreso', 15000.00, 'Proyecto de instalación de robots en línea 1'),
(2, 2, 'Actualización Máquina CNC', '2023-09-05', '2024-03-01', '2024-02-28', 'Finalizado', 8000.00, 'Actualización de software y hardware CNC');

INSERT INTO EMPLEADOS_PROYECTO (ID_Empleado, ID_Proyecto, Fecha_Asignación, Rol_Proyecto, Horas_Asignadas) VALUES
(1, 1, '2024-01-15', 'Jefe de Proyecto', 120),
(2, 1, '2024-02-01', 'Técnico', 100),
(3, 2, '2023-09-10', 'Programador', 90);

INSERT INTO MANTENIMIENTOS (ID_Mantenimiento, ID_Máquina, ID_Empleado_Responsable, Fecha_Mantenimiento, Tipo, Descripción, Estado) VALUES
(1, 1, 1, '2024-03-15', 'Preventivo', 'Revisión trimestral del robot', 'Realizado'),
(2, 2, 2, '2024-04-01', 'Correctivo', 'Reparación de fallo en eje', 'Pendiente');

INSERT INTO INCIDENCIAS (ID_Incidencia, ID_Cliente, ID_Máquina, Fecha_Incidencia, Descripción, Estado, Prioridad) VALUES
(1, 1, 1, '2024-04-10', 'Fallo no sistema de control', 'Abierta', 'Alta'),
(2, 2, 2, '2024-04-12', 'Problema coa alimentación eléctrica', 'Cerrada', 'Media');

INSERT INTO DOCUMENTACIÓN_TÉCNICA (ID_Documento, ID_Proyecto, ID_Máquina, Tipo_Documento, Versión, Fecha_Creación, Ubicación_Archivo) VALUES
(1, 1, 1, 'Manual Técnico', 'v1.0', '2024-01-05', '/docs/manual_robot_x.pdf'),
(2, 2, 2, 'Plano Mecánico', 'v2.1', '2023-08-20', '/docs/plano_cnc_y.pdf');

INSERT INTO PRESUPUESTOS (ID_Presupuesto, ID_Cliente, Fecha_Emisión, Validez, Estado, Monto_Total) VALUES
(1, 1, '2023-12-01', '2024-03-01', 'Aprobado', 15000.00),
(2, 2, '2023-08-15', '2023-11-15', 'Rechazado', 8000.00);

INSERT INTO FACTURAS (ID_Factura, ID_Proyecto, Fecha_Emisión, Fecha_Vencimiento, Estado_Pago, Monto_Total) VALUES
(1, 1, '2024-03-01', '2024-04-01', 'Pagada', 15000.00),
(2, 2, '2024-01-15', '2024-02-15', 'Pendiente', 8000.00);

INSERT INTO PEDIDOS (ID_Pedido, ID_Proveedor, Fecha_Pedido, Estado, Fecha_Entrega_Prevista, Fecha_Entrega_Real, Monto_Total, Número_Factura_Proveedor) VALUES
(1, 1, '2024-03-20', 'Entregado', '2024-04-05', '2024-04-04', 1275.00, 'F2024-001'),
(2, 2, '2024-04-01', 'En Proceso', '2024-04-20', NULL, 650.00, 'F2024-002');

INSERT INTO PEDIDOS_COMPONENTES (ID_Pedido, ID_Componente, Cantidad, Precio_Unitario, Estado_Línea) VALUES
(1, 1, 50, 25.50, 'Recibido'),
(2, 2, 30, 12.75, 'Pendiente');

INSERT INTO GARANTIAS (ID_Garantía, ID_Máquina, Fecha_Inicio, Fecha_Fin, Condiciones, Estado) VALUES
(1, 1, '2023-01-15', '2025-01-14', 'Garantía completa por dos anos', 'Activa'),
(2, 2, '2022-11-10', '2024-11-09', 'Garantía limitada por piezas', 'Expirada');

INSERT INTO FORMACIONES (ID_Formacion, Nombre_Curso, Fecha_Inicio, Fecha_Fin, Instructor, Tipo_Formacion) VALUES
(1, 'Formación en Robótica Industrial', '2023-09-01', '2023-09-15', 'Ing. Pérez', 'Técnica'),
(2, 'Seguridad en el Trabajo', '2024-01-10', '2024-01-20', 'Dr. López', 'Seguridad');

INSERT INTO EMPLEADOS_FORMACION (ID_Empleado, ID_Formacion, Fecha_Completado, Calificación) VALUES
(1, 1, '2023-09-15', 'Aprobado'),
(2, 2, '2024-01-20', 'Sobresaliente');

INSERT INTO CERTIFICACIONES (ID_Certificacion, ID_Empleado, Nombre, Fecha_Emisión, Fecha_Vencimiento, Entidad_Emisora, Estado) VALUES
(1, 1, 'Certificación de Programación PLC', '2023-06-01', '2026-06-01', 'Entidad Certificadora A', 'Vigente'),
(2, 2, 'Certificación en Mantenimiento Industrial', '2022-11-15', '2025-11-15', 'Entidad Certificadora B', 'Vigente');

INSERT INTO HORARIOS_SERVICIO_TÉCNICO (ID_Horario, ID_Empleado, Fecha, Turno, Disponibilidad) VALUES
(1, 1, '2024-05-01', 'Mañana', 'Disponible'),
(2, 2, '2024-05-01', 'Tarde', 'No Disponible');








