
# challenge &middot; 

Repositorio material utilizado no desafio.

====

### Atividades por etapa:

- 1xx - pfSense (firewall01 | firewall02)
  - Instalação pfSense
  - IP Roteamento
  - CARP
  - NAT e Rules
  - IPSEC
  - Hardening e melhores práticas
  - 

- 2xx - ROTEADORES (internalrouter01 | internalrouter02)
  - Instalação CentOS 7
  - IP Roteamento
  - Config IP Forwarding
  - IPTABLES Stateless
  - Hardening and best practices
  

- 3xx - SRV042 + HAPROXY (srv042)
  - Instalação CentOS 7
  - IP Roteamento
  - HAProxy 2.5.6
    - Instalação a partir do source-code
    - Configuração (haproxy.conf)
    - Liberar frontend 80 no firewalld
  - Hardening and best practices
  

- 4xx - SRV042 + CONTAINERS (srv042)
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


- 5xx - DBPGSQL01 (pgsql01)
  - Instalação CentOS 7
  - IP Roteamento
  - PostegresSQL 12
    - Instalação a partir do repositorio oficial
    - Configuração (postgresql.conf)
    - Configuração (pg_hba.conf)
    - Criação database padrão
    - Liberar service no firewalld
  - Hardening and best practices


- 6xx - MONGODB01 (mongodb01)
  - Instalação CentOS 7
  - IP Roteamento
  - MongoDB 5
    - Instalação  do repositorio oficial
    - Configuração SELINUX CGROUPS
    - Configuração SELINUX NETSTAT
    - Configuração (mongod.conf)
    - Criação database padrão
    - Performance (Disable THP)
    - Liberar service no firewalld
  - Config FirewallD
  - Hardening and best practices


- 7xx - CLIENTE01 (cliente01)
  - Instalação Ubuntu Server
  - IP Roteamento
  - IPSEC
    - Configuração (ipsec.conf)
  - Hardening and best practices
