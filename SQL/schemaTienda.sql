
-- Se crea la base de datos Tienda si no existe
CREATE DATABASE IF NOT EXISTS Tienda;

-- Usamos la BD Tienda
USE Tienda;

--- Creación del usuario Administrador en el servidor local con su password
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY '123';

-- Le damos todos todos los privilegios a este usuario administrador
GRANT ALL PRIVILEGES ON Tienda.* TO 'admin'@'localhost' WITH GRANT OPTION;

-- Para desactivar las restricciones de las llaves primarias momentáneamente
SET FOREIGN_KEY_CHECKS = 0;


--- Creación de tablas

-- Tabla principal que almacena las categorías de los productos
CREATE TABLE Categorias (
 id INT NOT NULL AUTO_INCREMENT,
 nombre_categoria VARCHAR(50),
 PRIMARY KEY (id)
);

-- Tabla que almacena los usuarios que se le asigna a cada cliente para registrarse al sistema
CREATE TABLE Usuarios (
 id INT NOT NULL AUTO_INCREMENT,
 email VARCHAR(100) NOT NULL,
 password VARCHAR(100) NOT NULL,
 rol VARCHAR(50) NOT NULL,
 activo BOOLEAN NOT NULL DEFAULT TRUE,
 PRIMARY KEY (id)
);

-- Tabla que almacena a los clientes del negocio
CREATE TABLE Clientes (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100) NOT NULL,
 apellido_paterno VARCHAR(100) NOT NULL,
 apellido_materno VARCHAR(100) NOT NULL,
 telefono INT(12) NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id) REFERENCES Usuarios (id)
);

-- Tabla que almacena las diferentes direcciones que pueden guardar los clientes en el sistema
CREATE TABLE Direcciones_Clientes (
 id INT NOT NULL AUTO_INCREMENT,
 direccion VARCHAR(200) NOT NULL,
 cliente_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (cliente_id) REFERENCES Clientes (id)
);

-- Tabla que almacena lso distintos tipos de pagos que se pueden aplicar en las ventas
CREATE TABLE Tipos_Pagos(
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100),
 PRIMARY KEY (id)
);

-- Tabla que almacena las ventas del negocio (los pedidos de los clientes)
CREATE TABLE Ventas (
 id INT NOT NULL AUTO_INCREMENT,
 fecha_venta DATE NOT NULL,
 cliente_id INT NOT NULL,
 direccion_id INT NOT NULL,
 tipo_pago_id INT NOT NULL,
 total_venta INT NOT NULL,
 empleado_id INT NOT NULL,
 transaccion_id INT NOT NULL,
 local_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (cliente_id) REFERENCES Clientes (id),
 FOREIGN KEY (direccion_id) REFERENCES Direcciones_Clientes (id),
 FOREIGN KEY (tipo_pago_id) REFERENCES Tipos_Pagos (id),
 FOREIGN KEY (empleado_id) REFERENCES Empleados(id),
 FOREIGN KEY (local_id) REFERENCES Locales (id)
);

-- Tabla que almacena los distintos proveedores de calzado que tiene el negocio
CREATE TABLE Proveedores (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(100) NOT NULL,
 RFC VARCHAR(100) NOT NULL,
 telefono INT NOT NULL,
 email VARCHAR(100),
 PRIMARY KEY (id)
);

-- Tabla que almacena la información de los distintos locales que tiene el micronegocio
CREATE TABLE Locales (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(50),
 direccion VARCHAR(100),
 imagen VARCHAR(100),
 PRIMARY KEY (id)
);

-- Tabla que almacena los distintos productos (tipos de calzado) que ofrece el micronegocio
CREATE TABLE Productos (
 id INT NOT NULL AUTO_INCREMENT,
 nombre_producto VARCHAR(50),
 descripcion TEXT,
 precio_compra DECIMAL (10,2),
 precio_venta DECIMAL (10,2),
 categoria_id INT NOT NULL,
 proveedor_id INT NOT NULL,
 imagen VARCHAR(100),
 PRIMARY KEY (id),
 FOREIGN KEY (categoria_id) REFERENCES Categorias (id),
 FOREIGN KEY (proveedor_id) REFERENCES Proveedores (id)
);

-- Tabla que almacena los detalles de las ventas realizadas
CREATE TABLE Detalles_Ventas(
 id INT NOT NULL AUTO_INCREMENT,
 venta_id INT NOT NULL,
 cantidad_producto INT NOT NULL,
 producto_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (producto_id) REFERENCES Productos (id),
 FOREIGN KEY (venta_id) REFERENCES Ventas(id)
);

-- Tabla que almacena el inventario que tiene cada uno de los locales del negocio
CREATE TABLE Productos_Locales (
 id INT NOT NULL AUTO_INCREMENT,
 cantidad INT NOT NULL,
 local_id INT NOT NULL,
 producto_id INT NOT NULL,
 disponibilidad BOOLEAN NOT NULL DEFAULT TRUE,
 fecha_ingreso DATE,
 PRIMARY KEY (id),
 FOREIGN KEY (local_id) REFERENCES Locales (id),
 FOREIGN KEY (producto_id) REFERENCES Productos (id)
);

 -- Tabla que almacena los empleados que tiene el negocio repartidos en lso distintos locale
CREATE TABLE Empleados (
 id INT NOT NULL AUTO_INCREMENT,
 nombre VARCHAR(50) NOT NULL,
 apellido_paterno VARCHAR(50) NOT NULL,
 apellido_materno VARCHAR(50) NOT NULL,
 salario DECIMAL (10,2) NOT NULL,
 puesto VARCHAR(20) NOT NULL,
 local_id INT NOT NULL,
 usuario_id INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (local_id) REFERENCES Locales (id),
 FOREIGN KEY (usuario_id) REFERENCES Usuarios (id)
);

-- Tabla principal para registrar transacciones financieras que se generan de las ventas y compras del negocio
CREATE TABLE Transacciones (
    id INT NOT NULL AUTO_INCREMENT,
    tipo_transaccion VARCHAR(50) NOT NULL, -- Puede ser  'Venta', 'Compra', 'Cancelación', 'En Proceso' o 'Reembolso'
    monto DECIMAL(10,2) NOT NULL,
    fecha_transaccion DATE NOT NULL,
    referencia VARCHAR(100),
    usuario_id INT, -- Nueva columna para asociar la transacción con un usuario
    PRIMARY KEY (id),
    FOREIGN KEY (usuario_id) REFERENCES Usuarios (id)
);

-- Tabla que almacena las distintas compras (pedidos a los proveedores) que realiza el negocio
CREATE TABLE Compras (
    id INT NOT NULL AUTO_INCREMENT,
    proveedor_id INT NOT NULL,
    fecha_compra DATE NOT NULL,
    empleado_id INT NOT NULL,
    transaccion_id INT NOT NULL,
    local_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (proveedor_id) REFERENCES Proveedores (id),
    FOREIGN KEY (empleado_id) REFERENCES Empleados (id),
    FOREIGN KEY (transaccion_id) REFERENCES Transacciones (id),
    FOREIGN KEY (local_id) REFERENCES Locales (id)
);

-- Tabla que almacena los detalles de las compras realizadas por el negocio
CREATE TABLE Detalles_Compras (
    id INT NOT NULL AUTO_INCREMENT,
    compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (compra_id) REFERENCES Compras (id),
    FOREIGN KEY (producto_id) REFERENCES Productos (id)
);

-- Para activar de vuelta las restricciones de las llaves primarias 
SET FOREIGN_KEY_CHECKS = 1;
