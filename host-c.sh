export DEBIAN_FRONTEND=noninteractive

ip link set enp0s8 up
ip add add 10.15.0.1/23 dev enp0s8

ip route add 10.11.0.0/23 via 10.15.0.2 
ip route add 10.12.0.0/23 via 10.15.0.2
ip route add 10.13.0.0/23 via 10.15.0.2

#web-server in docker
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y docker.io
sudo docker pull nginx
sudo docker run --name web-server -p 80:80 -d nginx
