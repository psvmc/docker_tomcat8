# Pull base image  
FROM centos  
  
MAINTAINER psvmc "psvmc@outlook.com"  

# Set Charset 
ENV LANG en_US.UTF-8    
ENV LANGUAGE en_US:en    
ENV LC_ALL en_US.UTF-8 
  
# Install curl  
RUN yum -y install curl  
  
# Install JDK 8  

RUN cd /tmp &&  curl -L 'http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz  
RUN mkdir -p /usr/lib/jvm  
RUN mv /tmp/jdk1.8.0_171/ /usr/lib/jvm/java-8-oracle/  
  
# Set Oracle JDK 8 as default Java  
RUN update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-oracle/bin/java 300     
RUN update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-oracle/bin/javac 300     
  
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/  
  
# Install tomcat8  
RUN cd /tmp && curl -L 'https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v8.5.24/bin/apache-tomcat-8.5.24.tar.gz' | tar -xz  
RUN mv /tmp/apache-tomcat-8.5.24/ /opt/tomcat8/  
  
ENV CATALINA_HOME /opt/tomcat8  
ENV PATH $PATH:$CATALINA_HOME/bin  
  
ADD catalina.sh /opt/tomcat8/bin/catalina.sh
RUN chmod 755 /opt/tomcat8/bin/catalina.sh  
  
# Expose ports.  
EXPOSE 8080  
  
# Define default command.  
WORKDIR /opt/tomcat8/bin/
ENTRYPOINT startup.sh && tail -F /opt/tomcat8/logs/catalina.out

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone