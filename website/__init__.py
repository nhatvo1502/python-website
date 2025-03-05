from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from os import path
import os

db = SQLAlchemy()
DB_NAME = "database.db"

def create_app():
	app = Flask(__name__)
	app.config['SECRET_KEY'] = 'awkgebakwbgealawbglwa' #app secret do not share
   
	app.config['SQLALCHEMY_DATABASE_URI'] = f'sqlite:///{DB_NAME}'
	db.init_app(app)

	from .views import views # import all routes from views
	from .auth import auth # import all auths from auth

	app.register_blueprint(views, url_prefix='/')
	app.register_blueprint(auth, url_prefix='/')

	from .models import User, Note
	create_database(app)

	return app

def create_database(app):
    # Check if the database exists, if not, create it
    print('create_database is running')
    if not path.exists('website/' + DB_NAME):
        # Use the app context to create all tables
        with app.app_context():
            db.create_all()
            print('Created Database!')