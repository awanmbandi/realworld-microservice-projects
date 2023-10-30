#############################################
######### INSTALL GCP SDK `gcloud` ##########
## Installation Google Cloud SDK for Linux
- https://cloud.google.com/sdk/docs/install#linux

## Steps
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/PACKAGE_NAME

tar -xf PACKAGE_NAME

./google-cloud-sdk/install.sh

sudo cp -rf google-cloud-sdk /usr/lib/

export PATH="/usr/lib/google-cloud-sdk/bin:$PATH"

gcloud version  # or
gcloud --version

## Initialize Cloud SDK and Login
gcloud init

## Configure User and Application Auth, Set Project ID
gcloud auth login
gcloud config set project PROJECT_ID
gcloud auth application-default login

## Enable The Following APIs
gcloud services enable gkemulticloud.googleapis.com
gcloud services enable gkeconnect.googleapis.com
gcloud services enable connectgateway.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable anthos.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable opsconfigmonitoring.googleapis.com

