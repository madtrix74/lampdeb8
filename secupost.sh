#!/bin/bash
. /root/lampdeb8/var.sh
		if [[ $EUID -ne 0 ]]; then
				echo -e "$ROUGE""Ce script doit ce démmarer en root""$NORMAL" 1>&2
			exit 1
		fi
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "la première étape consiste à mettre à jour la liste des paquets disponibles." "$NORMAL"
		sleep 3
			echo "#dépôt paquet propriétaire
deb http://ftp2.fr.debian.org/debian/ jessie  main non-free
deb-src http://ftp2.fr.debian.org/debian/ jessie  main non-free" >> /etc/apt/sources.list.d/non-free.list

echo "# dépôt dotdeb
deb http://packages.dotdeb.org jessie  all
deb-src http://packages.dotdeb.org jessie  all" >> /etc/apt/sources.list.d/dotdeb.list

echo "# dépôt dotdeb php 5.6
deb http://packages.dotdeb.org jessie -php56 all
deb-src http://packages.dotdeb.org jessie -php56 all" >> /etc/apt/sources.list.d/dotdeb-php56.list

echo "
deb http://ftp.us.debian.org/debian/ jessie main contrib non-free
deb-src http://ftp.us.debian.org/debian/ jessie main contrib non-free

deb http://security.debian.org/ jessie/updates main contrib non-free
deb-src http://security.debian.org/ jessie/updates main contrib non-free" >> /etc/apt/sources.list.d/contrib non-free.list

cd /tmp
wget http://www.dotdeb.org/dotdeb.gpg
apt-key add dotdeb.gpg

			apt-get -y update
			apt-get -y full-upgrade
			apt-get -y install sudo htop build-essential pkg-config libcurl4-openssl-dev libsigc++-2.0-dev libncurses5-dev vim nano screen subversion curl git unzip unrar ffmpeg buildtorrent mediainfo dtach make
			
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Mis a jour " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
		sleep 3
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "La règle n°1 à suivre pour sécuriser un système d'exploitation est de le maintenir à jour." "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Ce guide met en place une alerte par mél lorsque de nouvelles mises à jour sont disponibles sur le système." "$NORMAL"
		sleep 3
			apt-get install -y cron-apt
			rm /etc/cron-apt/action.d/3-download
			rm /etc/cron-apt/config
			grep security /etc/apt/sources.list > /etc/apt/security.sources.list
			cat << EOF > /etc/cron-apt/action.d/3-download
autoclean -y
dist-upgrade -d -y -o APT::Get::Show-Upgraded=true
EOF
			cat << EOF > /etc/cron-apt/config
APTCOMMAND=/usr/bin/apt-get
OPTIONS="-o quiet=1 -o Dir::Etc::SourceList=/etc/apt/security.sources.list"
MAILTO="${mailroot}"
MAILON="output"
EOF
			
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Mis a jour automatique " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
		sleep 1
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "On change le Hostname et host du serveur" "$NORMAL"
		sleep 3
			rm /etc/hostname
			echo -e "$HOSTNAME" >> /etc/hostname
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "/etc/hostname modifier " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
			rm /etc/hosts
			cat << EOF > /etc/hosts
127.0.0.1 localhost.localdomain localhost
$IPV4	$HOSTNAME2	$HOSTNAME
$IPV6	$HOSTNAME2	$HOSTNAME
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
EOF
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "/etc/host modifier " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
		sleep 3
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "On vas installer d'un jolie logo au démarrage de la console avec LinuxLogo" "$NORMAL"
		sleep 3
			apt-get -y install linuxlogo
			echo "linux_logo -L 14" >> /etc/profile
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Installation du logo " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
		sleep 3
logo
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "On vas changé le password root" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Toute les information vont ce retrouver dans le fichier .infosecu" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "on vas aussi profiter pour ajouter un peux de couleur et l'envois d'un e-mail" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "quand root ce connect "
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "on vas aussi installer un serveur mail pour l'envois des information"  "$NORMAL"
		sleep 3
			debconf-set-selections <<< "postfix postfix/mailname string "$HOSTNAME2
			debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
			DEBIAN_FRONTEND=noninteractive apt-get install -y postfix
			apt-get install -y mailutils 
			echo "Ceci est un test de messagerie pour le service SMTP." > /tmp/email.message
			echo "Vous devriez recevoir ce mail!" >> /tmp/email.message
			echo "" >> /tmp/email.message
			echo "Tchao!" >> /tmp/email.message
			mail -s "Test SMTP" ${mailroot} < /tmp/email.message
			rm -f /tmp/email.message 
			#AUTOPWDR=`tr -dc A-Za-z0-9 < /dev/urandom | head -c 8 | xargs`
			echo -e "${AUTOPWDR}\n${AUTOPWDR}" | passwd root > /dev/null 2>&1
			echo ${rootProfile} >>/root/.bashrc
			echo 'echo "Acces SSH: " `who` `date` | mail -s "Acces SSH"' ${mailroot} >> /root/.bashrc
			source /root/.bashrc
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Password root " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Mail serveur " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Couleur " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
logo
	echo -e "$ROUGE" "*" "$NORMAL" "$VERT" "On crée un utilisateur avec les privilèges sudo" "$NORMAL"
	echo -e "$ROUGE" "*" "$NORMAL" "$VERT" "on génnaire un password automatiquement" "$NORMAL"
		sleep 3
			apt-get install -y sudo
			#AUTOPWDU=`tr -dc A-Za-z0-9 < /dev/urandom | head -c 8 | xargs`
			HOME_BASE="/home/"
			#read -p "Enter username : " USER
			useradd -m -d ${HOME_BASE}${USER} -s /bin/bash ${USER}
			echo "${USER}:${AUTOPWDU}" | chpasswd
			mkdir /home/${USER}/public_html
			mkdir /home/${USER}/logs
			cp -r /root/lampdeb8/theme /home/${USER}/public_html/
			cp /root/lampdeb8/htaccess.txt /home/${USER}/public_html/.htaccess
			rename /home/${USER}/public_html/theme/htaccess.txt /home/${USER}/public_html/theme/.htaccess
			echo ${userProfile} >> /${HOME_BASE}/${USER}/.bashrc
			echo 'echo "Acces SSH: " `who` `date` | mail -s "Acces SSH"' ${mailroot} >> /${HOME_BASE}/${USER}/.bashrc
			source /home/${USER}/.bashrc
			chown ${USER}:${USER} /home/${USER}/.bashrc
			chown ${USER}:${USER} /home/${USER}/public_html
			chown ${USER}:${USER} /home/${USER}/public_html/index.html
			chown ${USER}:${USER} /home/${USER}/public_html/theme
			adduser ${USER} sudo
			#adduser ${USER} adm
			echo "${USER}    ALL=(ALL:ALL) ALL" >> /etc/sudoers;
	echo -e "$ROUGE" "  *" "$NORMAL" "$JAUNE" "Utilisateur crée " "$NORMAL" "$VERT" "[OK]" "$NORMAL"
		sleep 3
logo		
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Protection contre les attaques DDOS et brute-force" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Fail2ban est un outil surveillant les échecs de connexion au serveur SSH, " "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "et bloquant pour un temps donné les adresses IP à l'origine de 5 échecs successifs. " "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Ce comportement permet de bloquer la plupart des attaques de déni de service, " "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "et la récupération des mots de passes des utilisateurs par la force brute." "$NORMAL"
		sleep 3
		command apt-get install -y fail2ban
		if [ ! -e '/etc/fail2ban/jail.local' ]; then
  command touch '/etc/fail2ban/jail.local'
fi
if [ -z "$(command grep "\[ssh-ddos\]" '/etc/fail2ban/jail.local')" ]; then
  echo "[ssh-ddos]
enabled = true

[pam-generic]
enabled = true
" >> '/etc/fail2ban/jail.local'
fi
		/etc/init.d/ssh restart
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Modifier le port découte du serveur SSH" "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Par défaut, le serveur SSH écoute sur le port 22." "$NORMAL" 
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Utiliser un autre port que celui par défaut limite de manière considérable le nombre attagues automatisées." "$NORMAL"
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Modifiez la configuration du serveur SSH:" "$NORMAL" 
		sleep 3
command sed -i -e "s/^[#\t ]*Port[\t ]*.*\$/Port ${SSH_PORT}/" \
    '/etc/ssh/sshd_config'
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Rechargez la configuration:" "$NORMAL" 
		sleep 3

		/etc/init.d/ssh reload

	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Mettez à jour la configuration de fail2ban" "$NORMAL" 
		sleep 3
echo "
# Custom SSH port
[ssh]
port = ${SSH_PORT}" >> '/etc/fail2ban/jail.local'
	echo -e "$ROUGE" "  *" "$NORMAL" "$VERT" "Redémarrez fail2ban:" "$NORMAL"
		sleep 3	
/etc/init.d/fail2ban restart



	
	echo -e "Information System :" >> .infosecu
	echo "-----------------------------------------------" >> .infosecu
    echo -e "Distro :" ${DSTRO} >> .infosecu
	echo -e "HostName :" ${HOSTNAME} >> .infosecu
	echo -e "L'ip  du serveur :" ${IPV4} >> .infosecu
	echo -e "port ssh : " ${SSH_PORT} >> .infosecu
	echo -e "CPU : " ${CPU} >> .infosecu 
	echo "-----------------------------------------------" >> .infosecu
	echo -e "Loging : root" >> .infosecu
	echo -e "Password :" ${AUTOPWDR} >> .infosecu
	echo -e "E-Mail root :" ${mailroot} >> .infosecu
	echo "-----------------------------------------------" >> .infosecu
	echo -e "Loging User" : ${USER} >> .infosecu
	echo -e "Password User" : ${AUTOPWDU} >> .infosecu
	echo -e "connection ftp : ftp://${USER}:${AUTOPWDU}@${HOSTNAME}:21" >> .infosecu
	#echo -e "rutorrent : http://${HOSTNAME}/rutorrent" >> .infosecu	
	#echo -e "Couch Potato Server : http://${HOSTNAME}:5050" >> .infosecu
	#echo -e "Sick Beard : http://${HOSTNAME}:8081" >> .infosecu
	echo -e "Madinfo : http://${HOSTNAME}/admin/madinfo.php" >> .infosecu
	echo "-----------------------------------------------" >> .infosecu
		mail -s "Info serveur" ${mailroot} < .infosecu
	echo -e "$ROUGE" "*" "$NORMAL" "$JAUNE" "Password root" "$NORMAL" "$VERT" "[OK]" "$NORMAL"
		cp .infosecu /home/${USER}/
		chown ${USER}:${USER} /home/${USER}/.infosecu
		sleep 3
cd
sh /root/lampdeb8/lamp.sh