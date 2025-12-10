-- ============================================
-- FUNCIONES
-- ============================================

DELIMITER $$

-- -----------------------------------------------------
-- 1. Función: calcular_total_pedido(pedido_id)
-- Suma pizzas + costo de envío (si existe domicilio con repartidor/zona)
-- -----------------------------------------------------
CREATE FUNCTION calcular_total_pedido(pedido_id INT)
RETURNS DOUBLE
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_pizzas DOUBLE DEFAULT 0;
    DECLARE costo_envio DOUBLE DEFAULT 0;

    -- Total por pizzas (precio ya incluye IVA)
    SELECT SUM(dp.cantidad * p.precio)
    INTO total_pizzas
    FROM detalle_pedido dp
    INNER JOIN pizza p ON dp.pizza_fk = p.id
    WHERE dp.pedido_fk = pedido_id;

    -- Costo del envío (si existe un domicilio asociado con repartidor -> zona)
    SELECT z.precio_domi
    INTO costo_envio
    FROM domicilio d
    INNER JOIN repartidor r ON d.repartidor_fk = r.id
    INNER JOIN zona z ON r.zona_fk = z.id
    WHERE d.pedido_fk = pedido_id
    LIMIT 1;

    RETURN IFNULL(total_pizzas, 0) + IFNULL(costo_envio, 0);
END$$

-- -----------------------------------------------------
-- 2. Función: calcular_iva_pedido(pedido_id)
-- IVA = total * 0.19
-- -----------------------------------------------------
CREATE FUNCTION calcular_iva_pedido(id INT)
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DOUBLE;
    DECLARE iva DOUBLE;

    SET total = calcular_total_pedido(id);
    SET iva = total * 0.19;

    RETURN iva;
END$$


-- -----------------------------------------------------
-- 3. Función: calcular_subtotal_pedido(pedido_id)
-- Subtotal = total - IVA
-- -----------------------------------------------------
CREATE FUNCTION calcular_subtotal_pedido(id INT)
RETURNS DOUBLE
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total DOUBLE;
    DECLARE iva DOUBLE;
    DECLARE subtotal DOUBLE;

    SET total = calcular_total_pedido(id);
    SET iva = calcular_iva_pedido(id);
    SET subtotal = total - iva;

    RETURN subtotal;
END$$


-- -----------------------------------------------------
-- 4. Función: calcular_ganancia_neta_dia(fecha)
-- Ganancia neta = total ventas – costo de ingredientes
-- -----------------------------------------------------
CREATE FUNCTION calcular_ganancia_neta_dia(fecha_consulta DATE)
RETURNS DOUBLE
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE ventas DOUBLE;
    DECLARE costo_ingredientes DOUBLE;

    -- Total de ventas del día (solo pizzas)
    SELECT SUM(p.precio * dp.cantidad)
    INTO ventas
    FROM pedido pe
    INNER JOIN detalle_pedido dp ON pe.id = dp.pedido_fk
    INNER JOIN pizza p ON dp.pizza_fk = p.id
    WHERE DATE(pe.fecha_hora) = fecha_consulta;

    -- Costo total de ingredientes usados ese día
    SELECT SUM(ing.costo_por_porcion * ingp.numero_de_porciones * dp.cantidad)
    INTO costo_ingredientes
    FROM pedido pe
    INNER JOIN detalle_pedido dp ON pe.id = dp.pedido_fk
    INNER JOIN ingrediente_en_pizza ingp ON dp.pizza_fk = ingp.pizza_fk
    INNER JOIN ingrediente ing ON ing.id = ingp.ingrediente_fk
    WHERE DATE(pe.fecha_hora) = fecha_consulta;

    RETURN IFNULL(ventas, 0) - IFNULL(costo_ingredientes, 0);
END$$

DELIMITER ;

-- ============================================
-- PROCEDIMIENTO: marcar_pedido_entregado
-- Actualiza el estado del pedido a "Entregado"
-- ============================================

DELIMITER $$

CREATE PROCEDURE marcar_pedido_entregado(IN pedido_id INT)
BEGIN
    UPDATE pedido
    SET estado = 'Entregado'
    WHERE id = pedido_id;
END$$

DELIMITER ;
