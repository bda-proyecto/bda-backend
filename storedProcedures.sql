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
	IN categoriaId INT
)
BEGIN
	UPDATE Productos
	SET nombre_producto = nombreProducto,
	descripcion = descripcion,
	precio_compra = precioCompra,
	precio_venta = precioVenta,
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
	UPDATE Usuario
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

)



