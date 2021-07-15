# OMI_audio_emitter

## Example

```json
{
  "extensions": {
    "OMI_audio_emitter": {
      "audioClips": [
        {
          "name": "environment",
          "sources": [
            {
              "mimeType": "audio/ogg",
              "uri": "./environment.ogg"
            },
            {
              "mimeType": "audio/wav",
              "uri": "./environment.wav"
            },
            {
              "mimeType": "audio/mpeg",
              "uri": "./environment.mp3"
            }
          ]
        },
        {
          "name": "quack",
          "sources": [
            {
              "mimeType": "audio/ogg",
              "bufferView": 3
            },
            {
              "mimeType": "audio/wav",
              "bufferView": 4
            },
            {
              "mimeType": "audio/mpeg",
              "bufferView": 5
            }
          ]
        }
      ],
      "audioEmitters": [
        {
          "name": "environment emitter",
          "type": "global",
          "volume": 1,
          "loop": true,
          "autoPlay": true,
          "muted": false,
          "clip": 0
        },
        {
          "name": "duck emitter",
          "type": "positional",
          "volume": 0.8,
          "loop": false,
          "autoPlay": false,
          "muted": false,
          "clip": 1,
          "coneInnerAngle": 360,
          "coneOuterAngle": 360,
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