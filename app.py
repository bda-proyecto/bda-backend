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
        password = sha256_crypt.encrypt(request.form['password'])
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
            cursor = mysql.connection.cursor()
            cursor.callproc('getUsuarioByEmail', (email,))
            usuario_existente = cursor.fetchone()
            cursor.nextset()
            cursor.close()
            
            if usuario_existente:
                flash('Ya existe un usuario con este correo electrónico', 'danger')
                return redirect(url_for('registro'))
                        
            cursor = mysql.connection.cursor()
            # Crear nuevo usuario
            cursor.callproc('insertUsuario', (email, password, rol))
            mysql.connection.commit()
            cursor.nextset()
            cursor.close()
        
            cursor = mysql.connection.cursor()
            # Obtener el ID del usuario recién creado
            cursor.callproc('getUsuarioByEmail', (email,))
            usuario = cursor.fetchone()
            cursor.nextset()
            cursor.close()
            if usuario:
                cursor = mysql.connection.cursor()
                # Crear nuevo cliente asociado al usuario
                cursor.callproc('insertCliente', (nombre, apellido_paterno, apellido_materno, telefono))
                mysql.connection.commit()
                cursor.nextset()
                cursor.close()
                
                cursor = mysql.connection.cursor()
                # Llamada al procedimiento almacenado para obtener el último ID insertado en Clientes
                cursor.callproc('getLastInsertedClienteId')
                cliente_id = cursor.fetchone()[0]
                cursor.nextset()
                cursor.close()

                cursor = mysql.connection.cursor()
                # Actualizar directamente el cliente_id en la tabla de usuarios
                cursor.execute('UPDATE Clientes SET id = %s WHERE id = %s', (cliente_id, usuario[0]))
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

        if data and sha256_crypt.verify(password_candidate, data[0][2]):
            session['logged_in'] = True
            session['cliente_id'] = data[0][0]
            session['user_role'] = data[0][3]
            flash('¡Inicio de sesión exitoso!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Correo electrónico o contraseña incorrectos', 'danger')

    return render_template('login.html')

# Ruta para el panel de control (requiere inicio de sesión y rol de cliente o empleado)
@app.route('/dashboard')
@is_logged_in_with_role(['cliente', 'empleado'])
def dashboard():
    # Obtener el rol del usuario desde la sesión o la base de datos
    user_role = session.get('user_role', None)

    # Seleccionar la plantilla según el rol del usuario
    template_name = 'dashboard_cliente.html' if user_role == 'cliente' else 'dashboard_empleado.html'

    return render_template(template_name)


# Ruta para cerrar sesión
@app.route('/logout')
@is_logged_in_with_role(['cliente', 'empleado'])
def logout():
    session.clear()
    flash('Has cerrado sesión', 'success')
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(debug=True)

