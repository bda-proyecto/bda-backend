
CREATE DATABASE IF NOT EXISTS Tienda;

USE Tienda;

--- Usuario Administrador
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY '123';

GRANT ALL PRIVILEGES ON Tienda.* TO 'admin'@'localhost' WITH GRANT OPTION;



--- Creación de tablas

CREATE TABLE Categorias (
 id INT NOT NULL AUTO_INCREMENT,
 nombre_categoria VARCHAR(50),
 PRIMARY KEY (id)
);

CREATE TABLE Productos (
 id INT NOT NULL AUTO_INCREMENT,
 nombre_producto VARCHAR(50),
 descripcion TEXT,
 precio_compra DECIMAL (10,2),
 precio_venta DECIMAL (10,2),
 categoria_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (categoria_id) REFERENCES Categorias (id)
);

CREATE TABLE Usuarios (
 id INT NOT NULL AUTO_INCREMENT,
 email VARCHAR(100) NOT NULL,
 password VARCHAR(100) NOT NULL,
 rol VARCHAR(50) NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE Clientes (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100) NOT NULL,
 apellido_paterno VARCHAR(100) NOT NULL,
 apellido_materno VARCHAR(100) NOT NULL,
 telefono INT(12) NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id) REFERENCES Usuarios (id)
);

CREATE TABLE Direcciones_Clientes (
 id INT NOT NULL AUTO_INCREMENT,
 direccion VARCHAR(200) NOT NULL,
 cliente_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (cliente_id) REFERENCES Clientes (id)
);

CREATE TABLE Tipos_Pagos(
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100),
 PRIMARY KEY (id)
);

CREATE TABLE Ventas (
 id INT NOT NULL AUTO_INCREMENT,
 fecha_venta DATE NOT NULL,
 cliente_id INT NOT NULL,
 direccion_id INT NOT NULL,
 tipo_pago_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (cliente_id) REFERENCES Clientes (id),
 FOREIGN KEY (direccion_id) REFERENCES Direcciones_Clientes (id),
 FOREIGN KEY (tipo_pago_id) REFERENCES Tipos_Pagos (id)
);

CREATE TABLE Detalles_Ventas(
 id INT NOT NULL AUTO_INCREMENT,
 cantidad_producto INT NOT NULL,
 producto_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (producto_id) REFERENCES Productos (id)
);

CREATE TABLE Proveedores (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100) NOT NULL,
 RFC VARCHAR(100) NOT NULL,
 telefono INT NOT NULL,
 email VARCHAR(100),
 PRIMARY KEY (id)
);

CREATE TABLE Locales (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(50),
 direccion VARCHAR(100),
 PRIMARY KEY (id)
);


CREATE TABLE Pedidos (
 id INT NOT NULL AUTO_INCREMENT,
 fecha_pedido DATE NOT NULL,
 estado VARCHAR(100) NOT NULL,
 local_id INT NOT NULL,
 proveedor_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (local_id) REFERENCES Locales (id),
 FOREIGN KEY (proveedor_id) REFERENCES Proveedores (id)
);

CREATE TABLE Detalles_Pedidos (
 id INT NOT NULL AUTO_INCREMENT,
 pedido_id INT NOT NULL,
 producto_id INT NOT NULL,
 cantidad INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (pedido_id) REFERENCES Pedidos (id),
 FOREIGN KEY (producto_id) REFERENCES Productos (id)
);

CREATE TABLE Productos_Locales (
 id INT NOT NULL AUTO_INCREMENT,
 cantidad INT NOT NULL,
 local_id INT NOT NULL,
 producto_id INT NOT NULL,
 disponibilidad BOOLEAN NOT NULL DEFAULT TRUE,
 PRIMARY KEY (id),
 FOREIGN KEY (local_id) REFERENCES Locales (id),
 FOREIGN KEY (producto_id) REFERENCES Productos (id)
);

CREATE TABLE Empleados (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(50) NOT NULL,
 apellido_paterno VARCHAR(50) NOT NULL,
 apellido_materno VARCHAR(50) NOT NULL,
 salario DECIMAL (10,2) NOT NULL,
 puesto VARCHAR(20) NOT NULL,
 local_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (local_id) REFERENCES Locales (id)
);



---- Usuarios


--- Usuario Caja
CREATE USER IF NOT EXISTS 'vendedor'@'localhost' IDENTIFIED BY '123';

GRANT SELECT, INSERT, UPDATE ON Tienda.Clientes TO 'vendedor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Direcciones_Clientes TO 'vendedor'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Ventas TO 'vendedor'@'localhost';
GRANT SELECT ON Tienda.Productos_Locales TO 'vendedor'@'localhost';

-- Usuario Gestor Proveedores

CREATE USER IF NOT EXISTS 'almacen'@'localhost' IDENTIFIED BY '123';

GRANT SELECT, INSERT, UPDATE ON Tienda.Pedidos TO 'almacen'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Detalles_Pedidos TO 'almacen'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Proveedores TO 'almacen'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Tienda.Productos_Locales TO 'almacen'@'localhost';

--- Usuario Gerente
CREATE USER IF NOT EXISTS 'gerente'@'localhost' IDENTIFIED BY '123';
GRANT SELECT, INSERT, UPDATE ON Tienda.Locales TO 'gerente'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Pedidos TO 'gerente'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Detalles_Pedidos TO 'gerente'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Productos_Locales TO 'gerente'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Tienda.Empleados TO 'gerente'@'localhost';

