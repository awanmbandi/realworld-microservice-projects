docker build -t apache-webapp .

docker images

docker run -p 3309:80 -d --name flask-app-v2 flask-app-2:latest

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

