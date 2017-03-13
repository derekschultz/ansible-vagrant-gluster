# GlusterFS - POC using Vagrant and Ansible

A two-node GlusterFS storage cluster with sufficient fault tolerance to survive
a single node failure with no loss of data.

## Requirements

1. [Vagrant](https://www.vagrantup.com/downloads.html)
1. [Virtualbox](https://www.virtualbox.org/wiki/Downloads) (required for Vagrant)
1. [Ansible](http://docs.ansible.com/ansible/intro_installation.html) 1.9+

## Guide

* Everything runs on Vagrant (using the Virtualbox provider)
* Ansible is used to provision the machines and configure GlusterFS
* All systems running Ubuntu 16.04
  * 2 intances in total to demonstrate data persistence in cluster

### 1. Build it

Here we use the Virtualbox provider for Vagrant to spin up machines.

```bash
./build.sh
```

By using the Vagrant Ansible provider we can automate the system configuration as follows:

1. Set firewall rules. Install Gluster client and server packages and start server daemon
    1. These are roles from community galaxy playbooks (see [requirements.yml](requirements.yml))
1. Create necessary Gluster brick and mount directories
1. Create a new Gluster volume and start it
    1. Uses `gluster_volume` module
1. Connect Gluster nodes together through peer probe
    1. Replica count for volume: 2
1. Mount the Gluster volume

### 2. Verify / Test it

```bash
$ ansible gluster -i inventory -a "gluster peer status" -s
172.16.0.11 | SUCCESS | rc=0 >>
Number of Peers: 1

Hostname: 172.16.0.10
Uuid: 7b2e4a3f-6876-4d46-95c1-a2304759f144
State: Peer in Cluster (Connected)

172.16.0.10 | SUCCESS | rc=0 >>
Number of Peers: 1

Hostname: 172.16.0.11
Uuid: 41885a9b-06bf-46f5-a5ac-596baa524227
State: Peer in Cluster (Connected)
```

```bash
$ ansible gluster -i inventory -a "gluster volume info" -s
172.16.0.10 | SUCCESS | rc=0 >>

Volume Name: gv0
Type: Replicate
Volume ID: 93844a33-91bd-4df7-a696-0aceab4128ee
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: 172.16.0.10:/data/brick/gv0
Brick2: 172.16.0.11:/data/brick/gv0
Options Reconfigured:
performance.flush-behind: off
network.ping-timeout: 5
transport.address-family: inet
performance.readdir-ahead: on
nfs.disable: on

172.16.0.11 | SUCCESS | rc=0 >>

Volume Name: gv0
Type: Replicate
Volume ID: 93844a33-91bd-4df7-a696-0aceab4128ee
Status: Started
Snapshot Count: 0
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: 172.16.0.10:/data/brick/gv0
Brick2: 172.16.0.11:/data/brick/gv0
Options Reconfigured:
performance.flush-behind: off
network.ping-timeout: 5
transport.address-family: inet
performance.readdir-ahead: on
nfs.disable: on
```

### 3. Break it