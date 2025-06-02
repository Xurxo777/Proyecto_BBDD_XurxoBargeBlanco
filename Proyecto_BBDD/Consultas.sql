use AUTOMATIZACION_INDUSTRIAL;

-- 1. Clientes con número de proxectos

SELECT c.ID_Cliente, c.Nombre_Empresa, COUNT(p.ID_Proyecto) AS Total_Proyectos
FROM CLIENTES c
JOIN PROYECTOS p ON c.ID_Cliente = p.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre_Empresa;

-- 2. Empregados con máis de 3 proxectos asignados

SELECT e.ID_Empleado, e.Nombre, e.Apellidos, COUNT(ep.ID_Proyecto) AS Proyectos_Asignados
FROM EMPLEADOS e
JOIN EMPLEADOS_PROYECTO ep ON e.ID_Empleado = ep.ID_Empleado
GROUP BY e.ID_Empleado, e.Nombre, e.Apellidos
HAVING COUNT(ep.ID_Proyecto) > 3;

-- 3. Proxectos que acabaron despois da data prevista

SELECT ID_Proyecto, Nombre_Proyecto, Fecha_Fin_Prevista, Fecha_Fin_Real
FROM PROYECTOS
WHERE Fecha_Fin_Real > Fecha_Fin_Prevista;

-- 4. Facturas pendentes de pago por cliente

SELECT c.Nombre_Empresa, SUM(f.Monto_Total) AS Total_Pendiente
FROM FACTURAS f
JOIN PROYECTOS p ON f.ID_Proyecto = p.ID_Proyecto
JOIN CLIENTES c ON p.ID_Cliente = c.ID_Cliente
WHERE f.Estado_Pago <> 'Pagado'
GROUP BY c.Nombre_Empresa;

-- 5. Subconsulta correlacionada: Clientes que teñen máquinas con máis dunha incidencia rexistrada

SELECT c.Nombre_Empresa
FROM CLIENTES c
WHERE EXISTS (
  SELECT 1
  FROM MAQUINAS m
  JOIN INCIDENCIAS i ON i.ID_Maquina = m.ID_Maquina
  WHERE m.ID_Cliente = c.ID_Cliente
  GROUP BY m.ID_Maquina
  HAVING COUNT(i.ID_Incidencia) > 1
);

-- 6. Mellores provedores segundo total de pedidos

SELECT pr.Nombre_Empresa, COUNT(p.ID_Pedido) AS Total_Pedidos, SUM(p.Monto_Total) AS Total_Comprado
FROM PROVEEDORES pr
JOIN PEDIDOS p ON pr.ID_Proveedor = p.ID_Proveedor
GROUP BY pr.Nombre_Empresa
ORDER BY Total_Comprado DESC;

-- 7. Horas totais asignadas por proxecto

SELECT p.Nombre_Proyecto, SUM(ep.Horas_Asignadas) AS Total_Horas
FROM PROYECTOS p
JOIN EMPLEADOS_PROYECTO ep ON p.ID_Proyecto = ep.ID_Proyecto
GROUP BY p.Nombre_Proyecto;

-- 8. Componentes con stock por debaixo do mínimo

SELECT ID_Componente, Nombre, Stock, Stock_Minimo
FROM COMPONENTES
WHERE Stock < Stock_Minimo;

-- 9. Proxectos cun custo en facturas superior ao seu presuposto

SELECT p.ID_Proyecto, p.Nombre_Proyecto, p.Presupuesto, SUM(f.Monto_Total) AS Total_Facturado
FROM PROYECTOS p
JOIN FACTURAS f ON p.ID_Proyecto = f.ID_Proyecto
GROUP BY p.ID_Proyecto, p.Nombre_Proyecto, p.Presupuesto
HAVING SUM(f.Monto_Total) > p.Presupuesto;

-- 10. Número de mantementos por tipo de máquina

SELECT m.Tipo_Maquina, COUNT(mt.ID_Mantenimiento) AS Total_Mantenimientos
FROM MAQUINAS m
JOIN MANTENIMIENTOS mt ON m.ID_Maquina = mt.ID_Maquina
GROUP BY m.Tipo_Maquina;

-- 11. Clientes sen proxectos rexistrados

SELECT c.ID_Cliente, c.Nombre_Empresa
FROM CLIENTES c
LEFT JOIN PROYECTOS p ON c.ID_Cliente = p.ID_Cliente
WHERE p.ID_Proyecto IS NULL;

-- 12. Empregados sen formación completada

SELECT e.ID_Empleado, e.Nombre, e.Apellidos
FROM EMPLEADOS e
LEFT JOIN EMPLEADOS_FORMACION ef ON e.ID_Empleado = ef.ID_Empleado
WHERE ef.ID_Formacion IS NULL;

-- 13. Facturas vencidas sen pagar

SELECT f.ID_Factura, f.Fecha_Vencimiento, f.Monto_Total, p.Nombre_Proyecto
FROM FACTURAS f
JOIN PROYECTOS p ON f.ID_Proyecto = p.ID_Proyecto
WHERE f.Estado_Pago <> 'Pagado'
AND f.Fecha_Vencimiento < CURDATE();
  
-- 14. Proxectos sen documentación técnica asignada

SELECT p.ID_Proyecto, p.Nombre_Proyecto
FROM PROYECTOS p
LEFT JOIN DOCUMENTACION_TECNICA d ON p.ID_Proyecto = d.ID_Proyecto
WHERE d.ID_Documento IS NULL;

-- 15. Máquinas con garantía activa hoxe

SELECT m.ID_Maquina, m.Modelo, g.Fecha_Inicio, g.Fecha_Fin
FROM MAQUINAS m
JOIN GARANTIAS g ON m.ID_Maquina = g.ID_Maquina
WHERE CURDATE() BETWEEN g.Fecha_Inicio AND g.Fecha_Fin;
