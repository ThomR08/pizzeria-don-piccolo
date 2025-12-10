USE pizzeria_don_piccolo;
DELIMITER $$

-- =================================================
-- 1) VALIDAR STOCK ANTES DE INSERTAR detalle_pedido
-- =================================================
CREATE TRIGGER trg_validar_stock_detalle
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    DECLARE faltante INT DEFAULT 0;

    SELECT COUNT(*)
    INTO faltante
    FROM ingrediente_en_pizza ip
    JOIN ingrediente i ON i.id = ip.ingrediente_fk
    WHERE ip.pizza_fk = NEW.pizza_fk
      AND (i.stock_actual - (ip.numero_de_porciones * i.cantidad_por_porcion * NEW.cantidad)) < 0;

    IF faltante > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay stock suficiente para preparar esta pizza';
    END IF;
END$$


-- =================================================
-- 2) DESCONTAR STOCK DESPUÉS DE INSERTAR detalle_pedido
-- =================================================
CREATE TRIGGER trg_descontar_stock_detalle_pedido
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    -- Resta del stock: numero_de_porciones * cantidad_por_porcion * cantidad (del pedido)
    UPDATE ingrediente i
    JOIN ingrediente_en_pizza ip ON ip.ingrediente_fk = i.id
    SET i.stock_actual = i.stock_actual - (ip.numero_de_porciones * i.cantidad_por_porcion * NEW.cantidad)
    WHERE ip.pizza_fk = NEW.pizza_fk;
END$$


-- =================================================
-- 3) REVERTIR STOCK SI SE BORRA UN detalle_pedido
-- =================================================
CREATE TRIGGER trg_reponer_stock_detalle_pedido
AFTER DELETE ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE ingrediente i
    JOIN ingrediente_en_pizza ip ON ip.ingrediente_fk = i.id
    SET i.stock_actual = i.stock_actual + (ip.numero_de_porciones * i.cantidad_por_porcion * OLD.cantidad)
    WHERE ip.pizza_fk = OLD.pizza_fk;
END$$


-- =================================================
-- 4) ACTUALIZAR TOTALES EN pedido AL INSERTAR/ACTUALIZAR/ELIMINAR detalle_pedido
-- Usa las funciones que ya definiste: calcular_total_pedido, calcular_iva_pedido, calcular_subtotal_pedido
-- =================================================
CREATE TRIGGER trg_recalcular_totales_after_insert
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET total = IFNULL(calcular_total_pedido(NEW.pedido_fk), 0),
        iva = IFNULL(calcular_iva_pedido(NEW.pedido_fk), 0),
        sub_total = IFNULL(calcular_subtotal_pedido(NEW.pedido_fk), 0)
    WHERE id = NEW.pedido_fk;
END$$

CREATE TRIGGER trg_recalcular_totales_after_update
AFTER UPDATE ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET total = IFNULL(calcular_total_pedido(NEW.pedido_fk), 0),
        iva = IFNULL(calcular_iva_pedido(NEW.pedido_fk), 0),
        sub_total = IFNULL(calcular_subtotal_pedido(NEW.pedido_fk), 0)
    WHERE id = NEW.pedido_fk;
END$$

CREATE TRIGGER trg_recalcular_totales_after_delete
AFTER DELETE ON detalle_pedido
FOR EACH ROW
BEGIN
    UPDATE pedido
    SET total = IFNULL(calcular_total_pedido(OLD.pedido_fk), 0),
        iva = IFNULL(calcular_iva_pedido(OLD.pedido_fk), 0),
        sub_total = IFNULL(calcular_subtotal_pedido(OLD.pedido_fk), 0)
    WHERE id = OLD.pedido_fk;
END$$


-- =================================================
-- 5) TRIGGER DE AUDITORÍA: registrar cambios de precio en pizza
-- Inserta en tabla historial_precios si cambia precio
-- =================================================
CREATE TRIGGER trg_historial_precio_pizza
BEFORE UPDATE ON pizza
FOR EACH ROW
BEGIN
    IF NEW.precio <> OLD.precio THEN
        INSERT INTO historial_precios (pizza_fk, precio_anterior, precio_nuevo, fecha)
        VALUES (OLD.id, OLD.precio, NEW.precio, CURRENT_TIMESTAMP);
    END IF;
END$$


-- =================================================
-- 6) MARCAR REPARTIDOR COMO DISPONIBLE cuando se registra hora_entrega (domicilio)
-- Además, podemos llamar al procedimiento marcar_pedido_entregado para asegurar pedido.estado
-- =================================================
CREATE TRIGGER trg_domicilio_entregado
AFTER UPDATE ON domicilio
FOR EACH ROW
BEGIN
    -- Si se acaba de registrar hora_entrega (antes era NULL)
    IF OLD.hora_entrega IS NULL AND NEW.hora_entrega IS NOT NULL THEN
        -- Marcar repartidor disponible si existe repartidor asignado
        IF NEW.repartidor_fk IS NOT NULL THEN
            UPDATE repartidor
            SET estado = 'Disponible'
            WHERE id = NEW.repartidor_fk;
        END IF;

        -- Marcar pedido como entregado (usa el procedimiento creado)
        CALL marcar_pedido_entregado(NEW.pedido_fk);
    END IF;
END$$

DELIMITER ;
