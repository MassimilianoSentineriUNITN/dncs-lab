export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up                                   #switch port enp0s8 on
ip link set enp0s9 up                                   #switch port enp0s9 on

ip link add link enp0s8 name enp0s8.1 type vlan id 1    #Splitting port enp0s8 in enp0s8.1 and anp0s8.2 to generate VLANs
ip link add link enp0s8 name enp0s8.2 type vlan id 2

ip link set enp0s8.1 up                                 #switch port enp0s8.1 on
ip link set enp0s8.2 up                                 #switch port enp0s8.2 on

ip add add 10.11.0.2/23 dev enp0s8.1                    #add IP to enp0s8.1
ip add add 10.12.0.2/23 dev enp0s8.2                    #add IP to enp0s8.2
ip add add 10.14.0.1/23 dev enp0s9                      #add IP to enp0s9

ip route add 10.11.0.0/23  dev enp0s8.1                 #add route to reach the subnet of host-a
ip route add 10.12.0.0/23  dev enp0s8.2                 #add route to reach the subnet of host-b
ip route add 10.15.0.0/23 via 10.14.0.2 dev enp0s9      #add generic route to reach host-c network via router-2 


sysctl net.ipv4.ip_forward=1                            #set field = 1 in order to forward packages

