-- CRECION BASE DE DATOS:

-- -----------------------------------------------------
-- Base de datos pizzeria-don-piccolo
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS pizzeria_don_piccolo;
USE pizzeria_don_piccolo;

-- -----------------------------------------------------
-- Tabla persona
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS persona (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    telefono VARCHAR(45),
    direccion VARCHAR(45),
    email VARCHAR(45),
    documento VARCHAR(45) NOT NULL,
    tipo_documento ENUM('CC', 'CE') NOT NULL DEFAULT 'CC',
    PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Tabla cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS cliente (
    id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES persona (id)
);

-- -----------------------------------------------------
-- Tabla pizza
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS pizza (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    tamano ENUM('Pequeña', 'Mediana', 'Grande', 'Familiar') NOT NULL,
    tipo ENUM('Clasica', 'Especial', 'Vegetariana') NOT NULL,
    precio DOUBLE NOT NULL,
    PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Tabla ingrediente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ingrediente (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    cantidad_por_porcion INT NOT NULL,
    unidad_de_medida ENUM('Unidad', 'Gramo', 'Mililitro') NOT NULL,
    costo_por_porcion DOUBLE NOT NULL,
    stock_actual DOUBLE NOT NULL DEFAULT 0,
    stock_minimo DOUBLE NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Tabla pedido
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS pedido (
    id INT NOT NULL AUTO_INCREMENT,
    cliente_fk INT NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    metodo_pago ENUM('Efectivo', 'Datafono', 'Transferencia por banco virtual') NOT NULL,
    estado ENUM('Por preparar', 'En preparacion', 'Por entragar', 'En camino', 'Entregado') NOT NULL,
    pedido_para ENUM('Mesa', 'Llevar', 'Recoger') NOT NULL,
    sub_total DOUBLE,
    iva DOUBLE,
    total DOUBLE,
    PRIMARY KEY (id),
    FOREIGN KEY (cliente_fk) REFERENCES cliente (id)
);

-- -----------------------------------------------------
-- Tabla zona
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS zona (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(45) NOT NULL,
    precio_domi DOUBLE NOT NULL,
    distancia_km DOUBLE,
    PRIMARY KEY (id)
);

-- -----------------------------------------------------
-- Tabla repartidor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS repartidor (
    id INT NOT NULL,
    estado ENUM('Disponible', 'Ocupado', 'Fuera de Horario') NOT NULL,
    zona_fk INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES persona (id),
    FOREIGN KEY (zona_fk) REFERENCES zona (id)
);

-- -----------------------------------------------------
-- Tabla domicilio
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS domicilio (
    id INT NOT NULL AUTO_INCREMENT,
    hora_salida DATETIME,
    hora_entrega DATETIME,
    direccion VARCHAR(45) NOT NULL,
    pedido_fk INT NOT NULL,
    repartidor_fk INT,
    PRIMARY KEY (id),
    FOREIGN KEY (pedido_fk) REFERENCES pedido (id),
    FOREIGN KEY (repartidor_fk) REFERENCES repartidor (id)
);

-- -----------------------------------------------------
-- Tabla ingrediente_en_pizza
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ingrediente_en_pizza (
    id INT NOT NULL AUTO_INCREMENT,
    pizza_fk INT NOT NULL,
    ingrediente_fk INT NOT NULL,
    numero_de_porciones INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    FOREIGN KEY (pizza_fk) REFERENCES pizza (id),
    FOREIGN KEY (ingrediente_fk) REFERENCES ingrediente (id)
);

-- -----------------------------------------------------
-- Tabla detalle_pedido
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id INT NOT NULL AUTO_INCREMENT,
    pedido_fk INT NOT NULL,
    pizza_fk INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    FOREIGN KEY (pedido_fk) REFERENCES pedido (id),
    FOREIGN KEY (pizza_fk) REFERENCES pizza (id)
);

-- -----------------------------------------------------
-- Tabla historial_precios
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS historial_precios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pizza_fk INT NOT NULL,
    precio_anterior DOUBLE NOT NULL,
    precio_nuevo DOUBLE NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pizza_fk) REFERENCES pizza(id)
);

-- FIN CREACION BASE DE DATOS
-- -----------------------------------------------------
-- -----------------------------------------------------




-- -----------------------------------------------------
-- EXAMEN !!!!!!!!!!!!
-- -----------------------------------------------------

-- 3. Consulta de pedidos por cliente
-- Consulta SQL que muestre el nombre del cliente, el ID del pedido, el total y el estado del pedido.
SELECT
    p.nombre AS nombre_cliente,
    pd.id AS id_pedido,
    pd.total,
    pd.estado
FROM pedido pd
LEFT JOIN persona p ON p.id = pd.cliente_fk; -- Traer tabla persona para consultar el nombre del cliente

-- 4. Consulta de pedidos entregados en un rango de fechas
-- Mostrar los pedidos con estado entregado cuya fecha esté entre dos fechas dadas (usa BETWEEN).
SELECT
    p.id AS id_pedido,
    p.fecha_hora,
    p.pedido_para,
    p.metodo_pago,
    p.total
FROM (
    SELECT * FROM pedido WHERE pedido.estado = 'Entregado' -- Filtrar pedidos con estado 'Entregado'
) AS p
WHERE DATE(p.fecha_hora) BETWEEN '2025-01-10' AND '2025-01-15' -- Filtrar por el rango de fechas
ORDER BY p.fecha_hora;

-- 5. Consulta de resumen de pedidos por método de pago
-- Mostrar cuántos pedidos se hicieron por cada método de pago y el total acumulado (GROUP BY).
SELECT
    p.metodo_pago,
    COUNT(*) AS num_pedidos,
    SUM(p.total) AS ingreso_total
FROM pedido p
GROUP BY p.metodo_pago; -- Agrupar por metodo de pago

-- 6. Consulta de clientes frecuentes
-- Mostrar los clientes que tengan más de 5 pedidos en total (usa HAVING COUNT(*) > 5).
SELECT
    per.nombre AS cliente,
    p.cliente_fk AS id_cliente,
    COUNT(*) AS num_pedidos,
    SUM(p.total) AS total_gastado
FROM pedido p
LEFT JOIN persona per ON per.id = p.cliente_fk
GROUP BY p.cliente_fk -- Agrupar por cliente
HAVING COUNT(*) > 5; -- Filtrar los que tengan mas de 5 pedidos