
=====================================================================================================================
                                           START
=====================================================================================================================
## Manage Multiple Containers 
## MySQL Demo

`
docker pull mysql/mysql-server:latest
docker run -p 3306:3306 -d --name mysql mysql/mysql-server:latest 
`
- you can as well add `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` but we won't in our case and te password will still get randomed

`
docker logs mysql
`
- look for [Entrypoint] GENERATED ROOT PASSWORD: HaVk4O0I2O5#6?.HGQ,+7Uvg2vPY_/@4

`
docker exec -it mysql bash
`
- # Getting a Shell Inside Containers: No Need for SSH
- This command allows you to remote into any running Docker Container using bash shell just like when you run `ssh, rdp etc` But here we do not need `SSH, RDP etc`
- Once you run this command it'll take you into the Database mysql container
- BUT this container just represent the database container instance not the actuall databse itself (to get in run)

`
mysql -uroot -p
`
- once you run the above command, provide the password you copied from the MySQL LOGS. Where you ran `docker logs mysql`
- Now you're logged into the Database

`
ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
`
- you need to ALTER the MySQL Password (Generated) to be able to use this Database or run any MySQL Commands
- you can run the command `SHOW DATABASES;` you will notice it'll break because the Password has not been ALTERED
- where you have 'newpassword' , provide the new PASSWORD you would like to give

`
show databases;
`
- run this command again now and it will work. Will show you existing Databases

`
create database weekly_product_sales;
create database company_payroll;
`
- Create this Database 
- You can create more and more 
- You can as well INJEST DATA in these databases


## Create a Copy(IMAGE) of The Updated Container 
`
docker commit "CONTAINER ID"
`

`
docker images -a
`
- This will allow you to see all your active docker images including the SAVED once
- If you just run `docker images` you won't see the once that are saved from running containers

`
docker tag "IMAGE ID" mysql/mysql-server/added-two-databases-bk:v1
`
- Tag the image with your own image name/tag to create your copy
- Another version `docker tag "IMAGE ID" mysql/mysql-server/added-two-databases`

`
docker images
`
- Now run docker images and you'll see the recent image you just tagged 

`
docker run -p 3307:3306 -d --name mydb mysql/mysql-server/added-two-databases-bk:v1
`
- USE a different HOST PORT `3307`

`
docker ps
`
- You'll see your newly deployed DB container, log in using `exec`

`
docker logs mydb
`
- YOU WILL NOT SEE ANY PASSWORD DISPLAYED BECAUSE, The IMAGE of the container was 
  gotten from a CONTAINER that had alredy ALTERED the PASSWORD. 
- That been said use `admin` to login when asked, since that was the new password. If not provide YOURS. 

`
docker exec -it mydb bash
`
- # Getting a Shell Inside Containers: No Need for SSH
- Remote into the container using bash

`
mysql -uroot -p
`
- That been said use `admin` to login when asked, since that was the new password. If not provide YOURS. 

`
show databases;
`
- THIS WOULD SHOW YOU ALL THE DATABASES, INCLUDING THE ONCE WE CREATED IN THE OTHER CONTAINER where the IMAGE IS FROM
- run this command again now and it will work. Will show you existing Databases


=====================================================================================================================
                                           THE NEXT BIG STEP
=====================================================================================================================

## Check Docker Container Resource USAGE (RAM, CPU, NETWORK, MEMORY etc)
docker container stats --help
- Help in checking CPU, MEMORY, NETWORK etc Usage (just lile the `TOP` command in linux)
- Check container usage

`
docker container ls  
`
- OR `docker ps`
- Check hidden containers `docker container ls -a`
`
docker container stats "CONTAINER ID"
`

## Docker Networks: Concepts for Private and Public Comms in Containers

`
docker container run -p 80:80 --name webhost -d nginx
`

`
docker container port webhost 
`
- This shows you the port your container is running on including the PORT BINDING

`
docker container port mysql
`
- This shows you the port your container is running on including the PORT BINDING

`
docker container inspect --format '{{ .NetworkSettings.IPAddress }}' mysql
`
- This IP is given to your containers so they can communicate with your LOCALHOST and by that I mean your APP
- This IP is assigned the moment a container gets orchestrated or provision
- IP allows docker to feed on the SYSTEM RESOURCES
- The IPs are all taken from the range `172.17.0.0`

## Docker Networks: CLI Management of Virtual Networks
`
docker network ls

docker network create --help

docker network inspect my_app_net

docker network --help

docker container inspect
`
=====================================================================================================================
=====================================================================================================================
                                            END HERE
=====================================================================================================================
=====================================================================================================================