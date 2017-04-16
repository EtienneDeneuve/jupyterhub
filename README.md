# Build docker image
docker build . -t <tag>

# Tip & tricks : How to Test
docker exec -i -t <container> /bin/bash
## Identification of docekr image
docker images
## Tag docker image
docker tag <id_image> l2cconseils/jupyterhub:latest
## How to push image?
1. Login dockerhub
2. docker push l2cconseils/jupyterhub:latest

# Delete local images
*docker images* then *docker rim <id_image>*, if necessary use *docker rim -f <id_image>* to force deletion.

# Deployment with Kubernetes
Go to Deployment directory and follow step 1, 2, 3. Add comments if you'd like to share an optimized version!

# Run web-ui / api
http://your_master_hostname:30300 / http://your_master_hostname:30301

# once deployed you still can go inside if you need to
> kubectl exec -i -t <container> /bin/bash
