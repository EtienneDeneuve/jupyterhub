# jupyterhub + kernel R

## Download github jupyterhub
`bash
mkdir /home/$USER/jupyterhub
cd jupyterhub
git init
get pull https://github.com/lcolombier/jupyterhub`

## Build de l'image docker
`bash
docker build ../jupyterhub -t  jupyterhub:withR`

## Commandes utiles
`bash
docker images (pour la liste des images)
docker ps -a (pour la liste des conteneurs qui s'exécutent avec docker run <image>)`

## Deployment dans kubernetes
`bash 
kubectl run jupyterhub --image jupyterhub:withR --namespace jupyterhub`
