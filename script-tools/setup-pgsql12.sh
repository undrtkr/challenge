#!/bin/bash
#
# Script "setup-pgsql127.sh" para desafio técnico Firewalls SOFTPLAN
# Escrito por Filipe Cardoso - undrtkr@gmail.com / fpca87@gmail.com
# revisado em 22/05/2022
#

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "Esse script só roda com root!!!"

echo ">> Instalando repositorio e dependencias PGSQL12 ......"
yum -y install https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
yum -y install epel-release yum-utils
yum-config-manager --enable pgdg12
yum install postgresql12-server postgresql12
sleep 1
echo ">> OK! ......"
echo -e "\n"

echo ">> Instalando PGSQL12 ......"
yum install postgresql12-server postgresql12
sleep 1
echo ">> OK! ......"
echo -e "\n"


echo ">> Configuração (postgresql.conf) ......"
while read -r p; do echo $p >>/var/lib/pgsql/12/data/postgresql.conf; done < <(
    cat <<"EOF"
    hba_file = '/var/lib/pgsql/12/data/pg_hba.conf'
    listen_address = '*'
    authentication_timeout = 30s
    password_encryption = scram-sha-256
EOF
)
sleep 1
echo ">> OK! ......"
echo -e "\n"

echo ">> Configuração (postgresql.conf) ......"
while read -r p; do echo $p >>/var/lib/pgsql/data/pg_hba.conf; done < <(
    cat <<"EOF"
    host	all		all		192.168.172.10/32		scram-sha-256
    host	all		all		127.0.0.1/32			scram-sha-256   
EOF
)
sleep 1
echo ">> OK! ......"
echo -e "\n"

echo ">> Liberar service no firewalld ......"
firewall-cmd --add-service=postgresql-12 --permanent
firewall-cmd --reload
sleep 1
echo ">> OK! ......"
echo -e "\n"

