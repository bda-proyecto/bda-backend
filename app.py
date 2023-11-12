from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

########################## BASE DE DATOS

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'admin'
app.config['MYSQL_PASSWORD'] = '123'
app.config['MYSQL_DB'] = 'Tienda'

mysql = MySQL(app)

########################################


########################### RUTAS CRUD





#######################################



