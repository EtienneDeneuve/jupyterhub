FROM jupyterhub/jupyterhub:latest

# Install jupyterhub
RUN useradd -d /home/laurent -m -p laurent laurent
RUN wget https://raw.githubusercontent.com/lcolombier/jupyterhub/master/jupyterhub_config.py -O /srv/jupyterhub/jupyterhub_config.py
RUN pip install jupyter

# Install R
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
#RUN echo "deb http://cran.irsn.fr/bin/linux/ubuntu jessie/" >> /etc/apt/sources.list.d/R.list
RUN apt-get update
RUN apt-get install -y r-base r-base-dev

WORKDIR /opt
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret
RUN mkdir -p /mnt/jupyterhub

RUN echo "chooseCRANmirror(57)" >> /opt/setup_R_kernel
RUN echo "install.packages(c('pbdZMQ', 'repr', 'devtools'))" >> /opt/setup_R_kernel
RUN echo "devtools::install_github('IRkernel/IRdisplay')" >> /opt/setup_R_kernel
RUN echo "devtools::install_github('IRkernel/IRkernel')" >> /opt/setup_R_kernel
RUN echo "IRkernel::installspec(user = FALSE)"  >> /opt/setup_R_kernel
RUN R -f /opt/setup_R_kernel
