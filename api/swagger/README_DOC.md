# MEF LSO Presto Swagger definitions

Swagger definitions were automatically derived from yang files using yang2swagger tool (https://github.com/bartoszm/yang2swagger).
The directory contains prefered Swagger definition ``presto-nrp.yaml`` and some additional ones (in ``additions`` directory):
* presto-nrp-rpc-only.yaml - Presto NRP definitions for RPC operations only
* presto-nrp-rpc-only-simplified-hierarchy.yaml - Presto NRP definitions for RPC operations only with simplified class hierarchy
* presto-nrp-simplified-hierarchy.yaml - Presto NRP definitions with simplified hierarchy

All Swagger definitions in ``additions`` directory are compatible with ``presto-nrp.yaml``

## Hierarchy flattening
Swagger allows combining and extending model definitions using the ``allOf`` property of JSON Schema, in effect offering model composition. allOf takes in an array of object definitions that are validated independently but together compose a single object.
However most of the default code generators do not handle definitions that contain more than one simple model and a single reference.

To allow Presto NRP swagger definition to be consumed by default code generator we need to flatten data model, for example:

```
  tapi.connectivity.deleteconnectivityservice.output.Service:
    allOf:
    - $ref: "#/definitions/nrp.interface.ServiceAugmentation1"
    - $ref: "#/definitions/tapi.common.AdminStatePac"
    - $ref: "#/definitions/tapi.common.GlobalClass"
    - $ref: "#/definitions/tapi.connectivity.ConnectivityConstraint"
    - $ref: "#/definitions/tapi.connectivity.ResilienceConstraint"
    - $ref: "#/definitions/tapi.connectivity.TopologyConstraint"
    - type: "object"
      properties:
        layer-protocol-name:
          description: "none"
          $ref: "#/definitions/tapi.common.LayerProtocolName"
        connection:
          type: "array"
          description: "none"
          items:
            type: "string"
            x-path: "/tapi-common:context/tapi-connectivity:connection/tapi-connectivity:uuid"
        end-point:
          type: "array"
          description: "none"
          items:
            $ref: "#/definitions/tapi.connectivity.deleteconnectivityservice.output.service.EndPoint"
        direction:
          description: "none"
          $ref: "#/definitions/tapi.common.ForwardingDirection"
      description: "none"
```
is converted to:
```
tapi.connectivity.deleteconnectivityservice.output.Service:
    allOf:
    - $ref: "#/definitions/tapi.common.GlobalClass"
    - properties:
        schedule:
          description: "none"
          $ref: "#/definitions/tapi.common.TimeRange"
        requested-capacity:
          description: "none"
          $ref: "#/definitions/tapi.common.Capacity"
        is-exclusive:
          type: "boolean"
          description: "To distinguish if the resources are exclusive to the service\
            \  - for example between EPL(isExclusive=true) and EVPL (isExclusive=false),\
            \ or between EPLAN (isExclusive=true) and EVPLAN (isExclusive=false)"
          default: true
        diversity-exclusion:
          type: "array"
          description: "none"
          items:
            $ref: "#/definitions/tapi.connectivity.ConnectivityServiceRef"
        service-level:
          type: "string"
          description: "An abstract value the meaning of which is mutually agreed\
            \ – typically represents metrics such as - Class of service, priority,\
            \ resiliency, availability"
        service-type:
          description: "none"
          $ref: "#/definitions/tapi.connectivity.ServiceType"
        cost-characteristic:
          type: "array"
          description: "The list of costs where each cost relates to some aspect of\
            \ the TopologicalEntity."
          items:
            $ref: "#/definitions/tapi.topology.CostCharacteristic"
        latency-characteristic:
          type: "array"
          description: "The effect on the latency of a queuing process. This only\
            \ has significant effect for packet based systems and has a complex characteristic."
          items:
            $ref: "#/definitions/tapi.topology.LatencyCharacteristic"
        coroute-inclusion:
          type: "string"
          description: "none"
          
          [... CUT ...]
```
In other words properties from most of the referenced models got unpacked to definition using it.

## Generating swagger definitions from YANG modules 

You can generate swagger definitions by yourself using https://github.com/bartoszm/y2s-tapi-cli. 
The latest released version is:  https://github.com/bartoszm/y2s-tapi-cli/releases/tag/v1.0.0

For example, to get ``presto-nrp.yaml``:
``java -cp yang2swagger-tapi-cli-1.0-cli.jar com.amartus.y2s.Generator -yang-dir yang  -output presto-nrp.yaml``

To get file with simplified hierarchy:
``java -cp yang2swagger-tapi-cli-1.0-cli.jar com.amartus.y2s.Generator -yang-dir yang -simplify-hierarchy -output presto-nrp-simplified.yaml``