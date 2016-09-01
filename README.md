# lampdeb8
scripte shell installation automatique d'un serveur LAMP pour Debian 8

Pour l'installation 
  1. apt-get install git
  2. git clone https://github.com/madtrix74/lampdeb8.git lampdeb8
  3. cd lampdeb8
  4. nano var.sh "Remplicer les information"
  5. sh secupost.sh
  
Important commands

#To start/stop/restart and to see status of Apache 2, enter

  systemctl start apache2
  
  systemctl stop apache2
  
  systemctl restart apache2
  
  systemctl status apache2

#To start/stop/restart and to see status of MySQL server, enter

  systemctl start mysql
  
  systemctl stop mysql
  
  systemctl restart mysql
  
  systemctl status mysql

#Verify that port # 80 open

  netstat -tulpn | grep :80
  
  ss -t -a
  
  ss -t -a | grep http
  
  ss -o state established '( dport = :http or sport = :http )'
  
  iptable -L -n -v | less

#Important log files

tail -f /var/log/apache2/access.log

tail -f /var/log/apache2/error.log

grep something /var/log/apache2/error.log

tail -f /var/log/apache2/php-error.log

tail -f /var/log/apache2/cyberciti.biz/logs/error.log

tail -f /var/log/apache2/cyberciti.biz/logs/access.log

grep something /var/log/apache2/cyberciti.biz/logs/error.log
