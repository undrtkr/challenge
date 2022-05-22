# challenge &middot;

Repositorio material utilizado no desafio.

====

### Atividades por etapa:

- [1xx - pfSense (firewall01 | firewall02)](#PFSENSE)

  - Instalação pfSense
  - IP Roteamento
  - CARP
  - NAT e Rules
  - IPSEC
  - Hardening e melhores práticas

- [2xx - ROTEADORES (internalrouter01 | internalrouter02)](#ROTEADORES)

  - [Instalação CentOS 7](#CENTOS7)
  - IP Roteamento
  - Config IP Forwarding
  - IPTABLES Stateless
  - Hardening and best practices

- [3xx - SRV042 + HAPROXY (srv042)](#HAPROXY)

  - [Instalação CentOS 7](#CENTOS7)
  - IP Roteamento
  - HAProxy 2.5.6
    - Instalação a partir do source-code
    - Configuração (haproxy.conf)
    - Liberar frontend 80 no firewalld
  - Hardening and best practices

- [4xx - SRV042 + CONTAINERS (srv042)](#CONTAINERS)

  - Instalação Docker e Compose
  - docker-compose.yaml
    - APPGNINX01
      - Configuração (/etc/nginx/conf/nginx.conf)
      - Configuração (/etc/nginx/conf.d/99-appnginx01.conf)
      - HTML (nginx/html)
    - RPGNINX01
      - Configuração (/etc/nginx/conf/nginx.conf)
      - Configuração (/etc/nginx/conf.d/99-rpnginx01.conf)
    - RPOPENRESTY01
      - Configuração (/usr/local/openresty01/nginx/conf/nginx.conf)
      - Configuração (/eetc/nginx/conf.d/99-rpopenresty01.conf)

- [5xx - DBPGSQL01 (pgsql01)](#PGSQL12)

  - [Instalação CentOS 7](#CENTOS7)
  - IP Roteamento
  - PostegresSQL 12
    - Instalação a partir do repositorio oficial
    - Configuração (postgresql.conf)
    - Configuração (pg_hba.conf)
    - Criação database padrão
    - Liberar service no firewalld
  - Hardening and best practices

- [6xx - MONGODB01 (mongodb01)](#MONGODB5)

  - [Instalação CentOS 7](#CENTOS7)
  - IP Roteamento
  - MongoDB 5
    - Instalação do repositorio oficial
    - Configuração SELINUX CGROUPS
    - Configuração SELINUX NETSTAT
    - Configuração (mongod.conf)
    - Criação database padrão
    - Performance (Disable THP)
    - Liberar service no firewalld
  - Config FirewallD
  - Hardening and best practices

- [7xx - CLIENTE01 (cliente01)](#CLIENTE01)
  - Instalação Ubuntu Server
  - IP Roteamento
  - IPSEC
    - Configuração (ipsec.conf)
    - Script monitoramento (monitor.sh)
    - crontab
  - Hardening and best practices

## PFSENSE

## CENTOS7

A instalação do CentOS 7 segue as premissas a seguir para todas instancias desse desafio:

- Particionamento:
  Mount point Size (MB) Mount options
  / 2000
  /var 2000
  /var/log 512
  /vat/tmp bind (/tmp)
  /tmp 512 nodev,nosuid,noexec
  /home 512 nodev  
  /dev/shm nodev,nosuid,noexec
  /boot 200 ro

- Contas de usuário:
  root:123456
  admin:123456

- Fuso horario, linguagem e layout de teclado:
  Fuso: GMT -3 (Sao Paulo)
  Linguagem: EN
  Layout teclado: PT-BR ABNT2

- [Script de configuração inicial](script-tools/centos7-default.sh)
  Instalação ferramentas básicas:

        ```
        while read -r p ; do apt-get install -y $p ; done < <(cat << "EOF"
            nano
            bash-completion
            net-tools
            wget
            curl
            libwww-curl-perl
            lsof
        EOF
        )
        ```
        Hardening serviço SSHD:

        ```
        while read -r p ; do echo $p >> /etc/ssh/sshd_config ; done < <(cat << "EOF"
            "PermitRootLogin no"
            "TCPKeepAlive no"
            "PrintLastLog no"
            "PrintMotd no"
            "ClientAliveInterval 300"
            "LoginGraceTime 30s"
            "PermitEmptyPasswords no"
            "HostbasedAuthentication no"
            "MaxSessions 1"
            "MaxAuthTries 3"
            "PermitUserEnvironment no"
        EOF
        )
        ```

## HAPROXY

## CONTAINERS

## PGSQL12

## MONGODB5

## CLIENTE01
