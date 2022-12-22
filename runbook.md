## ECS Microservice Project Runbook

## Pre-requisites 
1. Make sure you have an `ECS(EC2)` Cluster deployed on ECS already
2. Deploy just the `td-musicbox-setup.json`, `td-operaapp-setup.json` and `td-flamencoapp-setup.json` Task Definition
    - 
    - 
    - 
3. Deploy the External `Application Load Balancer` which'll we use to manage the `Application` Requests
    - 

## Deploy Microservices On ECS
1. Deploy the `flamencoapp service`
- Navigate to the `ECS(EC2) Cluster`
    - Click on `Services`
        - Click on `Deploy`
        - Launch type: `EC2`
        - Application type: `Service`
        - Task Definition Family: `td-flamencoapp`, Revision: `1`
        - Service name: `flamencoapp-service`
        - Desired task: `1`
        - Networking:
            - VPC: `select Default` or `a working VPC with Internet connections`
            - Sebnets: `Select TWO or MORE subnets`
            - Security Group: 
                - Name: `flamencoapp-sg`
                - Inbound Rules: 
                    - Type: Port: `9001`, Source: `0.0.0.0/0` (However, we only need to open this to the ECS(EC2) Security Group)
                    - NOTE(New Console Experience): Since `Custom TCP` is not provided, Use Port: `HTTP:80` 
                        - But Remember the `flamencoapp` PORT Number is `9001`, however we don't have the option to update this
                          on the `New Console Experience`
                        - You can update this later, after creating the service
        - Click on `Deploy`

    ## Update The MusicBox(Entrypoint) Service With The FlamencoApp Service Task Private IP for Integration Purpose
    - Click on the `flamencoapp` service/name
        - Select `Tasks`
            - Click on the `running task`
            - Copy the `Private IP` (We need to create a `NEW Task Definition(TD)` Revision for the `musicbox` service 
              and Update the `HOST` section with the `flamencoapp` task IP). This is for the integration/communication betweeen both services

- Click on the `Task Definition` Menu on the Left hand side
    - Click on the `td-musicbox` task definition
        - Environment Variables: 
            - FLAMENCO_HOST  :  <<flamencoapp>>:9001        ,NOTE: (Replace `<<flamencoapp>>:9001` with the `flamencoapp` `Private IP`)
        
        - Environment:
            - CPU: `1vCPU`
            - Memory: `1GCP` or `2GB`
    
    - Click on `Create`

2. Deploy the `operaapp service`
- Navigate back to the `ECS(EC2) Cluster`
    - Click on `Services`
        - Click on `Deploy`
        - Launch type: `EC2`
        - Application type: `Service`
        - Task Definition Family: `td-operaapp`, Revision: `1`
        - Service name: `operaapp-service`
        - Desired task: `1`
        - Networking:
            - VPC: `select Default` or `a working VPC with Internet connections`
            - Sebnets: `Select TWO or MORE subnets`
            - Security Group: 
                - Name: `operaapp-sg`
                - Inbound Rules: 
                    - Type: Port: `9002`, Source: `0.0.0.0/0` (However, we only need to open this to the ECS(EC2) Security Group)
                    - NOTE(New Console Experience): Since `Custom TCP` is not provided, Use Port: `HTTP:80` 
                        - But Remember the `operaapp` PORT Number is `9002`, however we don't have the option to update this
                          on the `New Console Experience`
                        - You can update this later, after creating the service
        - Click on `Deploy`

    ## Update The MusicBox(Entrypoint) Service With The OperaApp Service Task Private IP for Integration Purpose
    - Click on the `operaapp` service/name
        - Select `Tasks`
            - Click on the `running task`
            - Copy the `Private IP` (We need to create a `NEW Task Definition(TD)` Revision for the `musicbox` service 
              and Update the `HOST` section with the `operaapp` task IP). This is for the integration/communication betweeen both services

- Click on the `Task Definition` Menu on the Left hand side
    - Click on the `td-musicbox` task definition
        - Environment Variables: 
        - NOTE: (You have to Replace `<<operaapp>>:9002` with the `operaapp` `Private IP`)
            - Key: `FLAMENCO_HOST` , Value: `<<operaapp>>:9002`   
        
        - Environment:
            - CPU: `1vCPU`
            - Memory: `1GCP` or `2GB`
    
    - Click on `Create`

3. Deploy the `musicbox service`
- Navigate back to the `ECS(EC2) Cluster`
    - Click on `Services`
        - Click on `Deploy`
        - Launch type: `EC2`
        - Application type: `Service`
        - Task Definition Family: `td-musicbox`, Revision: `3`
        - Service name: `musicbox-service`
        - Desired task: `1`
        - Click on `NEXT STEP`

        - Networking:
            - VPC: `select Default` or `a working VPC with Internet connections`
            - Sebnets: `Select TWO or MORE subnets`
        - Load Balancing:
            - Select the External `Application Load Balancer`  (Created through CloudFormation)
        - Service IAM Role: `AWSServiceRoleForECS`
        - Container to Load Balance:
            - Click on `Add to Load Balancer`
                - Production listerner port: `Create New` , `9000`
                - Target group name: `musicbox-service-tg`
                - Health check path: `/ping`
                - NOTE: Leave everything else as Default
        - Click on `NEXT STEP`
            - Set Auto Scaling (Optional): 
                - Service Auto Scaling: `Select` Do not adjust the service desired count

        - Click on `NEXT STEP`

        - Click on `Create Service`

## TEST/VALIDATE Microservice Deployment
- Copy your Load Balancer Public DNS 
    - Open a New Tab on your browser and Paste
    - Test the following Paths `LoadBalancerDNS:9000/opera` and `LoadBalancerDNS:9000/flamenco`

- CONGRATULATIONS for Deploying a Microservice App on ECS.

## Troubleshoot 
### IAM Roles (taskExecutionRole and TaskRole)
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html#:~:text=Verifying%20the%20Amazon%20ECS%20container%20instance%20IAM%20role 
- or https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html 
