#!/bin/bash

RELEASE="7"
IMAGES=images/centos/${RELEASE}/x86_64

MIRROR="http://ftp.heanet.ie/pub/centos/${RELEASE}/os/x86_64/"

mkdir -p ${IMAGES}
for i in initrd.img vmlinuz; do \
  wget ${MIRROR}/images/pxeboot/$i -P ${IMAGES}; done


#Download ipxe
git clone https://github.com/ipxe/ipxe.git

