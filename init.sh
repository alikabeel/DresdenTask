#!/bin/bash
# This script downloads all needed packages before beginning the topology setup

# Update and upgrade all packages.
apt-get update
apt-get upgrade

# Download net-tools that will be used later for "ifconfig" command
apt install net-tools

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