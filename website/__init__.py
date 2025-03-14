from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from os import path
import os
from flask_login import LoginManager
from sqlalchemy_utils import database_exists, create_database

db = SQLAlchemy()
DB_USERNAME = "admin"
DB_PASSWORD = "password"
DB_HOST = "nnote-database.cyhfgtpbee5r.us-east-1.rds.amazonaws.com"
DB_NAME = "nnote_database"


def create_app():
	app = Flask(__name__)
	app.config['SECRET_KEY'] = 'awkgebakwbgealawbglwa' #app secret do not share
	url = f"mysql+pymysql://{DB_USERNAME}:{DB_PASSWORD}@{DB_HOST}/{DB_NAME}"
	app.config['SQLALCHEMY_DATABASE_URI'] = url
	
	db.init_app(app)

	from .views import views # import all routes from views
	from .auth import auth # import all auths from auth

	app.register_blueprint(views, url_prefix='/')
	app.register_blueprint(auth, url_prefix='/')

	from .models import User, Note
	create_db(url, app)

	login_manager = LoginManager()
	login_manager.login_view = 'auth.login'
	login_manager.init_app(app)

	@login_manager.user_loader
	def load_user(id):
		return User.query.get(int(id))

	return app

def create_db(url, app):
    # Check if the database exists, if not, create it
    print('create_database is running')
    if not database_exists(url):
        create_database(url)
        # Use the app context to create all tables
        with app.app_context():
            db.create_all()
            print('Created Database!')