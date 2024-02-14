#Given these requirements

Base address: 142.150.235.0
Network mask: 255.255.255.224
Broadcast address: 142.150.235.31
Reserved Router address: 142.150.235.1
#a) What is the address of the assigned subnetwork and what is the extended network prefix?
#solution
network mask in binary form: 11111111.11111111.11111111.11100000
network prefix: 27
#b)Which IP addresses can I use to configure the computers in my lab? 
# solution
142.150.235.2 to 142.150.235.30
c) Suppose I wanted to do subdivide the assigned address block into 4 smaller subnetworks of equal size. How large are these networks, and how many IP addresses can I assign in each subnetwork?
#solution
subnet=2^2=4 
subnet mask=27+2=29
host=32-29=3 bits
useable ip address=2^(3)-2
                  =6 ips
#subnet 1
network ip= 142.150.235.0
ip range=   142.150.235.1 to 142.150.235.6
broadcast addresss= 142.150.235.7

#subnet 2
network ip= 142.150.235.8
ip range=   142.150.235.9 to 142.150.235.14
broadcast addresss= 142.150.235.15

#subnet 3
network ip= 142.150.235.16
ip range=   142.150.235.17 to 142.150.235.22
broadcast addresss= 142.150.235.23

#subnet 4
network ip= 142.150.235.24
ip range=   142.150.235.25 to 142.150.235.30
broadcast addresss= 142.150.235.31



