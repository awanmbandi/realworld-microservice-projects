docker build -t apache-webapp .

docker images

docker run apache-webapp -p 8900:80 -d --name apache-webapp

## Check Docker IMAGE LABELS, ENV and Full Configuration
docker inspect "IMAGE_ID" 

# For LABELS
docker inspect 7e486f0e2b7f | grep Labels 


######################## Second Demo ########################
Once you run the flask app 

(This would show you everything that was copied from local by Docker using the "COPY . . ")
- Login to the container and run 
    - pwd
    - ls -al

