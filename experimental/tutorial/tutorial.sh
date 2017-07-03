#!/bin/bash

HOST="localhost"
AUTH="admin:admin"

URL="http://${HOST}:8181"
GET="curl --basic -u ${AUTH}"
POST="curl -X POST -H Content-Type:application/json --basic -u ${AUTH}"

# Get available topology
step1() {
    set -x
    ${GET} ${URL}/restconf/operational/tapi-common:context/tapi-topology:topology/mef:presto-nrp-topology
}

# Create a connectivity service
step2() {
    set -x
    ${POST} ${URL}/restconf/operations/tapi-connectivity:create-connectivity-service --data-ascii @- <<EOF
{
  "input": {
    "end-point": [
      {
        "service-interface-point": "sip:ovs-node:s1:s1-eth1",
        "direction": "bidirectional",
        "layer-protocol-name": "eth",
        "nrp-cg-eth-frame-flow-cpa-aspec": {
        	"ce-vlan-id-list": {
        		"vlan-id-list":[
        			{
        				"vlan-id": 300
        			}
        		]
        	}
        }
      },
      {
        "service-interface-point": "sip:ovs-node:s5:s5-eth1",
        "direction": "bidirectional",
        "layer-protocol-name": "eth",
        "nrp-cg-eth-frame-flow-cpa-aspec": {
        	"ce-vlan-id-list": {
        		"vlan-id-list":[
        			{
        				"vlan-id": 300
        			}
        		]
        	}
        }
      }
    ],
    "conn-constraint": {
      "service-type": "point-to-point-connectivity",
      "service-level": "best-effort",
      "requested-capacity": {
        "committed-information-rate": 1000,
        "committed-burst-size": 100
      }
    },
    "nrp-cg-eth-conn-serv-spec": {
      "connection-type": "point-to-point",
      "max-frame-size": "2000",
      "unicast-frame-delivery": "unconditionally",
      "broadcast-frame-delivery": "unconditionally",
      "multicast-frame-delivery": "unconditionally",
      "ce-vlan-id-preservation": "preserve",
      "ce-vlan-pcp-preservation": "true",
      "ce-vlan-dei-preservation": "true",
      "s-vlan-pcp-preservation": "true",
      "s-vlan-dei-preservation": "true",
      "available-meg-level": "0",
      "l2cp-address-set": "ctb"
    }
  }
}
EOF
}

# Get list of connectivity services
step3() {
    set -x
    ${POST} ${URL}/restconf/operations/tapi-connectivity:get-connectivity-service-list
}

# Delete a connectivity service
step4() {
    if [ $# -lt 1 ]
    then
        echo "Usage is: step4 <uuid>"
        exit 1
    fi
    set -x
    ${POST} ${URL}/restconf/operations/tapi-connectivity:delete-connectivity-service --data-ascii @- <<EOF
{
  "input" : {
    "service-id-or-name" : "${1}"
  }
}
EOF
}

# Print usage and exit
usage() {
    cat <<EOF

Usage: $0 <tutorial-step> [ argument ... ]

Tutorial steps are:

step1          Get topology
step2          Create a connectivity service
step3          Get a list of connectivity services
step4 <uuid>   Delete a connectivity service

help           This help

EOF
}

if [ $# -lt 1 ]
then
    usage
    exit 1
fi

case "$1" in
    step*)
        $*
        ;;
    *)
        usage
        ;;
esac
