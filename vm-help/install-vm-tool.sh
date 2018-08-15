#!/bin/bash

test -e /mnt/cdrom || sudo mkdir /mnt/cdrom
sudo mount /dev/cdrom /mnt/cdrom
_file_=`ls /mnt/cdrom/*.tar.gz`
tar xzvf ${_file_} -C /tmp/
test -e /tmp/vmware-tools-distrib/ && cd /tmp/vmware-tools-distrib/
sudo ./vmware-install.pl -d && sudo reboot
