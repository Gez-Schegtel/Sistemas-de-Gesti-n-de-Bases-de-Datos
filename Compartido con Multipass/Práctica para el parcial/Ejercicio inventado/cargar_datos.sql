
-- Cargar datos en la tabla empleados
INSERT INTO shoutdb.empleados (nombre, fecha_nacimiento) 
VALUES 
('Juan Perez', '1980-05-15'),
('María Gómez', '1992-03-22'),
('Carlos Torres', '1975-12-10');

-- Cargar datos en la tabla de_planta
INSERT INTO shoutdb.de_planta (id_empleado, fecha_planta)
VALUES 
(1, '2010-06-01'),
(2, '2015-09-15');

-- Cargar datos en la tabla contratados
INSERT INTO shoutdb.contratados (id_empleado, tipo_contrato)
VALUES 
(3, 'A');

-- Cargar datos en la tabla pedidos
INSERT INTO shoutdb.pedidos (detalle, fecha_pedido, id_empleado)
VALUES 
('Pedido de productos electrónicos', '2023-09-01', 1),
('Pedido de muebles de oficina', '2023-09-02', 2),
('Pedido de material de papelería', '2023-09-03', 3);

-- Cargar datos en la tabla línea_de_pedidos
INSERT INTO shoutdb.línea_de_pedidos (nro_línea, nombre_producto, cantidad, id_pedido)
VALUES 
(1, 'Laptop', 2, 1),
(2, 'Monitor', 3, 1),
(1, 'Silla de oficina', 10, 2),
(1, 'Cuaderno', 100, 3),
(2, 'Bolígrafo', 200, 3);

-- Cargar datos en la tabla productos
INSERT INTO shoutdb.productos (descripción)
VALUES 
('Laptop Dell'),
('Monitor Samsung'),
('Silla ergonómica'),
('Cuaderno A5'),
('Bolígrafo BIC');

-- Cargar datos en la tabla posee
INSERT INTO shoutdb.posee (id_pedido, id_producto)
VALUES 
(1, 1), -- Pedido 1 contiene Laptop
(1, 2), -- Pedido 1 contiene Monitor
(2, 3), -- Pedido 2 contiene Silla ergonómica
(3, 4), -- Pedido 3 contiene Cuaderno
(3, 5); -- Pedido 3 contiene Bolígrafo
