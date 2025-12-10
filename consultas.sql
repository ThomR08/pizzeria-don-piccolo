USE pizzeria_don_piccolo;

-- -----------------------------------------------------
-- 1) Clientes con pedidos entre dos fechas (BETWEEN)
-- -----------------------------------------------------
-- Parámetros de ejemplo: '2025-01-10' y '2025-01-15'
SELECT
    per.nombre AS cliente,
    pe.id AS pedido_id,
    pe.fecha_hora,
    pe.total
FROM pedido pe
JOIN cliente c ON pe.cliente_fk = c.id
JOIN persona per ON per.id = c.id
WHERE DATE(pe.fecha_hora) BETWEEN '2025-01-10' AND '2025-01-15'
ORDER BY pe.fecha_hora;


-- -----------------------------------------------------
-- 2) Pizzas más vendidas (GROUP BY y COUNT)
-- -----------------------------------------------------
SELECT
    p.nombre,
    SUM(dp.cantidad) AS total_vendidos
FROM detalle_pedido dp
JOIN pizza p ON p.id = dp.pizza_fk
GROUP BY p.id, p.nombre
ORDER BY total_vendidos DESC;


-- -----------------------------------------------------
-- 3) Pedidos por repartidor (JOIN)
-- -----------------------------------------------------
SELECT
    per.nombre AS repartidor,
    d.id AS domicilio_id,
    d.pedido_fk,
    d.hora_salida,
    d.hora_entrega,
    d.direccion
FROM domicilio d
LEFT JOIN repartidor r ON r.id = d.repartidor_fk
LEFT JOIN persona per ON per.id = r.id
ORDER BY per.nombre, d.hora_salida;


-- -----------------------------------------------------
-- 4) Promedio de entrega por zona (AVG y JOIN)
-- -----------------------------------------------------
SELECT
    z.nombre AS zona,
    COUNT(d.id) AS entregas,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos
FROM domicilio d
JOIN repartidor r ON r.id = d.repartidor_fk
JOIN zona z ON z.id = r.zona_fk
WHERE d.hora_entrega IS NOT NULL
GROUP BY z.id, z.nombre
ORDER BY promedio_minutos;


-- -----------------------------------------------------
-- 5) Clientes que gastaron más de un monto (HAVING)
-- -----------------------------------------------------
-- Ejemplo: clientes que gastaron más de 100000 en total
SELECT
    per.nombre AS cliente,
    SUM(pe.total) AS total_gastado
FROM cliente c
JOIN persona per ON per.id = c.id
JOIN pedido pe ON pe.cliente_fk = c.id
GROUP BY per.id, per.nombre
HAVING SUM(pe.total) > 100000;


-- -----------------------------------------------------
-- 6) Búsqueda por coincidencia parcial de nombre de pizza (LIKE)
-- -----------------------------------------------------
-- Ejemplo: buscar pizzas que contengan 'pollo'
SELECT * FROM pizza
WHERE nombre LIKE '%pollo%';


-- -----------------------------------------------------
-- 7) Subconsulta: clientes frecuentes (>5 pedidos mensuales)
-- -----------------------------------------------------
-- Esto muestra clientes que en algún mes tuvieron más de 5 pedidos.
SELECT
    per.nombre,
    sub.mes_anyo,
    sub.pedidos_en_mes
FROM (
    SELECT
        pe.cliente_fk,
        DATE_FORMAT(pe.fecha_hora, '%Y-%m') AS mes_anyo,
        COUNT(*) AS pedidos_en_mes
    FROM pedido pe
    GROUP BY pe.cliente_fk, DATE_FORMAT(pe.fecha_hora, '%Y-%m')
    HAVING COUNT(*) > 5
) AS sub
JOIN cliente c ON c.id = sub.cliente_fk
JOIN persona per ON per.id = c.id
ORDER BY sub.mes_anyo DESC, per.nombre;
