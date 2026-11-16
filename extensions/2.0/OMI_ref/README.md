# OMI_ref

## Contributors

* Robert Long, Element Inc.

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows a glTF document to reference resources in other glTF documents. This enables better resource sharing between assets, streaming / progressive enhancement, and authoring use-cases.

### Example:

Root File:

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
      "name": "Duck",
      "translation": [1.0, 2.0, 3.0],
      "extensions": {
        "OMI_ref": {
          "uri": "asset.glb",
          "scene": 0
        }
      }
    }
  ]
}
```

Referenced File (asset.glb):

```json
{
  "scenes": [
    {
      "name": "Duck",
      "nodes": [0]
    }
  ],
  "nodes": [
    {
      "mesh": 0
    }
  ]
}
```

## glTF Schema Updates

TODO

### JSON Schema

TODO

## Known Implementations

* Third Room (Design Phase) - https://github.com/thirdroom/thirdroom

## Resources

TODO

