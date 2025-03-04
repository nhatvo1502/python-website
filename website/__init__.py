from flask import Flask

def create_app():
	app = Flask(__name__)
	app.config['SECRET_KEY'] = 'awkgebakwbgealawbglwa' #app secret do not share

	from .views import views # import all routes from views
	from .auth import auth # import all auths from auth

	app.register_blueprint(views, url_prefix='/')
	app.register_blueprint(auth, url_prefix='/')

	return app