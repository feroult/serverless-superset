# Serverless Superset on Google Cloud

For a more detailed guide on how to deploy [Apache Superset (Incubating)](https://superset.incubator.apache.org/) on Google Cloud refere tho this [blog post](https://medium.com/@feroult/serverless-superset-on-google-cloud-87d3cf324845).

## TL;DR Instructions

1. You can start by creating the following environment variables:

```Bash
export PROJECT_ID="<your project id>"
export VPC_NETWORK="superset-network"
export REGION="europe-west1"
export SHORT_REGION="europe-west"
export ZONE="europe-west1-b"
export REDIS_INSTANCE_NAME="superset"
export SQL_INSTANCE_NAME="webapps-configs"
export SQL_DATABASE="superset"
export SQL_USER="superset"
export SQL_PASSWORD=`openssl rand -base64 15`
echo "Your password is $SQL_PASSWORD";
```

Don't worry about the password, if you follow all the steps in the same session, it will get written in the `config\app.yaml` file created in the 7th point.

2. Don't forget to update the project in gcloud tools (maybe create rather a configuration):

```Bash
gcloud config set project ${PROJECT_ID}
gcloud auth configure-docker
```

3. Building Superset.

Creates a one-time cloud build to create the docker image we are going to be working with (version 0.37.2).
To build a different version, change the Dockerfile

```Bash
source scripts/build.sh
```

4. Setup VPC (Networking).

Creates a VPC network to allow private communication between AppEngine and Redis and Cloud SQL. Also creates private addresses for VPC_PEERING and allows connection to the redis and Cloud SQL via those addresses. Finally it creates a firewall-rule to allow ssh connection to the machines inside of the network.

```Bash
source scripts/setup_network.sh
```

5. Setup Memorystore (Redis).

Creates a redis instance and saves the IP into REDIS_HOST environment variable.

```Bash
source scripts/setup_redis.sh
```

6. Setup Cloud SQL.

Creates a PostgreSQL (Version 12) instance, then it creates a database inside, and a user to connect to it. Finally it saves the IP into SQL_HOST environment variable.

```Bash
source scripts/setup_sql.sh
```

7. Create the `config/app.yaml` file.

It uses the `config/app-template.yaml` file and substitutes all the environment variables necessary to create the configuration file to deploy the app engine. Also, initializes the app engine in the project if it have never been configured before. Another side effect of creating the app engine for the first time, is that it also creates the service account `${PROJECT_ID}@appspot.gserviceaccount.com` necessary to setup the bigquery steps.

```Bash
source scripts/setup_appengine.sh
```

8. Setup BigQuery.

Grant roles to the default app engine service account `${PROJECT_ID}@appspot.gserviceaccount.com` to query BigQuery

```Bash
source scripts/setup_bigquery.sh
```

9. Initializes superset.

Spins a Compute Engine with the Docker image created in point **3**. This will initilize the database and load some demo data. It also creates the admin user, so you will be prompted for a username and password.

```Bash
source scripts/superset_init.sh
```

10. Deploys the App Engine application.

This step can be done multiple times, each time will create a new App Engine version and start serving from it.

Steps that it does:

- Extract the Superset build from our docker image to staging folder
- Merge into the same staging folder the following configuration files: `app.yaml`, `superset-config.py`, `requirements-db.txt`
- Deploy the app to the cloud

```Bash
source scripts/deploy.sh
```
