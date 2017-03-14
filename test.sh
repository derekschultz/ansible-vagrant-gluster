#!/bin/bash
set -eufx -o pipefail

echo "Mounting Gluster volume and copying over files..."
vagrant ssh gluster-01 -c 'sudo mount -t glusterfs 172.16.0.10:/gv0 /mnt'
vagrant ssh gluster-01 -c 'for i in `seq -w 1 100`; do sudo cp /var/log/syslog /mnt/copy-test-$i; done; ls -l /mnt | wc -l;'

echo "Checking Gluster bricks..."
vagrant ssh gluster-01 -c 'ls -l /data/brick/gv0 | wc -l'
vagrant ssh gluster-02 -c 'ls -l /data/brick/gv0 | wc -l'
