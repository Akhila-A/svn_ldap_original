FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install apache2 -y && \
    a2enmod ldap && \
    a2enmod authnz_ldap && \
    apt-get install subversion subversion-tools libapache2-svn -y 
ENV PORT "$PORT"
RUN addgroup subversion && \
    useradd -G subversion admin
#    useradd -G subversion www-data
RUN mkdir -p /var/svn/repos/
WORKDIR /var/svn/repos
RUN mkdir Repository1 && \
    svnadmin create /var/svn/repos/Repository1
WORKDIR /var/svn/repos
RUN chown -R www-data:subversion Repository1 && \
    chmod -R g+rws Repository1
WORKDIR /etc/apache2/mods-available/
COPY src/dav_svn.conf .
#WORKDIR /etc/apache2/sites-available
#COPY src/000-default.conf .
#RUN sed -i -e 's/var\/www\/html'/home\/svn/myproject/g /etc/apache2/sites-available
RUN sed -i "s|var/www/html|var/svn/repos/Repository1|g" /etc/apache2/sites-available/000-default.conf 
#RUN source /etc/apache2/envvars 
#RUN apache2 -V
RUN  echo "ServerName localhost" |  tee /etc/apache2/conf.d/fqdn
RUN service apache2 restart
#RUN /etc/init.d/apache2 restart
#EXPOSE 80 3690
EXPOSE ${PORT}
COPY entrypoint.sh /tmp/
#RUN chmod -R 777 entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh","run"] 
#RUN svn --version
