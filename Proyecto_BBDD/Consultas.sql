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

