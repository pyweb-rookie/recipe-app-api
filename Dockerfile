FROM python:3.9-alpine3.13
LABEL maintainer="dracokal"

ENV PYTHONBUFFERED 1
#copy req from local machine to tmp address
COPY ./requirements.txt /tmp/requirements.txt
COPY ./req.dev.txt /tmp/req.dev.txt
#copy app from local to app docker image
COPY ./app /app
#dir from which all the commands will be executed
WORKDIR /app
#8000 is the port
EXPOSE 8000

ARG DEV=false
# virtual env to store dependencies
RUN python -m venv /py && \
#upgrade the pip
    /py/bin/pip install --upgrade pip && \
# install the req inside the docker image
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [$DEV = 'true']; \
        then /py/bin/pip install -r /tmp/req.dev.txt ; \
    fi && \
# remove tmp directory
    rm -rf /tmp && \
# adds new user in the docker image, not to use the root user
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# updating the PATH env var 
ENV PATH="/py/bin:$PATH"

# to switch to temp user defined above and not as root user, root user has full access
USER django-user