# MEF LSO Presto Tutorial

This tutorial introduces the MEF LSO Presto API with examples that can be used live with
OpenDaylight Unimgr.

There are several ways for you to run through the steps in this tutorial:

* Play along with the provided MEF-LSO-Presto-SDK Postman collection.
* Use the provided *tutorial.sh* to run each step from your shell.
* Construct and execute each of the HTTP requests in your favourite programming language.

## Prerequisites

The tutorial assumes that the Presto SDK demo VM is running OpenDaylight Unimgr and mininet. The VM can be downloaded from the following locations: 

* Presto-SDK.zip (https://metroethernetforum.box.com/s/h5j78genqwx2y4z7msho6119wxqnpffe)
* Presto-SDK.z01 (https://metroethernetforum.box.com/s/2rhbl3ct3wqkszm06ootbe31frjhyhps)

Here are the commands to unzip after you have downloaded both the files

* zip -s 0 Presto-SDK.zip --out Presto-SDK-full.zip
* unzip Presto-SDK-full.zip

Alternatively, you can install mininet and Opendaylight by yourself. Presto SDK R2 is not part of official distribution of Opendaylight yet,
therefore you can download sources from github fork: https://github.com/donaldh/unimgr/tree/presto-20180307  

If you need to manually start OpenDaylight, these are the steps:

### Start OpenDaylight

```sh
% cd unimgr-karaf-0.3.1.SNAPSHOT
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
** Creating network
*** Adding controller
Unable to contact the remote controller at 127.0.0.1:6633
*** Adding hosts:
h1 h2 
*** Adding switches:
s1 s2 s3 
*** Adding links:
(h1, s1) (h2, s2) (s1, s3) (s2, s3) 
*** Configuring hosts
h1 h2 
*** Starting controller
c0 
*** Starting 3 switches
s1 s2 s3 ...
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

### Configure mininet default state
It is needed to remove some of the default flow rules from mininet switches
```
% sudo python clear_edge_switches.py
```

# Tutorial

You can run this tutorial step with the *tutorial.sh* helper:

```sh
% ./tutorial.sh init
```

If you prefer to use postman, the collection with all the tutorial steps can be found in ../examples directory ``MEF-LSO-Presto-SDK-ODL.postman_collection``

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
    "topology": {
        "layer-protocol-name": [
            "ETH"
        ],
        "uuid": "mef:presto-nrp-topology",
        "node": [
            {
                "uuid": "mef:presto-nrp-abstract-node",
                "layer-protocol-name": [
                    "ETH"
                ],
                "encap-topology": {
                    "topology-id": "mef:presto-nrp-topology-system"
                },
                "owned-node-edge-point": [
                    {
                        "uuid": "ovs-node:s2:s2-eth1",
                        "layer-protocol-name": "ETH",
                        "link-port-role": "SYMMETRIC",
                        "mapped-service-interface-point": [
                            {
                                "service-interface-point-id": "sip:ovs-node:s2:s2-eth1"
                            }
                        ],
                        "link-port-direction": "BIDIRECTIONAL"
                    },
/*[ ... CUT ...]*/
                    {
                        "uuid": "ovs-node:s1:s1-eth1",
                        "layer-protocol-name": "ETH",
                        "link-port-role": "SYMMETRIC",
                        "mapped-service-interface-point": [
                            {
                                "service-interface-point-id": "sip:ovs-node:s1:s1-eth1"
                            }
                        ],
                        "link-port-direction": "BIDIRECTIONAL"
                    },
                    {
                        "uuid": "ovs-node:s1:s1-eth2",
                        "layer-protocol-name": "ETH",
                        "link-port-role": "SYMMETRIC",
                        "mapped-service-interface-point": [
                            {
                                "service-interface-point-id": "sip:ovs-node:s1:s1-eth2"
                            }
                        ],
                        "link-port-direction": "BIDIRECTIONAL"
                    }
/*[ ... CUT ...]*/
                ]
            }
        ]
    }
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
        "service": {
            "uuid": "cs:16253332dff:25aeaf3d",
            "connection": [
                "conn:mef:presto-nrp-abstract-node:16253332dff:25aeaf3d"
            ],
            "end-point": [
                {
                    "local-id": "sep:-1898313e",
                    "service-interface-point": {
                        "service-interface-point-id": "sip:ovs-node:s1:s1-eth1"
                    },
                    "direction": "BIDIRECTIONAL",
                    "layer-protocol-name": "ETH",
                    "nrp-interface:nrp-carrier-eth-connectivity-end-point-resource": {
                        "ce-vlan-id-list-and-untag": {
                            "vlan-id": [
                                {
                                    "vlan-id": 301
                                }
                            ]
                        }
                    },
                    "role": "SYMMETRIC"
                },
                {
                    "local-id": "sep:7d611662",
                    "service-interface-point": {
                        "service-interface-point-id": "sip:ovs-node:s2:s2-eth1"
                    },
                    "direction": "BIDIRECTIONAL",
                    "layer-protocol-name": "ETH",
                    "nrp-interface:nrp-carrier-eth-connectivity-end-point-resource": {
                        "ce-vlan-id-list-and-untag": {
                            "vlan-id": [
                                {
                                    "vlan-id": 301
                                }
                            ]
                        }
                    },
                    "role": "SYMMETRIC"
                }
            ]
        }
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
