# GlusterFS - POC using Vagrant and Ansible

A three-node replicated GlusterFS storage cluster built with Vagrant and Ansible.

## Requirements

1. [Vagrant](https://www.vagrantup.com/downloads.html)
1. [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (required for Vagrant)
1. [Ansible](http://docs.ansible.com/ansible/intro_installation.html) >= 1.9

## Guide

* Everything runs on Vagrant (using the Virtualbox provider)
* Ansible is used to provision the machines and configure GlusterFS
* All systems running Ubuntu 16.04
  * 3 intances in total to demonstrate data replication in cluster

### 1. Build

Here we use the Virtualbox provider for Vagrant to spin up machines.

```bash
./build.sh
```

By using the Vagrant Ansible provider we can automate the system configuration as follows:

* Set firewall rules to allow Gluster nodes to communicate
* Install Gluster client and server packages and start server daemon
  * These are roles from community galaxy playbooks (see [requirements.yml](requirements.yml))
* Create necessary Gluster brick and mount directories
* Create a new Gluster volume and start it
  * Uses `gluster_volume` module
* Probe for peer nodes
  * Replica count for volume: 3
* Mount the Gluster volume

### 2. Verify / Test

```bash
$ ansible gluster -i inventory -a "gluster peer status" -s
172.16.0.10 | SUCCESS | rc=0 >>
Number of Peers: 2

Hostname: 172.16.0.11
Uuid: 33a9107a-7d7e-46ad-b4d2-a008c3021ff6
State: Peer in Cluster (Connected)

Hostname: 172.16.0.12
Uuid: 98f1e2c8-6f7e-4de0-96d9-9ac5ad4ace49
State: Peer in Cluster (Connected)

172.16.0.12 | SUCCESS | rc=0 >>
Number of Peers: 2

Hostname: 172.16.0.10
Uuid: f09844c2-64e8-43ce-9bca-ee603403e8d1
State: Peer in Cluster (Connected)

Hostname: 172.16.0.11
Uuid: 33a9107a-7d7e-46ad-b4d2-a008c3021ff6
State: Peer in Cluster (Connected)

172.16.0.11 | SUCCESS | rc=0 >>
Number of Peers: 2

Hostname: 172.16.0.10
Uuid: f09844c2-64e8-43ce-9bca-ee603403e8d1
State: Peer in Cluster (Connected)

Hostname: 172.16.0.12
Uuid: 98f1e2c8-6f7e-4de0-96d9-9ac5ad4ace49
State: Peer in Cluster (Connected)
```

```bash
$ ansible gluster -i inventory -a "gluster volume info" -s
172.16.0.11 | SUCCESS | rc=0 >>

Volume Name: gv0
Type: Replicate
Volume ID: ddcfb66e-fcc3-4c84-8b96-422272ff7984
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: 172.16.0.10:/data/brick/gv0
Brick2: 172.16.0.11:/data/brick/gv0
Brick3: 172.16.0.12:/data/brick/gv0
Options Reconfigured:
transport.address-family: inet
performance.readdir-ahead: on
nfs.disable: on

172.16.0.10 | SUCCESS | rc=0 >>

Volume Name: gv0
Type: Replicate
Volume ID: ddcfb66e-fcc3-4c84-8b96-422272ff7984
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: 172.16.0.10:/data/brick/gv0
Brick2: 172.16.0.11:/data/brick/gv0
Brick3: 172.16.0.12:/data/brick/gv0
Options Reconfigured:
transport.address-family: inet
performance.readdir-ahead: on
nfs.disable: on

172.16.0.12 | SUCCESS | rc=0 >>

Volume Name: gv0
Type: Replicate
Volume ID: ddcfb66e-fcc3-4c84-8b96-422272ff7984
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 3 = 3
Transport-type: tcp
Bricks:
Brick1: 172.16.0.10:/data/brick/gv0
Brick2: 172.16.0.11:/data/brick/gv0
Brick3: 172.16.0.12:/data/brick/gv0
Options Reconfigured:
transport.address-family: inet
performance.readdir-ahead: on
nfs.disable: on
```

For testing, run:

```bash
$ ./test.sh
```

To mimick client behavior, this script will add a new mount for the GlusterFS volume
created in the steps above and will sequentially copy an arbitrary file 100x.
We then check the GlusterFS mount points on each host and list the number of files.
You should see 100 files on each host to show replication is working properly.