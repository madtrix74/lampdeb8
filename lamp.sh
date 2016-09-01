#!/bin/bash
. /root/lampdeb8/lampdeb8/var.sh
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Installation de apache2 php5 plus bibliotec." "$NORMAL"
	sleep 3
			apt-get install -y php5
			apt-get install -y libapache2-mod-php5 php5-cgi php5-cli php5-curl php5-imap php5-gd php5-mysql php5-pgsql php5-json php5-mcrypt php5-xmlrpc php5-gmp php5-xsl
			a2enmod ssl
			a2enmod rewrite
			a2enmod userdir
			a2enmod suexec
			a2enmod include
			a2enmod php5
			a2enmod auth_digest
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Installation de Mysql." "$NORMAL"
	sleep 3
		echo mysql-server mysql-server/root_password password $MYSQL_PASS | debconf-set-selections
		echo mysql-server mysql-server/root_password_again password $MYSQL_PASS | debconf-set-selections
		apt-get -q -y install mysql-server
		cp /etc/mysql/my.cnf /etc/mysql/my.bak.cnf
		sed -i "47s/^/#/" /etc/mysql/my.cnf
		mysql -uroot -p$MYSQL_PASS -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '"$MYSQL_PASS"'; FLUSH PRIVILEGES;" 
		service mysql restart
		logo

		echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Installation de PhpMyadmin." "$NORMAL"
	sleep 3
		echo phpmyadmin phpmyadmin/dbconfig-install boolean true | debconf-set-selections
		echo phpmyadmin phpmyadmin/app-password-confirm password $MYSQL_PASS | debconf-set-selections
		echo phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_PASS | debconf-set-selections
		echo phpmyadmin phpmyadmin/mysql/app-pass password $MYSQL_PASS | debconf-set-selections
		echo phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2 | debconf-set-selections
		apt-get install -q -y phpmyadmin
		service mysql restart
		

		sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-enabled/security.conf
		sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-enabled/security.conf
		sed -i 's/TraceEnable On/TraceEnable Off/' /etc/apache2/conf-enabled/security.conf
		sed -i 's/disable_functions =/disable_functions = show_source, system, exec/' /etc/php5/apache2/php.ini
		sed -i 's/expose_php = On/expose_php = Off/' /etc/php5/apache2/php.ini
		sed -i 's/display_errors = On/display_errors = Off/' /etc/php5/apache2/php.ini
		sed -i 's/log_errors = Off/log_errors = On/' /etc/php5/apache2/php.ini
		sed -i 's/allow_url_fopen = On/allow_url_fopen = Off/' /etc/php5/apache2/php.ini
		rm /etc/apache2/mods-available/php5.conf
		cat << EOF > /etc/apache2/mods-available/php5.conf
<IfModule mod_php5.c>
    <FilesMatch "\.ph(p3?|tml)$">
        SetHandler application/x-httpd-php
    </FilesMatch>
    <FilesMatch "\.phps$">
        SetHandler application/x-httpd-php-source
    </FilesMatch>
    # To re-enable php in user directories comment the following lines
    # (from <IfModule ...> to </IfModule>.) Do NOT set it to On as it
    # prevents .htaccess files from disabling it.
    #<IfModule mod_userdir.c>
    #    <Directory /home/*/public_html>
    #        php_admin_value engine Off
    #    </Directory>
    #</IfModule>
</IfModule>
EOF

#on config userdir.conf
	sed -i 's/AllowOverride FileInfo AuthConfig Limit Indexes/AllowOverride All/' /etc/apache2/mods-available/userdir.conf
	sed -i '/Options MultiViews Indexes SymLinksIfOwnerMatch IncludesNoExec/d' /etc/apache2/mods-available/userdir.conf

	
		cat > /etc/php5/conf.d/custom.ini << EOF
cgi.fix_pathinfo = 1
extension=gd2.so
extension=pdo.so
extension=pdo_mysql.so 
extension=php_pgsql.so
extension=php_pdo_pgsql.so
EOF


		echo "ServerName $HOSTNAME" >> /etc/apache2/apache2.conf
		

		echo proftpd shared/proftpd/inetd_or_standalone select standalone | debconf-set-selections
		apt-get purge -q -y proftpd
		apt-get install -q -y proftpd
		sed -i 's|# RequireValidShell|RequireValidShell|g' /etc/proftpd/proftpd.conf
		sed -i 's|# DefaultRoot|DefaultRoot|g' /etc/proftpd/proftpd.conf
		

		service apache2 restart
		service proftpd restart

				mkdir /var/www/html/admin
		cat << EOF > /var/www/html/admin/madinfo.php
<html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<style type="text/css">
.monbloc{
   width:90%; /* Largeur du bloc */
   height: auto; /* Hauteur du bloc */
   padding:5px; /* Marges intérieures */
   border: 1px dashed gray; /* bordure en pointillé, d'un pixel et en gris */
   font-family:"century gothic";
   font-size:11px;
   -moz-box-shadow: 10px 10px 5px 0px #656565;
   -webkit-box-shadow: 10px 10px 5px 0px #656565;
   -o-box-shadow: 10px 10px 5px 0px #656565;
   box-shadow: 5px 5px 5px 0px #656565;
   filter:progid:DXImageTransform.Microsoft.Shadow(color=#656565, Direction=134, Strength=5);
   -moz-border-radius: 5px;
   -webkit-border-radius: 5px;
   border-radius: 5px;
} 
.motcle{
   font-family:arial;
   font-size:20px;
   color:#ff9900;
} 
</style>
	</head>
		<div class="monbloc"><span class="motcle">Information System :</span>
        					<?php echo "<pre><b>Distro : </b>".shell_exec('cat /proc/version')."</pre>"; ?>
        					<?php echo "<pre><b>Hostname : </b>".shell_exec('uname -n')."</pre>"; ?>
        					<?php echo "<pre><b>Kernel : </b>".shell_exec('uname -r')."</pre>"; ?>
        					<?php echo "<pre><b>Uptime : </b>".shell_exec("uptime | awk '{print $3,$4,$5}' | sed 's/,$//'")."</pre>"; ?>
		</div></br>
		<div class="monbloc"><span class="motcle">Information CPU :</span>
							<?php echo "<pre><b>CPU : </b>".shell_exec("cat /proc/cpuinfo | grep \"model name\" | awk '{print $4,$5,$6,$7,$8,$9}' | tail -1")."</pre>"; ?>
							<?php echo "<pre><b>CPU Cores : </b>".shell_exec("cat /proc/cpuinfo | grep processor | tail -1 | awk '{print $3+1}'")."</pre>"; ?>
							<?php echo "<pre><b>CPU frequency (MHz): </b>".shell_exec("cat /proc/cpuinfo|grep MHz|head -1|awk '{ print $4 }'")."</pre>"; ?>
        </div></br>
		<div class="monbloc"><span class="motcle">Information Memoire :</span>				
							<?php echo "<pre><b>RAM Total en (MB) : </b>".shell_exec("free -m | grep Mem | awk '{print $2}'")."</pre>"; ?>
							<?php echo "<pre><b>RAM Utilisée en (MB) : </b>".shell_exec("free -m | grep Mem | awk '{print $3}'")."</pre>"; ?>
							<?php echo "<pre><b>RAM Restant en (MB) : </b>".shell_exec("free -m | grep Mem | awk '{print $4}'")."</pre>"; ?>
							<?php echo "<pre><b>RAM SWAP en (MB) : </b>".shell_exec("free -m | awk 'NR==4'|awk '{ print $2 }'")."</pre>"; ?>
        </div></br>
		<div class="monbloc"><span class="motcle">Information Disque :</span>
		        			<?php echo "<pre><b>".shell_exec("df -h | grep Filesystem")."</b></pre>"; ?>
							<?php echo "<pre>".shell_exec("df -h | grep /dev/sd")."</pre>"; ?>		
		</div></br>
		<div class="monbloc"><span class="motcle">Qui est logé :</span>
							<?php echo "<pre>".shell_exec("who")."</pre>"; ?>	
		</div></br>
		<div class="monbloc"><span class="motcle">Information sur la conection :</span>
							<?php echo "<pre><b>Download speed :</b>".shell_exec("wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | tail -2 | head -1 | awk '{print $3 $4 }'")."</pre>"; ?>
		</div>
		<div class="monbloc"><span class="motcle">Information sur la Sécurité :</span>
			<?php echo "<pre><b>List count of number of connections the IPs are connected to the server using TCP or UDP protocol.</pre>"; ?>
			<?php echo "<pre>".shell_exec("netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n")."</pre>"; ?>
 
			<?php echo "<pre><b>How many active SYNC_REC are happening on the server.Less than 5 is OK.</pre>"; ?>
			<?php echo "<pre>".shell_exec("netstat -n -p|grep SYN_REC | wc -l")."</pre>"; ?>
 
			<?php echo "<pre><b>List out the all IP addresses involved.</pre>"; ?>
			<?php echo "<pre>".shell_exec("netstat -n -p | grep SYN_REC | awk '{print $5}' | awk -F: '{print $1}'")."</pre>"; ?>
 
			<?php echo "<pre><b>List out the all connections to port 80.</pre>"; ?>
			<?php echo "<pre>".shell_exec("netstat -n -a -p|grep :80")."</pre>"; ?>
 
			<?php echo "<pre><b>Which ip's are having more connection to 80 port.</pre>"; ?>
			<?php echo "<pre>".shell_exec("netstat -anp | grep :80 | awk '{print $5}' | sort | uniq -c | sort -n")."</pre>"; ?>
		</div></br>
		</div>
		<?php phpinfo(); ?>
    </body>
</html>
EOF

		apt-get install -y logwatch
		cp /usr/share/logwatch/default.conf/logwatch.conf /usr/share/logwatch/default.conf/logwatch.conf.ori
		rm /usr/share/logwatch/default.conf/logwatch.conf
		cat << EOF > /usr/share/logwatch/default.conf/logwatch.conf
LogDir = /var/log
TmpDir = /var/cache/logwatch
Output = mail
Format = html
Encode = none
MailTo = ${mailroot}
MailFrom = Logwatch
Range = yesterday
Detail = 0
Service = All
Service = "-zz-network"
Service = "-zz-sys"                           
Service = "-eximstats"
mailer = "/usr/sbin/sendmail -t"
EOF
		history -c
#sh rtorrent.sh