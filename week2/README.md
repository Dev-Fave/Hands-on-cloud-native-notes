# Containers & Images

Build and run Cloud Native Notes found in `app.py`  written in Python.


## Week 2 - Tasks 

- Build and tag the image `cloud-native-notes:1.0` 
- Run the container in detached mode with port 3000. stop.
- Run the container with environment variable APP_NAME="My App" using port 3000
- Test the running container
- Push the image to Docker Hub or to local registry

## Extra Challenge

- Find or create a simple app of your choice, write the Dockerfile, build the image and run it.
- Explore Docker Hub. Pull and run the latest images of  nginx, mongodb and ubuntu and any other interesting images.
- Explore some other docker commands learnt in class or  found online.

**Note: You may wish to delete some unused images from your machine after getting your verification score.**

## To Think About
- What is the meaning and uses of the various flags in the command line?
- What did you learn anything about port mapping? How did you solve any issue encountered?

## Solution Guide

- To build and tag
`docker build -t`

- To run a container
`docker run`

- Test the application 
`curl http://localhost:3000/health` or `curl http://localhost:3000/`

## Verify

Run the verification script `./verify-week2.sh`

If your verification score is 100%, you are good to go!

If not, read the report and rectify the error(s).

If you are stucked after several trials, ask for help in the group.

Note some extra challenges are required to get 100%. 
Document and share your learning publicly.
