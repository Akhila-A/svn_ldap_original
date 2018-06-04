#!/bin/bash

set -e
echo "LDAP enabled = ${LDAP_ENABLED}"

#cp -arf /resources/ports.conf ${APACHE_CONFDIR}/ports.conf
#cp -arf /resources/000-default.conf ${APACHE_CONFDIR}/sites-enabled/000-default.conf

if [ "${LDAP_ENABLED}" = true ];
  then
    SVN_CONFIG="<Location /svn>
        DAV svn
        #SVNListParentPath On
        SVNPath /var/svn/firstrepo
      #hzLDAPAuthoritative off
        AuthType Basic
        AuthName "SVN"
      #  AuthLDAPEnabled on
       # AuthLDAPAuthoritative on
        AuthBasicProvider ${LDAP_AUTH_PROTOCOL}
        AuthLDAPURL "${LDAP_URL}"
        AuthLDAPGroupAttribute ${LDAP_GROUP_ID_ATTRIBUTE}
        AuthLDAPBindDN "${LDAP_BIND_DN}"
        AuthLDAPBindPassword "${LDAP_BIND_PASSWORD}"
        Require valid-user
    </Location>"
else
  SVN_CONFIG="<Location /svn>
    DAV svn
    SVNPath /var/svn/firstrepo
  </Location>"
fi

cat > ${APACHE_CONFDIR}/mods-available/dav_svn.conf <<EOM
$SVN_CONFIG
EOM

cd /var/svn
svnadmin create firstrepo
mkdir ~/mainrepo
cd ~/mainrepo
mkdir trunk tags branches
svn import ~/mainrepo file:///var/svn/firstrepo -m 'Adding Initial Directories'

svnserve -d -r /var/svn/firstrepo
apache2 -DFOREGROUND
#service apache2 start
