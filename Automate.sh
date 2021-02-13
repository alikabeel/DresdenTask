#!/bin/bash
# This script downloads all needed packages before beginning the topology setup

# Update and upgrade all packages.
apt-get -y update
apt-get -y upgrade

# Download net-tools that will be used later for "ifconfig" command
apt -y install net-tools

# Download docker
apt-get -y install docker.io

# Download openvswitch
apt-get -y install openvswitch-switch

#Setting the ovs-docker to have permissions to execute
cd /usr/bin
chmod a+rwx ovs-docker
cd

# Creating two docker containers (ubuntu) & bringing them up
docker run -d -it --name ContainerA ubuntu bash
docker run -d -it --name ContainerB ubuntu bash

docker exec ContainerA apt-get -y update
docker exec ContainerA apt-get -y install iputils-ping
docker exec ContainerB apt-get -y update
docker exec ContainerB apt-get -y install iputils-ping
# Creating an OVS bridge to connect the docker containers
ovs-vsctl add-br ovs-brY

# Configure the IP address onto the bridge and bringing it up
ifconfig ovs-brY 175.16.1.1 netmask 255.255.255.0 up

# Connecting the docker containers with the OVS bridge
# Setting Container A to have an ip 175.16.1.2
# Setting Container B to have an ip 175.16.1.3
sudo ovs-docker add-port ovs-brY ovs-brY ContainerA --ipaddress=175.16.1.2/24
sudo ovs-docker add-port ovs-brY ovs-brY ContainerB --ipaddress=175.16.1.3/24

# Print out setup successful message
echo "Topology setup successful"

# Delete any existing rules to prevent any kind of conflict
ovs-ofctl del-flows ovs-brY
# Set a default flow where we allow communication between all hosts.
ovs-ofctl add-flow ovs-brY priority=0,actions=normal
# Block pings from A to B, We only block echo requests so that pings from B to A can still work as it needs an echo reply from A to B
ovs-ofctl add-flow ovs-brY ip,nw_proto=1,icmp_type=8,nw_src=175.16.1.2,nw_dst=175.16.1.3,actions=drop
# Verify no errors happened
echo "Rules are now set!"
docker exec ContainerA ping -c 5 175.16.1.3 > PingAToB.txt
docker exec ContainerB ping -c 5 175.16.1.2 > PingBToA.txt
ovs-ofctl dump-flows ovs-brY > ovs-command.txt
echo "Output Written Successfully"
