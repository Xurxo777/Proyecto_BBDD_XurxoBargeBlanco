
-- Proveedor
INSERT INTO PROVEEDORES VALUES (1, 'Proveedora Técnica S.A.', 'A11111111', 'Rúa dos Provedores, 45', '981123456', 'contacto@provetec.com', 'Manuel Castro');

-- Compoñente
INSERT INTO COMPONENTES VALUES (10, 'Sensor de temperatura', 'Sensor analóxico 4-20mA', 100, 15.00, 20, 200, 1);

-- Pedido
INSERT INTO PEDIDOS VALUES (1, 1, '2025-05-10', 'Solicitado', '2025-05-20', NULL, 1500.00, 'F123-987');

-- Pedido de compoñente
INSERT INTO PEDIDOS_COMPONENTES VALUES (1, 10, 100, 15.00, 'Pendiente');

-- Máquina
INSERT INTO MAQUINAS VALUES (50, 100, 'PLC', 'Siemens S7-1500', '2025-04-01', 'Operativa');

-- Compoñente instalado na máquina
INSERT INTO COMPONENTES_MAQUINA VALUES (10, 50, 2, '2025-04-02');

-- Máquina 999 non existe
INSERT INTO COMPONENTES_MAQUINA VALUES (10, 999, 2, '2025-04-02');
-- Resultado: ERRO por FK

INSERT INTO MANTENIMIENTOS VALUES (1, 50, 300, '2025-05-15', 'Preventivo', 'Revisión anual', 'Completado');

-- Curso
INSERT INTO FORMACIONES VALUES (1, 'Curso PLC avanzado', '2025-01-15', '2025-02-15', 'Xosé López', 'Presencial');

-- Asistencia do empregado
INSERT INTO EMPLEADOS_FORMACION VALUES (300, 1, '2025-02-16', 'Aprobado');

INSERT INTO CERTIFICACIONES VALUES (1, 300, 'Certificación Siemens TIA', '2025-03-01', '2028-03-01', 'Siemens', 'Vixente');

-- Repetimos a mesma entrada en EMPLEADOS_FORMACION
INSERT INTO EMPLEADOS_FORMACION VALUES (300, 1, '2025-02-16', 'Aprobado');
-- ERRO por PK duplicada (ID_Empleado + ID_Formacion)

-- Carlos ten mantementos asignados
DELETE FROM EMPLEADOS WHERE ID_Empleado = 300;
-- Esperado: En MANTENIMIENTOS, o campo ID_Empleado_Responsable pasa a NULL

-- Inserción de incidencia:
INSERT INTO INCIDENCIAS VALUES (1, 100, 50, '2025-05-20', 'Avería na comunicación Modbus', 'Aberta', 'Alta');

-- Cliente 999 non existe
INSERT INTO INCIDENCIAS VALUES (2, 999, 50, '2025-05-21', 'Proba con erro', 'Aberta', 'Media');
-- ERRO por FK

