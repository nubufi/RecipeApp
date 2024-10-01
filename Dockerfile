FROM python:3.12-slim

LABEL maintainer="numanburakfidan.com"

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt ./
RUN pip install -r requirements.txt && \
	adduser --disabled-password --no-create-home django-user

COPY app .

RUN chown -R django-user /app

USER django-user

EXPOSE 8000

CMD ["gunicorn", "app.wsgi:application", "--bind", "8000"]

	
