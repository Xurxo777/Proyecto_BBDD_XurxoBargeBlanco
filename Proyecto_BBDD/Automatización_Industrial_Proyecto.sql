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

-- Inserción de clientes: almacena datos básicos das empresas clientes da empresa de automatización, incluíndo contacto e dirección.

INSERT INTO CLIENTES (ID_Cliente, Nombre_Empresa, CIF, Direccion, Telefono, Email, Persona_Contacto) VALUES
(1, 'Empresa 1', 'A00000001', 'Rúa Exemplo 1, Cidade', '+34 612345678', 'contacto1@empresa.com', 'Persoa 1'),
(2, 'Empresa 2', 'A00000002', 'Rúa Exemplo 2, Cidade', '+34 623456789', 'contacto2@empresa.com', 'Persoa 2'),
(3, 'Empresa 3', 'A00000003', 'Rúa Exemplo 3, Cidade', '+34 634567890', 'contacto3@empresa.com', 'Persoa 3'),
(4, 'Empresa 4', 'A00000004', 'Rúa Exemplo 4, Cidade', '+34 645678901', 'contacto4@empresa.com', 'Persoa 4'),
(5, 'Empresa 5', 'A00000005', 'Rúa Exemplo 5, Cidade', '+34 656789012', 'contacto5@empresa.com', 'Persoa 5'),
(6, 'Empresa 6', 'A00000006', 'Rúa Exemplo 6, Cidade', '+34 656789045', 'contacto6@empresa.com', 'Persoa 6'),
(7, 'Empresa 7', 'A00000007', 'Rúa Exemplo 7, Cidade', '+34 667890123', 'contacto7@empresa.com', 'Persoa 7'),
(8, 'Empresa 8', 'A00000008', 'Rúa Exemplo 8, Cidade', '+34 678901234', 'contacto8@empresa.com', 'Persoa 8');

-- Inserción de empregados: información dos empregados da empresa, co seu DNI, especialidade, datos de contacto e data de contratación.

INSERT INTO EMPLEADOS (ID_Empleado, Nombre, Apellidos, DNI, Especialidad, Telefono, Email, Fecha_Contratacion) VALUES
(1, 'Empregado1', 'Apelido1', '12345678X', 'Electrónica', '+34 600111222', 'empregado1@empresa.com', '2019-03-15'),
(2, 'Empregado2', 'Apelido2', '23456789Y', 'Mecánica', '+34 600222333', 'empregado2@empresa.com', '2018-07-10'),
(3, 'Empregado3', 'Apelido3', '34567890Z', 'Programación', '+34 600333444', 'empregado3@empresa.com', '2020-11-01'),
(4, 'Empregado4', 'Apelido4', '45678901W', 'Robótica', '+34 600444555', 'empregado4@empresa.com', '2021-02-20'),
(5, 'Empregado5', 'Apelido5', '56789012V', 'Electrónica', '+34 600555666', 'empregado5@empresa.com', '2022-09-05'),
(6, 'Empregado6', 'Apelido6', '56789012M', 'Gestión', '+34 600545666', 'empregado6@empresa.com', '2027-06-02'),
(7, 'Empregado7', 'Apelido7', '67890123N', 'Automatización', '+34 600666777', 'empregado7@empresa.com', '2023-05-10'),
(8, 'Empregado8', 'Apelido8', '78901234P', 'Electrónica', '+34 600777888', 'empregado8@empresa.com', '2020-10-01');

-- Inserción de provedores: empresas que proveen compoñentes ou servizos, cos seus datos de contacto e persoas de referencia.

INSERT INTO PROVEEDORES (ID_Proveedor, Nombre_Empresa, CIF, Dirección, Teléfono, Email, Persona_Contacto) VALUES
(1, 'Proveedor 1', 'P0000001', 'Rúa Proveedor 1', '+34 912345678', 'contacto@proveedor1.com', 'Contacto 1'),
(2, 'Proveedor 2', 'P0000002', 'Rúa Proveedor 2', '+34 923456789', 'contacto@proveedor2.com', 'Contacto 2'),
(3, 'Proveedor 3', 'P0000003', 'Rúa Proveedor 3', '+34 934567890', 'contacto@proveedor3.com', 'Contacto 3'),
(4, 'Proveedor 4', 'P0000004', 'Rúa Proveedor 4', '+34 945678901', 'contacto@proveedor4.com', 'Contacto 4'),
(5, 'Proveedor 5', 'P0000005', 'Rúa Proveedor 5', '+34 956789012', 'contacto@proveedor5.com', 'Contacto 5');

-- Inserción de compoñentes: detalles dos compoñentes dispoñibles en stock, prezo, stock mínimo/máximo e provedores principais.

INSERT INTO COMPONENTES (ID_Componente, Nombre, Descripcion, Stock, Precio_Unitario, Stock_Minimo, Stock_Maximo, ID_Proveedor_Principal) VALUES
(1, 'Componente A', 'Componente para control', 50, 25.50, 10, 100, 1),
(2, 'Componente B', 'Componente eléctrico', 30, 12.75, 5, 50, 2),
(3, 'Componente C', 'Sensor de temperatura', 40, 15.90, 10, 80, 3),
(4, 'Componente D', 'Relé de control industrial', 20, 9.80, 5, 40, 1),
(5, 'Componente E', 'Motor paso a paso', 15, 45.00, 3, 20, 4),
(6, 'Componente F', 'Pantalla HMI 7"', 10, 120.00, 2, 15, 5),
(7, 'Componente G', 'Variador de frecuencia', 8, 220.50, 2, 10, 3),
(8, 'Componente H', 'Interruptor de fin de carreira', 25, 6.50, 5, 30, 2),
(9, 'Componente I', 'Placa Arduino Mega', 35, 32.00, 10, 50, 4),
(10, 'Componente J', 'Módulo Wi-Fi ESP32', 60, 8.25, 15, 100, 5),
(11, 'Componente K', 'Fonte de alimentación 24V', 18, 55.30, 5, 25, 1),
(12, 'Componente L', 'Encoder rotativo óptico', 12, 27.80, 3, 20, 2);

-- Inserción de máquinas: máquinas instaladas nos clientes, co tipo, modelo, data de instalación e estado operativo.

INSERT INTO MAQUINAS (ID_Maquina, ID_Cliente, Tipo_Maquina, Modelo, Fecha_Instalacion, Estado) VALUES
(1, 1, 'Robot Industrial', 'Model X', '2023-01-15', 'Operativa'),
(2, 2, 'CNC', 'Model Y', '2022-11-10', 'Mantenimiento'),
(3, 3, 'Impresora 3D', 'Delta Pro', '2023-05-22', 'Operativa'),
(4, 1, 'PLC Siemens', 'S7-1200', '2021-09-30', 'Operativa'),
(5, 4, 'Brazo Robótico', 'UR5e', '2022-02-14', 'Mantenimiento'),
(6, 5, 'Sistema SCADA', 'WinCC Advanced', '2023-08-01', 'Operativa'),
(7, 2, 'Fresadora CNC', 'Model Z', '2020-12-20', 'Averiada'),
(8, 3, 'Robot Colaborativo', 'Cobot A1', '2024-01-10', 'Operativa'),
(9, 4, 'Controlador PID', 'Omron E5CC', '2022-06-18', 'Mantenimiento'),
(10, 5, 'Sistema de Visión', 'Cognex In-Sight', '2023-03-03', 'Operativa');

-- Inserción de proxectos: proxectos que a empresa está a levar a cabo para os clientes, con datas, estado, orzamento e descrición.

INSERT INTO PROYECTOS (ID_Proyecto, ID_Cliente, Nombre_Proyecto, Fecha_Inicio, Fecha_Fin_Prevista, Fecha_Fin_Real, Estado, Presupuesto, Descripcion) VALUES
(1, 1, 'Automatización Línea 1', '2024-01-10', '2024-06-10', NULL, 'En Progreso', 15000.00, 'Proyecto de instalación de robots en línea 1'),
(2, 2, 'Actualización Máquina CNC', '2023-09-05', '2024-03-01', '2024-02-28', 'Finalizado', 8000.00, 'Actualización de software y hardware CNC'),
(3, 3, 'Integración SCADA', '2024-02-01', '2024-07-01', NULL, 'En Progreso', 12000.00, 'Integración de SCADA en planta de produción'),
(4, 4, 'Instalación Brazo Robótico', '2023-06-15', '2023-12-15', '2023-12-20', 'Finalizado', 9500.00, 'Instalación e posta en marcha de robot colaborativo');

-- Relación entre empregados e proxectos: asignación de empregados a proxectos con datas, rol e horas asignadas.

INSERT INTO EMPLEADOS_PROYECTO (ID_Empleado, ID_Proyecto, Fecha_Asignacion, Rol_Proyecto, Horas_Asignadas) VALUES
(1, 1, '2024-01-15', 'Jefe de Proyecto', 120),
(2, 1, '2024-02-01', 'Técnico', 100),
(3, 2, '2023-09-10', 'Programador', 90),
(4, 3, '2024-02-05', 'Programador', 100),
(5, 4, '2023-06-20', 'Instalador', 80);

-- Mantementos realizados ou pendentes sobre máquinas, indicando quen é responsable, tipo, data e estado.

INSERT INTO MANTENIMIENTOS (ID_Mantenimiento, ID_Maquina, ID_Empleado_Responsable, Fecha_Mantenimiento, Tipo, Descripcion, Estado) VALUES
(1, 1, 1, '2024-03-15', 'Preventivo', 'Revisión trimestral del robot', 'Realizado'),
(2, 2, 2, '2024-04-01', 'Correctivo', 'Reparación de fallo en eje', 'Pendiente'),
(3, 5, 5, '2024-05-10', 'Correctivo', 'Substitución de pezas desgastadas', 'Realizado'),
(4, 6, 6, '2024-05-18', 'Preventivo', 'Revisión mensual sistema SCADA', 'Pendiente');

-- Incidencias rexistradas para clientes e máquinas, con data, descrición, estado e prioridade.

INSERT INTO INCIDENCIAS (ID_Incidencia, ID_Cliente, ID_Maquina, Fecha_Incidencia, Descripcion, Estado, Prioridad) VALUES
(1, 1, 1, '2024-04-10', 'Fallo no sistema de control', 'Abierta', 'Alta'),
(2, 2, 2, '2024-04-12', 'Problema coa alimentación eléctrica', 'Cerrada', 'Media'),
(3, 3, 3, '2024-05-15', 'Problemas de calibrado', 'Abierta', 'Media'),
(4, 5, 6, '2024-05-19', 'Erro de conexión coa rede', 'Abierta', 'Alta');

-- Documentación técnica asociada a proxectos e máquinas, incluíndo tipo de documento, versión, data e ubicación do arquivo.

INSERT INTO DOCUMENTACION_TECNICA (ID_Documento, ID_Proyecto, ID_Maquina, Tipo_Documento, Version, Fecha_Creacion, Ubicacion_Archivo) VALUES
(1, 1, 1, 'Manual Técnico', 'v1.0', '2024-01-05', '/docs/manual_robot_x.pdf'),
(2, 2, 2, 'Plano Mecánico', 'v2.1', '2023-08-20', '/docs/plano_cnc_y.pdf'),
(3, 3, 6, 'Manual SCADA', 'v1.1', '2024-02-05', '/docs/manual_scada.pdf'),
(4, 4, 5, 'Esquema Eléctrico', 'v3.0', '2023-06-16', '/docs/esquema_robot.pdf');

-- Presupostos emitidos a clientes, con data, validez, estado (aprobado, rexeitado) e importe total.

INSERT INTO PRESUPUESTOS (ID_Presupuesto, ID_Cliente, Fecha_Emision, Validez, Estado, Monto_Total) VALUES
(1, 1, '2023-12-01', '2024-03-01', 'Aprobado', 15000.00),
(2, 2, '2023-08-15', '2023-11-15', 'Rechazado', 8000.00);

-- Facturas xeradas por proxectos, con datas de emisión e vencemento, estado do pago e importe.

INSERT INTO FACTURAS (ID_Factura, ID_Proyecto, Fecha_Emision, Fecha_Vencimiento, Estado_Pago, Monto_Total) VALUES
(1, 1, '2024-03-01', '2024-04-01', 'Pagada', 15000.00),
(2, 2, '2024-01-15', '2024-02-15', 'Pendiente', 8000.00),
(3, 3, '2024-05-10', '2024-06-10', 'Pendiente', 12000.00),
(4, 4, '2023-12-21', '2024-01-21', 'Pagada', 9500.00);

-- Pedidos feitos a provedores, con datas, estado do pedido, datas previstas e reais de entrega, importe total e número de factura do provedor.

INSERT INTO PEDIDOS (ID_Pedido, ID_Proveedor, Fecha_Pedido, Estado, Fecha_Entrega_Prevista, Fecha_Entrega_Real, Monto_Total, Numero_Factura_Proveedor) VALUES
(1, 1, '2024-03-20', 'Entregado', '2024-04-05', '2024-04-04', 1275.00, 'F2024-001'),
(2, 2, '2024-04-01', 'En Proceso', '2024-04-20', NULL, 650.00, 'F2024-002'),
(3, 3, '2024-04-15', 'Entregado', '2024-04-30', '2024-04-29', 330.00, 'F2024-003'),
(4, 4, '2024-05-01', 'Pendiente', '2024-05-20', NULL, 890.00, 'F2024-004');

-- Detalle dos compoñentes incluídos en cada pedido, con cantidade, prezo unitario e estado da liña.

INSERT INTO PEDIDOS_COMPONENTES (ID_Pedido, ID_Componente, Cantidad, Precio_Unitario, Estado_Linea) VALUES
(1, 1, 50, 25.50, 'Recibido'),
(2, 2, 30, 12.75, 'Pendiente'),
(3, 3, 20, 15.90, 'Recibido'),
(4, 4, 10, 9.80, 'Pendiente');

-- Garantías asociadas a máquinas, con datas de inicio e fin, condicións e estado da garantía.

INSERT INTO GARANTIAS (ID_Garantia, ID_Maquina, Fecha_Inicio, Fecha_Fin, Condiciones, Estado) VALUES
(1, 1, '2023-01-15', '2025-01-14', 'Garantía completa por dos anos', 'Activa'),
(2, 2, '2022-11-10', '2024-11-09', 'Garantía limitada por piezas', 'Expirada'),
(3, 3, '2024-01-10', '2026-01-10', 'Completa', 'Inclúe pezas e man de obra'),
(4, 5, '2023-07-01', '2025-07-01', 'Limitada', 'Só pezas principais');

-- Formacións dispoñibles, co nome, datas, instructor e tipo (técnica, seguridade, etc.).

INSERT INTO FORMACIONES (ID_Formacion, Nombre_Curso, Fecha_Inicio, Fecha_Fin, Instructor, Tipo_Formacion) VALUES
(1, 'Formación en Robótica Industrial', '2023-09-01', '2023-09-15', 'Ing. Pérez', 'Técnica'),
(2, 'Seguridad en el Trabajo', '2024-01-10', '2024-01-20', 'Dr. López', 'Seguridad');

-- Relación entre empregados e formacións, indicando data de finalización e calificación obtida.

INSERT INTO EMPLEADOS_FORMACION (ID_Empleado, ID_Formacion, Fecha_Completado, Calificacion) VALUES
(1, 1, '2023-09-15', 'Aprobado'),
(2, 2, '2024-01-20', 'Sobresaliente');

-- Certificacións obtidas polos empregados, con nome, datas de emisión e vencemento, entidade emisora e estado.

INSERT INTO CERTIFICACIONES (ID_Certificacion, ID_Empleado, Nombre, Fecha_Emision, Fecha_Vencimiento, Entidad_Emisora, Estado) VALUES
(1, 1, 'Certificación de Programación PLC', '2023-06-01', '2026-06-01', 'Entidad Certificadora A', 'Vigente'),
(2, 2, 'Certificación en Mantenimiento Industrial', '2022-11-15', '2025-11-15', 'Entidad Certificadora B', 'Vigente');

-- Horarios asignados aos empregados para o servizo técnico, con datas, turno e dispoñibilidade.

INSERT INTO HORARIOS_SERVICIO_TECNICO (ID_Horario, ID_Empleado, Fecha, Turno, Disponibilidad) VALUES
(1, 1, '2024-05-01', 'Mañana', 'Disponible'),
(2, 2, '2024-05-01', 'Tarde', 'No Disponible');

INSERT INTO COMPONENTES_MAQUINA (ID_Componente, ID_Maquina, Cantidad, Fecha_Instalacion) VALUES
(1, 1, 4, '2023-01-15'),   -- Componente A no Robot Industrial Model X
(2, 2, 6, '2022-11-10'),   -- Componente B na CNC Model Y
(3, 3, 2, '2023-05-22'),   -- Componente C na Impresora 3D Delta Pro
(4, 4, 3, '2021-09-30'),   -- Componente D no PLC Siemens S7-1200
(5, 5, 1, '2022-02-14'),   -- Componente E no Brazo Robótico UR5e
(6, 6, 1, '2023-08-01'),   -- Componente F no Sistema SCADA WinCC Advanced
(7, 7, 2, '2020-12-20'),   -- Componente G na Fresadora CNC Model Z
(8, 8, 5, '2024-01-10'),   -- Componente H no Robot Colaborativo Cobot A1
(9, 9, 2, '2022-06-18'),   -- Componente I no Controlador PID Omron E5CC
(10, 10, 3, '2023-03-03'), -- Componente J no Sistema de Visión Cognex In-Sight
(11, 1, 1, '2023-01-15'),  -- Componente K tamén no Robot Industrial Model X
(12, 2, 1, '2022-11-10');  -- Componente L tamén na CNC Model Y







