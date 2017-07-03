# MEF LSO Presto Tutorial

This tutorial introduces the MEF LSO Presto API with examples that can be used live with
OpenDaylight Unimgr.

There are several ways for you to run through the steps in this tutorial:

* Play along with the provided MEF-LSO-Presto-SDK Postman collection.
* Use the provided *tutorial.sh* to run each step from your shell.
* Construct and execute each of the HTTP requests in your favourite programming language.

## Prerequisites

The tutorial assumes that the Presto SDK demo VM is running OpenDaylight Unimgr and mininet. If
you need to manually start OpenDaylight, these are the steps:

### Start OpenDaylight

```sh
% cd unimgr-karaf-0.3.0-SNAPSHOT
% ./bin/karaf
Apache Karaf starting up. Press Enter to open the shell now...
100% [========================================================================]

Karaf started in 17s. Bundle stats: 338 active, 338 total

    ________                       ________                .__  .__       .__     __
    \_____  \ ______   ____   ____ \______ \ _____  ___.__.|  | |__| ____ |  |___/  |
     /   |   \\____ \_/ __ \ /    \ |    |  \\__  \<   |  ||  | |  |/ ___\|  |  \   __\
    /    |    \  |_> >  ___/|   |  \|    `   \/ __ \\___  ||  |_|  / /_/  >   Y  \  |
    \_______  /   __/ \___  >___|  /_______  (____  / ____||____/__\___  /|___|  /__|
            \/|__|        \/     \/        \/     \/\/            /_____/      \/


Hit '<tab>' for a list of available commands
and '[cmd] --help' for help on a specific command.
Hit '<ctrl-d>' or type 'system:shutdown' or 'logout' to shutdown OpenDaylight.

opendaylight-user@root>
```
### Enable OVS Driver in OpenDaylight

```sh
opendaylight-user@root>feature:install odl-unimgr-ovs-driver
```

### Launch Mininet

There is a script provided for starting mininet:

```sh
% cd mininet
% sudo python create_topology.py
*** Creating network
*** Adding controller
*** Adding hosts:
h1 h2 h3 h4
*** Adding switches:
s1 s2 s3 s4 s5
*** Adding links:
(h1, s1) (h2, s1) (h3, s5) (h4, s5) (s1, s2) (s1, s3) (s1, s4) (s2, s3) (s3, s4) (s3, s5) (s4, s5)
*** Configuring hosts
h1 h2 h3 h4
*** Starting controller
c0
*** Starting 5 switches
s1 s2 s3 s4 s5 ...
*** Starting CLI:
mininet>
```

### Register OVS with OpenDaylight

The RESTCONF call looks like this:

```
POST /restconf/config/network-topology:network-topology/topology/ovsdb:1
Authorization: basic-auth
Content-Type: application/json
```

The JSON request looks like this:

```json
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
```

You can run this tutorial step with the *tutorial.sh* helper:

```sh
% ./tutorial.sh init
```

## Step 1 - Get Available Topology

The controller provides a topology view which includes endpoints that are elegible for
connectivity serivces. Here we use a RESTCONF request to retrieve a single topology with the
name **mef:presto-nrp-topology**.

The RESTCONF call looks like this:
```
GET /restconf/operational/tapi-common:context/tapi-topology:topology/mef:presto-nrp-topology
Authorization: basic-auth
Content-Type: application/json
```

You can get the topology using curl in a shell like this:

```sh
curl -XGET --basic -u admin:admin \
  http://localhost:8181/restconf/operational/tapi-common:context/tapi-topology:topology/mef:presto-nrp-topology
```

The response in this test environment contains a single *abstract* node which represents the OVS
device, with a list of node edge points. Any two of these node edge points can be connected by a
connectivity service. This JSON response is shortened for readability.

```json
{
  "tapi-topology:topology": [
    {
      "uuid": "mef:presto-nrp-topology",
      "node": [
        {
          "uuid": "mef:presto-nrp-abstract-node",
          "encap-topology": "mef:presto-nrp-topology-system",
          "layer-protocol-name": [
            "eth"
          ],
          "owned-node-edge-point": [
            {
              "uuid": "ovs-node:s1:s1",
              "mapped-service-interface-point": [
                "sip:ovs-node:s1:s1"
              ]
            },
            {
              "uuid": "ovs-node:s5:s5-eth1",
              "mapped-service-interface-point": [
                "sip:ovs-node:s5:s5-eth1"
              ]
            }
          ]
        }
      ],
      "layer-protocol-name": [
        "eth"
      ]
    }
  ]
}
```

You can run this tutorial step with the *tutorial.sh* helper:

```sh
% ./tutorial.sh step1
{"tapi-topology:topology":[{"uuid":"mef:presto-nrp-topology","node":[ ...
```

## Step 2 - Create a Connectivity Service

The RESTCONF call looks like this:
```
POST /restconf/operations/tapi-connectivity:create-connectivity-service
Authorization: basic-auth
Content-Type: application/json
```

The JSON request looks like this:
```json
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
```

You can run this tutorial step with the *tutorial.sh* helper:

```sh
% ./tutorial.sh step2
{"output":{"service":{"uuid":"cs:15d08dd666c:-7f69bf18","connection": ...
```

## Step 3 - Get List of Connectivity Services

The RESTCONF call looks like this:
```
POST /restconf/operations/tapi-connectivity:get-connectivity-service-list
Authorization: basic-auth
Content-Type: application/json
```

The JSON response looks like this:

```json
{
  "output": {
    "service": [
      {
        "uuid": "cs:15d08ad16d5:6f00d57b",
        "connection": [
          "conn:mef:presto-nrp-abstract-node:15d08ad16d5:6f00d57b"
        ],
        "end-point": [
          {
            "local-id": "sep:UniversalId [_value=ovs-node:s5:s5-eth1]:15d08ad16d5:6f00d57b",
            "service-interface-point": "sip:ovs-node:s5:s5-eth1",
            "role": "symmetric",
            "direction": "bidirectional",
            "layer-protocol-name": "eth"
          },
          {
            "local-id": "sep:UniversalId [_value=ovs-node:s1:s1-eth1]:15d08ad16d5:6f00d57b",
            "service-interface-point": "sip:ovs-node:s1:s1-eth1",
            "role": "symmetric",
            "direction": "bidirectional",
            "layer-protocol-name": "eth"
          }
        ],
        "conn-constraint": {
          "requested-capacity": {
            "committed-information-rate": 1000,
            "committed-burst-size": 100
          },
          "service-level": "best-effort",
          "service-type": "point-to-point-connectivity"
        }
      },
      ...
    ]
  }
}
```

You can run this tutorial step with the *tutorial.sh* helper:

```sh
% ./tutorial.sh step3
{"output":{"service":[{"uuid":"cs:15d08ad16d5:6f00d57b" ...
```

## Step 4 - Delete a Connectivity Service

The RESTCONF call looks like this:
```
POST /restconf/operations/tapi-connectivity:delete-connectivity-service
Authorization: basic-auth
Content-Type: application/json
```

The JSON request payload looks like this:

```json
{
  "input" : {
    "service-id-or-name" : "{uuid}"
  }
}
```

You can run this tutorial step with the *tutorial.sh* helper - take the service-uuid from the output in step 3:

```sh
% ./tutorial.sh step4 <service-uuid>
```
