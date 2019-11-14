# DNCS-LAB

This repository contains the Vagrant files required to run the virtual lab environment used in the DNCS course.
```


        +-----------------------------------------------------+
        |                                                     |
        |                                                     |eth0
        +--+--+                +------------+             +------------+
        |     |                |            |             |            |
        |     |            eth0|            |eth2     eth2|            |
        |     +----------------+  router-1  +-------------+  router-2  |
        |     |                |            |             |            |
        |     |                |            |             |            |
        |  M  |                +------------+             +------------+
        |  A  |                      |eth1                       |eth1
        |  N  |                      |                           |
        |  A  |                      |                           |
        |  G  |                      |                     +-----+----+
        |  E  |                      |eth1                 |          |
        |  M  |            +-------------------+           |          |
        |  E  |        eth0|                   |           |  host-c  |
        |  N  +------------+      SWITCH       |           |          |
        |  T  |            |                   |           |          |
        |     |            +-------------------+           +----------+
        |  V  |               |eth2         |eth3                |eth0
        |  A  |               |             |                    |
        |  G  |               |             |                    |
        |  R  |               |eth1         |eth1                |
        |  A  |        +----------+     +----------+             |
        |  N  |        |          |     |          |             |
        |  T  |    eth0|          |     |          |             |
        |     +--------+  host-a  |     |  host-b  |             |
        |     |        |          |     |          |             |
        |     |        |          |     |          |             |
        ++-+--+        +----------+     +----------+             |
        | |                              |eth0                   |
        | |                              |                       |
        | +------------------------------+                       |
        |                                                        |
        |                                                        |
        +--------------------------------------------------------+



```

# Requirements
 - Python 3
 - 10GB disk storage
 - 2GB free RAM
 - Virtualbox
 - Vagrant (https://www.vagrantup.com)
 - Internet

# How-to
 - Install Virtualbox and Vagrant
 - Clone this repository
`git clone https://github.com/dustnic/dncs-lab`
 - You should be able to launch the lab from within the cloned repo folder.
```
cd dncs-lab
[~/dncs-lab] vagrant up
```
Once you launch the vagrant script, it may take a while for the entire topology to become available.
 - Verify the status of the 4 VMs
 ```
 [dncs-lab]$ vagrant status                                                                                                                                                                
Current machine states:

router                    running (virtualbox)
switch                    running (virtualbox)
host-a                    running (virtualbox)
host-b                    running (virtualbox)
```
- Once all the VMs are running verify you can log into all of them:
`vagrant ssh router`
`vagrant ssh switch`
`vagrant ssh host-a`
`vagrant ssh host-b`
`vagrant ssh host-c`

# Assignment
This section describes the assignment, its requirements and the tasks the student has to complete.
The assignment consists in a simple piece of design work that students have to carry out to satisfy the requirements described below.
The assignment deliverable consists of a Github repository containing:
- the code necessary for the infrastructure to be replicated and instantiated
- an updated README.md file where design decisions and experimental results are illustrated
- an updated answers.yml file containing the details of 

## Design Requirements
- Hosts 1-a and 1-b are in two subnets (*Hosts-A* and *Hosts-B*) that must be able to scale up to respectively 495 and 316 usable addresses
- Host 2-c is in a subnet (*Hub*) that needs to accommodate up to 338 usable addresses
- Host 2-c must run a docker image (dustnic82/nginx-test) which implements a web-server that must be reachable from Host-1-a and Host-1-b
- No dynamic routing can be used
- Routes must be as generic as possible
- The lab setup must be portable and executed just by launching the `vagrant up` command

## Tasks
- Fork the Github repository: https://github.com/dustnic/dncs-lab
- Clone the repository
- Run the initiator script (dncs-init). The script generates a custom `answers.yml` file and updates the Readme.md file with specific details automatically generated by the script itself.
  This can be done just once in case the work is being carried out by a group of (<=2) engineers, using the name of the 'squad lead'. 
- Implement the design by integrating the necessary commands into the VM startup scripts (create more if necessary)
- Modify the Vagrantfile (if necessary)
- Document the design by expanding this readme file
- Fill the `answers.yml` file where required (make sure that is committed and pushed to your repository)
- Commit the changes and push to your own repository
- Notify the examiner that work is complete specifying the Github repository, First Name, Last Name and Matriculation number. This needs to happen at least 7 days prior an exam registration date.

# Notes and References
- https://rogerdudler.github.io/git-guide/
- http://therandomsecurityguy.com/openvswitch-cheat-sheet/
- https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/
- https://www.vagrantup.com/intro/getting-started/


# Design

## Authors and notes
This project has been developed by Massimiliano Sentineri (mat. 193770) and Gabriele Bottamedi (mad. 193208) in equal parts working always in pair on the same device. We had some trubles while running vagrant with Windows OS, so we had to use a MacOS device.  

## Planning
Our idea about developing the infrastructure was to split it in two parts in a first phase, develop them as separate and then link them together. Part one is: host-a, host-b, switch and router-1; two other part is router-2 and host-c. We decided to use for the subnet IP address that would have been easy to recognize so each subnet IP address is 8 bits next to the previous one. Our goal is to build an architecture with 4 subnets: one from host-a to router-1 (10.11.0.0), one from host-b to router-1 (10.12.0.0), one between router-1 and router-2 (10.14.0.0) and one from host-c to router-2 (10.15.0.0).

## Developing
### Developing part one
- Host-a: it needs to accommodate up to 495 devices, as subnet IP addresses we used 10.11.0.0/23; in this host we turned on the enp0s8 interface with IP address 10.11.0.1/23. 
- Host-b: it needs to accommodate up to 316 devices, as subnet IP addresses we used 10.12.0.0/23; we turned on the enp0s8 interface with IP address 10.12.0.1/23.
- Switch: we had to learn how to build the vlans to keep host-a and host-b in separate subnets. We installed the openvswitch packages, and set enp0s8, enp0s9 and enp0s10 links up. Searching for documentation to do it we found ‘https://developers.redhat.com/blog/2017/09/14/vlan-filter-support-on-bridge/’ and ‘https://vda-it.blogspot.com/2014/03/introduzione-alle-reti-3-switch.html’. At this point we understood that we had to build the vlans in the router-1.
- Router-1: we turned enp0s8 port up. To develop the vlans we chose to split the router-1’s enp0s8 link in two separate virtual ports (8.1 and 8.2), both to be connected with the switch’s port enp0s8. In the switch a bridge has been set up to connect enp0s8, enp0s9 and enp0s10 ports. The bridge is built to manage packages coming from host-a and host-b to router-1 and vice versa. In this way we made host-a and host-b communicate only via router. We gave to the two virtual ports IP addresses 10.11.0.2/23, 10.12.0.2/23 for enp0s8.1 and enp0s8.2. We gave the router the command 'sysctl net.ipv4.ip_forward=1' to enable the router to forward packages.

In this architecture there are 2 vlans: one for host-a (subnet 10.11.0.0) and one for host-b (subnet 10.12.0.0). 
At this point we set up the routes: one form host-a to host-b via the router and one form host-b to host-a via the router. 

### Testing first phase
To test the infrastructure, we used ping commands. We pinged from host-a to router-1, from host-a to host-b, from host-b to router-1 and from host-b to host-a; this part of the architecture worked.

### Developing part two
- Host-c: knowing that it needs to accommodate up to 316 devices, as subnet IP addresses we used 10.15.0.0/23; then we turned on the enp0s8 link with IP address 10.15.0.1/23.
- Router-2: we made it to connect host-c subnet to the network connected to router-1. We turned on enp0s8 port as 10.15.0.2/23 (subnet 10.15.0.0 shared with host-c) and enp0s9 port as 10.14.0.2/23 (subnet 10.14.0.0 shared between touter-1 and router-2). We turned on also the enp0s9 port of the router-1 as 10.14.0.1/23. In this way the touters are connectors for subnets. We gave the router the command 'sysctl net.ipv4.ip_forward=1' to enable the router to forward packages. 

We set up the generic routes to connect router-2 nework to router-1 network.  

## Docker
we began studying how to import the docker image: we consulted ‘https://docs.docker.com/’. We ran the commands that we found; we made some tests and they gave us good results. It runs on port 80.

### Final testing 
We used ping commands to check all the routes; and "curl 10.15.0.1:80" to test the server based on host-c. The result is that the architecture works.

## Commands
To run the infrastructure use "vagrant up".
To test connections use "ping <IP address>".
To test the server on host-c use "curl 10.15.0.1:80".

## Notes
In the github repository there is a middle commit of an old version of the architecture that includes a wrong subnet scheme thas has been corrected in the final commit. 
