FROM mcr.microsoft.com/oryx/php-7.3:20190518.2
LABEL maintainer="Azure App Services Container Images <appsvc-images@microsoft.com>"

ENV PHP_VERSION 7.3
COPY init_container.sh /bin/
COPY hostingstart.html /home/site/wwwroot/hostingstart.html

# install the PHP extensions we need
RUN chmod 755 /bin/init_container.sh \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home/site/wwwroot" >> /etc/bash.bashrc 

RUN chmod 777 /bin/init_container.sh \
   && mkdir -p /home/LogFiles \
   && ln -s /home/site/wwwroot /var/www/html 

ENV PORT 8080
ENV SSH_PORT 2222
EXPOSE 2222 8080
COPY sshd_config /etc/ssh/

# setup default site
RUN mkdir -p /opt/startup
COPY generateStartupCommand.sh /opt/startup/generateStartupCommand.sh
RUN chmod 755 /opt/startup/generateStartupCommand.sh

ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR /var/www/html

ENTRYPOINT ["/bin/init_container.sh"]
