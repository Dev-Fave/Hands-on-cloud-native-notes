# Kubernetes Core Objects

Deploying cloud native notes app to Kubernetes using some Kubernetes core objects.

**NOTE: The file `kind-config.yaml` in this directory is the configuration for the bootcamp.**
**To avoid issues, kindly delete the cluster you created in week 1 and use the file to create a new cluster.**
**It contains the necessary configuration for this bootcamp. Do this before the tasks to avoid stories.**

## Week 3 - Tasks
- Build image `cloud-native-notes:2.0` using the files in `backend/`
- Load the image to Kind
- Deploy the Kubernetes objects using the manifest files in `k8s/`
- Check the pods to see if running
- Port forward the service to access the app.  
- Post messages to the backend.
- Test the application and view your notes.
- Restart the backend deployment and view your notes again

## Extra Challenges
- Push the image to Docker Hub or another registry
- Redeploy the backend by editing the manifest file to: 
    - pull that new image rather than using the local image loaded to Kind
    - change the replica from 2 to 4

## To Think About
- Was there any error when creating the Kubernetes objects? Why or why not?
- What other errors did you encounter and how did you solve them?
- Explore the manifest files in `k8s/`. What is the importance of the resource section in the `backend-deployment` manifest file?

## Solution Guide

- Load the local image to Kind to avoid ImagePullBack error

    `kind load docker-image cloud-native-notes:2.0 --name (YOUR-BOOTCAMP-CLUSTER-NAME)`

- Deploy to Kubernetes

    `kubectl apply`

- Port forwarding to test the app

    `kubectl port-forward -n cloud-native-notes svc/backend 3000:3000`

- On another terminal, post the following messages
    ```
    curl -X POST http://localhost:3000/api/notes -H "Content-Type: application/json" -d '{"title":"Week 1","content":"Getting Ready!"}'

    curl -X POST http://localhost:3000/api/notes -H "Content-Type: application/json" -d '{"title":"Week 2","content":"Containers and Images"}'

    curl -X POST http://localhost:3000/api/notes -H "Content-Type: application/json" -d '{"title":"Week 3","content":"Working on Kubernetes!"}'
    ```
    
- Test the app
    ```
    curl http://localhost:3000/api/notes
    
    curl http://localhost:3000/health
    ```

## Verify

Run the verification script `./verify-week3.sh`

If your verification score is 100%, you are good to go!

If not, read the report and rectify the error(s).

If you are stucked after several trials, ask for help in the group.
