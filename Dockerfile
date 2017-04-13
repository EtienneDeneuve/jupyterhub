FROM jupyterhub/jupyterhub:latest
RUN apt-get update

# Install jupyterhub
RUN useradd -d /home/laurent -m -p IrFM2Of9004Cs laurent
RUN wget https://raw.githubusercontent.com/lcolombier/jupyterhub/master/jupyterhub_config.py -O /srv/jupyterhub/jupyterhub_config.py
RUN pip install jupyter

# Install R
RUN apt-get install -y apt-transport-https apt-utils
# RUN apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480
RUN echo "deb https://cran.univ-paris1.fr/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list.d/R.list

RUN apt-get update
RUN apt-get install --force-yes -y libcurl4-gnutls-dev libssl-dev r-base r-base-dev

WORKDIR /opt
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret
RUN mkdir -p /mnt/jupyterhub

# Install kernel R
RUN wget https://raw.githubusercontent.com/lcolombier/jupyterhub/master/setup_r_kernel.R -O /opt/setup_r_kernel.R
RUN R -f /opt/setup_r_kernel.R
