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

# Clean Java
RUN apt-get purge openjdk-\*

# Retrieve Java 7 + Apache Toree packages - https://toree.incubator.apache.org/documentation/user/installation.html
RUN wget http://d3kbcqa49mib13.cloudfront.net/spark-2.1.0-bin-hadoop2.6.tgz
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
RUN tar xfvz spark-2.1.0-bin-hadoop2.6.tgz
RUN tar xfvz jdk-8u121-linux-x64.tar.gz
RUN rm *.tar.gz

# Install Java + env
RUN mkdir /usr/local/java
RUN mv jdk1.8.0_121 /usr/local/java/
RUN export JAVA_HOME=/usr/local/java/jdk1.8.0_121
RUN export JAVA_JRE=$JAVA_HOME/jre
RUN export PATH="$PATH:$JRE_HOME/bin:$JAVA_HOME/bin"update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/jdk1.8.0_121/bin/java" 1
RUN export PATH="$PATH:$JRE_HOME/bin:$JAVA_HOME/bin"update-alternatives --install "/usr/bin/javac" "javac" "/usr/local/java/jdk1.8.0_121/bin/javac" 1
RUN export PATH="$PATH:$JRE_HOME/bin:$JAVA_HOME/bin"update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/local/java/jdk1.8.0_121/bin/javaws" 1
RUN update-alternatives --set java /usr/local/java/jdk1.8.0_121/bin/java 
RUN update-alternatives --set javac /usr/local/java/jdk1.8.0_121/bin/javac
RUN update-alternatives --set javaws /usr/local/java/jdk1.8.0_121/bin/javaws

# Install Toree
RUN mv /opt/spark-2.1.0-bin-hadoop2.6 /usr/local/bin/apache-spark
RUN pip install https://dist.apache.org/repos/dist/dev/incubator/toree/0.2.0/snapshots/dev1/toree-pip/toree-0.2.0.dev1.tar.gz
RUN export SPARK_HOME=/usr/local/bin/apache-spark/ 
RUN export PATH="$PATH:/usr/local/bin/apache-spark/bin"
RUN jupyter toree install --spark_opts='--master=local[4]' --spark_home='/usr/local/bin/apache-spark/'
RUN jupyter toree install --interpreters=Scala,PySpark,SparkR,SQL

WORKDIR /opt
RUN openssl rand -hex 1024 > configproxy.token
RUN openssl rand -hex 32 > cookie.secret
RUN mkdir -p /mnt/jupyterhub

# Install kernel R
COPY setup_r_kernel.R /opt/
RUN R -f /opt/setup_r_kernel.R

WORKDIR /srv/jupyterhub
