FROM python:3.6-slim
SHELL ["/bin/bash", "-xc"]

ENV AIRFLOW_HOME=/usr/local/airflow
ENV AIRFLOW_GPL_UNIDECODE=1
ARG AIRFLOW_DEPS="all"
ARG PYTHON_DEPS=""
ARG BUILD_DEPS="freetds-dev libkrb5-dev libssl-dev libffi-dev libpq-dev git"
ARG APT_DEPS="libsasl2-dev freetds-bin build-essential default-libmysqlclient-dev apt-utils curl rsync netcat locales"

ENV PATH="$HOME/.npm-packages/bin:$PATH"

RUN set -euxo pipefail \
    && apt update \
    && if [ -n "${APT_DEPS}" ]; then apt install -y $APT_DEPS; fi \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt update \
    && apt install -y nodejs \
    && apt autoremove -yqq --purge \
    && apt clean

RUN pip install apache-airflow[aws,hdfs,s3,hive,jdbc,password,postgres,slack,ssh] && whereis airflow && pip install botocore boto3 && pip install awscli --upgrade

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
