export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up                       #switch port enp0s8 on
ip add add 10.12.0.1/23 dev enp0s8          #add IP to enp0s8

ip route add 10.11.0.0/23 via 10.12.0.2     #add generic route to reach host-a network via router-1 (VLAN2 port enp0s8.2)
ip route add 10.14.0.0/23 via 10.12.0.2     #add generic route to reach router-2 network via router-1 (VLAN2 port enp0s8.2)
ip route add 10.15.0.0/23 via 10.12.0.2     #add generic route to reach host-c network via router-1 (VLAN2 port enp0s8.2)

