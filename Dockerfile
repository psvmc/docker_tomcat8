# Pull base image  
FROM ubuntu:13.10  
  
MAINTAINER psvmc "psvmc@outlook.com"  

# Set Charset 
ENV LANG en_US.UTF-8    
ENV LANGUAGE en_US:en    
ENV LC_ALL en_US.UTF-8
  
# update source  
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe"> /etc/apt/sources.list  
RUN apt-get update  
  
# Install curl  
RUN apt-get -y install curl  
  
# Install JDK 8  
RUN cd /tmp &&  curl -L 'http://download.oracle.com/otn-pub/java/jdk/8u162-b12/0da788060d494f5095bf8624735fa2f1/jdk-8u162-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz  
RUN mkdir -p /usr/lib/jvm  
RUN mv /tmp/jdk1.8.0_162/ /usr/lib/jvm/java-8-oracle/  
  
# Set Oracle JDK 8 as default Java  
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-oracle/bin/java 300     
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-oracle/bin/javac 300     
  
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/  
  
# Install tomcat8  
RUN cd /tmp && curl -L 'https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz' | tar -xz  
RUN mv /tmp/apache-tomcat-8.5.24/ /opt/tomcat8/  
  
ENV CATALINA_HOME /opt/tomcat8  
ENV PATH $PATH:$CATALINA_HOME/bin  
  
ADD tomcat8.sh /etc/init.d/tomcat8  
RUN chmod 755 /etc/init.d/tomcat8  
  
# Expose ports.  
EXPOSE 8080  
  
# Define default command.  
ENTRYPOINT service tomcat8 start && tail -f /opt/tomcat8/logs/catalina.out 

 