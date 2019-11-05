export DEBIAN_FRONTEND=noninteractive
ip link set enp0s8 up
ip link set enp0s9 up

ip link add link enp0s8 name enp0s8.1 type vlan id 1
ip link add link enp0s8 name enp0s8.2 type vlan id 2

ip link set enp0s8.1 up
ip link set enp0s8.2 up

ip add add 10.13.0.1/23 dev enp0s8.1
ip add add 10.13.0.2/23 dev enp0s8.2
ip add add 10.14.0.1/23 dev enp0s9



ip route add 10.11.0.0/23  dev enp0s8.1 
ip route add 10.12.0.0/23  dev enp0s8.2 
ip route add 10.15.0.0/23 via 10.14.0.2 dev enp0s9


sysctl net.ipv4.ip_forward=1

