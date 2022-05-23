#!/bin/bash
#
# Script "setup-srv042.sh" para desafio técnico Firewalls SOFTPLAN
# Escrito por Filipe Cardoso - undrtkr@gmail.com / fpca87@gmail.com
# revisado em 22/05/2022
#

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "Esse script só roda com root!!!"

sleep 1
echo ">> Instalando dependencias ......"
yum install gcc openssl-devel readline-devel systemd-devel make pcre-devel yum-utils -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Instalando DOCKER ......"
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sleep 1
echo "!> OK! ......"
echo -e "\n"

sleep 1
echo ">> Baixando source-code HAPROXY ......"
cd ~/
curl https://www.lua.org/ftp/lua-5.4.4.tar.gz > lua-5.4.4.tar.gz
curl https://www.haproxy.org/download/2.4/src/haproxy-2.5.7.tar.gz > haproxy-2.5.7.tar.gz
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Instalando LUA  ......"
tar xvf lua-5.4.4.tar.gz
cd lua-5.4.4
make INSTALL_TOP=/opt/lua-5.4.4 linux install
cd ..
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Instalando HAPROXY  ......"
tar xvf haproxy-2.5.7.tar.gz
cd haproxy-2.5.7
make USE_NS=1 \
USE_TFO=1 \
USE_OPENSSL=1 \
USE_ZLIB=1 \
USE_LUA=1 \
USE_PCRE=1 \
USE_SYSTEMD=1 \
USE_LIBCRYPT=1 \
USE_THREAD=1 \
TARGET=linux-glibc \
LUA_INC=/opt/lua-5.4.4/include \
LUA_LIB=/opt/lua-5.4.4/lib

sudo make PREFIX=/opt/haproxy-2.5.7 install
cd ..
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configurando user:group......"
groupadd -g 188 haproxy
useradd -g 188 -u 188 -d /var/lib/haproxy -s /sbin/nologin -c haproxy haproxy
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Criando serviço HAPROXY ......"
while read -r p; do echo $p >>/etc/systemd/system/haproxy.service; done < <(
    cat <<"EOF"
    [Unit]
    Description=HAProxy 2.5.7
    After=syslog.target network.target
    [Service]
    Type=notify
    EnvironmentFile=/etc/sysconfig/haproxy-2.5.7
    ExecStart=/opt/haproxy-2.5.7/sbin/haproxy -f $CONFIG_FILE -p $PID_FILE $CLI_OPTIONS
    ExecReload=/bin/kill -USR2 $MAINPID
    ExecStop=/bin/kill -USR1 $MAINPID
    [Install]
    WantedBy=multi-user.target
EOF
)

while read -r p; do echo $p >>/etc/sysconfig/haproxy-2.5.7; done < <(
    cat <<"EOF"
    CLI_OPTIONS="-Ws"
    CONFIG_FILE=/etc/haproxy/haproxy.cfg
    PID_FILE=/var/run/haproxy.pid
EOF
)
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configuração HAPROXY / RSYSLOG ......"
mv /etc/haproxy/haproxy.conf  /etc/haproxy/haproxy.conf.ori
cp ../3xx/conf/haproxy/haproxy.conf  /etc/haproxy/haproxy.conf
cp ../3xx/conf/rsyslog.d/99-haproxy.conf  /etc/rsyslog.d
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Habilitando os serviços ......"
chmod 664 /etc/systemd/sysconfig/haproxy.service
systemctl daemon-reload
systemctl enable haproxy
systemctl enable rsyslog
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Reiniciando os serviços ......"
systemctl restart haproxy
systemctl restart rsyslog
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Liberando  serviços ......"
firewall-cmd --zone=public --add-port 45432/tcp --permanent
firewall-cmd --zone=public --add-port 80/tcp --permanent
firewall-cmd --reload
sleep 1
echo "!> OK! ......"
echo -e "\n"