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

docker container --help

docker container ls -a

docker container rm 63f 690 ode

docker container ls

docker container rm -f 63f

docker container ls -a

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
