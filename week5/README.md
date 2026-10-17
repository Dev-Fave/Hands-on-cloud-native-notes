# Basic Troubleshooting

Learn how to find information needed for troubleshooting. You have used some of this commands before. Let's dive deeper. 
 
## Week 5 - Tasks

- `kubectl get` 
- `kubectl describe`
- `kubectl logs`
- `kubectl events` 
- `kubectl exec` 
- `kubectl help`
- `kubectl explain`


## Extra Challenges

1. Explore other `kubectl` commands
2. Try `kubectl <command> --help` to gain further insight

## To Think About

- How helpful is the documentation on the CLI?


## Solution Guide
1. What's the pod state?

`kubectl get pods -n cloud-native-notes`

Look at: STATUS column (Pending, ContainerCreating, CrashLoopBackOff, Error, Running)

2. What does the cluster say?

`kubectl describe pod <pod-name> -n cloud-native-notes`

Look at: Events section at the bottom (this is where the real story is)

3. What does the app say?

`kubectl logs <pod-name> -n cloud-native-notes`

`kubectl logs <pod-name> -n cloud-native-notes --previous`  # For crashed pods

4. Get inside the pod

`kubectl exec -it <pod-name> -n cloud-native-notes -- /bin/sh`
Test: curl localhost:3000/health, ls -la /data, env | grep REDIS

5. What's happening in the cluster?

`kubectl get events -n cloud-native-notes --sort-by='.lastTimestamp'`

Look at: What happened recently? Scheduling? Image pulls? Volume mounts?

## Notes
This is a time take some rest and just reflect on your progress so far. 

Help others who are having difficulties and share your knowledge. 

Connect with fellow learners. Maybe your next co-founder is in this group.

Best Wishes!
