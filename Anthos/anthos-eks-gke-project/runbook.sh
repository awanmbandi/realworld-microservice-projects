##################### Create an AWS EC2 Instance #####################
## Create Setup EC2
- AMI: CentOs 7
- Instance type: t2.micro
- Keypair: Select or create one
- Launch Instance

## Create EKS Cluster (Console)
1) CREATE THE CLUSTER
- Click on `Add Cluster`
    - Name: `anthoseksmanagedclusters`
    - Kubernetes version: `1.23`
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

2) CREATE THE NODE GROUP
- Click on the Cluster name "anthoseksmanagedclusters" (Confirm it's in an Active State)
    - Name: `eks-ng1`
    - Node IAM role: Select the `AWSServiceRoleForAmazonEKSNodegroup` role or any existing role
    - Click `Next`
    - AMI type: Amazon Linux 2
    - Capacity: `On-Demand`
    - Instance type: `t2.small`
    - Disk size: `20`
    - Desired size: `1`
    - Minimum size: `1`
    - Maximum size: `1`
    - Maximum unavailable (Number): `1`
    
    - Click on `Next`
        - Subnets: Select atleast Two subnets (You can as well select all)
        - Configure remote access to nodes: `DISABLE`
        - Click on `Next`
        - Click on `CREATE`

##################### Create an AWS EKS clsuster #####################
## Create EKS cluster
eksctl create cluster \
--name anthoseksmanagedclustersss \
--node-type t3.large \
--nodes 1 \
--nodes-min 1 \
--nodes-max 2 \
--region us-west-2 \
--zones=us-west-2a,us-west-2b \
--kubernetes-version 1.23

## Create EKS Cluster
. touch eksctl-config.yaml
. vi eksctl-config.yaml
. eksctl create cluster -f eksctl-config.yaml

```
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: anthoseksmanagedclusters
  region: us-west-2

nodeGroups:
  - name: ng
    instanceType: t3.large
    minSize: 1
    maxSize: 2
    desiredCapacity: 1
    availabilityZones: ["us-west-2a", "us-west-2b"]
    ssh:
      publicKeyName: work_nova_key_newaccount
    kubernetesVersion: 1.23 
```

## Update the `Kube Config` Configuration 
### This file is used to managed K8S Cluster User Authorization Definition
aws eks --region CLUSTER_REGION update-kubeconfig --name CLUSTER_NAME

## Get the Nodes to confirm
kubectl get nodes

## Get EKS Cluster service
eksctl get cluster --name anthoseksmanagedclusterss --region us-west-2

## Get EKS Pod data.
kubectl get pods --all-namespaces

####################### For Deleting The Cluster #########################

## Delete EKS cluster
eksctl delete cluster --name anthoseksmanagedclusterss --region us-west-2

##########################################################################

1. AWS Context (Windows PowerShell)
. kubectl get nodes
. OIDC_URL=$(aws eks describe-cluster --name <Cluster_Name> --region <Cluster_Region> --query "cluster.identity.oidc.issuer" --output text)
. echo $OIDC_URL
. KUBE_CONFIG_CONTEXT=$(kubectl config current-context)
. echo $KUBE_CONFIG_CONTEXT
. kubectl get ns     (After Running the Mmbership Register Command, A new namespace will get created for the Anthos Connect Agent)

2.  GCP Context
. gcloud auth list
. gcloud config configurations list
. REGISTER Cluster To Anthos Hub
gcloud container hub memberships register anthoseksmanagedclusters \
--context=$KUBE_CONFIG_CONTEXT \
--public-issuer-url=$OIDC_URL \
--kubeconfig="~/.kube/config" \
--project=PROVIDE_PROJECT_ID \
--enable-workload-identity

. kubectl get ns
. kubectl get pods -n gke-connect

3.  Authentication AWS EKS in Anthos with Token
. kubectl create serviceaccount -n kube-system anthos-admin-sa
. kubectl get serviceaccount anthos-admin-sa -n kube-system
. kubectl create clusterrolebinding anthos-admin-sa-binding --clusterrole cluster-admin --serviceaccount kube-system:anthos-admin-sa
. SECRET_NAME=$(kubectl get serviceaccount -n kube-system anthos-admin-sa -o jsonpath='{$.secrets[0].name}')
. echo $SECRET_NAME
. BASE64_ENCODED_TOKEN=$(kubectl get secret -n kube-system $SECRET_NAME -o jsonpath='{$.data.token}')
. echo $BASE64_ENCODED_TOKEN
. Decode above token and use it
  . Go to: https://www.base64decode.org/
  . Paste the Encoded Version 
  . COPY the Decoded Version
    . Navigate to `Anthos LOGIN Page`
    . Click on `LOGIN` and Select `Token`
    . PASTE the Decoded Version in the BOX
    . Click `LOGIN`
    . NOW you are LOGGED IN
    . Navigate Back to Anthos UI/Dashboard

4.  We Have To Now Authorize The EKS Cluster Access From Cloud Anthos (To Proide Access To Anthos)
- Navigate tho the Anthos Dashboard
    - Click on `Clusters`
    - Click on your cluster name `anthoseksmanagedclusterss`
        NOTE:: You'll see, `Authenticate into the cluster to see more details`
        NOTE:: You can as well Go to GKE --> Click Cluster Name
        - Click on `LOGIN` 
        
        NOTE:: (You can use any of these options GCP Identity, K8S Service Account Token, IDP etc)
        - Select `Token`

##########################################################################