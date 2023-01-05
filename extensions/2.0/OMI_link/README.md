# OMI_link

## Contributors

* OMI glTF Extensions Group
* Robert Long, The Matrix.org Foundation
* Anthony Burchell, Individual Contributor

## Status

Draft Specification

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

This extension specification currently depends on the draft OMI_collider extension.

## Overview

This extension allows for objects to add world traversal behavior in the form of links. This specification does not contain any definitions in how the link data is used and it is up to the client builder to decide how the link is activated.

Currently this spec depends on the OMI_collider spec. The OMI_collider extension must be attached to the same node as an OMI_link. The client may decide to use the collider for activating the link behavior on click and/or on collision. If OMI_collider is not defined on the node the link the behavior is undefined and can be ignored.

Clients may choose to have application-specific behaviors for URIs otherwise the default platform / browser URI handler should be used. Applications should perform any necessary URI security checks and may decide to present a dialog to inform the user of how the URI is handled.

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
          "title": "Meetup World",
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
vrchat://launch?id=wrld_hjdksahgklfshjfgjklsd
./breakoutroom1
#portal1
```

### `title`

Optional field that describes the destination of the uri. Implementations can show this title if it exists or fallback to showing the uri.

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
