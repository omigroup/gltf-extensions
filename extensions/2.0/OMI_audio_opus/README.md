# OMI_audio_opus

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows glTF models to use Opus as a valid audio codec. A client that does not implement this extension can ignore the provided Opus audio data and continue to rely on the MP3 audio available in the base KHR_audio_emitter specification, if any. Defining fallback audio data is optional. The [best practices](#best-practices) section describes the intended use case of this extension and the expected behavior when using it without fallback audio data.

Opus codec audio is a free and open source lossy audio codec. It is widely used in modern websites and other Internet applications, but does not have widespread support in popular game engines. It is proposed as an IETF standard as defined by IETF RFC 6716. Opus superior format to MP3 and Ogg Vorbis, and it is suitable for many use cases traditionally suitable to WAV audio. Opus is a lossy audio codec that is more efficient than MP3 and Ogg Vorbis, with a higher quality for the same file size, or a smaller file size for the same quality.

The `OMI_audio_opus` extension allows the Opus audio data to be stored in either the Ogg container format or the WebM container format. This is done to minimize friction depending on the desired target platform. The Ogg container format is the de facto file format for Opus, it uses the `.opus` file extension and the `audio/opus` MIME type. The WebM container format is more commonly supported in web browsers such as Safari, it uses the `.webm` file extension and the `audio/webm` MIME type (or `video/webm` if the file contains video data, which is expected to be ignored by audio emitters). Implementations should be able to handle both formats, but may more efficiently support one format over the other. For example, in a web game targeting Safari, its own assets should be in the WebM container format, while if that same game encounters a user-provided glTF asset using Ogg Opus audio, the game may need to convert the audio to WebM Opus before playing it in Safari. The same may happen in reverse, if an app only supports Ogg Opus, it should prefer Ogg Opus for its own assets, and may need to convert WebM Opus to Ogg Opus before playing it. Additionally, WebM allows for videos, which allows the audio from a video file to be used in an audio emitter, while the video data may be used by another extension.

## glTF Schema Updates

The `OMI_audio_opus` extension can be added to the extensions of an object in the `"sources"` array inside of `KHR_audio_emitter`. and specifies an `audio` property that points to the index of an object in the `"audio"` array which in turn points to the Opus audio data.

The following glTF will load `music.opus` in clients that support this extension, and otherwise fall back to `music.mp3`. Note that this example excludes other properties typically found on an item in `"sources"`, such as the name or gain.

```json
"KHR_audio_emitter": {
    "sources": [
        {
            "audio": 0,
            "extensions": {
                "OMI_audio_opus": {
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
            "uri": "music.opus"
        }
    ]
}
```

When defined with a `uri` and no `mimeType`, the file extension of the audio data MUST be `.opus` when using the Ogg container format, or MUST be `.webm` when using the WebM container format. The `.oga` or `.ogg` file extensions MUST NOT be used for Opus codec audio data. Although most audio in the Ogg container shares the same MIME type, Opus uses `.opus` as the file extension, while other audio codecs in the Ogg container may use `.oga` or `.ogg` or another file extension.

Audio data can also be stored in a buffer, such as in the glTF Binary (.glb) format. When stored here, the item in the "audio" MUST have a `mimeType` set to `audio/opus` when using the Ogg container format (see proposed IETF RFC 7587 for IANA), or `audio/webm` or `video/webm` when using the WebM container format. If a WebM contains only audio data, then `audio/webm` should be used. If a WebM contains video data, then `video/webm` should be used, and the video data is expected to be ignored when playing the audio from a `KHR_audio_emitter` source extended with `OMI_audio_opus` with this data.

```json
"KHR_audio_emitter": {
    "sources": [
        {
            "audio": 0,
            "extensions": {
                "OMI_audio_opus": {
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
            "mimeType": "audio/opus",
            "bufferView": 2
        }
    ]
}
```

### JSON Schema

[KHR_audio_emitter.source.OMI_audio_opus.schema.json](schema/KHR_audio_emitter.source.OMI_audio_opus.schema.json)

## Best Practices

Opus codec audio is a superior format to MP3 and Ogg Vorbis for their intended use cases, and it is suitable for many use cases traditionally suitable to WAV audio. Opus is a lossy audio codec that is more efficient than MP3 and Ogg Vorbis, with a higher quality for the same file size, or a smaller file size for the same quality.

Opus is designed to be used either for long-term audio storage or streaming audio over the internet. Opus has a low decode time, with a low latency, making it suitable for time-sensitive audio playback such as short sound effects in video games, therefore it can be used in place of WAV audio when lossy audio is acceptable. See the Wikipedia chart comparing Opus to other audio codecs.

If making a comparison to image formats, Opus is to audio as WebP is to images. It is a modern, efficient, and high-quality format that is superior to older formats, but has less support in popular software.

Since Opus is not a part of the base KHR_audio_emitter spec, it is recommended to provide an MP3 or WAV fallback for clients that do not support this extension. Prefer using an MP3 fallback for music or a WAV fallback for short sound effects. The fallback audio data would typically be of lower quality than the corresponding Opus audio data, such that the total file size of both files is lower than the full quality audio saved as MP3 or WAV, otherwise it would defeat the purpose of using Opus to reduce file size.

When fallback audio data is defined, this extension should not be present in `extensionsRequired`. This will allow clients that support `KHR_audio_emitter` but not `OMI_audio_opus` to play the fallback audio data.

### Using Without a Fallback

To use Opus audio data without a fallback, define `OMI_audio_opus` in `extensionsUsed`, and if `KHR_audio_emitter` is a required extension, define `OMI_audio_opus` in `extensionsRequired` as well. The item in the `"sources"` array will then not have an `audio` property, and instead have an `extensions` property to define the audio data as shown below.

```json
"KHR_audio_emitter": {
    "sources": [
        {
            "extensions": {
                "OMI_audio_opus": {
                    "audio": 0
                }
            }
        }
    ],
    "audio": [
        {
            "uri": "music.opus"
        }
    ]
}
```

If a glTF contains an audio source using Opus audio with no fallback audio data, and `KHR_audio_emitter` is a required extension, then `OMI_audio_opus` should be added to the `extensionsRequired` array, such that clients that do not support Opus will not attempt to load the file. This ensures that glTF files which require audio playback will also require the ability to load Opus audio data to be played.

If a glTF contains an audio source using Opus audio with no fallback audio data, and `KHR_audio_emitter` is not a required extension, then do not add `OMI_audio_opus` to `extensionsRequired`. Clients supporting `KHR_audio_emitter` but not `OMI_audio_opus` will consider the lack of `"audio"` in a `KHR_audio_emitter` source to be an error, and either will not be able to play audio from that source, or will not load the `KHR_audio_emitter` extension.

### JSON Schema

See [schema/glTF.KHR_audio_emitter.source.OMI_audio_opus.schema.json](schema/glTF.KHR_audio_emitter.source.OMI_audio_opus.schema.json) for the schema.

## Known Implementations

None

## Resources

- https://wiki.xiph.org/OpusFAQ
- https://datatracker.ietf.org/doc/html/rfc6716
- https://datatracker.ietf.org/doc/html/rfc7587#section-6.1
- https://commons.wikimedia.org/wiki/File:Opus_bitrate%2Blatency_comparison.png
- https://www.webmproject.org/docs/container/
