
USE Tienda;

SET FOREIGN_KEY_CHECKS = 0;

-- Crear varios locales con administradores y usuarios ficticios
INSERT INTO Locales (nombre, direccion) VALUES
('Tienda A', 'Calle Principal 123'),
('Tienda B', 'Avenida Central 456'),
('Tienda C', 'Plaza Comercial 789');

INSERT INTO Empleados (nombre, apellido_paterno, apellido_materno, salario, puesto, local_id, usuario_id)
VALUES
('Admin A', 'Apellido', 'Paterno', 50000.00, 'Administrador', 1,1),
('Admin B', 'Apellido', 'Paterno', 50000.00, 'Administrador', 2,2),
('Admin C', 'Apellido', 'Paterno', 50000.00, 'Administrador', 3,3);

INSERT INTO Usuarios (email, password, rol) VALUES
('adminA@example.com', '123', 'admin'),
('adminB@example.com', '123', 'admin'),
('adminC@example.com', '123', 'admin');


SET FOREIGN_KEY_CHECKS = 1;
