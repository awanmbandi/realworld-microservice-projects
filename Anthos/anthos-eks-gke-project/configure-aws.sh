## Generate Access Keys
- Identify one of your Admin users
- Generate a new set of Access Keys
- Save them

## Install AWS CLI
sudo yum update -y
sudo yum install -y python3
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo yum install unzip -y
unzip awscliv2.zip
sudo ./aws/install
aws --version

## Configure Your AWS CLI User Profile
- NOTE: Make sure you use the USER Credentials from the user you used to create the cluster
- NOTE: If Not you wont be able to reach the cluster

aws configure

## Confirm User Credential Config
aws sts get-caller-identity


