# MEF-LSO-Presto-SDK - Billie Release

This repository contains the MEF LSO Presto SDK.

## Download Link

Download the entire repository by clicking
[here](https://github.com/MEF-GIT/MEF-LSO-Presto-SDK/releases/download/billie/MEF-LSO-Presto-SDK-billie.zip)

**Note:**
Since Q4 2020 MEF has introduced a common release schema for all SDKs.

Since the last Aretha release (December 2020) the following items have been updated:

- MEF 66 - SOAM for IP Services - has become a Published Standard, July 2020
- MEF 67 - Service Activation Testing for IP Services - has become a Published Standard, December 2020
- MEF 72.1 - Resource Model -Subscriber & Operator Layer 1 - a new Published Standard, January 2021
- MEF 83 - Network Resource Model - OAM - included, September 2019
- MEF 86 - Presto Service OAM Interface Profile Specification - included, November 2019

There is no update on the api and code artifacts.

The MEF LSO Presto SDK is released under the Apache 2.0 license.

More information about the LSO Presto API reference point can be found here:

https://wiki.mef.net/display/CESG/LSO+Presto+SDK

## Contents

This is the SDK for the MEF LSO Presto API reference point. 
The SDK contains the following items:

* COPYRIGHT - Copyright 2018 MEF Forum
* LICENSE - Contains a copy of the Apache 2.0 license
* api 
  * [swagger](api/swagger/README.md) - Contains the MEF NRP Swagger specifications.
  * yang - Contains the MEF NRP YANG modules, including the ONF Transport API yang modules on
    which the MEF NRP API is based.
* documentation - MEF specifications
  * [examples](documentation/examples/README.md) - Contains example JSON API requests and Postman collections.
  * [tutorial](documentation/tutorial/README.md) - A guide for getting started with the MEF LSO Presto SDK & a packaged demo VM running OpenDaylight Unimgr and mininet.
* uml - Contains UML models for MEF Network Resource Model

## Reference Implementations

1) LSO Presto APIs in OpenDaylight SDN Controller

   A reference implementation of the MEF Network Resource Provisioning API is available from the OpenDaylight Unimgr project.

   https://wiki.opendaylight.org/view/Unimgr:Main

   An instance of the Unimgr project is provided in MEFnet for MEF members to undertake integration testing. Please see the MEFnet Terms of Use.

   https://wiki.mef.net/display/CESG/MEFnet

   https://mef.net/TOU

2) LSO Presto APIs (older version) in ONOS SDN Controller

   A plugin to get network topology from Open Network Operating System (ONOS) and return to the Service Orchestration Functionality (SOF) is available here

   https://github.com/aboelbisher/LOS-PRESTO

## Commercial Implementations

## Related Projects

The MEF NRP IPS is an extension of the ONF Transport API (TAPI 2.0.2) which can be found here:

https://github.com/OpenNetworkingFoundation/TAPI

## Copyright

Copyright 2019 MEF Forum
