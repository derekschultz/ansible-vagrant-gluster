#!/bin/bash
set -x

echo "Mounting Gluster volume and copying files..."
vagrant ssh gluster-01 -c 'sudo mkdir /glustertest; sudo mount -t glusterfs 172.16.0.10:/gv0 /glustertest'
vagrant ssh gluster-01 -c 'for i in `seq -w 1 100`; do sudo cp /var/log/syslog /glustertest/copy-test-$i; done; ls -l /glustertest | wc -l;'

echo "Checking Gluster bricks..."
vagrant ssh gluster-02 -c 'ls -l /data/brick/gv0 | wc -l'
vagrant ssh gluster-03 -c 'ls -l /data/brick/gv0 | wc -l'

echo "Halting 1 out of 3 nodes..."
vagrant halt gluster-03

echo "Checking Gluster bricks on remaining hosts..."
vagrant ssh gluster-01 -c 'ls -l /data/brick/gv0 | wc -l'
vagrant ssh gluster-02 -c 'ls -l /data/brick/gv0 | wc -l'