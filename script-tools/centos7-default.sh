#!/bin/bash
#
# Script setup inicial SO CentOS 7 para desafio técnico Firewalls SOFTPLAN
# Escrito por Filipe Cardoso - undrtkr@gmail.com / fpca87@gmail.com
# revisado em 22/05/2022
#

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "Esse script só roda com root!!!"

echo ">> Instalando ferramentas basicas ......"
while read -r p; do yum install -y $p; done < <(
    cat <<"EOF"
    nano
    bash-completion
    net-tools
    wget
    curl
    libwww-curl-perl
    lsof
EOF
)
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configurando SSHD ......"
while read -r p; do echo $p >>/etc/ssh/sshd_config; done < <(
    cat <<"EOF"
    PermitRootLogin no
    TCPKeepAlive no
    PrintLastLog no
    PrintMotd no
    ClientAliveInterval 300
    LoginGraceTime 30s
    PermitEmptyPasswords no
    HostbasedAuthentication no
    MaxSessions 1
    MaxAuthTries 3
    PermitUserEnvironment no
EOF
)
sleep 1
echo ">> Reiniciando o serviço SSHD ......"
systemctl restart sshd
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configurando SYSCTL ......"
while read -r p; do echo $p >>/etc/sysctl.conf; done < <(
    cat <<"EOF"
    net.ipv6.conf.all.disable_ipv6 = 1
    net.ipv6.conf.default.disable_ipv6 = 1
    net.ipv6.conf.default.autoconf = 0
    net.ipv4.tcp_syncookies = 1
    net.ipv4.conf.all.log_martians = 1
    net.ipv4.conf.default.log_martians = 1
EOF
)
sleep 1

echo ">> Aplicando SYSCTL ......"
sysctl -p
sleep 1
echo "!> OK! ......"
echo -e "\n"
sleep 1

echo ">> Impedindo logon como ROOT na console ......"
mv /etc/securetty /etc/securetty.orig
touch /etc/securetty
chmod 600 /etc/securetty
sleep 1
echo "!> OK! ......"
echo -e "\n"
sleep 1

echo ">> Bloqueando CTRL+ALT+DEL ......"
systemctl mask ctrl-alt-del.target
sleep 1
echo ">> OK! ......"
echo -e "\n"
sleep 1

echo ">> Configurando Firewall ......"
firewall-cmd --remove-service dhcpv6-client
#Regras IPTABLES padrao
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP # Force SYN packets check
iptables -A INPUT -f -j DROP                                  #Force Fragments packets check
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP          #XMAS packets
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP         # Drop all NULL packets
sleep 1
echo ">> Salvando e reiniciando o serviço FirewallD / IPTABLES ......"
service iptables save
systemctl restart firewalld
sleep 1
echo ">> OK! ......"
echo -e "\n"

##configurar logrotate para serviços

# vi /etc/logrotate.d/<arq com nome da pasta>
# ex:

#/var/log/firewalld {
#    weekly
#    missingok
#    rotate 4
#    copytruncate
#    minsize 1M
#}
