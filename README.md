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
Our idea about developing the infrastructure was to split it in two parts in a first phase and then ‘paste’ them together. 

The first part that we developed included the router-1, the switch, host-a and host-b.
We began with Host-a: it needs to accommodate up to 495 devices, so our subnet mask has to be 255.255.254.0; for the project our purpose was to use IP address that would have been easy to recognize so as subnet address we used 10.11.0.0. in this host we turned on the enp0s8 link and gave it the IP address 10.11.0.1/23.

After Host-a we implemented host-b: it needs to accommodate up to 316 devices, so our subnet mask has to be 255.255.254.0; for this subnet we used the IP address 10.12.0.0. in this host we turned on the enp0s8 link and gave it the IP address 10.12.0.1/23.

Then we began working on the switch: that was not easy, and while working on this we realised that to test it we had to work also on the router-1. We installed the openvswitch packages, and sat emp0s8, emp0s9 and enp0s10 links up; at this point we had some trouble to understand how we could implement the vlans.
Searching for documentation to do it we found ‘https://developers.redhat.com/blog/2017/09/14/vlan-filter-support-on-bridge/’  and ‘https://vda-it.blogspot.com/2014/03/introduzione-alle-reti-3-switch.html’. Thanks to these examples we understood that we had to build the vlans in the router-1. We found different ways to develop the vlans: we choose to split the router-1’s enp0s8 link in two separate virtual ports. We saw this as the easiest way to make host-a and host-b communicate as they would have been in two separate subnets. We gave to the two virtual ports IP addresses which at the beginning was 10.13.0.1/23, 10.13.0.2/23 for enp0s8.1 and enp0s8.2; while in the switch we sat up a bridge between the 3 ports. Once done so we were ready to set up the routes. 

We made some tests and we understood that this part of the architecture worked.

At this point we began working on the second half of the project: the host-c and the router-2. we implemented host-c knowing that it needs to accommodate up to 316 devices,
so, our subnet mask must be 255.255.254.0; for this subnet at the beginning we used the IP address 10.15.0.0. In this host we turned on the enp0s8 link and gave it the IP address 10.15.0.1/23.
then we developed router-2: we made it as if it was in it’s own subnet (10.14.0.0) and we turned on enp0s8 port as 10.14.0.1/23 and enp0s9 port as 10.14.0.2/23. We turned on also the enp0s9 port of the router-1 as 10.13.0.3/23. First, we made the routes to connect router-2 and host-c then the routes to connect router-1 and router-2. 
While testing we found some conflicts and some links weren’t working properly.

We understood that the routers to work in the right way should be connectors for subnets so the fact was that routers ports should have IP addresses as part of the subnets which they are connected with; so we rearranged the IP addresses and the routes: we build an architecture with 5 subnets: one from host-a to the switch (10.11.0.0), one from host-b to the switch (10.12.0.0), one between the switch and router-1 (10.13.0.0), one between router-1 and router-2 (10.14.0.0) and one from host-c to router-2 (10.15.0.0). 

At this point our architecture was working well, so we began studying how to import the docker image: we consulted ‘https://docs.docker.com/’ and then we ran the commands that we found; we made some tests and they gave us good results. 
 
