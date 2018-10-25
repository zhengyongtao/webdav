#!/bin/bash
htpasswd -cb /etc/webdav.password $USERNAME $PASSWORD
chown www-data /etc/webdav.password
#chmod 640 /etc/webdav.password
chown daemon -R /var/webdav
httpd-foreground
