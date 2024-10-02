FROM python:3.12-alpine3.20

LABEL maintainer="numanburakfidan.com"

ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt ./
RUN apk add --update --no-cache postgresql-client && \
	apk add --update --no-cache --virtual .tmp-build-deps \
		build-base postgresql-dev musl-dev && \
	pip install -r requirements.txt && \
	apk del .tmp-build-deps && \
	adduser --disabled-password --no-create-home django-user

COPY app .

RUN chown -R django-user /app

USER django-user

EXPOSE 8000

CMD ["gunicorn", "app.wsgi:application", "--bind", "8000"]

	
