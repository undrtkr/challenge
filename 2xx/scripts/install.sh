#!/bin/bash
#
# Script config/install InternalRouters para desafio técnico Firewalls SOFTPLAN
# Escrito por Filipe Cardoso - undrtkr@gmail.com / fpca87@gmail.com
# revisado em 22/05/2022
#

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "Esse script só roda com root!!!"

sleep 1
echo ">> Instalando pacotes ......"
yum install keepalived iptables-services -y
sleep 1
echo "!> OK! ......"
echo -e "\n"

sleep 1
echo ">> Removendo FirewallD ......"
systemctl stop firewalld
systemctl disable firewalld
sudo systemctl mask firewalld
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Habilitando serviços ......"
systemctl enable keepalived
systemctl enable iptables
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configurando IPTABLES stateless ......"
iptables -F
iptables -t nat -F

iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -f -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

iptables -t raw -I PREROUTING -j NOTRACK
iptables -t raw -I OUTPUT -j NOTRACK

service iptables save

sleep 1
echo "!> OK! ......"
echo -e "\n"


echo ">> Configuração KEEPALIVED ......"
cp ../conf/InternalRouter01/keepalived.conf /etc/keepalived
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Reiniciando os serviços ......"
systemctl restart keepalived
systemctl restart iptables
sleep 1
echo "!> OK! ......"
echo -e "\n"
