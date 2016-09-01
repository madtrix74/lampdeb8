#!/bin/bash

# variables couleurs
VERT="\\033[1;32m"
NORMAL="\\033[0;39m"
ROUGE="\\033[1;31m"
ROSE="\\033[1;35m"
BLEU="\\033[1;34m"
BLANC="\\033[0;02m"
BLANCLAIR="\\033[1;08m"
JAUNE="\\033[1;33m"
CYAN="\\033[1;36m"

logo () 
{
clear
	echo -e "$VERT" "  *********************************************************************  " "$NORMAL"
	echo -e "$VERT" "  *                   ""$ROUGE""MadTrix Script Security et TWEAK""$NORMAL""$VERT""                *  " "$NORMAL"
	echo -e "$VERT" "  *********************************************************************  " "$NORMAL"
}
#Utilistaeur
USER=madtrix
AUTOPWDU=madtrix03111974
#password root
AUTOPWDR=root03111974
#mail root
mailroot=madtrix74@gmail.com
#variables sur le HostNam 
HOSTNAME=lordmad.com
#variables sur le host www.host.be
HOSTNAME2=srv.lordmad.com
#SSH PORT
SSH_PORT="16022"
#port monit
PORTM="8888"
#password Mysql et phpmyadmin
MYSQL_PASS=sql03111974

# variables info system
IPV4=`command ifconfig eth0 | grep "inet ad" | cut -f2 -d: | awk '{print $1}'`
IPV6=`command ip addr show dev eth0 | grep "inet6 " | head -n 1 | awk '{ print $2 }'`
DSTRO=`cat /proc/version`
#HOSTNAME=`uname -n`
KERNEL=`uname -r`
UPTIME=`uptime | awk '{print $3,$4}' | sed 's/,$//'`
CPU=`cat /proc/cpuinfo | grep "model name" | awk '{print $4,$5,$6,$7,$8,$9}' | tail -1`
CORE=`cat /proc/cpuinfo | grep processor | tail -1 | awk '{print $3+1}'`
CPUF=`cat /proc/cpuinfo|grep MHz|head -1|awk '{ print $4 }'`
RAMT=`free -m | grep Mem | awk '{print $2}'`
RAMU=`free -m | grep Mem | awk '{print $3}'`
RAMR=`free -m | grep Mem | awk '{print $4}'`
RAMS=`free -m | awk 'NR==4'|awk '{ print $2 }'`
INFD=`df -h | grep /dev/sd`
#CONT=`wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | tail -2 | head -1 | awk '{print $3 $4 }'`

# variables Profile
userProfile='export PS1="\[\e[0;36m\]\u\[\e[1;33m\]@\H \[\033[0;36m\] \w\[\e[0m\]$ "'
rootProfile='export PS1="\[\e[1;31m\]\u\[\e[1;33m\]@\H \[\033[0;36m\] \w\[\e[0m\]$ "'

pause () 
{ 
echo "Appuyer sur ENTER pour continuer .." 
read 
clear 
}
