FROM ubuntu:16.04

ENV APACHE_PORT=80 \
    APACHE_CONFDIR=/etc/apache2 \
    APACHE_ENVVARS=$APACHE_CONFDIR/envvars \
    APACHE_RUN_USER=www-data \
    APACHE_RUN_GROUP=www-data \
    APACHE_RUN_DIR=/var/run/apache2 \
    APACHE_PID_FILE=$APACHE_RUN_DIR/apache2.pid \
    APACHE_LOCK_DIR=/var/lock/apache2 \
    APACHE_LOG_DIR=/var/log/apache2 \
    LDAP_ENABLED=true \
    LDAP_SEARCH_BASE="" \
    LDAP_URL="" \
    LDAP_PORT=389 \
    LDAP_AUTH_PROTOCOL=ldap \
    LDAP_USER_EMAIL_ATTRIBUTE=mail \
    LDAP_GROUPS_AS_ROLES=true \
    LDAP_GROUP_BASE_DN=ou=groups \
    LDAP_GROUP_ID_ATTRIBUTE=cn \
    LDAP_GROUP_MEMBER_ATTRIBUTE=uniqueMember \
    LDAP_GROUP_OBJECT_CLASS=groupOfUniqueNames \
    LDAP_PREFERRED_PASSWORD_ENCODING=crypt \
    LDAP_USER_ID_ATTRIBUTE=uid \
    LDAP_USER_PASSWORD_ATTRIBUTE=userPassword \
    LDAP_USER_OBJECT_CLASS=inetOrgPerson \
    LDAP_USER_BASE_DN=ou-people \
    LDAP_USER_REAL_NAME_ATTRIBUTE=cn \
    LDAP_GROUP_MEMBER_FORMAT=dn


RUN apt-get update  && \
#    apt-get install python-software-properties -y && \
#   apt-get install apt-file -y && \
#    apt-file update && \
#    apt-get install software-properties-common -y && \
 
    apt-get install -y \
    apache2 \
    subversion \
    subversion-tools \
    libapache2-svn  
#    a2enmod ldap  \
#    a2enmod authnz_ldap

RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR /var/svn

EXPOSE $APACHE_PORT 3690

RUN mkdir -p /var/svn && \
    cd /var/svn

COPY resources/ /resources/
COPY resources/start_apache2_svn.sh /usr/local/bin/start_apache2_svn.sh

RUN chmod +x /usr/local/bin/start_apache2_svn.sh

#VOLUME ["/etc/apache2/"]

ENTRYPOINT ["/usr/local/bin/start_apache2_svn.sh"]
