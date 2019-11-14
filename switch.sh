export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

ip link set enp0s8 up                       #switch port enp0s8 on
ip link set enp0s9 up                       #switch port enp0s9 on
ip link set enp0s10 up                      #switch port enp0s10 on

ovs-vsctl add-br Tower                      #add bridge
ovs-vsctl add-port Tower enp0s8             #add ports to bridge, including tags for VLANs
ovs-vsctl add-port Tower enp0s9 tag=1
ovs-vsctl add-port Tower enp0s10 tag=2 
ip link set Tower up                        #switch bridge on