## Multi-Cloud Implementation With Cloud Anthos
![ProjectArch!]()

### 1) Create A GKE Cluster on GCP




### 2) Create An EKS Cluster on AWS
##### A) Create The Cluster
- Click on `Add Cluster`
    - Name: `anthoseksmanagedclusters`
    - Kubernetes version: `1.23`  # MAKE SURE TO SELECT BUT THIS VERSION
    - Cluster service role: Create a New One
        - Attach Policy: `AdministratorAccess`
    - Click `Next`
    - VPC: `Default VPC`
    - Subnets: Select at least `2 Subnets`
    - Security groups: Select `Default`  any (But you''ll have to Edit Inbound Rules)
    - Cluster endpoint access: Select `Public`
    - Control plane logging: Enable ALL OF THEM (API server, Audit, Authenticator, Controller manager, Scheduler)
    - Select add-ons: Enable kube-proxy, CodeDNS, Amazon VPC CNI
        - Click on `Next`
    - Click on `Next`
    - Click on `CREATE`

##### B) Create EKS Cluster Node Group
- Click on the Cluster name "anthoseksmanagedclusters" (Confirm it's in an Active State)
    - Name: `eks-ng1`
    - Node IAM role: Select the `AWSServiceRoleForAmazonEKSNodegroup` role or any existing role, or Create a NEW ONE
    - Click `Next`
    - AMI type: `Amazon Linux 2`
    - Capacity: `On-Demand`
    - Instance type: `t3.xlarge`
    - Disk size: `20`
    - Desired size: `2`
    - Minimum size: `2`
    - Maximum size: `2`
    - Maximum unavailable (Number): `1`
    
    - Click on `Next`
        - Subnets: Select atleast Two subnets (You can as well select all)
        - Configure remote access to nodes: `DISABLE`
        - Click on `Next`
        - Click on `CREATE`

### 2) Create An AKS Cluster on Azure




### 3) Create a Management Instance on AWS (For EKS Cluster Setup)
##### Create EC2 Instance 
- Name: `EKS-Setup-Env`
- AMI: `CentOs 7`
- Instance type: `t2.micro`
- Keypair: `Select or create one`
- `Launch` Instance

##### Generate API Access Keys
- Identify one of your `Admin` users
- Generate a new set of Access Keys from the user
- `Save` them

##### Install AWS CLI on The `EKS-Setup-Env` Instance 
```bash
sudo yum update -y
sudo yum install -y python3
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

##### Configure Your AWS CLI User Profile
- **NOTE:** Make sure you use the **USER Credentials** from the user you used to create the cluster **(Root or Normal user)**
- **NOTE:** If Not you wont be able to reach the cluster
```bash
aws configure
```

##### Confirm User Credential Config (Make sure the USER matches the user used to create the cluster)
```bash
aws sts get-caller-identity
```

### 3) INSTALL AWS EKS `eksctl` On The `EKS-Setup-Env` VM Instance. The Commands Support `arm64`, `armv6` or `armv7`
##### The Installation Link
- https://eksctl.io/installation/

##### Installation Commands
```bash
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

eksctl version
```

### 4) Installing Kubernetes `kubectl` Command Line in the `EKS-Setup-Env` Instance
##### Installing Kubernetes kubectl command line Link
- https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

##### `kubectl` Installation Commands
```bash
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.2/2023-10-17/bin/linux/amd64/kubectl

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.2/2023-10-17/bin/linux/amd64/kubectl.sha256

sha256sum -c kubectl.sha256

openssl sha1 -sha256 kubectl

chmod +x ./kubectl

mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH

echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

kubectl version --client
```

### 4) Installation Google Cloud SDK for Linux
- https://cloud.google.com/sdk/docs/install#linux

##### Cloud SDK Installation and Configuration Steps (For Cloud Anthos)
```bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/PACKAGE_NAME

tar -xf PACKAGE_NAME

./google-cloud-sdk/install.sh

sudo cp -rf google-cloud-sdk /usr/lib/

export PATH="/usr/lib/google-cloud-sdk/bin:$PATH"

gcloud version  # or
gcloud --version
```

##### Initialize Cloud SDK and Login
```bash
gcloud init
```

##### Configure Your User and Application Auths and Set Project ID
```bash
gcloud auth login
gcloud config set project PROJECT_ID
gcloud auth application-default login
```

##### Enable The Following APIs on GCP For Anthos
```bash
gcloud services enable gkemulticloud.googleapis.com
gcloud services enable gkeconnect.googleapis.com
gcloud services enable connectgateway.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable anthos.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
gcloud services enable opsconfigmonitoring.googleapis.com
```

### 5) Access Cluster: Update the `Kube Config` Configuration 
This file is used to managed K8S Cluster User Authorization Definition
```bash
aws eks --region CLUSTER_REGION update-kubeconfig --name CLUSTER_NAME
```

##### Get the Nodes and Pods to confirm Cluster Access
```bash
kubectl get nodes

eksctl get cluster --name anthoseksmanagedclusterss --region us-west-2

kubectl get pods --all-namespaces
```

### 6) Configure/Complete EKS Cluster Membership Prequisites
##### Setup The `OIDC` URL and `KUBE_CONFIG_CONTEXT` Context Variables
```bash
OIDC_URL=$(aws eks describe-cluster --name <Cluster_Name> --region <Cluster_Region> --query "cluster.identity.oidc.issuer" --output text)
echo $OIDC_URL
KUBE_CONFIG_CONTEXT=$(kubectl config current-context)
echo $KUBE_CONFIG_CONTEXT
kubectl get ns     (After Running the Mmbership Register Command, A new namespace will get created for the Anthos Connect Agent)
```

### 7) Register The EKS Cluster As A Member To The Anthos Hub
##### Confirm Your Auth and Project Configurations Are All Set
```bash
gcloud auth list
gcloud config configurations list
```

##### Register The EKS Cluster To Anthos Hub
```bash
gcloud container hub memberships register anthoseksmanagedclusters \
--context=$KUBE_CONFIG_CONTEXT \
--public-issuer-url=$OIDC_URL \
--kubeconfig="~/.kube/config" \
--project=PROVIDE_PROJECT_ID \
--enable-workload-identity
```

##### Confirm That The Anthos Connect Agent Was Deployed Successfully And It's Running
```bash
kubectl get ns
kubectl get pods -n gke-connect
```

### 8) Login To The Attached EKS Cluster (For Anthos To Manage)
#### 8.1) Configure Authentication/Authorization From AWS EKS To Anthos with S.A Tokens
```bash
kubectl create serviceaccount -n kube-system anthos-admin-sa
kubectl get serviceaccount anthos-admin-sa -n kube-system
kubectl create clusterrolebinding anthos-admin-sa-binding --clusterrole cluster-admin --serviceaccount kube-system:anthos-admin-sa

# Here We're setting a Variable for The Secret Name of the above Service Account
SECRET_NAME=$(kubectl get serviceaccount -n kube-system anthos-admin-sa -o jsonpath='{$.secrets[0].name}')
echo $SECRET_NAME

# Here's We're Setting a Variable for The Secret Token (The Encoded Format, We have to Decode it)
BASE64_ENCODED_TOKEN=$(kubectl get secret -n kube-system $SECRET_NAME -o jsonpath='{$.data.token}')
echo $BASE64_ENCODED_TOKEN
```

#### 8.2) Decode above token and use it
- Go to: https://www.base64decode.org/
    - Paste the Encoded Version 
    - COPY the Decoded Version
    - Navigate to `Anthos LOGIN Page`
    - Click on `LOGIN` and Select `Token`
    - PASTE the Decoded Version in the BOX
    - Click `LOGIN`

    - Congratulations, `you are now LOGGED IN`
    - Navigate Back to Anthos UI/Dashboard
























