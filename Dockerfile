FROM java:openjdk-8-alpine
ENV WILDFLY_VERSION 9.0.2.Final
ENV MYSQL_DRIVER_VERSION mysql-connector-java-5.1.40
RUN apk add --no-cache openssh supervisor wget
RUN mkdir -p /tmp/downloads
ADD http://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.zip /tmp/downloads/
ADD http://dev.mysql.com/get/Downloads/Connector-J/$MYSQL_DRIVER_VERSION.zip /tmp/downloads/
ADD resources/supervisord.conf /etc/supervisord.conf
ADD resources/sshd_config /etc/ssh/sshd_config
ADD resources/install-mysql-driver.sh /tmp/install-mysql-driver.sh
RUN ssh-keygen -A && echo "root:xebialabs" | chpasswd
RUN mkdir -p /opt && unzip -q /tmp/downloads/wildfly-$WILDFLY_VERSION.zip -d /opt && mv /opt/wildfly-$WILDFLY_VERSION /opt/wildfly && /bin/sh /tmp/install-mysql-driver.sh
ADD resources/mgmt-users.properties /opt/wildfly/standalone/configuration/mgmt-users.properties
ADD resources/mgmt-users.properties /opt/wildfly/domain/configuration/mgmt-users.properties
RUN apk del wget && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/usr/bin/supervisord"]
EXPOSE 22 8080 9990