# Handson Microservice-XRay-AppMesh

## 1 - Setup Microservice

* start with _flamencoapp_ and _operaapp_ taskdefinition

```bash
cd 1-Setup
aws ecs register-task-definition  --cli-input-json file://td-flamencoapp-setup.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-operaapp-setup.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-musicbox.json --region us-west-2
```

* create ECS service for both, _flamencoapp_ and _operaapp_ both without public URL assignment and without LB
* grab URLs (host:port) of both services and set it in the td-musicbox.json taskdefinition, environment variables
* create taskdefinition for musicboxapp (the frontend)

```bash
aws ecs register-task-definition  --cli-input-json file://td-musicbox-setup.json --region us-west-2
```

* create musicbox service
* grab public URL of musicbox ALB Url and make some requests

## 2 - Adding tracing with AWS XRay and logging with AWS CloudWatch

Extend role _ecsTaskRole_ by attaching policy **AWSXRayDaemonWriteAccess**

Updating the task definitions to add xray-daemon sidecar container and additional env properties.  

```bash
cd 2-Tracing-Logging
aws ecs register-task-definition  --cli-input-json file://td-flamencoapp-tracing.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-operaapp-tracing.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-musicbox-tracing.json --region us-west-2
```

Ensure to update the final IP addresses of the flamenco- / opera-app within the musicbox taskdefinition, section _environment variables_

To apply all the changes, redeploy the corresponding ECS service and select the latest revision of the task definition.

## 3 - Adding service discovery

## changes to our setup

- flamencoapp and operaapp PORT 80, instead of 9001/9002
- adjust security groups "flamencosvc" and "operasvc" to allow port 80
- adjust musicbox task definition to replace the flamenco_HOST and opera_HOST env variables by the DNS names of the corresponding services, flamencosvc.ecs-course.local and operasvc.ecs-course.local
- apply the changed task definitions
- delete existing services for flamenco- , and operasvc
- recreate service for flamenco- , and operasvc including _service discovery_
- redeploy the musicbox service with latest revision

##  Service discovery details

- namespace: _ecs-course.local_
- service discovery services: _flamencosvc_ and _operasvc_

## apply task definitions

```bash
cd 3-ServiceDiscovery
aws ecs register-task-definition  --cli-input-json file://td-flamencoapp-servicediscovery.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-operaapp-servicediscovery.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-musicbox-servicediscovery.json --region us-west-2
```

## 4 - Adding AppMesh

## extend TaskExecutionRole
attach policy _AWSAppMeshEnvoyAccess_

## create AppMesh resources

* open AWS mgm console, _AppMesh_ service
* click _Create Mesh_
* provide name _musicbox-mesh_ and click button _Create mesh_
* create AppMesh components

```bash
aws cloudformation create-stack --stack-name appmesh-resources --template-body file://./mesh-resources.yaml
```

## adjust ECS services

### musicbox service

#### Taskdefinition

* change to networking mode _awsvpc_ and launchtype _FARGATE_
* ensure env variables for flamenco and opera hosts match their service discovery names **flamenco-service.ecs-course.local** and **opera-service.ecs-course.local**
* delete environment variable **AWS_XRAY_DAEMON_ADDRESS**
* delete _Links_ entry _xray-daemon_ (this is no longer required in network mode awsvpc)
* enable AppMesh integration by clicking checkbox _Enable App Mesh integration_
  * select _musicbox_ as application container name
  * select _musicbox-mesh_ as Mesh name
  * select _musicbox-service-vn_ as Virtual node name
  * **click Apply** !
  * click _Confirm_
* in Container definitions, open the _envoy_ container
  * add environment  variable _ENABLE_ENVOY_XRAY_TRACING_ with value _1_
  * enable Cloudwatch logging
* click on _Create_ to create the new task definition revision

#### ECS service

* delete existing ECS service _musicboxsvc_
* delete listener _9000_ in ALB
* create new service
  * add to loadbalancer, new listener port _9000_, new target group _musicboxsvc_
  * click _Enable service discovery integration_
  * select the existing namespace _ecs-course.local_
  * create new service discovery service _musicbox-service_


### flamenco service

#### Taskdefinition

* move to _Fargate_ launchtype (to avoid the limitation of ENIs on our t2.small EC2 instance) by switching from _EC2_ to _Fargate_ in Requires compatibilities
* set _Task memory_ to _1GB_
* set _Task CPU_ to _0.5vCPU_
* enable AppMesh integration by clicking checkbox _Enable App Mesh integration_
  * select _flamencoapp_ as application container name
  * select _musicbox-mesh_ as Mesh name
  * select _flamenco-service-vn_ as Virtual node name
  * **click Apply** !
  * click _Confirm_
* in Container definitions, open the _envoy_ container
  * add environment  variable _ENABLE_ENVOY_XRAY_TRACING_ with value _1_
  * enable Cloudwatch logging
* click on _Create_ to create the new task definition revision

#### ECS service
* recreate ECS service
* create new security group, open port 80 from everywhere
* click _Enable service discovery integration_
  * select existing namespace
  * select existing service discovery service
  * select _flamenco-service_
* click _Next step_
* click _Next step_
* click _Create service_

### opera service

#### Taskdefinition

* enable AppMesh integration by clicking checkbox _Enable App Mesh integration_
  * select _operaapp_ as application container name
  * select _musicbox-mesh_ as Mesh name
  * select _opera-service-vn_ as Virtual node name
  * **click Apply** !
  * click _Confirm_
* in Container definitions, open the _envoy_ container
  * add environment  variable _ENABLE_ENVOY_XRAY_TRACING_ with value _1_
  * enable Cloudwatch logging
* click on _Create_ to create the new task definition revision


## apply task definitions

```bash
cd 4-AppMesh
aws ecs register-task-definition  --cli-input-json file://td-flamencoapp-appmesh.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-operaapp-appmesh.json --region us-west-2
aws ecs register-task-definition  --cli-input-json file://td-musicbox-appmesh.json --region us-west-2
```


export CORE_STACK_NAME="ecs-course-core-infrastructure" 


ecs-cli up \
--subnets subnet-06620e92772d7d0bc, subnet-0558b5109de70d1b3 \
--vpc vpc-0aad0e33a58c19a14 \
--launch-type EC2 \
--size 1
--instance-type t2.small \
--cluster ecs-ec2