from flask import Flask, render_template, request, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from passlib.hash import sha256_crypt
from functools import wraps

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

        # Ejecutar el procedimiento almacenado para obtener la información del cliente por correo electrónico
        cursor = mysql.connection.cursor()
        result = cursor.callproc('getUsuarioByEmail', (email,))
        data = cursor.fetchall()
        cursor.close()
        cursor = mysql.connection.cursor()
        result = cursor.callproc('getEmpleadoById', (data[0][0],))
        resultado = cursor.fetchall()
        cursor.close()
        print(data)
        print(resultado)
        if data and password_candidate == data[0][2]:
            session['logged_in'] = True
            session['user_id'] = data[0][0]
            session['user_role'] = data[0][3]
            session['local_id'] = resultado[0][6]
            flash('¡Inicio de sesión exitoso!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Correo electrónico o contraseña incorrectos', 'danger')

    return render_template('login.html')

# Ruta para el panel de control (requiere inicio de sesión y rol de cliente o empleado)
@app.route('/dashboard')
@is_logged_in_with_role(['cliente', 'admin', 'empleado_ventas', 'empleado_almacen'])
def dashboard():
    # Obtener el rol del usuario desde la sesión o la base de datos
    user_role = session.get('user_role', None)

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

    return render_template(template_name)



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

# # # # 

if __name__ == '__main__':
    app.run(debug=True)



