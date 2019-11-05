export DEBIAN_FRONTEND=noninteractive
# 

ip link set enp0s8 up
ip add add 10.11.0.1/23 dev enp0s8

ip route add 10.13.0.0/23 dev enp0s8

ip route add 10.12.0.0/23 via 10.13.0.1 
ip route add 10.14.0.0/23 via 10.13.0.1 
ip route add 10.15.0.0/23 via 10.13.0.1 