#!/bin/bash

HOST="localhost"
AUTH="admin:admin"

URL="http://${HOST}:8181"
GET="curl --basic -u ${AUTH}"
POST="curl -X POST -H Content-Type:application/json --basic -u ${AUTH}"

# Set up OpenDaylight with OVS
init() {
    ${POST} ${URL}/restconf/config/network-topology:network-topology/topology/ovsdb:1 --data-ascii @- <<EOF
{
    "node": [
        {
            "node-id": "odl",
            "connection-info": {
              "remote-ip": "127.0.0.1",
              "remote-port": 6640
            }
        }
    ]
}
EOF
}

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
        "service-interface-point": {
          "service-interface-point-id" :"sip:ovs-node:s1:s1-eth1"

        },
        "direction": "BIDIRECTIONAL",
        "layer-protocol-name": "ETH",
        "nrp-carrier-eth-connectivity-end-point-resource": {
          "ce-vlan-id-list-and-untag": {
            "vlan-id":[
              {
                "vlan-id": 301
              }
            ]
          }
        }
      },
      {
        "service-interface-point": {
          "service-interface-point-id" :"sip:ovs-node:s2:s2-eth1"
        },
        "direction": "BIDIRECTIONAL",
        "layer-protocol-name": "ETH",
        "nrp-carrier-eth-connectivity-end-point-resource": {
          "ce-vlan-id-list-and-untag": {
            "vlan-id":[
              {
                "vlan-id": 301
              }
            ]
          }
        }
      }
    ],
    "conn-constraint": {
      "service-type": "POINT_TO_POINT_CONNECTIVITY",
      "service-level": "BEST_EFFORT"
    },
    "nrp-interface:nrp-carrier-eth-connectivity-resource": {
      "max-frame-size": "2000"
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

init           Set up OpenDaylight with OVS info
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
    step*|init)
        $*
        ;;
    *)
        usage
        ;;
esac
