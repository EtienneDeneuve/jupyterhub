FROM jupyterhub/jupyterhub:latest

# Install jupyterhub
RUN useradd -d /admin -m -p cZlGSVzup98uU admin

WORKDIR /opt
COPY jupyterhub_config.py /srv/jupyterhub/
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret

# Install jupyter notebook
RUN apt-get update
RUN pip install jupyter

# Add R package
RUN apt-get install -y apt-transport-https apt-utils
# Upload key deactivated because of server time-out --> --force-yes during apt-get install
# RUN apt-key adv --keyserver keys.gnupg.net --recv-key 6212B7B7931C4BB16280BA1306F90DE5381BA480
RUN echo "deb https://cran.univ-paris1.fr/bin/linux/debian jessie-cran3/" >> /etc/apt/sources.list.d/R.list

# Install prerequisites packages
RUN apt-get update
RUN apt-get install --force-yes -y libcurl4-gnutls-dev libssl-dev r-base r-base-dev
RUN apt-get clean

# Prepare install Java
RUN apt-get purge openjdk-\*

# Install Java 8
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
RUN tar xfvz jdk-8u121-linux-x64.tar.gz
RUN mkdir /usr/local/java
RUN mv jdk1.8.0_121 /usr/local/java/
RUN rm jdk-8u121-linux-x64.tar.gz

# Install Spark - https://toree.incubator.apache.org/documentation/user/installation.html
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.6.tgz
RUN tar xfvz spark-2.1.0-bin-hadoop2.6.tgz
RUN rm /opt/spark-2.1.0-bin-hadoop2.6.tgz
RUN mv /opt/spark-2.1.0-bin-hadoop2.6 /usr/local/bin/apache-spark

# Set ENV
ENV JAVA_HOME /usr/local/java/jdk1.8.0_121
ENV JAVA_JRE $JAVA_HOME/jre
ENV PATH $JRE_HOME/bin:$JAVA_HOME/bin:/usr/local/bin/apache-spark/bin:$PATH
ENV SPARK_HOME /usr/local/bin/apache-spark
RUN echo "JAVA_HOME=/usr/local/java/jdk1.8.0_121" >> /usr/local/bin/apache-spark/conf/spark-env.sh
RUN echo "JAVA_JRE=$JAVA_HOME/jre" >> /usr/local/bin/apache-spark/conf/spark-env.sh
RUN echo "PATH=$JRE_HOME/bin:$JAVA_HOME/bin:/usr/local/bin/apache-spark/bin:$PATH" >> /usr/local/bin/apache-spark/conf/spark-env.sh
RUN echo "SPARK_HOME=/usr/local/bin/apache-spark" >> /usr/local/bin/apache-spark/conf/spark-env.sh

# Install Toree
RUN pip install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
RUN jupyter toree install --spark_opts='--master=local[4]' --spark_home='/usr/local/bin/apache-spark' --interpreters=Scala,PySpark,SparkR,SQL

# Install kernel R from R script
COPY setup_r_kernel.R /opt/
RUN R -f /opt/setup_r_kernel.R

# Install additional python libs (example...)
RUN pip install ipyparallel numpy

# /!\ Allow install packages on the fly from note /!\
RUN chmod -R 777 /usr/lib/R/site-library

WORKDIR /srv/jupyterhub
