FROM python:3.11

# Define build arguments to pass DB connection information
ARG DB_USERNAME
ARG DB_PASSWORD
ARG DB_NAME
ARG DB_HOST

# Set environment variables for the app
ENV DB_USERNAME=$DB_USERNAME
ENV DB_PASSWORD=$DB_PASSWORD
ENV DB_NAME=$DB_NAME
ENV DB_HOST=$DB_HOST

WORKDIR /app

COPY . .

RUN pip3 install -r requirements.txt

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "website:create_app()"]