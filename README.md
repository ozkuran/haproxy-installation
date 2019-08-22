# [HAProxy](http://www.haproxy.org/ "HAProxy Homepage") Install Script

This is a simple installation script for different versions of HAProxy. Initially created for yum based linux distros and tested for CentOS 7.

## Current versions

#### CentOS 7
- 2.0.0: https://raw.githubusercontent.com/ozkuran/haproxy-installation/develop/2.0.0/ha_install.sh
- 2.0.1: https://raw.githubusercontent.com/ozkuran/haproxy-installation/develop/2.0.1/ha_install.sh
- 2.0.2: https://raw.githubusercontent.com/ozkuran/haproxy-installation/develop/2.0.2/ha_install.sh
- 2.0.3: https://raw.githubusercontent.com/ozkuran/haproxy-installation/develop/2.0.3/ha_install.sh
- 2.0.4: https://raw.githubusercontent.com/ozkuran/haproxy-installation/develop/2.0.4/ha_install.sh
- 2.0.5: https://raw.githubusercontent.com/ozkuran/haproxy-installation/develop/2.0.5/ha_install.sh


## Installation procedure

#### 1. Download the script:
```
sudo wget https://raw.githubusercontent.com/ozkuran/haproxy-installation/master/[VERSION_TO_INSTALL]/ha_install.sh
```
#### 2. Make the script executable
```
sudo chmod +x ha_install.sh
```
#### 3. Execute the script:
```
sudo ./ha_install.sh
```

## Post-Installation steps

#### 1. Change username and password of 
Load haproxy.cfg file.
```
sudo nano /etc/haproxy/haproxy.conf
```
Find line with contents of:
```
    stats auth admin:password
```
Change contents of line with username and password you like.
```
    stats auth [YOUR_USERNAME]:[YOUR_PASSWORD]
```

Save and quit document. Then restart HAProxy.

```
    sudo systemctl restart haproxy
```

Check status of HAProxy.

```
    sudo systemctl status haproxy
```
