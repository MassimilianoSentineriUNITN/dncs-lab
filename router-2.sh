export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up
ip link set enp0s9 up

ip add add 10.15.0.2/23 dev enp0s8
ip add add 10.14.0.2/23 dev enp0s9


ip route add 10.11.0.0/23 via 10.14.0.1 dev enp0s9 
ip route add 10.12.0.0/23 via 10.14.0.1 dev enp0s9 



sysctl net.ipv4.ip_forward=1