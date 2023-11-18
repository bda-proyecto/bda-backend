from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from passlib.hash import sha256_crypt
from functools import wraps
import os

app = Flask(__name__)

########################## BASE DE DATOS

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'admin'
app.config['MYSQL_PASSWORD'] = '123'
app.config['MYSQL_DB'] = 'Tienda'

app.secret_key = '123##'

mysql = MySQL(app)

########################################

########################### RUTAS CRUD

# Función decoradora para verificar si el usuario está autenticado
def is_logged_in_with_role(roles):
    def decorator(f):
        @wraps(f)
        def wrap(*args, **kwargs):
            if 'logged_in' in session:
                # Obtener el rol del usuario desde la sesión o la base de datos
                user_role = session.get('user_role', None)

                # Verificar si el rol del usuario está en la lista de roles permitidos
                if user_role in roles:
                    return f(*args, **kwargs)
                else:
                    flash('Acceso no autorizado para este rol', 'danger')
                    return redirect(url_for('dashboard'))
            else:
                flash('Inicia sesión para acceder a esta página', 'danger')
                return redirect(url_for('login'))
        return wrap
    return decorator

@app.route('/registro', methods=['GET', 'POST'])
def registro():
    if request.method == 'POST':
        # Obtener datos del formulario
        email = request.form['email']
        password = request.form['password']
        rol = 'cliente'  # Por defecto, los registros son de tipo 'cliente'

        # Validar campos del cliente
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellidoPaterno']
        apellido_materno = request.form['apellidoMaterno']
        telefono = request.form['telefono']

        if not (nombre and apellido_paterno and apellido_materno and telefono):
            flash('Todos los campos son obligatorios', 'danger')
            return redirect(url_for('registro'))

        try:
            # Verificar si el usuario ya existe
            if usuario_existe(email):
                flash('Ya existe un usuario con este correo electrónico', 'danger')
                return redirect(url_for('registro'))

            # Crear nuevo usuario
            crear_usuario(email, password, rol)

            # Obtener el ID del usuario recién creado
            usuario_id = obtener_id_usuario(email)

            if usuario_id:
                # Crear nuevo cliente asociado al usuario
                cursor = mysql.connection.cursor()
                cursor.callproc('insertCliente', (nombre, apellido_paterno, apellido_materno, telefono, usuario_id))
                mysql.connection.commit()
                cursor.nextset()
                cursor.close()

                # Obtener el último ID insertado en Clientes
                cursor = mysql.connection.cursor()
                cursor.callproc('getLastInsertedClienteId')
                cliente_id = cursor.fetchone()[0]
                cursor.nextset()
                cursor.close()

                # Actualizar directamente el cliente_id en la tabla de usuarios
                cursor = mysql.connection.cursor()
                cursor.execute('UPDATE Clientes SET id = %s WHERE id = %s', (cliente_id, usuario_id))
                mysql.connection.commit()
                cursor.close()

                flash('Registro exitoso. Inicia sesión para continuar.', 'success')
                return redirect(url_for('login'))
        except Exception as e:
            # Manejar cualquier error
            flash('Ocurrió un error durante el registro.', 'danger')
            print(f"Error: {e}")

        finally:
            cursor.close()

    return render_template('registro.html')

# Ruta para el inicio de sesión de clientes
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Obtener datos del formulario
        email = request.form['email']
        password_candidate = request.form['password']

        # Ejecutar el procedimiento almacenado para obtener la información del usuario por correo electrónico
        cursor = mysql.connection.cursor()
        result = cursor.callproc('getUsuarioByEmail', (email,))
        data = cursor.fetchall()
        cursor.close()

        if data and (data[0][3] == 'empleado' or data[0][3] == 'admin'):
            # Si es un empleado, obtener su información adicional
            cursor = mysql.connection.cursor()
            result = cursor.callproc('getEmpleadoById', (data[0][0],))
            empleado_data = cursor.fetchall()
            cursor.close()
        else:
            empleado_data = None

        if data and password_candidate == data[0][2] and data[0][4]:  # Verificar contraseña y que el usuario esté activo
            session['logged_in'] = True
            session['user_id'] = data[0][0]
            session['user_role'] = data[0][3]
            if empleado_data:
                session['local_id'] = empleado_data[0][6]
                print(empleado_data[0][6])
            flash('¡Inicio de sesión exitoso!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Correo electrónico o contraseña incorrectos o cuenta desactivada', 'danger')

    return render_template('login.html')

# Ruta para el panel de control (requiere inicio de sesión y rol de cliente o empleado)
@app.route('/dashboard')
@is_logged_in_with_role(['cliente', 'admin', 'empleado_ventas', 'empleado_almacen'])
def dashboard():
    # Obtener el rol del usuario desde la sesión o la base de datos
    user_role = session.get('user_role', None)
    local_id = session.get('local_id', None)

    local = obtener_local(local_id)
    print(local)
    print(local_id)
    # Seleccionar la plantilla según el rol del usuario
    if user_role == 'cliente':
        template_name = 'dashboard_cliente.html'
    elif user_role == 'admin':
        template_name = 'dashboard_admin.html'
    elif user_role == 'empleado_ventas':
        template_name = 'dashboard_empleado_ventas.html'
    elif user_role == 'empleado_almacen':
        template_name = 'dashboard_empleado_almacen.html'
    else:
        # Manejar el caso de un rol desconocido
        flash('Rol desconocido', 'danger')
        return redirect(url_for('login'))

    return render_template(template_name, local=local)



# Ruta para cerrar sesión
@app.route('/logout')
@is_logged_in_with_role(['cliente', 'empleado'])
def logout():
    session.clear()
    flash('Has cerrado sesión', 'success')
    return redirect(url_for('login'))

#######################################################
#           EMPLEADOS
#######################################################

# Ruta para obtener todos los empleados
@app.route('/empleados')
@is_logged_in_with_role(['admin'])
def obtener_empleados():
    admin_id = session.get('user_id', None)
    local_id = session.get('local_id', None)
    empleados = getEmpleados(local_id)
    return render_template('empleados_local.html', empleados=empleados)

@app.route('/create_empleado', methods=['GET','POST'])
@is_logged_in_with_role(['admin'])
def crear_empleado():
    local_id = session.get('local_id', None)
    if request.method == 'GET':
        return render_template('crear_empleado.html')
    if request.method == 'POST':
        # Obtener datos del formulario
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        salario = request.form['salario']
        puesto = request.form['puesto']
        email = request.form['email']
        password = request.form['password']
        
        try:
            # Verificar si el usuario ya existe
            if usuario_existe(email):
                flash('Ya existe un usuario con este correo electrónico', 'danger')
                return redirect(url_for('crear_empleado'))

            # Crear nuevo usuario
            crear_usuario(email, password, rol=puesto)

            # Obtener el ID del usuario recién creado
            usuario_id = obtener_id_usuario(email)
            print(usuario_id)
            if usuario_id:
                # Crear nuevo empleado asociado al usuario
                cursor = mysql.connection.cursor()
                cursor.callproc('insertEmpleadoInLocal', (nombre, apellido_paterno, apellido_materno, salario, puesto, local_id, usuario_id))
                mysql.connection.commit()
                cursor.nextset()
                cursor.close()

                flash('Empleado creado exitosamente', 'success')
                return redirect(url_for('crear_empleado'))
        except Exception as e:
            # Manejar cualquier error
            flash('Ocurrió un error al crear el empleado.', 'danger')
            print(f"Error: {e}")
        
        flash('Empleado creado exitosamente', 'success')
        return redirect(url_for('crear_empleado'))

@app.route('/editar_empleado/<int:empleado_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def editar_empleado(empleado_id):
    if request.method == 'GET':
        # Obtener información del empleado
        empleado = obtener_empleado_por_id(empleado_id)

        if empleado:
            return render_template('editar_empleado.html', empleado=empleado)
        else:
            flash('Empleado no encontrado', 'danger')
            return redirect(url_for('obtener_empleados'))

    elif request.method == 'POST':
        # Obtener datos del formulario
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        salario = request.form['salario']
        puesto = request.form['puesto']

        try:
            # Actualizar información del empleado
            actualizar_empleado(empleado_id, nombre, apellido_paterno, apellido_materno, salario, puesto)

            flash('Empleado actualizado exitosamente', 'success')
            return redirect(url_for('obtener_empleados'))

        except Exception as e:
            # Manejar cualquier error
            flash('Ocurrió un error al actualizar el empleado.', 'danger')
            print(f"Error: {e}")

    return redirect(url_for('obtener_empleados'))


@app.route('/desactivar_empleado/<int:empleado_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def desactivar_empleado(empleado_id):
    try:
        desactivar_empleado(empleado_id)
        flash('Empleado desactivado exitosamente', 'success')
    except Exception as e:
        flash('Ocurrió un error al desactivar el empleado.', 'danger')
        print(f"Error: {e}")
    
    return redirect(url_for('obtener_empleados'))

@app.route('/activar_empleado/<int:empleado_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def activar_empleado(empleado_id):
    try:
        activar_empleado(empleado_id)
        flash('Empleado activado exitosamente', 'success')
    except Exception as e:
        flash('Ocurrió un error al activar el empleado.', 'danger')
        print(f"Error: {e}")

    return redirect(url_for('obtener_empleados'))

#######################################################
#          CATEGORIAS
#######################################################
@app.route('/categorias')
@is_logged_in_with_role(['admin'])
def obtener_categorias():
    categorias = get_categorias()
    return render_template('categorias.html', categorias=categorias)

# Ruta para crear una nueva categoría
@app.route('/crear_categoria', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def crear_categoria():
    if request.method == 'POST':
        nombre_categoria = request.form['nombre_categoria']
        create_categoria(nombre_categoria)
        return redirect(url_for('obtener_categorias'))
    return render_template('crear_categoria.html')

# Ruta para editar una categoría
@app.route('/editar_categoria/<int:categoria_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def editar_categoria(categoria_id):
    if request.method == 'GET':
        categoria = obtener_categoria_id(categoria_id)
        return render_template('editar_categoria.html', categoria=categoria)

    elif request.method == 'POST':
        nombre_categoria = request.form['nombre_categoria']
        edit_categoria(categoria_id, nombre_categoria)
        flash('Categoría actualizada exitosamente', 'success')
        return redirect(url_for('obtener_categorias'))

#######################################################
#           PROVEEDORES
#######################################################

# Ruta para obtener todos los proveedores
@app.route('/proveedores')
@is_logged_in_with_role(['admin'])
def obtener_proveedores():
    proveedores = obtener_proveedores()
    return render_template('proveedores.html', proveedores=proveedores)

# Ruta para crear un nuevo proveedor
@app.route('/crear_proveedor', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def crear_proveedor():
    if request.method == 'POST':
        nombreProveedor = request.form['nombreProveedor']
        rfcProv = request.form['rfcProv']
        correoProv = request.form['correoProv']
        telefonoProv = request.form['telefonoProv']
        
        # Llama a la función para crear el proveedor
        crear_proveedor(nombreProveedor, rfcProv, correoProv, telefonoProv)
        return redirect(url_for('obtener_proveedores'))

    return render_template('crear_proveedor.html')

# Ruta para editar un proveedor
@app.route('/editar_proveedor/<int:proveedor_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def editar_proveedor(proveedor_id):
    if request.method == 'GET':
        proveedor = obtener_proveedor_id(proveedor_id)
        return render_template('editar_proveedor.html', proveedor=proveedor)

    elif request.method == 'POST':
        nombreProveedor = request.form['nombreProveedor']
        rfcProv = request.form['rfcProv']
        correoProv = request.form['correoProv']
        telefonoProv = request.form['telefonoProv']

        # Llama a la función para editar el proveedor
        editar_proveedor(proveedor_id, nombreProveedor, rfcProv, correoProv, telefonoProv)
        flash('Proveedor actualizado exitosamente', 'success')
        return redirect(url_for('obtener_proveedores'))

#######################################################
#           PRODUCTOS
#######################################################

@app.route('/productos')
@is_logged_in_with_role(['admin'])
def obtener_productos():
    admin_id = session.get('user_id', None)
    local_id = session.get('local_id', None)
    productos = obtener_productos()
    return render_template('productos_local.html', productos=productos)

@app.route('/desactivar_producto/<int:producto_local_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def desactivar_producto(producto_local_id):
    try:
        desactivar_producto(producto_local_id)
        flash('Producto desactivado exitosamente', 'success')
    except Exception as e:
        flash('Ocurrió un error al activar el producto.', 'danger')
        print(f"Error: {e}")

    return redirect(url_for('obtener_productos_locales'))

@app.route('/activar_producto/<int:producto_local_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def activar_producto(producto_local_id):
    try:
        activar_producto(producto_local_id)
        flash('Producto activado exitosamente', 'success')
    except Exception as e:
        flash('Ocurrió un error al activar el producto.', 'danger')
        print(f"Error: {e}")

    return redirect(url_for('obtener_productos_locales'))

# Ruta para la creación de un nuevo producto
@app.route('/crear_producto', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def crear_producto():
    if request.method == 'POST':
        nombre_producto = request.form['nombre_producto']
        descripcion = request.form['descripcion']
        precio_compra = request.form['precio_compra']
        precio_venta = request.form['precio_venta']
        categoria_id = request.form['categoria_id']
        proveedor_id = request.form['proveedor_id']  # Agrega esta línea
        imagen = request.files['imagen']

        # Verifica si la imagen está presente en la solicitud
        if imagen:
            # Guarda la imagen en el directorio
            imagen_filename = os.path.join('static/images/productos', imagen.filename)
            imagen.save(imagen_filename)
        else:
            # Si no se proporciona una imagen, puedes asignar un valor predeterminado o manejarlo según tus necesidades.
            imagen_filename = 'static/images/productos/default.jpg'
        print(proveedor_id)
        # Llama a la función para crear el producto
        crear_producto(nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen_filename)
        return redirect(url_for('obtener_productos'))

    # Obtén la lista de categorías y proveedores para el formulario
    categorias = get_categorias()
    proveedores = obtener_proveedores()  # Agrega esta línea
    return render_template('crear_producto.html', categorias=categorias, proveedores=proveedores)

# Ruta para la edición de un producto
@app.route('/editar_producto/<int:producto_id>', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin'])
def editar_producto(producto_id):
    if request.method == 'GET':
        # Obtener información del producto
        producto = obtener_producto_id(producto_id)

        if producto:
            # Obtener la lista de categorías y proveedores para el formulario
            categorias = get_categorias()
            proveedores = obtener_proveedores()
            return render_template('editar_producto.html', producto=producto, categorias=categorias, proveedores=proveedores)
        else:
            flash('Producto no encontrado', 'danger')
            return redirect(url_for('obtener_productos'))

    elif request.method == 'POST':
        # Obtener datos del formulario
        nombre_producto = request.form['nombre_producto']
        descripcion = request.form['descripcion']
        precio_compra = request.form['precio_compra']
        precio_venta = request.form['precio_venta']
        categoria_id = request.form['categoria_id']
        proveedor_id = request.form['proveedor_id']  # Agrega esta línea

        # Manejar la carga de la imagen
        imagen = request.files['imagen']
        imagen_filename = imagen.filename if imagen else None  # Modifica esta línea

        # Verifica si la imagen está presente en la solicitud
        if imagen:
            # Guarda la imagen en el directorio
            imagen_filename = os.path.join('static/images/productos', imagen.filename)
            imagen.save(imagen_filename)
            imagen_filename = imagen.filename
        else:
            # Si no se proporciona una imagen, puedes asignar un valor predeterminado o manejarlo según tus necesidades.
            imagen_filename = 'default.jpg'

        # Llamar a la función para editar el producto
        editar_producto(producto_id, nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen_filename)
        flash('Producto actualizado exitosamente', 'success')
        return redirect(url_for('obtener_productos'))

########################################################
#               PRODUCTOS_LOCALES
####################################################
@app.route('/productos_locales')
@is_logged_in_with_role(['admin', 'empleado_almacen'])
def obtener_productos_locales():
    local_id = session.get('local_id', None)
    productos_locales = obtener_productos_locales(local_id)
    return render_template('productos_locales.html', productos_locales=productos_locales)

# Ruta para agregar un producto local
@app.route('/agregar_producto_local', methods=['GET', 'POST'])
@is_logged_in_with_role(['admin', 'empleado_almacen'])
def agregar_producto_local():
    local_id = session.get('local_id', None)
    if request.method == 'POST':
        cantidad = request.form['cantidad']
        producto_id = request.form['producto_id']
        fecha_ingreso = request.form['fecha_ingreso']

        # Llama a la función para agregar el producto local
        agregar_producto_local(cantidad, local_id, producto_id, 1, fecha_ingreso)
        return redirect(url_for('obtener_productos_locales'))

    # Obtén la lista de productos para el formulario
    productos = obtener_productos()
    return render_template('agregar_producto_local.html', productos=productos)

####
# Métodos Auxiliares


# Función para verificar si un usuario ya existe por correo electrónico
def usuario_existe(email):
    cursor = mysql.connection.cursor()
    cursor.callproc('getUsuarioByEmail', (email,))
    usuario_existente = cursor.fetchone()
    cursor.nextset()
    cursor.close()
    return usuario_existente

# Función para crear un nuevo usuario
def crear_usuario(email, password, rol='cliente'):
    cursor = mysql.connection.cursor()
    cursor.callproc('insertUsuario', (email, password, rol))
    mysql.connection.commit()
    cursor.nextset()
    cursor.close()

# Función para obtener el ID de un usuario por correo electrónico
def obtener_id_usuario(email):
    cursor = mysql.connection.cursor()
    cursor.callproc('getUsuarioByEmail', (email,))
    usuario = cursor.fetchone()
    cursor.nextset()
    cursor.close()
    return usuario[0] if usuario else None


# Obtener Empleados
def getEmpleados(id):
    cursor = mysql.connection.cursor()
    resultado = cursor.callproc('getEmpleadosByLocalId',(id,))
    empleados = cursor.fetchall()
    cursor.close()
    return empleados

def createEmpleado(nombre, apellido_paterno, apellido_materno, salario, puesto, localid):
    cursor = mysql.connection.cursor()
    resultado = cursor.callproc('insertEmpleadoInLocal',(nombre, apellido_paterno, apellido_materno, salario, puesto, localid,))
    cursor.commit()
    cursor.close()

# Función para obtener información de un empleado por su ID
def obtener_empleado_por_id(empleado_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getEmpleadoById', (empleado_id,))
    empleado = cursor.fetchone()
    cursor.close()
    return empleado

# Función para actualizar información de un empleado
def actualizar_empleado(empleado_id, nombre, apellido_paterno, apellido_materno, salario, puesto):
    cursor = mysql.connection.cursor()
    cursor.callproc('updateEmpleado', (empleado_id, nombre, apellido_paterno, apellido_materno, salario, puesto))
    mysql.connection.commit()
    cursor.close()

# Función para desactivar el usuario de un empleado
def desactivar_empleado(usuario_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('deactivateEmpleado', (usuario_id,))
    mysql.connection.commit()
    cursor.close()

# Función para activar el usuario de un empelado
def activar_empleado(usuario_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('activateEmpleado', (usuario_id,))
    mysql.connection.commit()
    cursor.close()

### Local

def obtener_local(local_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getLocalById', (local_id,))
    local = cursor.fetchone()
    return local

### Categorias

def create_categoria(nombre_categoria):
    try:
        # Llamar al procedimiento almacenado insertCategoria
        cursor = mysql.connection.cursor()
        cursor.callproc('insertCategoria', (nombre_categoria,))
        mysql.connection.commit()
        cursor.close()
        flash('Categoría creada exitosamente', 'success')
    except Exception as err:
        # Manejar la excepción (por ejemplo, categoría existente)
        flash(f'Ocurrió un error: {err}', 'danger')

def edit_categoria(categoria_id, nombre_categoria):
    try:
        # Llamar al procedimiento almacenado updateCategoria
        cursor = mysql.connection.cursor()
        cursor.callproc('updateCategoria', (categoria_id, nombre_categoria))
        mysql.connection.commit()
        cursor.close()
        flash('Categoría actualizada exitosamente', 'success')
    except Exception as err:
        # Manejar la excepción
        flash(f'Ocurrió un error: {err}', 'danger')

def get_categorias():
    cursor = mysql.connection.cursor()
    cursor.callproc('getAllCategorias')
    categorias = cursor.fetchall()
    cursor.close()
    return categorias

def obtener_categoria_id(categoria_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getCategoriaById',(categoria_id,))
    categoria = cursor.fetchone()
    return categoria

### Proveedores

def obtener_proveedores():
    cursor = mysql.connection.cursor()
    cursor.callproc('getAllProveedores')
    proveedores = cursor.fetchall()
    cursor.close()
    return proveedores


def obtener_proveedor_id(proveedor_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getProveedorById',(proveedor_id,))
    proveedor = cursor.fetchone()
    cursor.close()
    return proveedor

def crear_proveedor(nombreProveedor, rfcProv, correoProv, telefonoProv):
    cursor = mysql.connection.cursor()
    cursor.callproc('insertProveedor', (nombreProveedor, rfcProv, correoProv, telefonoProv))
    mysql.connection.commit()
    cursor.close()

def editar_proveedor(proveedor_id, nombreProveedor, rfcProv, correoProv, telefonoProv):
    cursor = mysql.connection.cursor()
    cursor.callproc('updateProveedor', (proveedor_id, nombreProveedor, rfcProv, correoProv, telefonoProv))
    mysql.connection.commit()
    cursor.close()



### Productos

def obtener_productos():
    cursor = mysql.connection.cursor()
    cursor.callproc('getAllProductos')
    productos = cursor.fetchall()
    return productos
   
def desactivar_producto(productolocal_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('deactivateProducto',(productolocal_id,))
    mysql.connection.commit()
    cursor.close()

def activar_producto(productolocal_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('activateProducto',(productolocal_id,))
    mysql.connection.commit()
    cursor.close()

# Función para crear un nuevo producto
def crear_producto(nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen_referencia):
    try:
        # Llama al procedimiento almacenado insertProducto
        cursor = mysql.connection.cursor()
        cursor.callproc('insertProducto', (nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen_referencia))
        mysql.connection.commit()
        cursor.close()
        flash('Producto creado exitosamente', 'success')
    except Exception as err:
        # Maneja la excepción
        flash(f'Ocurrió un error: {err}', 'danger')

def editar_producto(producto_id, nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen_filename):
    try:
        # Lllama al procedimiento almacenado updateProducto
        cursor = mysql.connection.cursor()
        cursor.callproc('updateProducto', (producto_id, nombre_producto, descripcion, precio_compra, precio_venta, categoria_id, proveedor_id, imagen_filename))
        mysql.connection.commit()
        cursor.close()
        flash('Producto editado correctamente', 'success')
    except Exception as err:
        flash(f'Ocurrio un error: {err}','danger')

def obtener_producto_id(producto_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getProductoById',(producto_id,))
    producto = cursor.fetchone()
    cursor.close()
    return producto

## Productos en Locales

def agregar_producto_local(cantidad, local_id, producto_id, disponibilidad, fecha_ingreso):
    try:
        cursor = mysql.connection.cursor()
        cursor.callproc('insertProductoLocal', (cantidad, local_id, producto_id, disponibilidad, fecha_ingreso))
        mysql.connection.commit()
        cursor.close()
        flash('Producto local agregado exitosamente', 'success')
    except Exception as err:
        flash(f'Ocurrió un error: {err}', 'danger')

def obtener_productos_locales(local_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getProductosLocalesByLocalId', (local_id,))
    productos_locales = cursor.fetchall()
    cursor.close()
    return productos_locales

def desactivar_producto_local(producto_local_id):
    try:
        cursor = mysql.connection.cursor()
        cursor.callproc('deactivateProductoLocal', (producto_local_id,))
        mysql.connection.commit()
        cursor.close()
        flash('Producto local desactivado exitosamente', 'success')
    except Exception as err:
        flash(f'Ocurrió un error: {err}', 'danger')

def activar_producto_local(producto_local_id):
    try:
        cursor = mysql.connection.cursor()
        cursor.callproc('activateProductoLocal', (producto_local_id,))
        mysql.connection.commit()
        cursor.close()
        flash('Producto local activado exitosamente', 'success')
    except Exception as err:
        flash(f'Ocurrió un error: {err}', 'danger')

def obtener_producto_local_por_id(producto_local_id):
    cursor = mysql.connection.cursor()
    cursor.callproc('getProductoLocalById', (producto_local_id,))
    producto_local = cursor.fetchone()
    cursor.close()
    return producto_local


# # # # 

if __name__ == '__main__':
    app.run(debug=True)



