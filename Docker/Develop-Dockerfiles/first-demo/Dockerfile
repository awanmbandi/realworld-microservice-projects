################################################################
#      Dockerfile - 2: Add the below to Dockerfile - 3         #
################################################################
FROM ubuntu
RUN apt-get update
RUN apt-get -y install apache2
# Add/Copy all the files in the current Directory where you're running this/Dockerfile location to /var/www/html 
ADD . /var/www/html 
#USER root
#LABEL "com.example.vendor"="ACME Incorporated"
ENV name apache-webapp
# This ENTRYPOINT runs apache automatically
# apachectl -DFOREGROUND runs in the foreground. 
# In other words, it blocks the progress of your entrypoint script until apachectl exits
ENTRYPOINT apachectl -D FORCEGROUND 
