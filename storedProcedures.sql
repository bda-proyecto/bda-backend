USE Tienda;

DELIMITER $$

CREATE PROCEDURE insertCategoria(
	IN nombreCategoria VARCHAR(50)
)
BEGIN
	INSERT INTO Categorias (nombre_categoria)
	VALUES (nombreCategoria);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateCategoria(
	IN id INT,
	IN nombreCategoria VARCHAR(50)
)
BEGIN
	UPDATE Categorias
	SET nombre_categoria = nombreCategoria
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteCategoria(
	IN id INT	
)
BEGIN
	DELETE FROM Categorias
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getCategoriaById(
	IN id INT
)
BEGIN
	SELECT *
	FROM Categorias
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllCategorias(
)
BEGIN
	SELECT *
	FROM Categorias;
END$$

DELIMITER ;

DELIMITER $$

---  PRODUCTOS

CREATE PROCEDURE insertProducto(
	IN nombreProducto VARCHAR(50),
	IN descripcion TEXT,
	IN precioCompra DECIMAL(10,2),
	IN precioVenta DECIMAL(10,2),
	IN categoriaId INT
)
BEGIN
	INSERT INTO Productos (nombre_producto, descripcion, precio_compra, precio_venta, categoria_id)
	VALUES (nombreProducto, descripcion, precioCompra, precioVenta, categoriaId);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateProducto(
    IN id INT,
    IN nombreProducto VARCHAR(50),
    IN descripcion TEXT,
    IN precioCompra DECIMAL(10,2),
    IN precioVenta DECIMAL(10,2),
    IN categoriaId INT
)
BEGIN
    UPDATE Productos
    SET nombre_producto = nombreProducto,
        descripcion = descripcion,
        precio_compra = precioCompra,
        precio_venta = precioVenta,  -- Agrega esta línea
        categoria_id = categoriaId
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteProducto(
	IN id INT
)
BEGIN
       DELETE FROM Productos
       WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getProductoById(IN id INT)
BEGIN
	SELECT *
	FROM Productos
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllProductos()
BEGIN
	SELECT *
	FROM Productos;
END$$

DELIMITER ;

DELIMITER $$

--- Usuarios

CREATE PROCEDURE insertUsuario (
	IN email VARCHAR(100),
	IN password VARCHAR(100),
	IN rol VARCHAR(50)
)
BEGIN
	INSERT INTO Usuarios (email, password, rol)
	VALUES (email, password, rol);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateUsuario (
	IN id INT,
	IN email VARCHAR(100),
	IN password VARCHAR(100),
	IN rol VARCHAR(50)
)
BEGIN
	UPDATE Usuarios
	SET email = email,
	    password = password,
	    rol = rol
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteUsuario(
	IN id INT
)
BEGIN
	DELETE FROM Usuarios
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getUsuarioById(
	IN id INT
)
BEGIN
	SELECT *
	FROM Usuarios
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllUsuarios()
BEGIN
	SELECT *
	FROM Usuarios;
END$$

DELIMITER ;

DELIMITER $$

--- Clientes

CREATE PROCEDURE insertCliente(
	IN nombre VARCHAR(100),
	IN apellidoPaterno VARCHAR(100),
	IN apellidoMaterno VARCHAR(100),
	IN telefono INT (12)
)
BEGIN
	INSERT INTO Clientes (nombre, apellido_paterno, apellido_materno, telefono)
	VALUES (nombre, apellidoPaterno, apellidoMaterno, telefono);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateCliente(
    IN id INT,
    IN nombre VARCHAR(100),
    IN apellidoPaterno VARCHAR(100),
    IN apellidoMaterno VARCHAR(100),
    IN telefono INT(12)
)
BEGIN
    UPDATE Clientes
    SET nombre = nombre,
        apellido_paterno = apellidoPaterno,
        apellido_materno = apellidoMaterno,
        telefono = telefono
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteCliente(
    IN id INT
)
BEGIN
    DELETE FROM Clientes
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getClienteById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Clientes
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllClientes()
BEGIN
    SELECT *
    FROM Clientes;
END$$

DELIMITER ;

DELIMITER $$

-- Proveedores
CREATE PROCEDURE insertProveedor(
    IN nombreProveedor VARCHAR(100),
    IN telefono INT(12),
    IN direccion VARCHAR(255)
)
BEGIN
    INSERT INTO Proveedores (nombre_proveedor, telefono, direccion)
    VALUES (nombreProveedor, telefono, direccion);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateProveedor(
    IN id INT,
    IN nombreProveedor VARCHAR(100),
    IN telefono INT(12),
    IN direccion VARCHAR(255)
)
BEGIN
    UPDATE Proveedores
    SET nombre_proveedor = nombreProveedor,
        telefono = telefono,
        direccion = direccion
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteProveedor(
    IN id INT
)
BEGIN
    DELETE FROM Proveedores
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getProveedorById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Proveedores
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllProveedores()
BEGIN
    SELECT *
    FROM Proveedores;
END$$

DELIMITER ;

DELIMITER $$

--- Inventarios

CREATE PROCEDURE insertInventario(
    IN productoId INT,
    IN cantidad INT,
    IN fechaIngreso DATE
)
BEGIN
    INSERT INTO Inventarios (producto_id, cantidad, fecha_ingreso)
    VALUES (productoId, cantidad, fechaIngreso);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE updateInventario(
    IN id INT,
    IN productoId INT,
    IN cantidad INT,
    IN fechaIngreso DATE
)
BEGIN
    UPDATE Inventarios
    SET producto_id = productoId,
        cantidad = cantidad,
        fecha_ingreso = fechaIngreso
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteInventario(
    IN id INT
)
BEGIN
    DELETE FROM Inventarios
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getInventarioById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Inventarios
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllInventarios()
BEGIN
    SELECT *
    FROM Inventarios;
END$$

DELIMITER ;

DELIMITER $$

--- Ventas

CREATE PROCEDURE insertVenta(
    IN productoId INT,
    IN clienteId INT,
    IN cantidad INT,
    IN fechaVenta DATE,
    IN totalVenta DECIMAL(10,2)
)
BEGIN
    INSERT INTO Ventas (producto_id, cliente_id, cantidad, fecha_venta, total_venta)
    VALUES (productoId, clienteId, cantidad, fechaVenta, totalVenta);
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateVenta(
    IN id INT,
    IN productoId INT,
    IN clienteId INT,
    IN cantidad INT,
    IN fechaVenta DATE,
    IN totalVenta DECIMAL(10,2)
)
BEGIN
    UPDATE Ventas
    SET producto_id = productoId,
        cliente_id = clienteId,
        cantidad = cantidad,
        fecha_venta = fechaVenta,
        total_venta = totalVenta
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE deleteVenta(
    IN id INT
)
BEGIN
    DELETE FROM Ventas
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getVentaById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Ventas
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE getAllVentas()
BEGIN
    SELECT *
    FROM Ventas;
END$$
DELIMITER ;

DELIMITER $$

-- Compras
CREATE PROCEDURE insertCompra(
    IN proveedorId INT,
    IN fechaCompra DATE,
    IN totalCompra DECIMAL(10,2)
)
BEGIN
    INSERT INTO Compras (proveedor_id, fecha_compra, total_compra)
    VALUES (proveedorId, fechaCompra, totalCompra);
END$$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE updateCompra(
    IN id INT,
    IN proveedorId INT,
    IN fechaCompra DATE,
    IN totalCompra DECIMAL(10,2)
)
BEGIN
    UPDATE Compras
    SET proveedor_id = proveedorId,
        fecha_compra = fechaCompra,
        total_compra = totalCompra
    WHERE id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE deleteCompra(
    IN id INT
)
BEGIN
    DELETE FROM Compras
    WHERE id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getCompraById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Compras
    WHERE id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getAllCompras()
BEGIN
    SELECT *
    FROM Compras;
END$$
DELIMITER ;

DELIMITER $$
-- Detalles de Compras
CREATE PROCEDURE insertDetalleCompra(
    IN compraId INT,
    IN productoId INT,
    IN cantidad INT
)
BEGIN
    INSERT INTO Detalles_Compras (compra_id, producto_id, cantidad)
    VALUES (compraId, productoId, cantidad);
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE updateDetalleCompra(
    IN id INT,
    IN compraId INT,
    IN productoId INT,
    IN cantidad INT
)
BEGIN
    UPDATE Detalles_Compras
    SET compra_id = compraId,
        producto_id = productoId,
        cantidad = cantidad
    WHERE id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE deleteDetalleCompra(
    IN id INT
)
BEGIN
    DELETE FROM Detalles_Compras
    WHERE id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getDetalleCompraById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Detalles_Compras
    WHERE id = id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getAllDetallesCompras()
BEGIN
    SELECT *
    FROM Detalles_Compras;
END$$
DELIMITER ;
DELIMITER $$

--- Empleados
DELIMITER $$
CREATE PROCEDURE getEmpleadoById(
	IN Id INT)
BEGIN
	SELECT * FROM Empleados WHERE id = Id;
END$$

DELIMITER ;

DELIMITER $$
CREATE PROCEDURE getEmpleadoByLocalId(
	IN Id INT)
BEGIN
	SELECT * FROM Empleados WHERE local_id = Id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE 


--- Reportes Financieros

-- Obtener el total de ventas por cliente
CREATE PROCEDURE getVentasTotalesPorCliente()
BEGIN
    SELECT clientes.nombre AS nombre_cliente, SUM(ventas.total_venta) AS total_ventas
    FROM clientes
    JOIN ventas ON clientes.id = ventas.cliente_id
    GROUP BY clientes.id;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener el total de ventas por categoría de productos
CREATE PROCEDURE getVentasTotalesPorCategoria()
BEGIN
    SELECT categorias.nombre_categoria, SUM(ventas.total_venta) AS total_ventas
    FROM categorias
    JOIN productos ON categorias.id = productos.categoria_id
    JOIN ventas ON productos.id = ventas.producto_id
    GROUP BY categorias.id;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener el inventario actual de cada producto
CREATE PROCEDURE getInventarioActual()
BEGIN
    SELECT productos.nombre_producto, inventarios.cantidad
    FROM productos
    JOIN inventarios ON productos.id = inventarios.producto_id;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener el total de compras por proveedor
CREATE PROCEDURE getComprasTotalesPorProveedor(
    IN proveedorId INT,
    OUT totalCompras DECIMAL(10,2)
)
BEGIN
    SELECT SUM(total_compra) INTO totalCompras
    FROM Compras
    WHERE proveedor_id = proveedorId;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener el total de ventas por producto
CREATE PROCEDURE getVentasTotalesPorProducto()
BEGIN
    SELECT productos.nombre_producto, SUM(ventas.cantidad) AS total_ventas
    FROM productos
    JOIN ventas ON productos.id = ventas.producto_id
    GROUP BY productos.id;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener el balance general (total de ventas - total de compras)
CREATE PROCEDURE getBalanceGeneral(
    OUT balance DECIMAL(10,2)
)
BEGIN
    DECLARE totalVentas DECIMAL(10,2);
    DECLARE totalCompras DECIMAL(10,2);

    SELECT COALESCE(SUM(total_venta), 0) INTO totalVentas FROM ventas;
    SELECT COALESCE(SUM(total_compra), 0) INTO totalCompras FROM compras;

    SET balance = totalVentas - totalCompras;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener la lista de productos con bajo inventario (por ejemplo, menos de 10 unidades)
CREATE PROCEDURE getProductosBajoInventario(
    IN cantidadLimite INT,
    OUT mensaje VARCHAR(255)
)
BEGIN
    SELECT nombre_producto
    FROM inventarios
    JOIN productos ON inventarios.producto_id = productos.id
    WHERE cantidad < cantidadLimite;

    IF ROW_COUNT() > 0 THEN
        SET mensaje = 'Productos con bajo inventario encontrados.';
    ELSE
        SET mensaje = 'Todos los productos tienen inventario suficiente.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$
-- Aplicar un descuento a una venta
CREATE PROCEDURE aplicarDescuentoVenta(
    IN ventaId INT,
    IN porcentajeDescuento DECIMAL(5,2),
    OUT totalVentaConDescuento DECIMAL(10,2)
)
BEGIN
    DECLARE totalVenta DECIMAL(10,2);

    SELECT total_venta INTO totalVenta FROM ventas WHERE id = ventaId;

    SET totalVentaConDescuento = totalVenta - (totalVenta * (porcentajeDescuento / 100));

    UPDATE ventas SET total_venta = totalVentaConDescuento WHERE id = ventaId;
END$$
DELIMITER ;

DELIMITER $$
-- Obtener el total de descuentos aplicados en un rango de fechas
CREATE PROCEDURE getTotalDescuentosPorFecha(
    IN fechaInicio DATE,
    IN fechaFin DATE,
    OUT totalDescuentos DECIMAL(10,2)
)
BEGIN
    SELECT COALESCE(SUM(total_venta - total_venta_con_descuento), 0) INTO totalDescuentos
    FROM ventas
    WHERE fecha_venta BETWEEN fechaInicio AND fechaFin;
END$$
DELIMITER ;
