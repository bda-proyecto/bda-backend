-- Usamos la BD Tienda
USE Tienda;

-- Para desactivar las restricciones de las llaves primarias momentáneamente
SET FOREIGN_KEY_CHECKS = 0;

-- Insertar datos para crear varios locales con administradores y usuarios ficticios
INSERT INTO Locales (nombre, direccion, imagen) VALUES
('Tienda A', 'Calle Principal 123', 'TiendaA.jpg'),
('Tienda B', 'Avenida Central 456', 'TiendaB.jpg'),
('Tienda C', 'Plaza Comercial 789', 'TiendaC.jpg');

-- Insertar datos para empleados ficticios, con un salario, puesto, local asignado y usuario
INSERT INTO Empleados (nombre, apellido_paterno, apellido_materno, salario, puesto, local_id, usuario_id)
VALUES
('Admin A', 'Apellido', 'Paterno', 50000.00, 'Administrador', 1,1),
('Admin B', 'Apellido', 'Paterno', 50000.00, 'Administrador', 2,2),
('Admin C', 'Apellido', 'Paterno', 50000.00, 'Administrador', 3,3);

-- Insertar datos para crear usuarios administradores ficticios
INSERT INTO Usuarios (email, password, rol) VALUES
('adminA@example.com', '123', 'admin'),
('adminB@example.com', '123', 'admin'),
('adminC@example.com', '123', 'admin');

-- Insertar datos para crear diversos tipos de pagos
INSERT INTO Tipos_Pagos (nombre) VALUES
    ('Efectivo'),
    ('Tarjeta de Crédito'),
    ('Transferencia Bancaria'),
    ('Pago Móvil');

-- Insertar datos para crear diversas categorías de calzado
INSERT INTO Categorias (nombre_categoria) VALUES
    ('Deportivos'),
    ('Casuales'),
    ('Formales'),
    ('Sandalias'),
    ('Botas'),
    ('Zapatillas');

-- Insertar datos para crear varios proveedores ficticios
INSERT INTO Proveedores (nombre, RFC, telefono, email) VALUES
    ('Proveedor A', 'RFC123', 1234567, 'proveedorA@example.com'),
    ('Proveedor B', 'RFC456', 9876540, 'proveedorB@example.com'),
    ('Proveedor C', 'RFC789', 5555555, 'proveedorC@example.com');

-- Insertar datos para crear varios lclientes ficticios
INSERT INTO Clientes (nombre, apellido_paterno, apellido_materno, telefono) VALUES
    ('Cliente 1', 'Apellido1', 'Apellido2', 11111111),
    ('Cliente 2', 'Apellido3', 'Apellido4', 22222222),
    ('Cliente 3', 'Apellido5', 'Apellido6', 33333333);

-- Insertar datos para crear varias direcciones ficticias de los clientes
INSERT INTO Direcciones_Clientes (direccion, cliente_id) VALUES
    ('Direccion Cliente 1', 1),
    ('Direccion Cliente 2', 2),
    ('Direccion Cliente 3', 3);

-- Insertar datos para crear varios productos ficticios
INSERT INTO Productos (nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen) VALUES
    ('Zapato Deportivo', 'Perfectos para correr', 50.00, 100.00, 1, 1, 'zapato1.jpg'),
    ('Zapato Casual', 'Ideal para uso diario', 40.00, 80.00, 2, 2, 'zapato2.jpg'),
    ('Zapato Formal', 'Elegantes para ocasiones especiales', 60.00, 120.00, 3, 1, 'zapato3.jpg'),
    ('Sandalias Verano', 'Cómodas y frescas', 30.00, 60.00, 4, 2, 'sandalias.jpg'),
    ('Botas de Invierno', 'Calientes y resistentes al agua', 70.00, 140.00, 5, 3, 'botas1.jpg'),
    ('Zapatillas para Correr', 'Diseñadas para atletas profesionales', 80.00, 160.00, 1, 1, 'zapatillas1.jpg');

-- Insertar datos para crear varias ventas a clientes ficticias
INSERT INTO Ventas (fecha_venta, cliente_id, direccion_id, tipo_pago_id, total_venta, empleado_id, transaccion_id, local_id) VALUES
    ('2023-11-01', 1, 1, 1, 120.00, 2, 3, 1),
    ('2023-11-02', 2, 2, 2, 160.00, 3, 4, 2),
    ('2023-11-03', 3, 3, 3, 200.00, 4, 5, 3);

-- Insertar datos para crear varios detalles de ventas ficticios
INSERT INTO Detalles_Ventas (venta_id, cantidad_producto, producto_id) VALUES
    (1, 2, 1),
    (2, 2, 2),
    (3, 2, 3);

-- Insertar datos para crear varias transacciones ficticias
INSERT INTO Transacciones (tipo_transaccion, monto, fecha_transaccion, referencia, usuario_id) VALUES
    ('Venta', 120.00, '2023-11-01', 'ReferenciaVenta1', 2),
    ('Venta', 160.00, '2023-11-02', 'ReferenciaVenta2', 3),
    ('Venta', 200.00, '2023-11-03', 'ReferenciaVenta3', 4);

-- Insertar datos para crear varias compras a proveedores ficticias
INSERT INTO Compras (proveedor_id, fecha_compra, empleado_id, transaccion_id, local_id) VALUES
    (1, '2023-11-01', 2, 5, 1),
    (2, '2023-11-02', 3, 6, 2),
    (3, '2023-11-03', 4, 7, 3);

-- Insertar más datos ficticios en Compras (añadiendo más registros)
INSERT INTO Compras (proveedor_id, fecha_compra, empleado_id, transaccion_id, local_id) VALUES
    (1, '2023-10-10', 2, 8, 1),
    (2, '2023-10-15', 3, 9, 2),
    (3, '2023-10-20', 4, 10, 3);

-- Insertar datos para crear varios productos en diversos locales para tener un inventario ficticio
INSERT INTO Productos_Locales (cantidad, local_id, producto_id, disponibilidad, fecha_ingreso) VALUES
    (20, 1, 1, TRUE, '2023-10-01'),
    (15, 1, 2, TRUE, '2023-10-01'),
    (18, 2, 3, TRUE, '2023-10-02'),
    (25, 2, 4, TRUE, '2023-10-02'),
    (22, 3, 5, TRUE, '2023-10-03'),
    (30, 3, 6, TRUE, '2023-10-03');







-- Para activar de vuelta las restricciones de las llaves primarias 
SET FOREIGN_KEY_CHECKS = 1;


