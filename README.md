# MongoDB Replica Set Deployment with Vagrant, Ansible for Provisioning & PMM for Monitoring

Using & Tested with:

* MacOS High Sierra 10.13.6 Host
* Ubuntu 20.04 Focal Fossa for all VMs
* Vagrant 2.2.10
* VirtualBox 6.1.12
* ansible 2.9.12
* Docker 19.03.12
* Percona Monitoring and Management 2

## Prerequisites
- For customizing VMs configuration such as vCPU, RAM, port forwarding edit './Vagrantfile'
- All provision related files are located under ./provisioning folder, such as: './provisioning/group_vars/all' for adjusting ansible variable

## Playbooks Outline
- Software Dependencies Installation (MongoDB, Docker)
- MongoDB configuration (Wired Tiger, Authorization, Keyfile, Replica Set)
- Performance Tuning for MongoDB (Transparent Huge Pages, Swap, Separate Disk with XFS)
- Docker installation at *monitor* node for running PMM2 Server
- PMM2 Client configuration for all Nodes

## Replica Set Deployment Architectures
Primary with a Secondary and an Arbiter (PSA), there are 1 Primary, 1 Arbiter & 1 Secondary Node as minimal three member replica sets. SEE ([MongoDB Manual](https://docs.mongodb.com/manual/core/replica-set-architecture-three-members/))

## Node & MongoDB Monitoring with PMM2
All Nodes are monitored by PMM2 (*primary*, *arbiter*, *secondary-0*) on PMM2 Server at *monitor* Node

## How to Run/Deploy
1. First create all VMs by for running multi-machine VMs creation by Vagrant:

	`./setup.sh`

2. Check that all nodes are already up and reachable:

	`vagrant provision`
	
3. Then run main playbook:

`ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml'`

or running playbook by separate tags, ie: 

`ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory provisioning/playbook.yml --tags "TAG_NAME"`

with tag name (sequentially ordered): *base*, *mongodb*, *replication*, *monitoring_server* & *monitoring_client*

## Known Bugs & Possible Improvements
- Provisioning must be running after all VMs already UP to prevent unpredictable sequential step of playbook SEE (Ansible tips’n’tricks: provision multiple machines in parallel with Vagrant and Ansible)[https://martincarstenbach.wordpress.com/2019/04/11/ansible-tipsntricks-provision-multiple-machines-in-parallel-with-vagrant-and-ansible/]
- Grafana password always reset to default even after running reset via grafana-cli
- Dynamic RS Nodes deployment
- Dynamic horizontal scale and
- **LAST BUT NOT LEAST, FEEL FREE TO CONTRIBUTE**
