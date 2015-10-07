#version=RHEL7
# Action
install

# Disable anything graphical
skipx
text

# System authorization information
auth --enableshadow --passalgo=sha512
repo --name="EPEL" --baseurl=http://dl.fedoraproject.org/pub/epel/7/x86_64


# Accept Eula
eula --agreed

# Use network installation
#url --url="http://mirrors.isu.net.sa/pub/centos/7/os/x86_64/"
url --url="http://ftp.heanet.ie/pub/centos/${RELEASE}/os/x86_64/"


# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sda

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_US.UTF-8



## Network information
# for STATIC IP: uncomment and configure
# network --onboot=yes --device=eth0 --bootproto=static --ip=10.42.0.20 --netmask=255.255.255.0 --gateway=10.42.0.1 --nameserver=155.247.225.230 --noipv6

# for dhcp
network --hostname=centos7 --bootproto=dhcp --device=enp0s3 --noipv6 --activate


# Root password (letmein)
rootpw --iscrypted $1$lqtO5Lt6$FY9GNGIWtIio48P2IIiE50

# System services
services --enabled=NetworkManager,sshd

# System timezone
timezone Europe/Madrid --isUtc --ntpservers=0.centos.pool.ntp.org,1.centos.pool.ntp.org,2.centos.pool.ntp.org,3.centos.pool.ntp.org
user --groups=wheel --homedir=/home/niall --name=niall --password=$1$lqtO5Lt6$FY9GNGIWtIio48P2IIiE50 --iscrypted --gecos="niall"

# System bootloader configuration
bootloader --location=mbr --boot-drive=sda
autopart --type=lvm
zerombr

# Partition clearing information
clearpart --all --drives=sda

# Firewall/Security
selinux --disabled
firewall --enabled --service=ssh

%packages
@base
@core
vim
git



%end

reboot
