# Docker 
# Creating and Using Containers Like a Boss
## Install Docker On CentOS, Ubuntu, Debian, RHEL, Fedora etc
- ► https://docs.docker.com/engine/install/

## Install Docker on Amazon Linux 2
``
#!/bin/bash
sudo su
yum update -y
yum install docker -y
systemctl start docker
systemctl enable docker
systemctl docker status
``


## Check Our Docker Install and Config

docker version

docker info

docker

docker container run

docker run

## Starting a Nginx Web Server

docker container run --publish 80:80 nginx

docker container run --publish 80:80 --detach nginx
(By using "--detach", you're basically trying to run your docker container process in the background. NOTE: This does not mean the container will not be reachable e.g using the browser or API).

docker container ls

docker container stop 690

docker container ls

docker container ls -a     
(The Reason why you get back TWO(stopped) containers is because by default whenever you run the "docker run" command it started a new container from the NGINX image. You'll have to explicitly start the containers if you want to get them back up "docker start" or "docker container start". 

docker container run --publish 80:80 --detach --name webhost nginx
(Usually when you deploy/run a container without providing the name, docker automatically generates a random name for your container so this time we're going to specify a name "webhost".

docker container ls -a
(CONFIRM the Container name at the FAR END, Confirm it has PORT: "0.0.0.0:80/tcp"
(Copy your localhost/VM Machine and Access the App)

docker container logs webhost
(COPY and PASTE the Public/External IP address on the browser and Refresh a few times to generate some LOGS)

docker container top webhost
(This would show you the processes that are Running inside of your App Container (NGINX Container))
(The two NGINX Processes you'll see today are MASTER and WORKER Process)

## Starting a Grafana Container

docker pull grafana/grafana

docker run -d --name=grafana -p 3000:3000 grafana/grafana

###############################################################
docker container --help

docker container ls -a

docker container rm 63f 690 ode

docker container ls

docker container rm -f 63f

docker container ls -a

=====================================================================================================================
                                           START
=====================================================================================================================
## Container VS. VM: It's Just a Process

docker run --name mongo -d mongo

docker ps

docker top mongo

docker stop mongo

docker ps

docker top mongo

docker start mongo

docker ps

docker top mongo

## Assignment Answers: Manage Multiple Containers 
## MySQL Demo

docker pull mysql/mysql-server:latest

docker run -p 3306:3306 -d --name mysql mysql/mysql-server:latest 
- you can as well add `-e MYSQL_RANDOM_ROOT_PASSWORD=yes` but we won't in our case and te password will still get randomed

docker logs mysql
- look for [Entrypoint] GENERATED ROOT PASSWORD: HaVk4O0I2O5#6?.HGQ,+7Uvg2vPY_/@4

docker exec -it mysql bash
- # Getting a Shell Inside Containers: No Need for SSH
- This command allows you to remote into any running Docker Container using bash shell just like when you run `ssh, rdp etc`
  But here we do not need `SSH, RDP etc`
- Once you run this command it'll take you into the Database mysql container
- BUT this container just represent the database container instance not the actuall databse itself (to get in run)

mysql -uroot -p
- once you run the above command, provide the password you copied from the MySQL LOGS. Where you ran `docker logs mysql`
- Now you're logged into the Database

ALTER USER 'root'@'localhost' IDENTIFIED BY 'newpassword';
- you need to ALTER the MySQL Password (Generated) to be able to use this Database or run any MySQL Commands
- you can run the command `SHOW DATABASES;` you will notice it'll break because the Password has not been ALTERED
- where you have 'newpassword' , provide the new PASSWORD you would like to give

show databases;
- run this command again now and it will work. Will show you existing Databases

create database weekly_product_sales;
create database company_payroll;
- Create this Database 
- You can create more and more 
- You can as well INJEST DATA in these databases


## Create a Copy(IMAGE) of The Updated Container 

docker commit "CONTAINER ID"

docker images -a
- This will allow you to see all your active docker images including the SAVED once
- If you just run `docker images` you won't see the once that are saved from running containers

docker tag "IMAGE ID" mysql/mysql-server/added-two-databases-bk:v1
- Tag the image with your own image name/tag to create your copy
- Another version `docker tag "IMAGE ID" mysql/mysql-server/added-two-databases`

docker images
- Now run docker images and you'll see the recent image you just tagged 

docker run -p 3307:3306 -d --name mydb mysql/mysql-server/added-two-databases-bk:v1
- USE a different HOST PORT `3307`

docker ps
- You'll see your newly deployed DB container, log in using `exec`

docker logs mydb
- YOU WILL NOT SEE ANY PASSWORD DISPLAYED BECAUSE, The IMAGE of the container was 
  gotten from a CONTAINER that had alredy ALTERED the PASSWORD. 
- That been said use `admin` to login when asked, since that was the new password. If not provide YOURS. 

docker exec -it mydb bash
- # Getting a Shell Inside Containers: No Need for SSH
- Remote into the container using bash

mysql -uroot -p
- That been said use `admin` to login when asked, since that was the new password. If not provide YOURS. 

show databases;
- THIS WOULD SHOW YOU ALL THE DATABASES, INCLUDING THE ONCE WE CREATED IN THE OTHER CONTAINER where the IMAGE IS FROM
- run this command again now and it will work. Will show you existing Databases


=====================================================================================================================
                                           THE NEXT BIG STEP
=====================================================================================================================

## Check Docker Container Resource USAGE (RAM, CPU, NETWORK, MEMORY etc)
docker container stats --help
- Help in checking CPU, MEMORY, NETWORK etc Usage (just lile the `TOP` command in linux)
- Check container usage

docker container ls  
- OR `docker ps`
- Check hidden containers `docker container ls -a`

docker container stats "CONTAINER ID"


## Docker Networks: Concepts for Private and Public Comms in Containers

docker container run -p 80:80 --name webhost -d nginx

docker container port webhost 
- This shows you the port your container is running on including the PORT BINDING

docker container port mysql
- This shows you the port your container is running on including the PORT BINDING

docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost
- This IP is given to your containers so they can communicate with your LOCALHOST and by that I mean your APP
- This IP is assigned the moment a container gets orchestrated or provision
- IP allows docker to feed on the SYSTEM RESOURCES
- The IPs are all taken from the range `172.17.0.0`

## Docker Networks: CLI Management of Virtual Networks

docker network ls

docker network create --help

docker network inspect my_app_net

docker network --help

docker container inspect

=====================================================================================================================
=====================================================================================================================
                                            END HERE
=====================================================================================================================
=====================================================================================================================



docker container run -d -p 3306:3306 --name mysqldb -e MYSQL_RANDOM_ROOT_PASSWORD=yes MYSQL_RANDOM_ROOT_PASSWORD
(This starts up the MySQL container and passes a RANDOM password to the database by using "MYSQL_RANDOM_ROOT_PASSWORD=true".
For the PASSWORD, you get it by checking the Container LOGS) 

docker container logs mysqldb
(Search for the DB PASSWORD, Lookout for the STRING "GENERATED ROOT PASSWORD"). You'll need this password if you were to
Login to this MySQL database. 

docker container run -d --name webserver -p 8080:80 httpd

docker ps

docker container run -d --name proxy -p 80:80 nginx

docker ps

docker container ls

docker container stop   (PASS ALL OF THEIR CONTAINER IDs TO STOP ALL AT ONCE)

docker ps -a

docker container ls -a

docker container rm

docker ps -a

docker image ls

## What's Going On In Containers: CLI Process Monitoring

docker container run -d --name nginx nginx

docker container run -d -P 3306:3306 --name mysqldb -e MYSQL_RANDOM_ROOT_PASSWORD=true mysql
(This starts up the MySQL container and passes a RANDOM password to the database by using "MYSQL_RANDOM_ROOT_PASSWORD=true".
For the PASSWORD, you get it by checking the Container LOGS) 

docker container logs mysqldb
(Search for the DB PASSWORD, Lookout for the STRING "GENERATED ROOT PASSWORD"). You'll need this password if you were to
Login to this MySQL database. 

docker container ls

docker container top mysql

docker container top nginx

docker container inspect mysql

docker container stats --help

docker container stats

docker container ls

## Getting a Shell Inside Containers: No Need for SSH

docker container run -help

docker container run -it --name proxy nginx bash

docker container ls

docker container ls -a

docker container run -it --name ubuntu ubuntu

docker container ls

docker container ls -a

docker container start --help

docker container start -ai ubuntu

docker container exec --help

docker container exec -it mysql bash

docker container ls

docker pull alpine

docker image ls

docker container run -it alpine bash

docker container run -it alpine sh

## Docker Networks: Concepts for Private and Public Comms in Containers

docker container run -p 80:80 --name webhost -d nginx

docker container port webhost

docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost

## Docker Networks: CLI Management of Virtual Networks

docker network ls

docker network inspect bridge

docker network ls

docker network create my_app_net

docker network ls

docker network create --help

docker container run -d --name new_nginx --network my_app_net nginx

docker network inspect my_app_net

docker network --help

docker network connect

docker container inspect TAB COMPLETION

docker container disconnect TAB COMPLETION

docker container inspect

## Docker Networks: DNS and How Containers Find Each Other

docker container ls

docker network inspect TAB COMPLETION

docker container run -d --name my_nginx --network my_app_net nginx

docker container inspect TAB COMPLETION

docker container exec -it my_nginx ping new_nginx

docker container exec -it new_nginx ping my_nginx

docker network ls

docker container create --help

## Assignment Answers: Using Containers for CLI Testing

docker container run --rm -it centos:7 bash

docker ps -a

docker container run --rm -it ubuntu:14.04 bash

docker ps -a

## Assignment Answers: DNS Round Robin Testing

docker network create dude

docker container run -d --net dude --net-alias search elasticsearch:2

docker container ls

docker container run --rm -- net dude alpine nslookup search

docker container run --rm --net dude centos curl -s search:9200

docker container ls

docker container rm -f TAB COMPLETION
