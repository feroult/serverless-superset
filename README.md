# Serverless Superset on Google Cloud

For a more detailed guide on how to deploy [Apache Superset (Incubating)](https://superset.incubator.apache.org/) on Google Cloud refere tho this [blog post](https://medium.com/@feroult/serverless-superset-on-google-cloud-87d3cf324845).

Two addtions to the blog post:

- Source all scripts so newly set environment variables are available for the next script:
*source ./scripts/...* instead of *./scripts/..*

- Run bigquery_setup as very last step, as the service account that has to be modified is not available before
