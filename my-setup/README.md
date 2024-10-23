# My log-shipping setup

I like to run my apps on fly.io and use the google cloud logging explorer to collect/process logs. 

## Prerequisites

* A google cloud project that you want to send logs to (e.g. `my-project`)

### Optional: set up new logging infrastructure

You can skip this step if you just want to use the [`_Default`](https://cloud.google.com/logging/docs/default-settings) logging bucket/router. The only consideration for me is that I like to retain logs longer than the 30 day default, so I either update the settings for the default bucket to retain logs for longer, or set up a new log sink. To do the latter...

1. Create a new logging bucket that will eventually store logs
```
gcloud logging buckets create my-application-logs-bucket --location=global --retention-days=180 --description="bucket for storing application logs"
```
2. Create a new logging sink that will receive the logs from the shipper and write them to the bucket
```
gcloud logging sinks create my-application-logs-sink storage.googleapis.com/my-application-logs-bucket --description="sink for storing application logs"
```
3. Create a new service account user
```
gcloud iam service-accounts create application-log-writer --description="service account that writes application logs from external sources" --display-name="DISPLAY_NAME"
```
4. Create service account credentials for the user, and prepare to ship those in this docker container
```
gcloud iam service-accounts keys create ./secret_g_service_account_app_logs_writer.json --iam-account=application-log-writer@[PROJECT_ID].iam.gserviceaccount.com
```
5. Grant the service account the ability to write logs
```
gcloud projects add-iam-policy-binding PROJECT_ID --member=serviceAccount:application-log-writer@PROJECT_ID.iam.gserviceaccount.com --role=roles/logging.logWriter
```

We'll deploy the service account credentials with the app, but be careful not to check it in.

## Set up the log shipper

