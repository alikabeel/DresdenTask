#!/bin/bash
# Delete any existing rules to prevent any kind of conflict
ovs-ofctl del-flows ovs-brY
# Set a default flow where we allow communication between all hosts.
ovs-ofctl add-flow ovs-brY priority=0,actions=normal
# Block pings from A to B, We only block echo requests so that pings from B to A can still work as it needs an echo reply from A to B
ovs-ofctl add-flow ovs-brY ip,nw_proto=1,icmp_type=8,nw_src=175.16.1.2,nw_dst=175.16.1.3,actions=drop
# Verify no errors happened
echo "Rules are now set!"
