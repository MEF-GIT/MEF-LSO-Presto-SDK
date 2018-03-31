# MEF LSO Presto SDK

This repository contains the MEF LSO Presto SDK. 

This release is a significant step towards utilizing programmable
networks as part of our MEF 3.0 vision. The SDK builds on the previous
release to align the API schemas and definitions for Network Resource
Provisioning (NRP) to the LSO Presto NRP IPS which was recently
published as [MEF 60](https://www.mef.net/Assets/Technical_Specifications/PDF/MEF_60.pdf).
In addition, its information model incorporates the latest ONF TAPI 2.0
release. The SDK’s data models are supported in a reference
implementation of the OpenDaylight SDN Controller and will be part of
the official Fluorine release. This reference implementation
demonstrates how a northbound application can, in a technology-agnostic
and vendor-agnostic manner, provision a point-to-point or
point-to-multipoint network connectivity service between end points.
Released Presto APIs are controller and underlay technology-agnostic
thus enabling programmatic network orchestration via various SDN
controllers as well as via proprietary NMS/EMS software.

MEF has leveraged collaborative input from the ONF on its TAPI model in
the creation of the LSO Presto NRP (Network Resource Provisioning) IPS.
CenturyLink, Nokia, Amartus, Ciena, Cisco, Coriant, Ericsson, Huawei,
Infinera, Iometrix, NEC and RAD are among the key contributors of this
release.

The MEF LSO Presto SDK is released under the Apache 2.0 license.

More information about the LSO Presto API reference point can be found here:

https://wiki.mef.net/display/CESG/LSO+Presto+SDK

[ Define wider context of MEF Lifecycle Service Orchestration architecture ]

## Contents

This SDK contains the following items:

* COPYRIGHT - Copyright 2018 MEF Forum
* LICENSE - Contains a copy of the Apache 2.0 license
* experimental - SDK content for unpublished MEF specifications
* published - SDK content for published MEF specifications ([MEF 60](https://www.mef.net/Assets/Technical_Specifications/PDF/MEF_60.pdf))
  * yang - Contains the MEF NRP YANG modules, including the ONF Transport API yang modules on
    which the MEF NRP API is based.
  * [swagger](published/swagger/README.md) - Contains the MEF NRP Swagger specifications.
  * [examples](published/examples/README.md) - Contains example JSON API requests and Postman collections.
  * [tutorial](published/tutorial/README.md) - A guide for getting started with the MEF LSO Presto SDK & a packaged demo VM running OpenDaylight Unimgr and mininet.

## Reference Implementations

1) LSO Presto APIs in OpenDaylight SDN Controller

   A reference implementation of the MEF Network Resource Provisioning API is available from the OpenDaylight Unimgr project.

   https://wiki.opendaylight.org/view/Unimgr:Main

   An instance of the Unimgr project is provided in MEFnet for MEF members to undertake integration testing. Please see the MEFnet Terms of Use.

   https://wiki.mef.net/display/CTO/MEFnet

   https://mef.net/TOU

2) LSO Presto APIs (older version) in ONOS SDN Controller

   A plugin to get network topology from Open Network Operating System (ONOS) and return to the Service Orchestration Functionality (SOF) is available here

   https://github.com/aboelbisher/LOS-PRESTO


## Commercial Implementations


## Related Projects

The MEF NRP IPS is an extension of the ONF Transport API (TAPI 2.0.2) which can be found here:

https://github.com/OpenNetworkingFoundation/TAPI

## Copyright

Copyright 2018 MEF Forum
