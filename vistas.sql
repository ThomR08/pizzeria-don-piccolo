USE pizzeria_don_piccolo;

-- -----------------------------------------------------
-- 1) Vista: resumen de pedidos por cliente
-- nombre del cliente, cantidad de pedidos, total gastado
-- -----------------------------------------------------
CREATE OR REPLACE VIEW vista_resumen_pedidos_cliente AS
SELECT
    p.id AS cliente_id,
    p.nombre AS nombre_cliente,
    COUNT(pe.id) AS cantidad_pedidos,
    IFNULL(SUM(pe.total), 0) AS total_gastado
FROM cliente c
JOIN persona p ON c.id = p.id
LEFT JOIN pedido pe ON pe.cliente_fk = c.id
GROUP BY p.id, p.nombre;


-- -----------------------------------------------------
-- 2) Vista: desempeño de repartidores
-- número de entregas, tiempo promedio, zona
-- -----------------------------------------------------
CREATE OR REPLACE VIEW vista_desempeno_repartidor AS
SELECT
    r.id AS repartidor_id,
    per.nombre AS nombre_repartidor,
    z.nombre AS zona,
    COUNT(d.id) AS numero_entregas,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS tiempo_promedio_minutos
FROM repartidor r
JOIN persona per ON per.id = r.id
LEFT JOIN zona z ON z.id = r.zona_fk
LEFT JOIN domicilio d ON d.repartidor_fk = r.id AND d.hora_entrega IS NOT NULL
GROUP BY r.id, per.nombre, z.nombre;


-- -----------------------------------------------------
-- 3) Vista: ingredientes por debajo del stock_minimo
-- -----------------------------------------------------
CREATE OR REPLACE VIEW vista_stock_bajo AS
SELECT
    id,
    nombre,
    unidad_de_medida,
    stock_actual,
    stock_minimo
FROM ingrediente
WHERE stock_actual <= stock_minimo;
