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

Optionally depends on the `OMI_physics_body` spec for triggers.

## Overview

This extension allows for objects to add world traversal behavior in the form of links. This specification does not contain any definitions in how the link data is used and it is up to the client builder to decide how the link is activated.

In addition to being defined independently, the `OMI_link` extension can be defined on an `OMI_physics_body` node with the type set to trigger. When `OMI_link` is on a trigger, the trigger should be treated as an activator for the link, such that a player activating that trigger should cause that player to activate the link.

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
                "OMI_physics_body": {
                    "trigger": {}
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

### glTF Object Model

This extension defines no properties that can be read or manipulated by the glTF Object Model.

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
