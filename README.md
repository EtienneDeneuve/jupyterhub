# Download github jupyterhub
* mkdir /root/repo_git
* cd repo_git
* git init
* get pull https://github.com/lcolombier/jupyterhub
* cd ..
* mkdir jupyterhub
* cd jupyterhub
* cp ../repo_git/* ./
* cd ..

# Build de l'image docker
>  docker build . -t withr

# Test du docker
> docker exec -i -t <container> /bin/bash

# Identification de l'image
> docker images

# Tag de l'image docker
> docker tag <id_image> l2cconseils/jupyterhub:latest

# Login dockerhub
> docker login

# Upload de l'image
> docker push l2cconseils/jupyterhub:latest

# Suppression des images locales
> docker images
ou
> docker rim <id_image>
si besoin de forcer -f

# Lien avec GitHub
Dans le site docker faire le lien avec GitHub et lancer le build.

# Deployment dans kubernetes
> kubectl run jupyterhub --image jupyterhub/jupyterhub:latest --namespace jupyterhub
> kubectl run jupyterhubwithr --image lcolombier/jupyterhub:latest --namespace jupyterhub

# Exposition du contener
> kubectl expose deployments jupyterhubwithr --namespace=jupyterhub --port=8000 --type=LoadBalancer --name=jupyterhubwithr

# Test accès au service
http://[ip-master-kubernetes ou hostname masterkubernetes]:31087/

# Conteneur id
> kubectl exec -i -t <container> /bin/bash
