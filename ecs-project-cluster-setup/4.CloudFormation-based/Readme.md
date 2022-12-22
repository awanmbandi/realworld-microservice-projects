# Create ECS cluster based on EC2
If it complains about `` role, follow the instructions on the below doc to verify/create the role
- https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html#:~:text=Verifying%20the%20Amazon%20ECS%20container%20instance%20IAM%20role 
- or https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html 

Command to apply the CloudFormation template

Launchtype _EC2_:  

```bash
aws cloudformation create-stack --stack-name ecs-ec2 --capabilities CAPABILITY_IAM --template-body file://./ecs-ec2-via-cloudformation.yml
```

Launchtype _Fargate_:  

```bash
aws cloudformation create-stack --stack-name ecs-fargate --capabilities CAPABILITY_IAM --template-body file://./ecs-fargate-via-cloudformation.yml
```
