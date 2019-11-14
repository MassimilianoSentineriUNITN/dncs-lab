export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up                       #switch port enp0s8 on
ip add add 10.15.0.1/23 dev enp0s8          #add IP to enp0s8

ip route add 10.11.0.0/23 via 10.15.0.2     #add generic route to reach host-a network via router-2
ip route add 10.12.0.0/23 via 10.15.0.2     #add generic route to reach host-b network via router-2
ip route add 10.14.0.0/23 via 10.15.0.2     #add generic route to reach router-1 port network via router-2



#installation of web-server in docker
sudo apt-get update                                     #update and upgrade of applications
sudo apt-get upgrade
sudo apt-get install -y docker.io                       #installation of docker engine
sudo docker pull nginx                                  #downloading nginx image
sudo docker run --name web-server -p 80:80 -d nginx     #running docker called 'web-server' using nginx on port 80:80
