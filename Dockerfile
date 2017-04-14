FROM jupyterhub/jupyterhub:latest
RUN apt-get update

# Install jupyterhub
# RUN useradd -d /home/laurent -m -p IrFM2Of9004Cs laurent
RUN useradd -d /admin -m -p cZlGSVzup98uU admin

COPY jupyterhub_config.py /srv/jupyterhub/

RUN pip install jupyter

# Install R
RUN apt-get install -y apt-transport-https apt-utils
# RUN apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480
RUN echo "deb https://cran.univ-paris1.fr/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list.d/R.list

RUN apt-get update
RUN apt-get install --force-yes -y libcurl4-gnutls-dev libssl-dev r-base r-base-dev
RUN apt-get clean

WORKDIR /opt
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret
RUN mkdir -p /mnt/jupyterhub

# Install kernel R
COPY setup_r_kernel.R /opt/
RUN R -f /opt/setup_r_kernel.R

WORKDIR /srv/jupyterhub
