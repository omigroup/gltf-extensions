# OMI_audio_emitter

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
          "volume": 1,
          "loop": true,
          "autoPlay": true,
          "source": 0
        },
        {
          "name": "duck emitter",
          "type": "positional",
          "volume": 0.8,
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