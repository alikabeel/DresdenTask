# DresdenTask
## Motive
This repo serves as a solution to the following task:

On a Linux box, Setup a simple network topology where two docker containers are connected via an Openvswitch (OVS) bridge on the same host:

A ----- OVS ------ B

Once this topology is setup, install some Openflow rules on OVS to block pings (ICMP packets) from A to B but still allow pings from B to A to work normally.
### Deliverables
- A bash script that sets up the topology
- A bash script that installs the Openflow rules on OVS
- The output of `ovs-ofctl dump-flows <br_name>` command as a text file.
- The output of ping from A -> B as a text file
- The output of ping from B -> A as a text file

## Solution Steps
For the sake of solving this task we used a Digital Ocean Ubuntu instance for ease of deployment/destroying & redeployment although the same steps could have been done on any Linux box.
### Before You Start
This solution assumes a fresh Ubuntu instance namely Ubuntu 20.04 (LTS) x64. So we start with a fresh Ubuntu box and we don't need to initially run any commands.
### Initialization
In this step we need to run our [init.sh script](init.sh). The script automates the process of downloading/updating all the needed packages as well as creating two Ubuntu based containers namely ContainerA
 & ContainerB. The script can be used by giving it read, write & execute permissions using:
 ```
 chmod 777 init.sh
 ```
 The script can then be used using the following command:
 ```
 ./init.sh
 ```
 It is worth noting that the script need to be run by a root user or using the "sudo" keyword before the command.
 
 ### Setting Up The Topology
 It now remains to setup the topology by setting up the bridge and 
 adding the containers to it. This is done by executing the  [SetupTopology.sh script](SetupTopology.sh). We first need to give the script needed permissions using:
 ```
 chmod 777 SetupTopology.sh
 ```
 Then we can execute the script using:
 ```
 ./SetupTopology.sh
 ```
 Again this script needs to be executed by a root user or by using the "sudo" keyword.
 
 ### Applying Openflow Rules 
 This is the final step where we setup OpenFlow rules to block pinging from A to B while allowing pinging from B to A. We do this by blocking echo packets from A to B. This is done by the 
 [SetupOpenFlowRules.sh script](SetupOpenFlowRules.sh). The script simply add rules to satisfy the aforementioned requirements. To run the script we need to give it permissions using:
 ```
 chmod 777 SetupOpenFlowRules.sh
 ```
 Then we can execute it using:
 ```
 ./SetupOpenFlowRules.sh
 ```
 This script as well need root privileges  like the other scripts.
 
 ### Conclusion
 Once you are done with the aforementioned request you can start pinging between containers to check everything is working correctly. 
 
 Note that you may need to download the ping utility on the docker Ubuntu containers as it is not natively found on them. The following can be used to download the ping utility on the docker images:
 ```
apt-get update
apt-get install iputils-ping
```
 
 
 
 
 
