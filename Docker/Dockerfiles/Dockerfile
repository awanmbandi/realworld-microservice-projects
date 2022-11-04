# Links to Documents That Explains The Bellow Dockerfile Operations (Dommands)
- https://www.howtoforge.com/tutorial/how-to-create-docker-images-with-dockerfile/
- https://dzone.com/articles/understanding-dockerfile#:~:text=of%20these%20commands.-,Dockerfile%20Commands,-FROM%C2%A0%2D%20specifies

FROM
- This allows you to define a Docker Base Image
- You can have multiple Base Images defined
- Examples:
    FROM ImageName
    FROM python
    FROM Nginx
    FROM tomcat
    FROM ubuntu

LABEL
- The "LABEL" instruction adds "metadata" to an "image"
- Examples: 
    LABEL <key>=<value> <key>=<value> <key>=<value>
    LABEL "com.example.vendor"="ACME Incorporated"
    LABEL version="1.0"
- Labels are additive including "LABELs" in "FROM images".
- This allows you to define a tag/label for your application 
- Allows for easy container reference
- If Docker encounters a label/key that already exists, the "new value overrides" any "previous labels" with identical keys
- To view an image’s labels, use the docker inspect command. They will be under the "Labels" JSON attribute.
- Not Every Image has One
- COMMAND: docker inspect "IMAGE_ID"

ENV
- The other important advantage is security issues. Storing passwords or other sensitive information directly in the Dockerfile is probably not the best idea. 
- Environment variables help overcome "PASSWORD/SECRET" exposure problems.
- You can use ENV to Identify which container is set to RUN WHERE, IN WHICH ENVIRONMENT 
- Set Enviornment Variables (Key value pairs)
- Example: Application name, 
- The environment variables set using ENV will persist when a container is run from the resulting image
    ENV <key> <value>
    ENV <key>=<value> [<key>=<value> ...]
    ENV environment=prod
    ENV appname=webapp appversion=v01

WORKDIR
- Sets the working directory for any "RUN", "CMD", "ENTRYPOINT", "COPY", and "ADD" instructions that follow it.
- Example:  WORKDIR /app
- This is the directory where Docker packages/download your app code to during the Build Process
- This tells Docker what directly to use as default Working Directory 
- It can be used multiple times in the one Dockerfile. If a relative path is provided, it will be relative to 
  the path of the previous WORKDIR instruction.

USER
- This Instruction Tells Docker Which User You Want to Use when Running/Executing the image 
  and Container using "RUN", "CMD" and "ENTRYPOINT" specified in the Dockerfile
- The "USER" instruction sets the user name or UID to use when running the image and for any "RUN", "CMD" 
  and "ENTRYPOINT" instructions that follow it in the Dockerfile
      USER <username | UID>
- By "Default Docker Uses" the "Root" user Priviledge (This could be VERY RISKY)

RUN
- This gets Executed During the BUILD OF THE IMAGE 
- You use this instruction to perform installations of packages, Libraries, Dependencies on the Container etc
- Example: 
    RUN yum install python -y
    RUN ["c:\windows\system32\tasklist.exe"] 
    RUN yum update -y


COPY
- This gets Executed During the BUILD OF THE IMAGE 
- Copies new files or directories from ["<src> ..."] and adds them to the filesystem of the image at the path ["<dest>"]
- COPY <src> [<src> ...] <dest>
- <src> must be relative to the source directory that is being built (the context of the build).
- ["<src>", ... "<dest>"] (this form is required for paths containing whitespace)
- "<dest>" is an absolute path, or a path relative to "WORKDIR".

ADD
- If <src> is a file or directory, then they must be relative to the source directory that is being built (the context of the build).
- This allowes you to download particular files/content from certain locations to the Container
- Example: https:// /mnt/app-storage/
- Copies new files, directories, or remote file URLs from <src> and adds them to the filesystem of the image at the path <dest>
- <dest> is an absolute path, or a path relative to WORKDIR.
- If <dest> doesn’t exist, it is created along with all missing directories in its path.


VOLUME
  - Creates a mount point with the specified name and marks it as holding externally 
    mounted volumes from native host or other containers.
  - The VOLUME instruction should be used to expose any database storage area,
    configuration storage, or files/folders created by your docker container.
  - ["<path>", ...]
  - <path> [<path> ...]

HEALTHCHECK
- You can use this to check container health by running a command inside the container
- HEALTHCHECK NONE (disable any healthcheck inherited from the base image)

**Information:**

- Tells Docker how to test a container to check that it is still working
- Whenever a health check passes, it becomes healthy. After a certain number of consecutive failures, it becomes unhealthy.
- The <options> that can appear are...
    --interval=<duration> (default: 30s)
    --timeout=<duration> (default: 30s)
    --retries=<number> (default: 3)
- The health check will first run interval seconds after the container is started, and then again interval seconds after each previous check completes. If a single run of the check takes longer than timeout seconds then the check is considered to have failed. It takes retries consecutive failures of the health check for the container to be considered unhealthy.
- There can only be one HEALTHCHECK instruction in a Dockerfile. If you list more than one then only the last HEALTHCHECK will take effect.
- <command> can be either a shell command or an exec JSON array.
- The commands exit status indicates the health status of the container.
    0: success - the container is healthy and ready for use
    1: unhealthy - the container is not working correctly
    2: reserved - do not use this exit code
- When the health status of a container changes, a health_status event is generated with the new status.


EXPOSE
- This allows you to Expose the Application via a certain port
- Example: Port 80 for Nginx, Port 8080 for Jenkins, Port 3000 for Grafana etc 
- You can later map this port to the HOST port

CMD
- This command is what STARTS the application in the Docker Container
- This Operation and the `Entrypoint` command in the Dockerfile will only get Executed when we create the Container from the Image
- This command and the `Entrypoint` commands will only be Executed during the deployment of the Container not duing Image Build
- There can only be one CMD instruction in a Dockerfile. If you list more than one CMD then only the last CMD will take effect.


ENTRYPOINT
- Same as "CMD", USE to START the application in the Docker Container. 
- The Only difference is, this would RUN despite if you pass an Argument on the command line for ENTRYPOINT
- If you have certain actions/opertations to perform after the Container is Stood Up then you can use Entrypoint for that
- This Operation and the CMD command in the Dockerfile will only get Executed when we create the Container from the Image
- This command and the `CMD` commands will only be Executed during the deployment of the Container not duing Image Build


## BUILD AND PUSH TO DOCKER HUB (STEP by STEP)
- https://docs.docker.com/docker-hub/

- Make sure to tag the IMAGE with Your Repository name "awanmbandi/httpd:tagname"

- docker login

- docker push awanmbandi/httpd:tagname


# Dockerfile Instructions Sumaary 
FROM
LABEL
ENV
WORKDIR
USER
RUN
COPY
ADD
VOLUME
HEALTHCHECK
EXPOSE
Entrypoint
CMD

