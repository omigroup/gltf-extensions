# OMI_link

## Contributors

* Robert Long, The Matrix.org Foundation
* Anthony Burchell, Individual Contributor

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows for objects to add world traversal behavior in the form of links. This specification does not contain any definitions in how the link data is used and it is up to the client builder to decide how the link is activated.

A collider attached to the same node as an OMI_link object can be assumed to be collidable or clickable for activating the traversal behavior.

### Example:

```json
{
  "scenes": [
    {
      "name": "Default Scene",
      "nodes": [0]
    }
  ],
  "nodes": [
    {
      "name": "OMI Group meetup space",
      "translation": [1.0, 2.0, 3.0],
      "extensions": {
        "OMI_link": {
          "uri": "https://omigroup.org/worlds/meetup"
        },
        "OMI_collider": {
          ...
        }
      }
    }
  ]
}
```

## glTF Schema Updates

### `uri`

Must be a valid uri, relative path, or fragment.

Valid `uri` field values:

```
https://omigroup.org/worlds/meetup
https://omigroup.org/worlds/meetup#portal1
https://omigroup.org/worlds/meetup?autojoin=true#portal1
./breakoutroom1
#portal1
```

### JSON Schema

TODO

## Known Implementations
Interested Implementations:
* Third Room - https://github.com/thirdroom/thirdroom
* Three Object Viewer (WordPress Plugin) - https://wordpress.org/plugins/three-object-viewer/

## Resources

TODO

## Prior Art
* Third Room - https://github.com/matrix-org/thirdroom-unity-exporter/tree/main/Runtime/Scripts/MX_portal
