# Setup ECS infrastructure

## install prerequisites

- install _awscli_ **v2** cmdline tool
  - https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html
    ```bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    # check
    aws --version

    # configuration
    aws configure
    # provide region, access-key, secret and output-format
    ```
- install _ecs cli_ cmdline tool  
  - https://github.com/aws/amazon-ecs-cli#installing
  ```bash
  curl https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest -o "ecs-cli"
  sudo chmod +x ./ecs-cli
  sudo mv ./ecs-cli /usr/local/bin

  #check
  ecs-cli --version

  # configure
  ecs-cli configure profile --access-key <<YOUR-AWS_ACCESS_KEY_ID>> --secret-key <<YOUR-AWS_SECRET_ACCESS_KEY>>
  
  ```

- install base tools
```bash
sudo apt-get install -y jq gettext
```

## deploy a cluster

1. [Core AWS infra setup](./1_Core-infrastructure-setup/Readme.md)
2. [CloudFormation based](./2_CloudFormation-based/Readme.md)
3. [ECS-cli based](./3_ECS-cli-based/Readme.md)
4. [Real world example architecture](./4_Real-world-example-architecture/Readme.md)

