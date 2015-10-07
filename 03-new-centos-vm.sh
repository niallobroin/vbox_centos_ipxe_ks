#!/bin/bash
set -ex

VBOX=`which VirtualBox`
VBOXMANAGE=`which VBoxManage`
VBOXBASE="${HOME}/VirtualBox VMs"


# The name of your VM
VM="centos7_dev"
if [ "$1" ]; then
    VM=$1
fi

#if VM exists
if ${VBOXMANAGE} list vms | grep ${VM};  then
    ${VBOXMANAGE} unregistervm $VM --delete;
fi

isofile=ipxe.iso

VBOXINFO="${VBOXMANAGE} showvminfo ${VM}"


#Create the VM
${VBOXMANAGE} createvm --name "${VM}" --ostype "Linux_64" --register
${VBOXMANAGE} createhd --filename "${VBOXBASE}/${VM}/${VM}.vdi" --size 8192
${VBOXMANAGE} storagectl "${VM}" --name "SATA Controller" --add sata --controller IntelAHCI
${VBOXMANAGE} storageattach "${VM}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VBOXBASE}/${VM}/${VM}.vdi"
${VBOXMANAGE} modifyvm "${VM}" --memory 2048
${VBOXMANAGE} modifyvm "${VM}" --vram 16


#${VBOXMANAGE} modifyvm "${VM}" --boot1 dvd --boot2 disk --boot3 net --boot4 none


${VBOXMANAGE} modifyvm "${VM}" --nic1 nat
#    ${VBOXMANAGE} modifyvm "${VM}" --nic1 bridged --bridgeadapter1 eth0
${VBOXMANAGE} modifyvm ${VM} --macaddress1 00000000C700 
#${VBOXMANAGE} modifyvm "${VM}" --macaddress1 00000000${TYPE}${N} 

#${VBOXMANAGE} modifyvm "${VM}" --nic2 hostonly --hostonlyadapter2 vboxnet0



# Create IDE controller and attach DVD
${VBOXMANAGE} storagectl ${VM} --name "IDE controller" --add ide
${VBOXMANAGE} storageattach ${VM} --storagectl "IDE controller"  --port 0 --device 0 --type dvddrive --medium $isofile



## Create the boot configuration (need machine UUID)
UUID=`${VBOXINFO} |awk '/UUID/ {print $2}'|head -n 1`
echo $UUID
#ln -s ./pxelinux.cfg/pxe_menu.cfg ./pxelinux.cfg/${UUID}



## Start it up
#${VBOX} --startvm "${VM}"



