# jupyterhub + kernel R

## Download github jupyterhub
`mkdir /home/$USER/jupyterhub
cd jupyterhub
git init
get pull https://github.com/lcolombier/jupyterhub`

## Build de l'image docker
`docker build ../jupyterhub -t  jupyterhub:withR`

## Commandes utiles
`docker images (pour la liste des images)
docker ps -a (pour la liste des conteneurs qui s'exécutent avec docker run <image>)`

## Deployment dans kubernetes
`kubectl run jupyterhub --image jupyterhub:withR --namespace jupyterhub`
