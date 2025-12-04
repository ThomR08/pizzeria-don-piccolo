USE pizzeria_don_piccolo;

-- -----------------------------------------------------
-- INSERTS PERSONA
-- -----------------------------------------------------
INSERT INTO persona (nombre, telefono, direccion, email, documento, tipo_documento) VALUES
('Carlos Gomez', '3001112233', 'Calle 10 #12-22', 'carlos@mail.com', '10223344', 'CC'),
('Maria Rodriguez', '3012223344', 'Carrera 15 #45-18', 'maria@mail.com', '55667788', 'CE'),
('Andres Lopez', '3005557788', 'Calle 7 #9-14', 'andres@mail.com', '99887766', 'CC'),
('Luisa Fernanda', '3029876543', 'Av 4 #66-22', 'luisa@mail.com', '11224455', 'CC'),
('Jorge Ramirez', '3119988776', 'Calle 33 #12-80', 'jorge@mail.com', '66778899', 'CE'),
('Sofia Torres', '3021009988', 'Calle 19 #22-10', 'sofia@mail.com', '44332211', 'CC'),
('Diego Martinez', '3117788990', 'Carrera 11 #101-22', 'diego@mail.com', '55664422', 'CC'),
('Valeria Nuñez', '3004455667', 'Carrera 65 #88-21', 'vale@mail.com', '77889911', 'CE'),
('Felipe Castro', '3023344556', 'Calle 40 #13-55', 'felipe@mail.com', '99882244', 'CC'),
('Laura Medina', '3015566778', 'Calle 23 #12-90', 'laura@mail.com', '66221144', 'CC'),

('Daniel Repartidor', '3000001111', 'Sin dirección', 'daniel@mail.com', '12312312', 'CC'),
('Mateo Repartidor', '3000002222', 'Sin dirección', 'mateo@mail.com', '23423423', 'CE'),
('Julian Repartidor', '3000003333', 'Sin dirección', 'julian@mail.com', '34534534', 'CC'),
('Samuel Repartidor', '3000004444', 'Sin dirección', 'samuel@mail.com', '45645645', 'CC'),
('Camilo Repartidor', '3000005555', 'Sin dirección', 'camilo@mail.com', '56756756', 'CE');

-- -----------------------------------------------------
-- INSERTS CLIENTE
-- -----------------------------------------------------
INSERT INTO cliente (id) VALUES
(1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

-- -----------------------------------------------------
-- INSERTS PIZZA
-- -----------------------------------------------------
INSERT INTO pizza (nombre, tamano, tipo, precio) VALUES
('Margarita', 'Mediana', 'Clasica', 22000),
('Pepperoni', 'Grande', 'Clasica', 28000),
('Hawaiana', 'Familiar', 'Especial', 35000),
('Vegetariana', 'Mediana', 'Vegetariana', 26000),
('Carnes', 'Grande', 'Especial', 30000),
('Cuatro Quesos', 'Pequeña', 'Especial', 18000),
('Mexicana', 'Grande', 'Especial', 32000),
('Pollo Champiñón', 'Mediana', 'Especial', 27000),
('Napolitana', 'Familiar', 'Clasica', 34000),
('BBQ Pollo', 'Grande', 'Especial', 31000);

-- -----------------------------------------------------
-- INSERTS INGREDIENTE
-- -----------------------------------------------------
INSERT INTO ingrediente (nombre, cantidad_por_porcion, unidad_de_medida, costo_por_porcion) VALUES
('Queso Mozzarella', 100, 'Gramo', 1500),
('Pepperoni', 50, 'Gramo', 1700),
('Jamón', 60, 'Gramo', 1400),
('Piña', 50, 'Gramo', 900),
('Salsa de Tomate', 30, 'Mililitro', 500),
('Champiñones', 40, 'Gramo', 1200),
('Carne Molida', 70, 'Gramo', 2000),
('Pollo Desmechado', 70, 'Gramo', 2100),
('Cebolla', 40, 'Gramo', 600),
('Pimentón', 40, 'Gramo', 700),
('Queso Azul', 30, 'Gramo', 1800),
('Maíz Dulce', 50, 'Gramo', 800),
('Tocineta', 50, 'Gramo', 1900),
('Jalapeños', 25, 'Gramo', 1000),
('Orégano', 5, 'Gramo', 200),
('Aceitunas', 30, 'Gramo', 1100),
('Tomate', 50, 'Gramo', 900),
('Albahaca', 5, 'Gramo', 300),
('Queso Parmesano', 20, 'Gramo', 1600),
('Ajo', 5, 'Gramo', 300);

-- -----------------------------------------------------
-- INSERTS ZONA
-- -----------------------------------------------------
INSERT INTO zona (nombre, precio_domi, distancia_km) VALUES
('Centro', 3000, 2),
('Norte', 5000, 5),
('Sur', 6000, 6),
('Occidente', 4500, 4),
('Oriente', 5500, 7),
('Barrio Jardín', 4000, 3);

-- -----------------------------------------------------
-- INSERTS REPARTIDOR
-- -----------------------------------------------------
INSERT INTO repartidor (id, estado, zona_fk) VALUES
(11, 'Disponible', 1),
(12, 'Ocupado', 2),
(13, 'Disponible', 3),
(14, 'Fuera de Horario', 4),
(15, 'Disponible', 5);

-- -----------------------------------------------------
-- INSERTS INGREDIENTE EN PIZZA
-- -----------------------------------------------------
INSERT INTO ingrediente_en_pizza (pizza_fk, ingrediente_fk, numero_de_porciones) VALUES
(1, 1, 1), (1, 5, 1), (1, 18, 1),
(2, 1, 1), (2, 2, 2), (2, 5, 1),
(3, 1, 1), (3, 3, 1), (3, 4, 1),
(4, 1, 1), (4, 6, 1), (4, 9, 1),
(5, 1, 2), (5, 7, 1), (5, 13, 1),
(6, 1, 2), (6, 11, 1),
(7, 1, 1), (7, 13, 1), (7, 14, 1),
(8, 1, 1), (8, 6, 1), (8, 8, 1),
(9, 1, 2), (9, 17, 1),
(10, 1, 1), (10, 8, 1), (10, 13, 1);

-- -----------------------------------------------------
-- INSERTS PEDIDO
-- -----------------------------------------------------
INSERT INTO pedido (cliente_fk, fecha_hora, metodo_pago, estado, pedido_para, sub_total, iva, total) VALUES
(1, '2025-01-10 12:30:00', 'Efectivo', 'Entregado', 'Mesa', 52000, 9880, 61880),
(2, '2025-01-10 13:15:00', 'Datafono', 'En camino', 'Llevar', 34000, 6460, 40460),
(3, '2025-01-11 18:20:00', 'Efectivo', 'Por preparar', 'Mesa', 28000, 5320, 33320),
(4, '2025-01-12 19:00:00', 'Transferencia por banco virtual', 'Entregado', 'Recoger', 60000, 11400, 71400),
(5, '2025-01-12 20:10:00', 'Efectivo', 'En camino', 'Llevar', 31000, 5890, 36890),
(6, '2025-01-13 14:55:00', 'Datafono', 'Por entragar', 'Mesa', 27000, 5130, 32130),
(7, '2025-01-14 16:40:00', 'Efectivo', 'Entregado', 'Llevar', 69000, 13110, 82110),
(8, '2025-01-15 12:10:00', 'Efectivo', 'Por preparar', 'Mesa', 35000, 6650, 41650),
(9, '2025-01-15 18:00:00', 'Transferencia por banco virtual', 'Entregado', 'Recoger', 54000, 10260, 64260),
(10, '2025-01-16 13:45:00', 'Datafono', 'En camino', 'Llevar', 45000, 8550, 53550);

-- -----------------------------------------------------
-- INSERTS DETALLE DE PEDIDO
-- -----------------------------------------------------
INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad) VALUES
(1, 1, 1), (1, 2, 1),
(2, 3, 1),
(3, 6, 2),
(4, 5, 1), (4, 9, 1),
(5, 10, 1),
(6, 4, 1),
(7, 7, 2), (7, 8, 1),
(8, 1, 1), (8, 6, 1),
(9, 3, 1), (9, 10, 1),
(10, 2, 2);

-- -----------------------------------------------------
-- INSERTS DOMICILIO
-- -----------------------------------------------------
INSERT INTO domicilio (hora_salida, hora_entrega, direccion, pedido_fk, repartidor_fk) VALUES
('2025-01-10 13:20:00', '2025-01-10 13:55:00', 'Calle 99 #12-30', 2, 12),
('2025-01-12 19:10:00', '2025-01-12 19:50:00', 'Av 7 #66-20', 5, 11),
('2025-01-14 16:50:00', '2025-01-14 17:20:00', 'Calle 45 #88-22', 7, 13),
('2025-01-15 18:10:00', '2025-01-15 18:42:00', 'Carrera 9 #12-80', 9, 15),
('2025-01-16 13:50:00', NULL, 'Calle 10 #4-55', 10, 12);