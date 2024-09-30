-- 1. Crear la base de datos
DROP DATABASE IF EXISTS bd2024;
CREATE DATABASE bd2024;
USE bd2024;

-- 2. Crear la tabla de productos
CREATE TABLE producto (
    id_producto INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    stock INT UNSIGNED NOT NULL CHECK (stock >= 0)
);

-- 3. Crear la tabla de ventas
CREATE TABLE venta (
    id_venta INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_producto INT UNSIGNED NOT NULL,
    cantidad INT UNSIGNED NOT NULL CHECK (cantidad > 0),
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 4. Insertar datos en la tabla de productos
INSERT INTO producto (nombre, precio, stock) VALUES
('Sofá de 3 plazas', 500.00, 10),
('Mesa de comedor', 300.00, 5),
('Silla de oficina', 150.00, 20),
('Cama King Size', 1000.00, 3),
('Estantería de madera', 200.00, 15);

-- 5. Insertar datos en la tabla de ventas
-- Venta de 2 sofás
INSERT INTO venta (id_producto, cantidad, total) VALUES (1, 2, 2 * 500.00); -- 2 unidades de "Sofá de 3 plazas"

-- Venta de 1 mesa
INSERT INTO venta (id_producto, cantidad, total) VALUES (2, 1, 1 * 300.00); -- 1 unidad de "Mesa de comedor"

-- Venta de 4 sillas de oficina
INSERT INTO venta (id_producto, cantidad, total) VALUES (3, 4, 4 * 150.00); -- 4 unidades de "Silla de oficina"

-- Venta de 1 cama King Size
INSERT INTO venta (id_producto, cantidad, total) VALUES (4, 1, 1 * 1000.00); -- 1 unidad de "Cama King Size"

-- Venta de 3 estanterías
INSERT INTO venta (id_producto, cantidad, total) VALUES (5, 3, 3 * 200.00); -- 3 unidades de "Estantería de madera"
