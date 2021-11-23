# OMI_audio_emitter

## Contributors

## Example

```json
{
  "extensions": {
    "OMI_audio_emitter": {
      "audioSources": [
        {
          "name": "environment",
          "uri": "./environment.mp3"
        },
        {
          "name": "quack",
          "mimeType": "audio/mpeg",
          "bufferView": 5
        }
      ],
      "audioEmitters": [
        {
          "name": "environment emitter",
          "type": "global",
          "gain": 1,
          "loop": true,
          "autoPlay": true,
          "source": 0
        },
        {
          "name": "duck emitter",
          "type": "positional",
          "gain": 0.8,
          "loop": false,
          "autoPlay": false,
          "source": 1,
          "coneInnerAngle": 6.283185307179586,
          "coneOuterAngle": 6.283185307179586,
          "coneOuterGain": 0,
          "distanceModel": "inverse",
          "maxDistance": 10,
          "refDistance": 1,
          "rolloffFactor": 0.8
        }
      ]
    }
  },
  "scenes": [
    {
      "name": "Default Scene",
      "extensions": {
        "OMI_audio_emitter": {
          "audioEmitters": [0]
        }
      }
    }
  ],
  "nodes": [
    {
      "name": "Duck",
      "translation": [1, 2, 3],
      "extensions": {
        "OMI_audio_emitter": {
          "audioEmitter": 1
        }
      }
    }
  ]
}
```
# OMI_audio_emitter

## Contributors

* Robert Long, Element Inc.

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

TODO

## glTF Schema Updates

TODO

### JSON Schema

[glTF.OMI_audio_emitter.schema.json](/extensions/2.0/OMI_audio_emitter/schema/glTF.OMI_audio_emitter.schema.json)

## Known Implementations

* TODO: List of known implementations, with links to each if available.

## Resources

* TODO: Resources, if any.
