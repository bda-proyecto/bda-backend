-- Usamos la BD Tienda
USE Tienda;

-- Variable para en lugar de usar ; como delimitador o termionador de una secuencia, ahora sean los símbolos $$
DELIMITER $$ 
-- Se crea el procedimiento insertar categoria
CREATE PROCEDURE insertCategoria( 
	-- Parametro de entrada para el nombre de la categoria
    IN nombreCategoria VARCHAR(50) 
)
-- se empieza el SP
BEGIN 
	-- declaramos la variable categoria existente
    DECLARE categoriaExistente INT; 

    -- Verificar si la categoría ya existe
    SELECT COUNT(*) INTO categoriaExistente
    FROM Categorias
    WHERE nombre_categoria = nombreCategoria;

    -- Si la categoría no existe, insertarla (estructura IF)
    IF categoriaExistente = 0 THEN
        INSERT INTO Categorias (nombre_categoria)
        VALUES (nombreCategoria);
    ELSE
        -- Puedes manejar la lógica de error o mensaje aquí, por ejemplo:
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La categoría ya existe';
    END IF;
END $$ 
-- Terminamos el SP al delimitar la terminación de este con $$
DELIMITER ; 

DELIMITER $$

-- Se crea el procedimiento editar categoria
CREATE PROCEDURE updateCategoria(
        -- parámetros de entrada
        IN id INT,
        IN nombreCategoria VARCHAR(50)
)
BEGIN
        -- Actualizar el nombre de la categoria si el insertado y registrado son el mismo en donde el id es el mismo
        UPDATE Categorias
        SET nombre_categoria = nombreCategoria
        WHERE id = id;
END $$

DELIMITER ;


DELIMITER $$
-- Se crea el procedimiento eliminar categoria
CREATE PROCEDURE deleteCategoria( 
	-- Parámetro id de entrada
	IN id INT	
)
BEGIN
	-- Eliminar categoria cuando el id sea el mismo
	DELETE FROM Categorias
	WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
 -- Se crea el procedimiento obtiene categoria por id
CREATE PROCEDURE getCategoriaById(
	-- parámetro de entrada id
	IN id INT 
)
BEGIN
	-- seleccionar todo de categorias si tiene el mismo id registrado e insertado por el usuario
	SELECT *
	FROM Categorias
	WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtiene todas las categorias
CREATE PROCEDURE getAllCategorias(  
)
BEGIN
	-- seleccionar todo de categorias
	SELECT *
	FROM Categorias;
END $$

DELIMITER ;

---  PRODUCTOS

DELIMITER $$
-- se crea el procedimiento insertar producto
CREATE PROCEDURE insertProducto( 
	-- parámetros de entrada
    IN nombreProducto VARCHAR(50), 
    IN descripcion TEXT,
    IN precioCompra DECIMAL(10,2),
    IN precioVenta DECIMAL(10,2),
    IN categoriaId INT,
    IN proveedorId INT,  -- Nuevo parámetro para el proveedor
    IN imagen_path VARCHAR(100) -- Nuevo parámetro para la imagen
)
BEGIN
	-- declaración de variable 
    DECLARE productoExistente INT; 

    -- Verificar si el producto ya existe
    SELECT COUNT(*) INTO productoExistente
    FROM Productos
    WHERE nombre_producto = nombreProducto;

    -- Si el producto no existe, insertarlo
    IF productoExistente = 0 THEN
        INSERT INTO Productos (nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen)
        VALUES (nombreProducto, descripcion, precioCompra, precioVenta, categoriaId, proveedorId, imagen_path);
    ELSE
        -- Manejar la lógica de error o mensaje aquí
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto ya existe';
    END IF;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimeinto para editar un producto
CREATE PROCEDURE updateProducto( 
	-- parámetros de entrada
    IN productoId INT,
    IN nombreProducto VARCHAR(50),
    IN descripcion TEXT,
    IN precioCompra DECIMAL(10,2),
    IN precioVenta DECIMAL(10,2),
    IN categoriaId INT,
    IN proveedorId INT,  -- Nuevo parámetro para el proveedor
    IN imagen_path VARCHAR(100) -- Nuevo parámetro para la imagen
)
BEGIN
	-- actualizar productos cuando los parametros insertados sean los mismos que los registrados cuando id sea igual al id del producto
    UPDATE Productos
    SET nombre_producto = nombreProducto,
        descripcion = descripcion,
        precio_compra = precioCompra,
        precio_venta = precioVenta,
        categoria_id = categoriaId,
        proveedor_id = proveedorId,  -- Agrega esta línea
        imagen = IFNULL(imagen_path, imagen)  -- Modifica esta línea
    WHERE id = productoId;                                 
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento eliminar producto
CREATE PROCEDURE deleteProducto( 
	-- parámetro de entrada id
	IN id INT 
)
BEGIN
	-- eliminar productos donde el parámetro id sea igual al id registrado
       DELETE FROM Productos
       WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtiene producto por id con parámetro de entrada id
CREATE PROCEDURE getProductoById(IN id INT) 
BEGIN
	-- seleccionar todo de productos donde el parámetro id sea igual al id registrado
	SELECT *
	FROM Productos
	WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
 -- se crea el procedimiento obtiene todos los productos
CREATE PROCEDURE getAllProductos()
BEGIN
	-- seleccionar todos los productos
	SELECT *
	FROM Productos;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtiene productos por id del proveedor
CREATE PROCEDURE getProductosByProveedorId( 
	IN proveedorId INT -- parámetro de entrada id proveedor
)
BEGIN
	-- seleccionar todo de productos si el parametro del id proveedor es el mismo que el registrado en la tabla 
	SELECT *
	FROM Productos
	WHERE proveedor_id = proveedorId;
END $$

DELIMITER ;

DELIMITER $$

--- Usuarios

	
-- se crea el procedimiento insertar (agregar) un usuario 
CREATE PROCEDURE insertUsuario ( 
	-- parámetros de entrada
	IN email VARCHAR(100),
	IN password VARCHAR(100),
	IN rol VARCHAR(50)
)
BEGIN
	-- insertar en la tabla usuarios los valores que contienen los parametros de entrada en las columnas correspondinetes
	INSERT INTO Usuarios (email, password, rol)
	VALUES (email, password, rol);
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento editar un usuario
CREATE PROCEDURE updateUsuario ( 
	-- parámetros de entrada
	IN id INT,
	IN email VARCHAR(100),
	IN password VARCHAR(100),
	IN rol VARCHAR(50)
)
BEGIN
	-- actualizar usuarios al establecer el email, password y rol siempre y cuando se tenga el mismo id
	UPDATE Usuarios
	SET email = email,
	    password = password,
	    rol = rol
	WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento eliminar usuario
CREATE PROCEDURE deleteUsuario( 
	IN id INT -- parámetro de entrada id 
)
BEGIN
	-- borrar de usuarios el que tenga el id registrado que se inserto en el parámetro
	DELETE FROM Usuarios
	WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener usuario por id
CREATE PROCEDURE getUsuarioById( 
	IN id INT -- parámetro de entrada id
)
BEGIN
	-- seleccionar todo de usuarios si se tiene el mismo id
	SELECT *
	FROM Usuarios
	WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtiene todos los empleados
CREATE PROCEDURE getAllUsuarios() 
BEGIN
	-- seleccionar todo de usuarios
	SELECT *
	FROM Usuarios;
END $$

DELIMITER ;

-- Cliente


DELIMITER //
-- se crea el procedimiento insertar (agregar) cliente 
CREATE PROCEDURE insertCliente( 
	-- parámetros de entrada
	IN nombre_cliente VARCHAR(100), 
	IN apellido_paterno VARCHAR(100), 
	IN apellido_materno VARCHAR(100), 
	IN telefono INT, 
	IN dir VARCHAR(100))
BEGIN
	-- declaramos variable 
    DECLARE cliente_id INT; 

    -- Insertar cliente
    INSERT INTO Clientes (nombre, apellido_paterno, apellido_materno, telefono)
    VALUES (nombre_cliente, apellido_paterno, apellido_materno, telefono);

    -- Obtener el ID del cliente recién insertado
    SET cliente_id = LAST_INSERT_ID();

    -- Insertar direcciones
    INSERT INTO Direcciones_Clientes (direccion, cliente_id)
    VALUES (dir, cliente_id);
END //
DELIMITER ;

DELIMITER $$
-- se crea el procedimiento editar cliente 
CREATE PROCEDURE updateCliente( 
	-- parámetros de entrada
    IN cliId INT,
    IN nombre VARCHAR(100),
    IN apellidoPaterno VARCHAR(100),
    IN apellidoMaterno VARCHAR(100),
    IN telefono INT(12)
)
BEGIN
	-- actualizar clientes si los parametros de entrada coinciden con alguno de los registrados cuando el id del cliente sea el mismo
    UPDATE Clientes
    SET nombre = nombre,
        apellido_paterno = apellidoPaterno,
        apellido_materno = apellidoMaterno,
        telefono = telefono
    WHERE id = cliId;                                      
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento eliminar cliente 
CREATE PROCEDURE deleteCliente( 
    IN id INT -- parámetro de entrada id
)
BEGIN
	-- borrar de clientes cuando los id coincidan
    DELETE FROM Clientes
    WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtiene cliente por id
CREATE PROCEDURE getClienteById( 
	-- parametro de entrada id
    IN id INT 
)
BEGIN
	-- seleccionar todo cuando los id coincidan
    SELECT *
    FROM Clientes
    WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener todos los clientes
CREATE PROCEDURE getAllClientes()
BEGIN
	-- seleccionar todo de la tabla clientes
    SELECT *
    FROM Clientes;
END $$

DELIMITER ;

--- Direcciones_Clientes


DELIMITER $$
-- se crea el procedimiento obtener todas las direcciones del cliente por id 
CREATE PROCEDURE getAllDireccionesById(
	IN cliente_id INT
)
BEGIN
	-- selecciona todo lo que esta en la tabla clientes siempre que los id coincidan
	SELECT *
	FROM Clientes
	WHERE id = cliente_id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el porocedimient insertar direccion del cliente
CREATE PROCEDURE insertDireccionCliente(
	-- parámetros de entrada
	IN cliente_id INT,
	IN nueva_direccion VARCHAR(100)
)
BEGIN
	-- insertar en direcciones clientes la direccion y id cliente los valores que estan en los parámetros
	INSERT INTO Direcciones_Clientes (direccion, cliente_id)
	VALUES (nueva_direccion, cliente_id);
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento actualizar la direccion del cliente 
CREATE PROCEDURE updateDireccionCliente(
	-- parámetros de entrada
	IN dirId INT,
	IN nueva_direccion VARCHAR(100)
)
BEGIN
	-- actualizar la tabla con la nueva direccion siempre que los id coincidan
	UPDATE Direcciones_Clientes
	SET direccion = nueva_direccion
	WHERE id = dirId;
END $$

DELIMITER ;



-- Proveedores


DELIMITER $$
-- se crea el procedimiento insertar proveedor 
CREATE PROCEDURE insertProveedor(
	-- parámetros de entrada
    IN nombreProveedor VARCHAR(100),
    IN rfcProv VARCHAR(15),
    IN correoProv VARCHAR(50),
    IN telefonoProv INT
)
BEGIN
	-- insertar en proveedores nombre, rfc, email, telefono con los valores de los parámetros
    INSERT INTO Proveedores (nombre, RFC, email, telefono)
    VALUES (nombreProveedor, rfcProv, correoProv, telefonoProv);
END$$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento actualizar proveedor 
CREATE PROCEDURE updateProveedor(
	-- parámetros de entrada
    IN proveedor_id INT,
    IN nombreProveedor VARCHAR(100),
    IN rfcProv VARCHAR(15),
    IN correoProv VARCHAR(50),
    IN telefonoProv INT(12)
)
BEGIN
	-- actualizar proveedores con los nuevos valores que tienen los parámetros siempre y cuando el id coincida
    UPDATE Proveedores
    SET 
        nombre = nombreProveedor,
        RFC = rfcProv,
        email = correoProv,
        telefono = telefonoProv
    WHERE id = proveedor_id;
END$$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento eliminar proveedor
CREATE PROCEDURE deleteProveedor(
	-- parámetro de entrada id
    IN id INT
)
BEGIN
	-- eliminar de proveedores siempre y cuando los id coincidan
    DELETE FROM Proveedores
    WHERE id = id;
END$$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener el proveedor por id 
CREATE PROCEDURE getProveedorById(
	-- parámetro de entrada id 
    IN id INT
)
BEGIN
	-- seleccionar todo de proveedores si los id coinciden
    SELECT *
    FROM Proveedores
    WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener todos los proveedores 
CREATE PROCEDURE getAllProveedores()
BEGIN
	-- seleccionar todo de proveedores
    SELECT *
    FROM Proveedores;
END $$

DELIMITER ;


--- Inventarios


DELIMITER //
-- se crea el procedimiento insertar productos al local
CREATE PROCEDURE insertProductoLocal(
	- parámetros de entrada
    IN p_cantidad INT,
    IN p_local_id INT,
    IN p_producto_id INT,
    IN p_disponibilidad TINYINT,
    IN p_fecha_ingreso DATE
)
BEGIN
	-- insertar en productos locales cantidad, local id, producto id, disponibilidad, fecha ingreso los valores de los parámetros
    INSERT INTO Productos_Locales (cantidad, local_id, producto_id, disponibilidad, fecha_ingreso)
    VALUES (p_cantidad, p_local_id, p_producto_id, p_disponibilidad, p_fecha_ingreso);
END //

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener precio por producto 
CREATE PROCEDURE getPrecioProducto(
	-- parámetro de entrada producto id 
	IN productoId INT
)
BEGIN
	-- seleccionar el precio de venta de productos si los id coinciden
	SELECT precio_venta FROM Productos WHERE id = productoId;
END $$

DELIMITER ;


DELIMITER //
-- se crea el procedimiento almacenado obtener productos de los locales por id del local
CREATE PROCEDURE getProductosLocalesByLocalId(
	-- parámetro de entrada 
    IN p_local_id INT
)
BEGIN
	-- seleccionar todo de productos locales si los id de los locales coinciden
    SELECT * FROM Productos_Locales WHERE local_id = p_local_id;
END //

DELIMITER ;


DELIMITER //
-- se crea el procedimiento obtener productos disponibles por local 
CREATE PROCEDURE getProductosDisponiblesByLocalId(
	-- parámetro de entrada
	IN p_local_id INT
)
BEGIN
	-- seleccionar todo de productos locales si los id de los locales coinciden, la cantidad de productos es mayor a 0 y hay dispobibilidad
	SELECT * FROM Productos_Locales WHERE local_id = p_local_id AND cantidad > 0 
	AND disponibilidad = 1;
END //

DELIMITER ;

DELIMITER //
-- se crea el procedimiento obtener productos en local con parámtero de entrada 
CREATE PROCEDURE obtener_productos_en_local(IN p_local_id INT)
BEGIN
    -- seleccionar el id y nombre del producto de la unión de productos locales y productos si el id del local coincide
    SELECT p.id, p.nombre_producto
    FROM Productos_Locales pl
    JOIN Productos p ON pl.producto_id = p.id
    WHERE pl.local_id = p_local_id;
END //

DELIMITER ;

DELIMITER //
-- se crea el procedimiento desactivar producto del local
CREATE PROCEDURE deactivateProductoLocal(
	-- parámetro de entrada
    IN p_producto_local_id INT
)
BEGIN
	-- actualizar disponibilidad a 0 (que ya no hay) en productos locales si los id coinciden
    UPDATE Productos_Locales SET disponibilidad = 0 WHERE id = p_producto_local_id;
END //

DELIMITER ;

DELIMITER //
-- se crea el procedimiento activar producto del local 
CREATE PROCEDURE activateProductoLocal(
	-- parámetro de entrada
    IN p_producto_local_id INT
)
BEGIN
	-- actualizar disponibilidad a 1 (que si hay) en productos locales si los id coinciden
    UPDATE Productos_Locales SET disponibilidad = 1 WHERE id = p_producto_local_id;
END //

DELIMITER ;

DELIMITER //
-- se crea el procedimiento obtener productos local por id
CREATE PROCEDURE getProductoLocalById(
	-- parámetro de entrada
    IN p_producto_local_id INT
)
BEGIN
	-- seleccionar todo de productos locales si los id coinciden
    SELECT * FROM Productos_Locales WHERE id = p_producto_local_id;
END //

DELIMITER ;


--- Ventas



DELIMITER $$
	-- se crea el procedimiento obtener ventas por id del local
CREATE PROCEDURE getVentasByLocalId(
	-- parámetro de entrada
	IN localId INT
)
BEGIN
	-- seleccionar todo de ventas si los id coinciden
	SELECT * FROM Ventas 
	WHERE local_id = localId;
END $$

DELIMITER ;


DELIMITER $$
-- se crea el procedimiento registrar venta
CREATE PROCEDURE registrar_venta(
	-- parámteros de entrada
    IN p_cliente_id INT,
    IN p_direccion_id INT,
    IN p_tipo_pago_id INT,
    IN p_total_venta DECIMAL(10, 2),
    IN p_empleado_id INT,
    IN p_local_id INT
)
BEGIN
    -- Iniciar transacción
    START TRANSACTION;

    -- Registrar la transacción financiera asociada a la venta
    INSERT INTO Transacciones (tipo_transaccion, monto, fecha_transaccion, usuario_id)
    VALUES ('Venta', p_total_venta, NOW(), p_empleado_id);

    -- Obtener el ID de la transacción registrada
    SET @transaccion_id = LAST_INSERT_ID();

    -- Registrar la venta principal
    INSERT INTO Ventas (cliente_id, fecha_venta, direccion_id, tipo_pago_id, total_venta, empleado_id, transaccion_id, local_id)
    VALUES (p_cliente_id, NOW(), p_direccion_id, p_tipo_pago_id, p_total_venta, p_empleado_id, @transaccion_id, p_local_id);

    -- Obtener el ID de la venta registrada
    SET @venta_id = LAST_INSERT_ID();

    -- Commit de la transacción
    COMMIT;

    -- Devolver el ID de la venta registrado
    SELECT @venta_id AS venta_id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento registrar detalle de la venta
CREATE PROCEDURE registrar_detalle_venta(
	-- parámetros de entrada
    IN p_venta_id INT,
    IN p_producto_id INT,
    IN p_cantidad_producto INT
)
BEGIN
    -- Registrar el detalle de la venta
    INSERT INTO Detalles_Ventas (venta_id, producto_id, cantidad_producto)
    VALUES (p_venta_id, p_producto_id, p_cantidad_producto);

    -- Restar la cantidad vendida de Productos_Locales
    UPDATE Productos_Locales
    SET cantidad = cantidad - p_cantidad_producto
    WHERE producto_id = p_producto_id;
END $$


DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento actualizar venta
CREATE PROCEDURE updateVenta(
	-- parámetros de entrada
    IN id INT,
    IN productoId INT,
    IN clienteId INT,
    IN cantidad INT,
    IN fechaVenta DATE,
    IN totalVenta DECIMAL(10,2)
)
BEGIN
	-- actualizar ventas al poner los valores de los parámteros en los registros correspondientes si los id coinciden
    UPDATE Ventas
    SET producto_id = productoId,
        cliente_id = clienteId,
        cantidad = cantidad,
        fecha_venta = fechaVenta,
        total_venta = totalVenta
    WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- eliminar venta
CREATE PROCEDURE deleteVenta(
	-- parámetro de entrada
    IN id INT
)
BEGIN
	-- borrar todo de ventas si el id coincide
    DELETE FROM Ventas
    WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener venta por id 
CREATE PROCEDURE getVentaById(
	-- parámetro de entrada
    IN id INT
)
BEGIN
	-- seleccionar todo de ventas si coinciden los id
    SELECT *
    FROM Ventas
    WHERE id = id;
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener todas las ventas 
CREATE PROCEDURE getAllVentas()
BEGIN
	-- seleccionar todo de ventas 
    SELECT *
    FROM Ventas;
END $$
DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener todas las ventas por id del local 
CREATE PROCEDURE getAllVentasByLocalId(
	-- parámetro de entrada
	IN localId INT
)
BEGIN
	-- seleccionar todo de venta si los id del local coinciden
	SELECT * FROM Ventas WHERE local_id = localId;
END $$

DELIMITER ;



-- Compras


DELIMITER $$
	-- se crea el procedimiento registrar compra
CREATE PROCEDURE registrar_compra(
    IN proveedorId INT,
    IN totalCompra DECIMAL(10,2),
    IN empleadoId INT,
    IN localId INT
)
BEGIN
	-- se empieza la transacción
    START TRANSACTION;

-- insertar en transacciones tipo de transaccion, monto, fecha de transaccion y usuario id los valores de los parámetros 
    INSERT INTO Transacciones (tipo_transaccion, monto, fecha_transaccion, usuario_id)
    VALUES ('Compra', totalCompra, NOW(), empleadoId);

    -- Obtener el ID
    SET @transaccion_id = LAST_INSERT_ID();

-- insertar en compras el proveedor id, fecha de compra, empleado id, transacción id y local id los valores de los parámetros
    INSERT INTO Compras (proveedor_id, fecha_compra, empleado_id, transaccion_id, local_id)
    VALUES (proveedorId, NOW(), empleadoId, @transaccion_id, localId);

    -- Obtener el ID de la compra
    SET @compra_id = LAST_INSERT_ID();

-- guardar cambios en la transaccion 
    COMMIT;

-- establecer variable de entorno 
    SELECT @compra_id AS compra_id;
END $$	
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento registrar detalle de compra 
CREATE PROCEDURE registrar_detalle_compra(
	-- parámetros de entrada
    IN compraId INT,
    IN productoId INT,
    IN cantidad INT
)
BEGIN
	-- insertar en detalles compras compra id, producto id y cantidad los valores de los parámetros 
    INSERT INTO Detalles_Compras (compra_id, producto_id, cantidad)
    VALUES (compraId, productoId, cantidad);
END $$

DELIMITER ;

DELIMITER $$
-- se crea el procedimiento obtener compras por id del local 
CREATE PROCEDURE getComprasByLocalId(
	-- parámetro de entrada
	IN localId INT
)
BEGIN
	-- seleccionar todo de compras si los id coinciden
	SELECT * FROM Compras WHERE local_id = localId;
END $$

DELIMITER ;


DELIMITER $$
-- se crea el procedimiento actualizar compra
CREATE PROCEDURE updateCompra(
	-- parámetros de entrada
    IN id INT,
    IN proveedorId INT,
    IN fechaCompra DATE,
    IN totalCompra DECIMAL(10,2)
)
BEGIN
	-- actualizar compras donde los registros tengan los valores de los parámetros de entrada si el id coincide
    UPDATE Compras
    SET proveedor_id = proveedorId,
        fecha_compra = fechaCompra,
        total_compra = totalCompra
    WHERE id = id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento eliminar compra
CREATE PROCEDURE deleteCompra(
	-- parámetro de entrada
    IN id INT
)
BEGIN
	-- eliminar de compras si los id coinciden
    DELETE FROM Compras
    WHERE id = id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento obtener compra por id 
CREATE PROCEDURE getCompraById(
	-- parámetro de entrada
    IN id INT
)
BEGIN
	-- seleccionar todo de compras si los id coinciden
    SELECT *
    FROM Compras
    WHERE id = id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento obtener todas las compras
CREATE PROCEDURE getAllCompras()
BEGIN
	-- se selecciona todo de compras
    SELECT *
    FROM Compras;
END $$
DELIMITER ;


-- Detalles de Compras


DELIMITER $$
-- se crea el procedimiento insertar detalles de compras
CREATE PROCEDURE insertDetalleCompra(
	-- parámetros de entrada
    IN compraId INT,
    IN productoId INT,
    IN cantidad INT
)
BEGIN
	-- insertar en detalles compras compra id, producto id y cantidad con los valores de los parámetros
    INSERT INTO Detalles_Compras (compra_id, producto_id, cantidad)
    VALUES (compraId, productoId, cantidad);
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento actualizar detalles de compra
CREATE PROCEDURE updateDetalleCompra(
	-- parámetros de entrada
    IN id INT,
    IN compraId INT,
    IN productoId INT,
    IN cantidad INT
)
BEGIN
	-- actualizar detalles compras en donde los registros tengan los valores de los parámetros si los id coinciden
    UPDATE Detalles_Compras
    SET compra_id = compraId,
        producto_id = productoId,
        cantidad = cantidad
    WHERE id = id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento eliminar detalle de la compra 
CREATE PROCEDURE deleteDetalleCompra(
	-- parámetro de entrada
    IN id INT
)
BEGIN
	-- borrar de detalles compras si los id coinciden
    DELETE FROM Detalles_Compras
    WHERE id = id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento obtener detalles de compra por id 
CREATE PROCEDURE getDetalleCompraById(
	-- parámetro de entrada
    IN id INT
)
BEGIN
	-- seleccionar todo de detalles compras si los id coinciden 
    SELECT *
    FROM Detalles_Compras
    WHERE id = id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento obtener todos los detalles de compras
CREATE PROCEDURE getAllDetallesCompras()
BEGIN
	-- seleccionar todo de detalles de compras
    SELECT *
    FROM Detalles_Compras;
END $$
DELIMITER ;



--- Empleados



DELIMITER $$
	-- se crea el procedimiento obtener empleado por id 
CREATE PROCEDURE getEmpleadoById(
	-- parámetro de entrada
	IN IdEmpleado INT)
BEGIN
	-- seleccionar todo de empleados si el id coincide
	SELECT * FROM Empleados 
	WHERE id = IdEmpleado;
END $$

DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento obtener empleados por id del local
CREATE PROCEDURE getEmpleadosByLocalId(
	-- parámetro de entrada
	IN Id INT)
BEGIN
	-- seleccionar todo de empleados si los id coinciden
	SELECT * FROM Empleados WHERE local_id = Id;
END $$
DELIMITER ;

DELIMITER $$
-- Procedimiento para insertar un nuevo empleado asociado a un usuario
CREATE PROCEDURE insertEmpleadoInLocal(
	-- parámetros de entrada
    IN name VARCHAR(100),
    IN appPaterno VARCHAR(100),
    IN appMaterno VARCHAR(100),
    IN sal DECIMAL(10,2),
    IN puesto VARCHAR(100),
    IN localId INT,
    IN userId INT
)
BEGIN
    -- Insertar un nuevo empleado asociado al usuario
    INSERT INTO Empleados (nombre, apellido_paterno, apellido_materno, salario, puesto, local_id, usuario_id)
    VALUES (name, appPaterno, appMaterno, sal, puesto, localId, userId);
END $$

DELIMITER ;


-- Conseguir Usuario


DELIMITER $$
	-- se crea el procedimiento obtener el usuario con el email
CREATE PROCEDURE getUsuarioByEmail(
	-- parámetro de entrada
	IN correo VARCHAR(100)
)
BEGIN
	-- seleccionar todo de usuarios si los correos coinciden
	SELECT * FROM Usuarios
	WHERE email = correo;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento desactivar empleado 
CREATE PROCEDURE deactivateEmpleado(
	-- parámetro de entrada
IN usuario_id INT
)
BEGIN
	-- actualizar usuarios y poner la variable activo como 0 (no est activo) si los id coinciden
 UPDATE Usuarios
 SET activo = 0
 WHERE id = usuario_id;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento activar empleado 
CREATE PROCEDURE activateEmpleado(
	-- parámetro de entrada
IN usuario_id INT
)
BEGIN
	-- actualizar usuarios y a variable activo como 1 (esta activo) si los id coinciden
 UPDATE Usuarios
 SET activo = 1
 WHERE id = usuario_id;
END $$
DELIMITER ;

-- Actualizar el Empleado
DELIMITER $$
CREATE PROCEDURE updateEmpleado(
	-- parámetros de entrada
	IN IdEmpleado INT,
	IN nombre VARCHAR(100),
	IN appPaterno VARCHAR(100),
	IN appMaterno VARCHAR(100),
	IN salario DECIMAL(10,2),
	IN puesto VARCHAR(100)
)
BEGIN
	-- actualizar los registros de la tabla usuarios si con los valores de los parámteros si los id coinciden
	UPDATE Empleados
	SET nombre = nombre,
	apellido_paterno = appPaterno,
	apellido_materno = appMaterno,
	salario = salario,
	puesto = puesto
	WHERE id = IdEmpleado;
END $$
DELIMITER ;


--- Locales



DELIMITER $$
-- se crea el procedimient obtener local por id 
CREATE PROCEDURE getLocalById(
	-- parámetro de entrada
	IN IdLocal INT
)
BEGIN
	-- seleccionar todo de locales si los id coinciden
	SELECT * FROM Locales
	WHERE id = IdLocal;
END $$

DELIMITER ;

--- Productos

DELIMITER $$
	-- se crea el procedimiento obtener productos 
CREATE PROCEDURE getProductos(
	-- parámetro de entrada
	IN IdLocal INT
)
BEGIN
	-- seleccionar todo de la combinación de tablas de productos y productos locales si el id del local coincide
	SELECT * FROM Productos p JOIN Productos_Locales pl
	ON p.id = pl.producto_id WHERE pl.local_id = IdLocal;
END $$
DELIMITER ;

DELIMITER $$
	-- se crea el procedimiento para desactivar producto
CREATE PROCEDURE deactivateProducto(
	-- parámetro de entrada
	IN IdProductoLocal INT
)
BEGIN
	-- actualizar productos locales al establecer la disponibilidad en o (no hay) si los id coinciden
	UPDATE Productos_Locales
	SET disponibilidad = 0
	WHERE id = IdProductoLocal;
END $$

DELIMITER ;


DELIMITER $$
	-- se crea el procedimiento para activar un producto
CREATE PROCEDURE activateProducto(
	-- parámetro de entrada
        IN IdProductoLocal INT
)
BEGIN
	-- actualizar productos locales al establecer la dispinibilidad en 1 (si hay) si los id coinciden
        UPDATE Productos_Locales
        SET disponibilidad = 1
        WHERE id = IdProductoLocal;
END $$

DELIMITER ;



--- Tipos de pago


DELIMITER $$
	-- se crea el procedimiento obtener tipos de pago 
CREATE PROCEDURE getTiposPagos()
BEGIN
	-- seleccionar todo de la tabla tipos de pago 
	SELECT * FROM Tipos_Pagos;
END $$


DELIMITER ;

-- Direcciones



DELIMITER $
-- se crea el procedimiento obtener direcciones del cliente por su id 
CREATE PROCEDURE getDireccionesByClienteId(
	-- parámetro de entrada 
	IN clienteId INT
)
BEGIN 
	-- se selecciona todo de direcciones clientes si los id del cliente coinciden
	SELECT * FROM Direcciones_Clientes
	WHERE cliente_id = clienteId;
END $$

DELIMITER ;



-- Reporte financiero



DELIMITER //
-- se crea el procedimiento obtener ventas totales por cliente con parámetro de entrada 
CREATE PROCEDURE getTotalSalesByClient(IN clientId INT)
BEGIN
	-- se seleccina nombre, ambos apellidos y en total de las ventas de la combinación de las tablas clientes y ventas si el id del cliente coincide
    SELECT c.nombre, c.apellido_paterno, c.apellido_materno, SUM(v.total_venta) AS total_ventas
    FROM Clientes c
    JOIN Ventas v ON c.id = v.cliente_id
    WHERE c.id = clientId;
END //

DELIMITER ;

DELIMITER //
-- se crea el procedimiento obtener ventas totales por mes
CREATE PROCEDURE GetTotalSalesByMonth()
BEGIN
	-- se selecciona la fecha venta del mes, año y la suma de las ventas totales de ventas agrupándolas por mes y año
    SELECT
        MONTH(fecha_venta) AS mes,
        YEAR(fecha_venta) AS anio,
        SUM(total_venta) AS total_ventas
    FROM Ventas
    GROUP BY mes, anio;
END //

DELIMITER ;


DELIMITER //
-- se crea el procedimiento obtener ventas totales por año 
CREATE PROCEDURE GetTotalSalesByYear()
BEGIN
	-- se selecciona la fecha venta del año y la suma de las ventas totales de ventas agrupándolas por año
    SELECT
        YEAR(fecha_venta) AS anio,
        SUM(total_venta) AS total_ventas
    FROM Ventas
    GROUP BY anio;
END //

DELIMITER ;

