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
    sub_total DOUBLE NOT NULL,
    iva DOUBLE NOT NULL,
    total DOUBLE NOT NULL,
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
    distancia_km INT NOT NULL,
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