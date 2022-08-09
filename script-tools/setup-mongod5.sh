#!/bin/bash
#
# Script "setup-mongod5.sh" para desafio técnico Firewalls SOFTPLAN
# Escrito por Filipe Cardoso - undrtkr@gmail.com / fpca87@gmail.com
# revisado em 22/05/2022
#

set -eu -o pipefail

sudo -n true
test $? -eq 0 || exit 1 "Esse script só roda com root!!!"

echo ">> Instalando repositorio oficial MongoDB 5 ......"
while read -r p; do echo $p >>/etc/yum.repos.d/mongodb-org-5.0.repo; done < <(
    cat <<"EOF"
    [mongodb-org-5.0]
    name=MongoDB Repository
    baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/5.0/x86_64/
    gpgcheck=1
    enabled=1
    gpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc
EOF
)
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Instalando o MongoDB 5 e dependencias ......"
yum install -y mongodb-org checkpolicy policycoreutils-python
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configuração SELINUX CGROUPS ......"
while read -r p; do echo $p >>mongodb_cgroup_memory.te; done < <(
    cat <<"EOF"
    module mongodb_cgroup_memory 1.0;
    require {
        type cgroup_t;
        type mongod_t;
        class dir search;
        class file { getattr open read };
    }
    allow mongod_t cgroup_t:dir search;
    allow mongod_t cgroup_t:file { getattr open read };
EOF
)

checkmodule -M -m -o mongodb_cgroup_memory.mod mongodb_cgroup_memory.te
semodule_package -o mongodb_cgroup_memory.pp -m mongodb_cgroup_memory.mod
semodule -i mongodb_cgroup_memory.pp

sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configuração SELINUX NETSTAT ......"
while read -r p; do echo $p >>mongodb_proc_net.te; done < <(
    cat <<"EOF"
    module mongodb_proc_net 1.0;
    require {
        type cgroup_t;
        type configfs_t;
        type file_type;
        type mongod_t;
        type proc_net_t;
        type sysctl_fs_t;
        type var_lib_nfs_t;
        class dir { search getattr };
        class file { getattr open read };
    }

    allow mongod_t cgroup_t:dir { search getattr } ;
    allow mongod_t cgroup_t:file { getattr open read };
    allow mongod_t configfs_t:dir getattr;
    allow mongod_t file_type:dir { getattr search };
    allow mongod_t file_type:file getattr;
    allow mongod_t proc_net_t:file { open read };
    allow mongod_t sysctl_fs_t:dir search;
    allow mongod_t var_lib_nfs_t:dir search;
EOF
)

checkmodule -M -m -o mongodb_proc_net.mod mongodb_proc_net.te
semodule_package -o mongodb_proc_net.pp -m mongodb_proc_net.mod
semodule -i mongodb_proc_net.pp

sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Configuração (mongod.conf) ......"
while read -r p; do echo $p >>/etc/mongod.conf; done < <(
    cat <<"EOF"
    security:
        authorization: enabled
    setParameter:
        enableLocalhostAuthBypass: false
EOF
)
sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Performance (Disable THP) ......"
while read -r p; do echo $p >>/etc/systemd/system/disable-thp.service; done < <(
    cat <<"EOF"
    [Unit]
    Description=Disable THP
    DefaultDependencies=no
    After=sysinit.target local-fs.target
    Before=mongod.service
    [Service]
    Type=oneshot
    ExecStart=/bin/sh -c 'echo never | tee /sys/kernel/mm/transparent_hugepage/enabled > /dev/null'
    [Install]
    WantedBy=basic.target
EOF
)

systemctl daemon-reload
systemctl start disable-thp
systemctl enable disable-thp

sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Liberar service no firewalld ......"
firewall-cmd --add-rich-rule 'rule family="ipv4" service name="mongodb" source address="192.168.172.0/28" accept'

echo "AllowZoneDrifting=no" >> /etc/firewalld/firewalld.conf

sleep 1
echo "!> OK! ......"
echo -e "\n"

echo ">> Reiniciando os serviços ......"

systemctl enable mongod
systemctl restart mongod
systemctl restart firewalld 

sleep 1
echo "!> OK! ......"
echo -e "\n"
