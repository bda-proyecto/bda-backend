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

mysql = MySQL(app)

########################################


########################### RUTAS CRUD


# Ruta de Autenticación

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido_paterno = request.form['apellido_paterno']
        apellido_materno = request.form['apellido_materno']
        telefono = request.form['telefono']
        email = request.form['email']
        password = sha256_crypt.encrypt(str(request.form['password']))

        # Insertar en la tabla Usuarios
        cur = mysql.connection.cursor()
        cur.execute(
            'INSERT INTO Usuarios (email, password, rol) VALUES (%s, %s, %s)',
            (email, password, 'cliente')
        )
        mysql.connection.commit()

        # Obtener el ID del usuario recién insertado
        cur.execute('SELECT id FROM Usuarios WHERE email = %s', (email,))
        user_id = cur.fetchone()[0]

        # Insertar en la tabla Clientes
        cur.execute(
            'INSERT INTO Clientes (id, nombre, apellido_paterno, apellido_materno, telefono) VALUES (%s, %s, %s, %s, %s)',
            (user_id, nombre, apellido_paterno, apellido_materno, telefono)
        )
        mysql.connection.commit()

        cur.close()

        return redirect(url_for('login'))

    return render_template('register.html')

@app.route('/login', methods=['GET','POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password_candidate = request.form['password']

        cur = mysql.connection.cursor()
        result = cur.execute('SELECT * FROM Usuarios WHERE email = %s', [email])

        if result > 0:
            data = cur.fetchone()
            password = data[2]

            if sha256_crypt.verify(password_candidate, password):
                return redirect(url_for('index'))
            else:
                error = 'Contraseña incorrecta'
                return render_template('login.html', error=error)
        else:
            error = 'Usuario no encontrado'
            return render_template('login.html', error=error)

    return render_template('login.html')

##########

@app.route('/productos')
def productos():
    cur = mysql.connection.cursor()
    result = cur.execute('SELECT * FROM Productos')
    productos = result.fetchall()

    return render_template('productos.html', productos = productos)


@




#######################################



if __name__ == '__main__':
    app.run(debug=True)

