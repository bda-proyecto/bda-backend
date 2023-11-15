USE Tienda;

DELIMITER $$

CREATE PROCEDURE insertCategoria(
	IN nombreCategoria VARCHAR(50)
)
BEGIN
	INSERT INTO Categorias (nombre_categoria)
	VALUES (nombreCategoria);
END$$

CREATE PROCEDURE updateCategoria(
	IN id INT,
	IN nombreCategoria VARCHAR(50)
)
BEGIN
	UPDATE Categorias
	SET nombre_categoria = nombreCategoria
	WHERE id = id;
END$$

CREATE PROCEDURE deleteCategoria(
	IN id INT	
)
BEGIN
	DELETE FROM Categorias
	WHERE id = id;
END$$

CREATE PROCEDURE getCategoriaById(
	IN id INT
)
BEGIN
	SELECT *
	FROM Categorias
	WHERE id = id;
END$$

CREATE PROCEDURE getAllCategorias(
)
BEGIN
	SELECT *
	FROM Categorias;
END$$


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


CREATE PROCEDURE deleteProducto(
	IN id INT
)
BEGIN
       DELETE FROM Productos
       WHERE id = id;
END$$

CREATE PROCEDURE getProductoById(IN id INT)
BEGIN
	SELECT *
	FROM Productos
	WHERE id = id;
END$$

CREATE PROCEDURE getAllProductos()
BEGIN
	SELECT *
	FROM Productos;
END$$

--- Usuarios

CREATE PROCEDURE insertUsuario (
	IN email VARCHAR(100),
	IN password VARCHAR(100),
	IN rol VARCHAR(50)
)
BEGIN
	INSERT INTO Usuarios (email, password, rol)
	VALUES (email, password, rol)
END$$

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

CREATE PROCEDURE deleteUsuario(
	IN id INT
)
BEGIN
	DELETE FROM Usuarios
	WHERE id = id;
END$$

CREATE PROCEDURE getUsuarioById(
	IN id INT
)
BEGIN
	SELECT *
	FROM Usuarios
	WHERE id = id;
END$$

CREATE PROCEDURE getAllUsuarios()
BEGIN
	SELECT *
	FROM Usuarios;
END$$

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

CREATE PROCEDURE deleteCliente(
    IN id INT
)
BEGIN
    DELETE FROM Clientes
    WHERE id = id;
END$$

CREATE PROCEDURE getClienteById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Clientes
    WHERE id = id;
END$$

CREATE PROCEDURE getAllClientes()
BEGIN
    SELECT *
    FROM Clientes;
END$$


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

CREATE PROCEDURE deleteProveedor(
    IN id INT
)
BEGIN
    DELETE FROM Proveedores
    WHERE id = id;
END$$

CREATE PROCEDURE getProveedorById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Proveedores
    WHERE id = id;
END$$

CREATE PROCEDURE getAllProveedores()
BEGIN
    SELECT *
    FROM Proveedores;
END$$

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

CREATE PROCEDURE deleteInventario(
    IN id INT
)
BEGIN
    DELETE FROM Inventarios
    WHERE id = id;
END$$

CREATE PROCEDURE getInventarioById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Inventarios
    WHERE id = id;
END$$

CREATE PROCEDURE getAllInventarios()
BEGIN
    SELECT *
    FROM Inventarios;
END$$


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

CREATE PROCEDURE deleteVenta(
    IN id INT
)
BEGIN
    DELETE FROM Ventas
    WHERE id = id;
END$$

CREATE PROCEDURE getVentaById(
    IN id INT
)
BEGIN
    SELECT *
    FROM Ventas
    WHERE id = id;
END$$

CREATE PROCEDURE getAllVentas()
BEGIN
    SELECT *
    FROM Ventas;
END$$


--- Reportes Financieros

-- Obtener el total de ventas por cliente
CREATE PROCEDURE getVentasTotalesPorCliente()
BEGIN
    SELECT clientes.nombre AS nombre_cliente, SUM(ventas.total_venta) AS total_ventas
    FROM clientes
    JOIN ventas ON clientes.id = ventas.cliente_id
    GROUP BY clientes.id;
END$$

-- Obtener el total de ventas por categoría de productos
CREATE PROCEDURE getVentasTotalesPorCategoria()
BEGIN
    SELECT categorias.nombre_categoria, SUM(ventas.total_venta) AS total_ventas
    FROM categorias
    JOIN productos ON categorias.id = productos.categoria_id
    JOIN ventas ON productos.id = ventas.producto_id
    GROUP BY categorias.id;
END$$

-- Obtener el inventario actual de cada producto
CREATE PROCEDURE getInventarioActual()
BEGIN
    SELECT productos.nombre_producto, inventarios.cantidad
    FROM productos
    JOIN inventarios ON productos.id = inventarios.producto_id;
END$$

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

-- Obtener el total de ventas por producto
CREATE PROCEDURE getVentasTotalesPorProducto()
BEGIN
    SELECT productos.nombre_producto, SUM(ventas.cantidad) AS total_ventas
    FROM productos
    JOIN ventas ON productos.id = ventas.producto_id
    GROUP BY productos.id;
END$$

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



