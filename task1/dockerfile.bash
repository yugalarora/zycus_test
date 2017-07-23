# 'FROM' will define the base image (like shebang in Shell), subsequent instructions will follow the same base image
# it's mandatory and must be defined in the first line, however can be changed anywhere below. here we have defined base image as Centos6 as per problem statement
FROM centos:centos6

# a non-executable, optional instruction, just denoting the author of the 'dockerfile'
MAINTAINER Yugal Arora <yugal.arora@outlook.com>

# Updating already installed packages and installing dependencies using yum, package manager
# 'RUN' executes the commands that follow, 
# '-y' option with yum is to assume 'yes' as answers for questions prompted by installer
# '&&' operator specifies to proceed with next command only if previous command executes successfully
# ' \' operator is to seperate packages into seperate lines, to improve readability and make file more understandable
# list is sorted alphabetically to make updating/ammending easier and avoid installing duplicate packages
RUN yum -y update && yum -y install \
    apr-devel \
	bzip2-devel \
	gcc \
    git \
    hostname \
    openssl \
    openssl-devel \
    sqlite-devel \
    sudo \
    tar \
    wget \
    zlib-dev

# Installing python 2.7 and scl package as below, and then setting s/w collection as auto enabled using 'scl'

RUN yum -y install centos-release-scl && \
    yum -y install python27 && \
    scl enable python27 bash

# Installing mongoDB v3.4

COPY mongodb-org-3.4.repo /etc/yum.repos.d/
RUN yum install -y mongodb-org \
 && mkdir -p /data/db    

# Installing Java 7 64 bit as 2nd alternative for tomcat-7
RUN cd /opt/ && \
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.tar.gz" && \
    tar xzf jdk-7u79-linux-x64.tar.gz 
    
RUN cd /opt/jdk1.7.0_79/ && \
    alternatives --install /usr/bin/java java /opt/jdk1.7.0_79/bin/java 2 && \
    echo | alternatives --config java  && \
    alternatives --install /usr/bin/jar jar /opt/jdk1.7.0_79/bin/jar 2 && \
    alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_79/bin/javac 2 && \
    alternatives --set jar /opt/jdk1.7.0_79/bin/jar && \
    alternatives --set javac /opt/jdk1.7.0_79/bin/javac

# Setting new JAVA in environment variables
ENV JAVA_HOME=/opt/jdk1.7.0_79
ENV JRE_HOME=/opt/jdk1.7.0_79/jre
ENV PATH=$PATH:/opt/jdk1.7.0_79/bin:/opt/jdk1.7.0_79/jre/bin

# Install Tomcat 7
RUN cd /opt/ && \
RUN wget "http://apache.mirrors.spacedump.net/tomcat/tomcat-7/v7.0.73/bin/apache-tomcat-7.0.73.tar.gz" -O apache-tomcat-7.0.73.tar.gz && \
	tar xvzf apache-tomcat-7.0.73.tar.gz && \
    mv apache-tomcat-7.0.73 /usr/local/tomcat7 && \
	rm /opt/apache-tomcat-7.0.73.tar.gz

#Starting services, we have not defined an entrypoint, so default is assumed as /bin/sh

CMD ["service mongod start"]
CMD ["/usr/local/tomcat7/bin/startup.sh"]

# Expose ports for tomcat and mongodb
EXPOSE 7080 8080
EXPOSE 27017 27017