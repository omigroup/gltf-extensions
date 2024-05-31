# OMI_audio_ogg_vorbis

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows glTF models to use Ogg Vorbis as a valid audio data format. A client that does not implement this extension can ignore the provided Ogg Vorbis audio data and continue to rely on the MP3 audio available in the base KHR_audio_emitter specification, if any. Defining fallback audio data is optional. The [best practices](#best-practices) section describes the intended use case of this extension and the expected behavior when using it without fallback audio data.

Ogg Vorbis is a free and open-source lossy audio compression format. It is widely used in video games and other applications that require high-quality audio with a small file size. It has similar use cases to MP3, but is more efficient, with a higher quality for the same file size, or a smaller file size for the same quality.

## glTF Schema Updates

The `OMI_audio_ogg_vorbis` extension can be added to the extensions of an object in the `"sources"` array inside of `KHR_audio_emitter`. and specifies an `audio` property that points to the index of an object in the `"audio"` array which in turn points to the Ogg Vorbis audio data.

The following glTF will load `music.ogg` in clients that support this extension, and otherwise fall back to `music.mp3`. Note that this example excludes other properties typically found on an item in `"sources"`, such as the name or gain.

```json
"KHR_audio_emitter": {
    "sources": [
        {
            "audio": 0,
            "extensions": {
                "OMI_audio_ogg_vorbis": {
                    "audio": 1
                }
            }
        }
    ],
    "audio": [
        {
            "uri": "music.mp3"
        },
        {
            "uri": "music.ogg"
        }
    ]
}
```

When defined with a `uri` and no `mimeType`, the file extension of the audio data MUST be `.ogg`. The `.oga` file extension MUST NOT be used for Vorbis audio data. Although most audio in the Ogg container shares the same MIME type, Vorbis and Speex have been grandfathered in to use `.ogg` as the file extension, while other audio codecs in the Ogg container may use `.oga` or another file extension.

Audio data can also be stored in a buffer, such as in the glTF Binary (.glb) format. When stored here, the item in the "audio" MUST have a `mimeType` set to `audio/ogg`.

```json
"KHR_audio_emitter": {
    "sources": [
        {
            "audio": 0,
            "extensions": {
                "OMI_audio_ogg_vorbis": {
                    "audio": 1
                }
            }
        }
    ],
    "audio": [
        {
            "mimeType": "audio/mpeg",
            "bufferView": 1
        },
        {
            "mimeType": "audio/ogg",
            "bufferView": 2
        }
    ]
}
```

### JSON Schema

[KHR_audio_emitter.source.OMI_audio_ogg_vorbis.schema.json](schema/KHR_audio_emitter.source.OMI_audio_ogg_vorbis.schema.json)

## Best Practices

Ogg Vorbis has similar use cases to MP3. Both are lossy audio compression formats that are widely supported. Ogg Vorbis should be preferred to MP3 when delivering audio data to clients that support loading Ogg Vorbis audio data from `OMI_audio_ogg_vorbis`.

Since Ogg Vorbis is not a part of the base KHR_audio_emitter spec, it is recommended to provide an MP3 fallback for clients that do not support this extension. The fallback audio data would typically be of lower quality than the corresponding Ogg Vorbis audio data, such that the total file size of both files is lower than the full quality audio saved as MP3, otherwise it would defeat the purpose of using Ogg Vorbis to reduce file size.

When fallback audio data is defined, this extension should not be present in `extensionsRequired`. This will allow clients that support `KHR_audio_emitter` but not `OMI_audio_ogg_vorbis` to play the fallback audio data.

### Using Without a Fallback

To use Ogg Vorbis audio data without a fallback, define `OMI_audio_ogg_vorbis` in `extensionsUsed`, and if `KHR_audio_emitter` is a required extension, define `OMI_audio_ogg_vorbis` in `extensionsRequired` as well. The item in the `"sources"` array will then not have an `audio` property, and instead have an `extensions` property to define the audio data as shown below.

```json
"KHR_audio_emitter": {
    "sources": [
        {
            "extensions": {
                "OMI_audio_ogg_vorbis": {
                    "audio": 0
                }
            }
        }
    ],
    "audio": [
        {
            "uri": "music.ogg"
        }
    ]
}
```

If a glTF contains an audio source using Ogg Vorbis audio with no fallback audio data, and `KHR_audio_emitter` is a required extension, then `OMI_audio_ogg_vorbis` should be added to the `extensionsRequired` array, such that clients that do not support Ogg Vorbis will not attempt to load the file. This ensures that glTF files which require audio playback will also require the ability to load Ogg Vorbis audio data to be played.

If a glTF contains an audio source using Ogg Vorbis audio with no fallback audio data, and `KHR_audio_emitter` is not a required extension, then do not add `OMI_audio_ogg_vorbis` to `extensionsRequired`. Clients supporting `KHR_audio_emitter` but not `OMI_audio_ogg_vorbis` will consider the lack of `"audio"` in a `KHR_audio_emitter` source to be an error, and either will not be able to play audio from that source, or will not load the `KHR_audio_emitter` extension.

## Known Implementations

None

## Resources

- https://wiki.xiph.org/Vorbis
- https://wiki.xiph.org/MIME_Types_and_File_Extensions
