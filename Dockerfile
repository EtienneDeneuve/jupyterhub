FROM jupyterhub/jupyterhub:latest
RUN apt-get update

# Install jupyterhub
RUN useradd -d /admin -m -p cZlGSVzup98uU admin

COPY jupyterhub_config.py /srv/jupyterhub/

RUN pip install jupyter

# Install R
RUN apt-get install -y apt-transport-https apt-utils
# Upload key deactivated because of server time-out --> --force-yes during apt-get install
# RUN apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480
RUN echo "deb https://cran.univ-paris1.fr/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list.d/R.list

RUN apt-get update
RUN apt-get install --force-yes -y libcurl4-gnutls-dev libssl-dev r-base r-base-dev
RUN apt-get clean

# Clean Java
RUN apt-get purge openjdk-\*

# Retrieve Java 7 + Apache Toree packages - https://toree.incubator.apache.org/documentation/user/installation.html
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.6.tgz
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
RUN tar xfvz spark-2.1.0-bin-hadoop2.6.tgz
RUN tar xfvz jdk-8u121-linux-x64.tar.gz
RUN rm *.tar.gz

# env
RUN echo "JAVA_HOME='/usr/local/java/jdk1.8.0_121/'" >> /etc/environement
RUN echo "JAVA_JRE='$JAVA_HOME/jre'" >> /etc/environment
RUN echo "PATH='$PATH:$JRE_HOME/bin:$JAVA_HOME/bin'" >> /etc/environment
RUN echo "SPARK_HOME='/usr/local/bin/apache-spark/'" >> /etc/environment
RUN echo "PATH='$PATH:/usr/local/bin/apache-spark/bin'" >> /etc/environment
RUN source /etc/environement

# Install Java
RUN mkdir /usr/local/java
RUN mv jdk1.8.0_121 /usr/local/java/

# Install Toree
RUN mv /opt/spark-2.1.0-bin-hadoop2.6 /usr/local/bin/apache-spark
RUN pip install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz

RUN jupyter toree install --spark_opts='--master=local[4]' --spark_home='/usr/local/bin/apache-spark/' --interpreters=Scala,PySpark,SparkR,SQL

WORKDIR /opt
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret
RUN mkdir -p /mnt/jupyterhub

# Install kernel R
COPY setup_r_kernel.R /opt/
RUN R -f /opt/setup_r_kernel.R

# Install additional libs (pip)
RUN pip install ipyparallel
RUN pip install numpy

WORKDIR /srv/jupyterhub
