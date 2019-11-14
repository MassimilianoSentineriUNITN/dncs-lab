export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up                                   #switch port enp0s8 on
ip link set enp0s9 up                                   #switch port enp0s9 on

ip add add 10.15.0.2/23 dev enp0s8                      #add IP to enp0s8
ip add add 10.14.0.2/23 dev enp0s9                      #add IP to enp0s9

ip route add 10.11.0.0/23 via 10.14.0.1 dev enp0s9      #add generic route to reach host-a network via router-1 
ip route add 10.12.0.0/23 via 10.14.0.1 dev enp0s9      #add generic route to reach host-b network via router-1


sysctl net.ipv4.ip_forward=1                            #set field = 1 in order to forward packages