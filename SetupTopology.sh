#!/bin/bash
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