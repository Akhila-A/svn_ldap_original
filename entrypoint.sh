#!/bin/bash
svnserve -d -r /home/svn/myproject
source /etc/apache2/envvars
apache2 -DFOREGROUND
service apache2 start
tail -f /var/log/apache2/access.log
~
