#!/usr/bin/python

"""
This script creates topology preepared for POC.
"""

import re
import sys
import os
import time

from mininet.cli import CLI
from mininet.log import setLogLevel, info, error
from mininet.net import Mininet
from mininet.link import Intf
from mininet.util import quietRun
from mininet.node import Controller, RemoteController
from mininet.topo import Topo
from mininet.node import Node
from mininet.util import waitListening
from functools import partial
from mininet.node import OVSSwitch

class PocTopo( Topo ):
    "Topology prepared for Presto NRP tutorial"

    def __init__( self ):

        # Initialize topology
        Topo.__init__( self )

	# Add hosts and switches
        h1 = self.addHost( 'h1' )
        h2 = self.addHost( 'h2' )
	h3 = self.addHost( 'h3' )
	h4 = self.addHost( 'h4' )


        s1 = self.addSwitch( 's1' )
        s2 = self.addSwitch( 's2' )
     
        # Add links
        self.addLink( h1, s1 )
	self.addLink( h3, s1 )
        self.addLink( h2 , s2 )
	self.addLink( h4, s2 )
        self.addLink( s1, s2 )


topos = { 'poctopo': ( lambda: PocTopo() ) }
  
def setVlanHost(host, vlan):
   host.cmd('modprobe 8021q')
   host.cmd('vconfig add '+host.name+'-eth0 '+vlan)
   host.cmd('ip addr add '+host.IP()+'/24 dev '+host.name+'-eth0.'+vlan)
   host.cmd('ip link set up '+host.name+'-eth0.'+vlan)
 
def connectToRootNS( network, switch, ip, routes ):
    """Connect hosts to root namespace via switch. Starts network.
      network: Mininet() network object
      switch: switch to connect to root namespace
      ip: IP address for root namespace node
      routes: host networks to route to"""
    # Create a node in root namespace and link to switch 0
    root = Node( 'root', inNamespace=False )
    intf = network.addLink( root, switch ).intf1
    root.setIP( ip, intf=intf )
    # Start network that now includes link to root namespace
    network.start()
    # Add routes from root ns to hosts
    for route in routes:
        root.cmd( 'route add -net ' + route + ' dev ' + str( intf ) )

def sshd( network, cmd='/usr/sbin/sshd', opts='-D',
          ip='10.123.123.1/32', routes=None, switch=None ):
    """Start a network, connect it to root ns, and run sshd on all hosts.
       ip: root-eth0 IP address in root namespace (10.123.123.1/32)
       routes: Mininet host networks to route to (10.0/24)
       switch: Mininet switch to connect to root namespace (s1)"""
    if not switch:
        switch = network[ 's1' ]  # switch to use
    if not routes:
        routes = [ '10.0.0.0/24' ]
    connectToRootNS( network, switch, ip, routes )
    for host in network.hosts:
        host.cmd( cmd + ' ' + opts + '&' )
    print "*** Waiting for ssh daemons to start"
    for server in network.hosts:
        waitListening( server=server, port=22, timeout=5 )

    print
    print "*** Hosts are running sshd at the following addresses:"
    print
    for host in network.hosts:
        print host.name, host.IP()
    print
    print "*** Type 'exit' or control-D to shut down network"
    setVlanHost(network.hosts[0],'300')
    setVlanHost(network.hosts[1],'300')
    setVlanHost(network.hosts[2],'200')
    setVlanHost(network.hosts[3],'200')

    CLI( network )
    for host in network.hosts:
        host.cmd( 'kill %' + cmd )
    network.stop()

def add_ovsdb_node_to_odl(ip):
    os.system('curl --user admin:admin -X POST -H "Content-Type: application/json" -d @./ovsdb_node.json http://'+ip+':8181/restconf/config/network-topology:network-topology/topology/ovsdb:1/')



if __name__ == '__main__':
    setLogLevel( 'info' )
   
    os.system('ovs-vsctl set-manager ptcp:6640')
    
    odl_controller_ip = '127.0.0.1'	
  
    OVSSwitch13 = partial( OVSSwitch, protocols='OpenFlow13' )
    
    topo=PocTopo( )
    net = Mininet( topo , switch=OVSSwitch13 , controller=partial( RemoteController, ip=odl_controller_ip, port=6633 ) )
 
    argvopts = ' '.join( sys.argv[ 1: ] ) if len( sys.argv ) > 1 else (
        '-D -o UseDNS=no -u0' )
    sshd( net, opts=argvopts )   
