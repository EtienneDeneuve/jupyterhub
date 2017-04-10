FROM jupyterhub/jupyterhub:latest

# Install jupyterhub
RUN useradd -d /home/laurent -m -p laurent laurent
RUN wget https://raw.githubusercontent.com/lcolombier/jupyterhub/master/jupyterhub_config.py -O /srv/jupyterhub/jupyterhub_config.py
RUN pip install jupyter

# Install R
RUN apt-get update
RUN apt-get install -y apt-utils libcurl4-openssl-dev libssl-dev
RUN apt-get install -y r-base r-base-dev

WORKDIR /opt
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret
RUN mkdir -p /mnt/jupyterhub

# Install kernel R
RUN wget https://raw.githubusercontent.com/lcolombier/jupyterhub/master/setup_r_kernel.R -O /opt/setup_r_kernel.R
RUN R -f /opt/setup_r_kernel.R
