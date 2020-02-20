ARG NODE_VERSION=10-jessie
ARG PYTHON_VERSION=3.7  

#
# --- Build assets with NodeJS
#

FROM node:${NODE_VERSION} AS build

# Superset version to build
ARG SUPERSET_VERSION=0.35.2
ENV SUPERSET_HOME=/var/lib/superset/

# Download source
WORKDIR ${SUPERSET_HOME}
RUN wget -O /tmp/superset.tar.gz https://github.com/apache/incubator-superset/archive/${SUPERSET_VERSION}.tar.gz && \
    tar xzf /tmp/superset.tar.gz -C ${SUPERSET_HOME} --strip-components=1

# Build assets
WORKDIR ${SUPERSET_HOME}
RUN (cd superset/assets && npm install)
RUN (cd superset/assets && npm run build)

#
# --- Build dist package with Python 3
#

FROM python:${PYTHON_VERSION} AS dist

# Copy prebuilt workspace into stage
ENV SUPERSET_HOME=/var/lib/superset/
WORKDIR ${SUPERSET_HOME}
COPY --from=build ${SUPERSET_HOME} .

# Create package to install
RUN python setup.py sdist