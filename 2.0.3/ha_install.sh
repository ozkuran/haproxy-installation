#!/bin/bash
yum -y update
yum -y install nano

yum -y install gcc openssl-devel readline-devel systemd-devel make pcre-devel

curl https://www.lua.org/ftp/lua-5.3.5.tar.gz > lua-5.3.5.tar.gz
curl http://www.haproxy.org/download/2.0/src/haproxy-2.0.3.tar.gz > haproxy-2.0.3.tar.gz

tar xf lua-5.3.5.tar.gz
tar xf haproxy-2.0.3.tar.gz

cd lua-5.3.5
make INSTALL_TOP=/opt/lua-5.3.5 linux install

cd
cd haproxy-2.0.3
make USE_NS=1 USE_TFO=1 USE_OPENSSL=1 USE_ZLIB=1 USE_LUA=1 USE_PCRE=1 USE_SYSTEMD=1 USE_LIBCRYPT=1 USE_THREAD=1 TARGET=linux-glibc LUA_INC=/opt/lua-5.3.5/include LUA_LIB=/opt/lua-5.3.5/lib 	
make PREFIX=/opt/haproxy-2.0.3 install

groupadd -g 188 haproxy
useradd -g 188 -u 188 -d /var/lib/haproxy -s /sbin/nologin -c haproxy haproxy


cat <<EOF > /etc/systemd/system/haproxy.service
[Unit]
Description=HAProxy 2.0.3
After=syslog.target network.target

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/haproxy
ExecStart=/opt/haproxy-2.0.3/sbin/haproxy -f $CONFIG_FILE -p $PID_FILE $CLI_OPTIONS
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -USR1 $MAINPID

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/sysconfig/haproxy
# Command line options to pass to HAProxy at startup
# The default is:  
#CLI_OPTIONS="-Ws"
CLI_OPTIONS="-Ws"

# Specify an alternate configuration file. The default is:
#CONFIG_FILE=/etc/haproxy/haproxy.conf
CONFIG_FILE=/etc/haproxy/haproxy.conf

# File used to track process IDs. The default is:
#PID_FILE=/var/run/haproxy.pid
PID_FILE=/var/run/haproxy.pid
EOF


systemctl daemon-reload

mkdir /etc/haproxy

cat <<EOF > /etc/haproxy/haproxy.conf
global
    daemon
    maxconn 256
    user        haproxy
    group       haproxy
    chroot      /var/lib/haproxy

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms
	
listen  stats
    bind *:1905
    mode            http
    log             global

    maxconn 5

    stats enable
    stats hide-version
    stats refresh 30s
    stats show-node
    stats auth admin:password
    stats uri  /haproxy?stats

frontend http
    bind *:8000
    default_backend servers

backend servers
    server server 127.0.0.1:81
EOF
	
systemctl enable haproxy
systemctl start haproxy
systemctl status haproxy
	