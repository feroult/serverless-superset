ARG NODE_VERSION=latest
ARG PYTHON_VERSION=3.7  

#
# --- Build assets with NodeJS
#

FROM node:${NODE_VERSION} AS build

# Superset version to build
ARG SUPERSET_VERSION=0.37.2
ENV SUPERSET_HOME=/var/lib/superset/

# Download source
WORKDIR ${SUPERSET_HOME}
RUN wget -O /tmp/superset.tar.gz https://github.com/apache/incubator-superset/archive/${SUPERSET_VERSION}.tar.gz && \
    tar xzf /tmp/superset.tar.gz -C ${SUPERSET_HOME} --strip-components=1

# Build assets
WORKDIR ${SUPERSET_HOME}
RUN (cd superset-frontend && npm install)
RUN (cd superset-frontend && npm run build)

#
# --- Build dist package with Python 3
#

FROM python:${PYTHON_VERSION} AS dist

# Copy prebuilt workspace into stage
ENV SUPERSET_HOME=/var/lib/superset/
WORKDIR ${SUPERSET_HOME}
COPY --from=build ${SUPERSET_HOME} .
COPY config/requirements-db.txt .

# Patch dependencies (fix bigquery dependency)
RUN sed -i '/six==/c six==1.14.0' requirements.txt

# Create package to install
RUN python setup.py sdist && \
    tar czfv /tmp/superset.tar.gz requirements.txt requirements-db.txt dist

#
# --- Install dist package and finalize app
#

FROM python:${PYTHON_VERSION} AS final

# Configure environment
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONPATH=/etc/superset:/home/superset:$PYTHONPATH \
    SUPERSET_HOME=/var/lib/superset

# Install dependencies
WORKDIR /tmp/superset
COPY --from=dist /tmp/superset.tar.gz .

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        default-libmysqlclient-dev \
        freetds-bin \
        freetds-dev \
        libaio1 \
        libffi-dev \
        libldap2-dev \
        libpq-dev \
        libsasl2-2 \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libssl1.0 && \
    apt-get clean && \
    tar xzf superset.tar.gz && \ 
    pip install dist/*.tar.gz -r requirements-db.txt -r requirements.txt

# Create superset user
RUN groupadd supergroup && \
    useradd -U -m -G supergroup superset && \
    mkdir -p /etc/superset && \
    mkdir -p ${SUPERSET_HOME} && \
    mv superset.tar.gz ${SUPERSET_HOME} && \
    chown -R superset:superset /etc/superset && \
    chown -R superset:superset ${SUPERSET_HOME}

# Configure Filesystem
WORKDIR /home/superset
VOLUME /etc/superset \
       /home/superset \
       /var/lib/superset

USER superset
CMD ["bash"]
