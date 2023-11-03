# Multi-Cloud Implementation With Cloud Anthos
![ProjectArch!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/multi_cloud_with_anthos_arch.png)

### 1) Create A GKE Cluster on GCP
### A) Sign into your GCP Account
- Open a new Tab on your choice browser
- Signup For a Free Google Cloud Account using the Following URL: https://cloud.google.com/free
- Once you complete the Signup process, you would be logged into the Google Cloud Console as shown below
![ProjectArch!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%201.26.23%20PM.png)

### B) Enable The GKE Service API and Cloud Anthos APIs
1. Enable GKE Service API
![GKEService API1!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-30%20at%204.11.29%20PM.png)
![GKEService API2!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-30%20at%204.12.59%20PM.png)

2. Enable Anthos Service APIs
![AnthosService API!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-30%20at%204.07.45%20PM.png)

3. Navigate to The Anthos Dashboard
![AnthosService Dashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-30%20at%204.06.09%20PM.png)

### C) Create The GKE Cluster
- Navigate to the `GKE Service`
- Click on `Create`
![GKEDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%201.09.45%20PM.png)
![GKEDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%201.10.47%20PM.png)
* Click on `SWITCH TO STANDARD CLUSTER`
  * Cluster name: `gke-anthos-managed-cluster`
  * Location type: Select `Zonal`
    * Zone: Select `us-central1-c`
    * Release channel: Select `Regular channel (default)`
    * Control plane version: Select the latest `default`
  
  * Click on `default-pool` on your left
    * Name: `default-pool`
    * Size: `2`
    * Surge upgrade: `1`
    * Surge upgrade: `0`

  * Click on `Nodes`
    * Image type: `Container-Optimize OS With Containerd (cos_containerd) (default)`
    * Machine Configurations:
      * Series: `E2`
      * Machine type: `e2-standard-4`  (We need at least between `8` Memory or more. `16` is perfect)
      * Boot disk type: `Balanced Persistent Disk`
      * Boot disk size: `100`
      * Boot disk encryption: Select `Google-managed encryption key`
      * Click `CREATE` to create the Cluster


### 2) Create An EKS Cluster on AWS
### A) Create The Cluster
- Navigate to `AWS EKS`
- Click on `Add Cluster`
![EKSDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%201.43.36%20PM.png)
  - Name: `eks-anthos-managed-cluster`
  - Kubernetes version: `1.23`  *MAKE SURE TO SELECT BUT THIS VERSION*
  - Cluster service role: Create a New One
    - Attach Policy: `AdministratorAccess`
  - Click `Next`
  - VPC: `Default VPC`
  - Subnets: Select at least `2 Subnets`
  - Security groups: Select `Default`  *any (But you''ll have to `Edit Inbound Rules` and Open port `80`)*
  - Choose cluster IP address family: `IPv4`
  - Cluster endpoint access: Select `Public`
  - Control plane logging: `Enable ALL OF THEM` *(API server, Audit, Authenticator, Controller manager, Scheduler)*
  - Click `Next`
  - Select add-ons: Enable kube-proxy, CodeDNS, Amazon VPC CNI
    - Click on `Next`
![EKSDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%201.43.36%20PM.png)
  - CoreDNS Version: Default version
  - Amazon VPC CNI Version: Default version
  - kube-proxy version: Default version
  - Click `Next`
  - Click on `CREATE` *to create the cluster*
  - **NOTE:** *If you run into an error about resource availability within a specific zone, click on previous and delete the Zone Subnet Selection and then Create*
![EKSDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%202.03.16%20PM.png)

### B) Create EKS Cluster Node Group
- Once the Cluster Creation is Complete and the `Status = Active`
- Click on the Cluster name `eks-anthos-managed-cluster` (Confirm it's in an Active State)
- Click on `Compute`
- Click on `Add node group`
![EKSDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%202.11.27%20PM.png)
  - Name: `eks-default-ng`
  - Node IAM role: Select the `AWSServiceRoleForAmazonEKSNodegroup` *role or any existing role, or Create a NEW ONE*
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
![EKSDashboard!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%202.30.09%20PM.png)

### 3) Create a Management Instance on AWS (For EKS Cluster Setup)
### 3.1) Create EC2 Instance 
- Name: `EKS-Setup-Env`
- AMI: `CentOs 7`
- Instance type: `t2.micro`
- Keypair: `Select or create one`
- `Launch` Instance

### 3.2) Generate API Access Keys
- Navigate to `IAM`
- Identify the `User` that you used to `create` the `EKS Cluster`
  - Could be a *`Normal User` or `Root User`*
![IAMGenerateAccessKeys!](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%202.39.21%20PM.png)
- Generate a new set of `Access Keys` from the user
  - **NOTE:** *Make sure it's the user you used to create the EKS Cluster*
  - **Root User:** *For the `Root User`, Follow the bellow steps to Generate the Access Keys*
    - Click on your Account Name `Top Right`
    - Click on `Security Credentials`
    - Click on `Create Access Keys`
- `Save` them on a NodePad or Something

### A) Install AWS CLI on The `EKS-Setup-Env` Instance 
- Navigate to `EC2`
- Login/SSH into the `EKS-Setup-Env` Instance 
- Install the following Utilities
  * Install `AWS CLI`
  * Install `eksctl`
  * Install `kubectl`
  * Install `Google Cloud SDK (gcloud)etc`

```bash
sudo yum update -y
sudo yum install -y python3
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### Configure Your AWS CLI User Profile
- **NOTE:** Make sure you use the **USER Credentials** from the user you used to create the cluster **(Root or Normal user)**
- **NOTE:** If Not you wont be able to reach the cluster
```bash
aws configure
```

### Confirm User Credential Config (Make sure the USER matches the user used to create the cluster)
**NOTE:*** *Make sure the User Name you get reflects the User that Provisioned the EKS Cluster*
```bash
aws sts get-caller-identity
```

### B) Install AWS `eksctl` On The `EKS-Setup-Env` VM Instance. The Commands Support `arm64`, `armv6` or `armv7`
#### The Installation Link
- https://eksctl.io/installation/

### Installation Commands
```bash
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"

curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

sudo mv /tmp/eksctl /usr/local/bin

eksctl version
```

### C) Installing Kubernetes `kubectl` Command Line in the `EKS-Setup-Env` Instance
#### Installing Kubernetes kubectl command line Link
- https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html

### `kubectl` Installation Commands
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

### D) Installation Google Cloud SDK for Linux
- https://cloud.google.com/sdk/docs/install#linux

### Cloud SDK Installation and Configuration Steps (For Cloud Anthos)
```bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/PACKAGE_NAME

## With Shell Script add a 30 seconds sleep after this command
tar -xf PACKAGE_NAME

./google-cloud-sdk/install.sh

sudo cp -rf google-cloud-sdk /usr/lib/

export PATH="/usr/lib/google-cloud-sdk/bin:$PATH"

gcloud version  # or
gcloud --version
```

### E) Initialize Cloud SDK and Login
```bash
gcloud init
```

### Configure Your User and Application Auths and Set Project ID
```bash
gcloud auth login
gcloud config set project PROJECT_ID
gcloud auth application-default login
```

### F) Enable The Following APIs on GCP For Anthos
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

### 4) Access Cluster: Update the `Kube Config` Configuration 
This file is used to managed K8S Cluster User Authorization Definition
```bash
aws eks --region CLUSTER_REGION update-kubeconfig --name CLUSTER_NAME
```

### Get the Nodes and Pods to confirm Cluster Access
```bash
kubectl get nodes

eksctl get cluster --name eks-anthos-managed-cluster --region us-west-2

kubectl get pods --all-namespaces
```

### 5) Configure/Complete EKS Cluster Membership Prequisites
### Setup The `OIDC` URL and `KUBE_CONFIG_CONTEXT` Context Variables
```bash
# Create OIDC URL Variable
OIDC_URL=$(aws eks describe-cluster --name <Cluster_Name> --region <Cluster_Region> --query "cluster.identity.oidc.issuer" --output text)
echo $OIDC_URL

# Create KubeConfig Context Variable
KUBE_CONFIG_CONTEXT=$(kubectl config current-context)
echo $KUBE_CONFIG_CONTEXT
kubectl get ns     (After Running the Mmbership Register Command, A new namespace will get created for the Anthos Connect Agent)
```

### 6) Register The GKE Cluster As A Member To The Anthos Hub
- Navigate to `Anthos Clusters Dashboard`
- Click on `REGISTER GKE CLUSTER`
![RegisterGKECluster](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%203.28.07%20PM.png)
  - You'll see the `gke-anthos-managed-cluster` cluster displayed
  - Click on `REGISTER`
  - Go back to `Clusters`
![AnthosFleet](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%203.33.33%20PM.png)

### 7) Register The EKS Cluster As A Member To The Anthos Hub
- Navigate back to the `EKS-Setup-Env` Instance
- A) Confirm That Your Auth and Project Configurations Are All Set
```bash
gcloud auth list
gcloud config configurations list
```

### B) Register The EKS Cluster To Anthos Hub
- Remove `PROVIDE_PROJECT_ID` and Provide your Anthos `Project ID`
```bash
gcloud container hub memberships register eks-anthos-managed-cluster \
--context=$KUBE_CONFIG_CONTEXT \
--public-issuer-url=$OIDC_URL \
--kubeconfig="~/.kube/config" \
--project=PROVIDE_PROJECT_ID \
--enable-workload-identity
```
![CreateMembership](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%203.40.55%20PM.png)

### Confirm That The Anthos Connect Agent Was Deployed Successfully And It's Running
```bash
kubectl get ns
kubectl get pods -n gke-connect
```

### Confirm That The EKS Cluster Membership Regration Was Successful
- Navigate back to Cloud Anthos 
- Click on Clusters
- You can as well verify this From the `GKE Service`
![CreateMembership](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%203.46.02%20PM.png)

### 8) Login To The Attached EKS Cluster (For Anthos To Manage)
**NOTE:** *We Need To Authorize Anthos To The EKS Cluster Using K8S Service Accounts and Token*

### 8.1) Configure Authentication/Authorization From AWS EKS To Anthos with S.A Tokens
```bash
kubectl create serviceaccount -n kube-system anthos-admin-sa

# Run the following ""GET"" Command and Confirm You Have a Result With ""SECRET=1""
# IF you do not have ""SECRET=1"", it therefore means you didn't select the right ""K8S Version"" For Your EKS Cluster
# Kubernetes made an Update that says any Cluster with version 24.++ and Above, would'nt support Auto Secret Creation
kubectl get serviceaccount anthos-admin-sa -n kube-system
kubectl create clusterrolebinding anthos-admin-sa-binding --clusterrole cluster-admin --serviceaccount kube-system:anthos-admin-sa

# Here We're setting a Variable for The Secret Name of the above Service Account
SECRET_NAME=$(kubectl get serviceaccount -n kube-system anthos-admin-sa -o jsonpath='{$.secrets[0].name}')
echo $SECRET_NAME

# Here's We're Setting a Variable for The Secret Token (The Encoded Format, We have to Decode it)
BASE64_ENCODED_TOKEN=$(kubectl get secret -n kube-system $SECRET_NAME -o jsonpath='{$.data.token}')
echo $BASE64_ENCODED_TOKEN
```

### 8.2) Decode above token and use it
- Go to: https://www.base64decode.org/
    - Paste the Encoded Version 
    - Click on `DECODE`
    - Navigate to `Anthos LOGIN Page`

### 8.3) We Have To Now Authorize The EKS Cluster Access From Cloud Anthos (To Proide Access To Anthos)
- Navigate tho the `Anthos Dashboard` or `Login Page`
    - Click on `Clusters`
    - Click on your cluster name `eks-anthos-managed-cluster`
        - **NOTE::** You'll see, `Authenticate into the cluster to see more details`
        - **NOTE::** You can as well Go to GKE --> Click Cluster Name
        - Click on `LOGIN` 
        
        - **NOTE::** *(You can use any of these options GCP Identity, K8S Service Account Token, IDP etc)*
        - Select `Token`
        - PASTE the `DECODED Version` of the `TOKEN` in the `BOX`
        - Click on `LOGIN` 
        - Congratulations, `you are now LOGGED IN`
        - Navigate Back to `Anthos UI/Dashboard`
![CreateMembership](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%204.00.20%20PM.png)

### 9) Create Your Project GitHub Repository (Deploy A Microservice Application)
- Navigate to `GitHub`
- Click on `Repositories` and then `Create New Repository`
![GitHubProjectRepo](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%204.30.14%20PM.png)
- Repository Name: `anthos-acm-configsync-project`
- Select `Public`
- Check the box `Add a README file`
- Click `Create Repository`

### Clone The Above Repository Locally, Download The Project Scripts and Push To Your GitHub Repo
- Download the `Project ZIP/Code` From: https://github.com/awanmbandi/realworld-microservice-projects/tree/GCP
    - Unzip the Downloaded ZIP
    - Copy All the Folders/Directorys in the Following Path `realworld-microservice-projects/Anthos/anthos-gke-eks-aks-project`
    - There are `5 Packages` Deployments in Total
        - package-backend
        - package-database
        - package-redis
        - package-results
        - package-vote
    - `COPY` ALL of the ABOVE Project `PACKAGES/Deployments` Configs
    - `PASTE` them in the Repository You Cloned Locally
    - `COMMIT` the Changes and PUSH the Code to `GitHub`
- You Should Have Same Code On Github as Shown Below
![GitHubProjectRepo](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%204.56.51%20PM.png)

### 10) Configure and Implement Anthos Config Management With Config Sync
### A) Install The ACM Config Sync Agent Accross Your Fleet (GKE and EKS Clusters)
- On the Anthos Dashboard
- Under `Fleet Features`, Click on `Config` 
![ConfigureACM](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%204.04.25%20PM.png)
  - Click on `Install Config Sync`
  - Version: Select the `Latest`
  - Installation options: Choose `Install Config Sync on entire fleet (recommended)`
  - Click on `INSTALL CONFIG SYNC`
- Confirm the Installation was Successful across Both the `GKE` and `EKS` Clusters
  - Click on `Config` >>> `SETTINGS`
![ConfigureACM](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%204.15.04%20PM.png)

### B) Create and Deploy A Microservice Application Package Across The Fleet
- NOTE: This could also be a monitoring software you might want to deploy across your entire Anthos Environment to monitor Workloads
- Use Case: It could be a Distributed Tracing Software to expose you the application Traces (Across All Environments)
- Use Case: It Could be a Governance or Compliance Policy or Control which you might want to Enforce Accros All Cloud Workloads
- Use Case: Etc.. Etc..
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%204.17.18%20PM.png)

- Select clusters
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%205.07.52%20PM.png)
- Source type: Select `Package hosted on Git`
- Package details
    - Source type: Select `Git`
    - Sync type: Select `RepoSync`
    - Package namespace: `voting-webapp`
    - Auto-create namespaces: Check the box to `Enable`
    - SOURCE: *Follow Provide your values based on the screenshot below*
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%205.18.33%20PM.png)
    - DEPLOY PACKAGE
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%205.34.19%20PM.png)

### C) Verify and Validate Package Was Deployed Successfully and The Cluster is In SYNC
1. Confirm that the `voting-webapp` namespace was created across both the `GKE` and `EKS` Clusters
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%205.37.28%20PM.png)

### 11) AWS EKS Cluster 
- Login to your `EKS Cluster` using the VM if you're not logged in
- Run the bellow commands to verify the `Namespace and Pods`
```bash
kubectl get ns
kubectl get pods -n voting-webapp
```
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%205.55.07%20PM.png)

- Confirm that The `Voting` and `Result` LoadBalancer Services were created successfully
- Confirm that The postgresql`db` and `redis` Cluster IP Services were created successfully
- Also Confirm that the various Deployments succeded as well
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%206.04.56%20PM.png)

- Navigate to `LoadBalancers` in `EC2` and You'll see the two Loadbalancers
- Click on `EC2` >>>> Click `LoadBalacners` 
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-10-31%20at%206.08.06%20PM.png)

- Access the `Voting` Frontend Service using the `Vote` Service LoadBalancer DNS
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%201.46.02%20AM.png)

- Access the `Result` Frontend Service, using the `Result` Service LoadBalancer DNS
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%201.48.11%20AM.png)

### 12) Google GKE Cluster 
- Login to your `GKE Cluster` using the VM if you're not logged in
- Navigate to `GKE`
    - Click on the cluster name `gke-anthos-managed-cluster`
    - Click on `Connect`
![LoginToGKECluster](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%201.56.46%20AM.png)
  - Once the Terminal Opens, Run the Command
  - Click `Authorize` to Authaurize Cloud Shell access

- Run the bellow commands to verify the `Namespace and Pods`
```bash
kubectl get ns
kubectl get pods -n voting-webapp
```
![DeployACMPackage](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%202.01.00%20AM.png)

- Confirm that The `Voting` and `Result` LoadBalancer Services were created successfully
- Confirm that The postgresql`db` and `redis` Cluster IP Services were created successfully
- Also Confirm that the various Deployments succeded as well
![LoginToGKECluster](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%202.08.55%20AM.png)

- Navigate to `LoadBalancers` in `Frontend` and You'll see the two Loadbalancers
- Click on `LoadBalancers` >>>> Click `Frontend` 
![LoginToGKECluster](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%202.20.46%20AM.png)

### 13) TEST THE SELF HEALING CAPABILITY OF ConfigSync with ACM
### Google GKE Cluster  (The Expectation Is Once You Delete It Should Reconcile The Configuration after `15` Seconds)
1) Update The Amount of Replicas of the application..
**NOTE:** MAKE SURE TO UPDATE THIS THROUGH `GIT/GITHUB` NOT DIRECTLY 
**NOTE:** SINCE CONFIG SYNC WILL `SYNCRONIZE THE CHANGES` AUTOMATICALLY
**NOTE:** VERIFY BOTH YOUR `GKE` and `EKS` CLUSTERS, FOR THE CHANGES
    - Scale The *`Voting Microservice`:* to `10`
    - Scale The *`Result Microservice:`* to `10`
    - Scale The *`Worker Microservice:`* to `5`

2) Delete The LoadBalancer Services Including the PostgreSQL DB and Redis Cache Service 
3) Delete All The Various Deployments In The `voting-webapp` Namespace
4) Delete the `voting-webapp` Namespace 

### 14) IMPLEMENT A GOVERNANCE AND COMPLIANCE POLICY THAT PREVENTS INTERNET ACCESS IN THE `GKE` CLUSTER
### A) Install Anthos Policy Controller on Both Clusters
- Navigate to `Anthos Dashboard`
- Click on `Config` also known as `ACM`
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%203.04.41%20AM.png)
- Choose an installation option: Select `Install on your fleet`
- Click `ACTIVATE POLICY CONTROLER`
- Monitor the `Policy Controller Status` for both Clusters 
    - gke-anthos-managed-cluster: Shows `Installed`
    - eks-anthos-managed-cluster: Shows `Installed` as well
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%203.20.50%20AM.png)

- Run The Bellow Command Across your `GKE` and `EKS` Cluster to Confirm Policy Controller Installation
- Google Kubernetes Engine Cluster
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%203.24.22%20AM.png)
- AWS EKS Cluster
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%203.17.06%20AM.png)

### B) Deploy The Policy Configuration To BLOCK INTERNET ACCESS To The `AWS` CLUSTER
- Open the following Repository/Branch URL: https://github.com/awanmbandi/anthos-acm-configsync-project/tree/anthos-policies
- COPY the Git URL
- Navigate to `Anthos Dashboard`
- Click on `Config`
- Click on `Deploy Package`
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%203.31.25%20AM.png)
- Select clusters for package deployment: 
    - Select `eks-anthos-managed-cluster`  *we'll apply the `No-Internet-Access` to the `EKS Cluster` only for Testing*
    - Click on `Continue`
    - Source type: Choose `Git`
    - Click on `Continue`
    - Source type: Select `Git`
    - Package name: `no-internet-access-policy`
    - Sync type: `RootSync`
    - Repository URL: Provide `https://github.com/awanmbandi/anthos-acm-configsync-project.git`
    - Revision: `HEAD`
    - Path: `/aws-cluster-policies`
    - Branch: `anthos-policies`
    - Authentication type: `None`
    - Sync Wait time: `15` Seconds
    - Source Format: `Unstructured`
    - Click `CONTINUE`
    - Click `DEPLOY PACKAGE`
**NOTE:** *Confirm that the policy was deployed succesfully*
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%203.44.24%20AM.png)

### 15) TEST THE NO-INTERNET-ACCESS-POLICY YOU JUST APPLIED TO THE AWS CLUSTER
- Navigate to the AWS EKS VM Instance 
- Install Git and Clone the Project Repository
```bash
sudo yum install git -y
git clone https://github.com/awanmbandi/anthos-acm-configsync-project.git
ls -al
cd anthos-acm-configsync-project/
git checkout anthos-policies
ls -al
cd internet-service-resource/
# Deploy to Default Namespace
kubectl apply -f lb-service.yaml
```

- **NOTE:** *ONCE you deploy, you'll get the following ERORR MESSAGE*
```js
Error from server (Forbidden): error when creating "lb-service.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [no-internet-services] Creating services of type `LoadBalancer` without Internal annotation or not setting `service.beta.kubernetes.io/aws-load-balancer-internal` to true is not allowed
```

### 16) TEST THE THE SAME INTERNET/LOADBALANCER SERVICE DEPLOYMENT IN THE GKE CLUSTER
- Navigate to your `Cloud Shell` where you are logged in
- Run the Following Commands
```bash
git clone https://github.com/awanmbandi/anthos-acm-configsync-project.git
ls -al
cd anthos-acm-configsync-project/
git checkout anthos-policies
cd internet-service-resource/
ls -al
# Deploy to Default Namespace
kubectl apply -f lb-service.yaml
```

- **NOTE:** *ONCE you Deploy to the GKE Cluster, It should succeed with message*
```js
service/webapp created
```
### Policy Controller Reports/UI Dashbaord
![ACMPolicyController](https://github.com/awanmbandi/realworld-microservice-projects/blob/zdocs/images/Screen%20Shot%202023-11-01%20at%204.19.42%20AM.png)

## CONGRATULATIONS! CONGRATULATIONS!





















