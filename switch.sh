export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

# Startup commands for switch go here
ip link set enp0s8 up
ip link set enp0s9 up
ip link set enp0s10 up

ovs-vsctl add-br Tower
ovs-vsctl add-port Tower enp0s8
ovs-vsctl add-port Tower enp0s9 tag=1
ovs-vsctl add-port Tower enp0s10 tag=2 
ip link set Tower up