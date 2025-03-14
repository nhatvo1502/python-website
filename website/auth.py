from flask import Blueprint, render_template, request, flash, redirect, url_for
from .models import User
from werkzeug.security import generate_password_hash, check_password_hash
from . import db
from flask_login import login_user, login_required, logout_user, current_user

auth = Blueprint('auth', __name__)

@auth.route('/login', methods=['GET', 'POST'])
def login():
	if request.method == 'POST':
		email = request.form.get('email')
		password = request.form.get('password')

		user = User.query.filter_by(email=email).first()
		if user:
			if check_password_hash(user.password, password):
				flash('Logged in Successfully!', category='success')
				login_user(user, remember=True)
				return redirect(url_for('views.home'))
			else:
				flash('Incorrect password, try again', category='error')
		else:
			flash('Email does not exist.', category='error')

	return render_template('login.html', user=current_user)

@auth.route('/logout')
@login_required
def logout():
	logout_user()
	return redirect(url_for('auth.login'))

@auth.route('/sign-up', methods=['GET', 'POST'])
def sign_up():
	if request.method == 'POST':
		email = request.form.get('email')
		firstName = request.form.get('firstName')
		password1 = request.form.get('password1')
		password2 = request.form.get('password2')

		user = User.query.filter_by(email=email).first()

		if user:
			flash('Email already exists.', category='error')
		elif len(email) < 4:
			flash('Email must be greater than 3 characters.', category='error')
		elif len(firstName) < 2:
			flash('First name must be greater than 1 characters.', category='error')
		elif password1 !=password2:
			flash('Password don\'t match', category='error')
		elif len(password1) < 7:
			flash('Password must be at least 7 characters.', category='error')
		else:
			new_user = User(email=email, firstName=firstName, password=generate_password_hash(password1, method='pbkdf2:sha256'))
			db.session.add(new_user)
			db.session.commit()
			login_user(new_user, remember=True)
			flash('Account created!', category='success')
			return redirect(url_for('views.home'))

	return render_template('sign_up.html', user=current_user)

@auth.route('/reset-password', methods=['GET', 'POST'])
def reset_password():
	if request.method == 'POST':
		current_password = request.form.get('current_password')
		new_password1 = request.form.get('new_password1')
		new_password2 = request.form.get('new_password2')
		
		if check_password_hash(current_user.password, current_password) == False:
			flash('Incorrect password!', category='error')
		else:
			if len(new_password1) < 7:
				flash('Password must be at least 7 characters.', category='error')
			elif new_password1!=new_password2:
				flash('Password don\'t match', category='error')
			else:
				current_user.password = generate_password_hash(new_password1, method='pbkdf2:sha256')
				db.session.commit()	
				flash('Password  reset succesfully! Please login again.')
				logout_user()
				return redirect(url_for('auth.login'))
	return render_template('reset_password.html', user=current_user)