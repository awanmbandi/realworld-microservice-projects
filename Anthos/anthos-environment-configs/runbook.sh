


####################### For Deleting The Cluster #########################

## Delete EKS cluster
eksctl delete cluster --name anthoseksmanagedclusterss --region us-west-2

##########################################################################

1. AWS Context (Windows PowerShell)
. kubectl get nodes


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