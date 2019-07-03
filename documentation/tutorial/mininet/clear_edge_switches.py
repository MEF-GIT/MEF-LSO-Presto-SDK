import os
os.system('ovs-ofctl -O OpenFlow13 del-flows s1')
os.system('ovs-ofctl -O OpenFlow13 del-flows s2')