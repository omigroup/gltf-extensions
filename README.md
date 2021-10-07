# OMI glTF Extensions

This repository is used by the [Open Metaverse Interoperability Group](https://github.com/omigroup/OMI) to develop and document extensions for the [glTF 3D transmission format](https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md).

Extensions in this repository are intended to extend the glTF format with features useful for 3D virtual worlds. These extensions could include things related audio, physics, avatars, animations, behaviors, and more.

Vendor extensions are developed and approved via the W3C Metaverse Interoperability Community Group [process](https://github.com/omigroup/OMI/blob/main/PROCESS.md). Our intentions are to create OMI specific vendor extensions, but common extensions that make sense within the greater glTF community may be proposed to the Khronos 3D Formats Working Group at a later date. Our goal with this repository is to prototype and standardize extensions useful for the portability of 3D metaverse media.

## Meetings

Our next meeting is on Thursday July 29th at 2:30 PM PDT in the [AngellXR Discord](https://discord.gg/NJtT9grz5E)

You can add these meetings to your calendar [here](https://calendar.google.com/calendar/u/1?cid=Y18wZHB1Z2Y5ZjgzZXE0cWVrbWI2b21xYmptZ0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t).

## Working agreement 

Our sub-group has drafted a working agreement that highlights who we are, our purpose, how we communicate, and when we meet. Working agreements are living documents meant to be revisited and revised as needed. To view our working agreement, please visit this [figjam by figma file](https://www.figma.com/file/ns8eBTPfq330lZR3DfsOvD/OMI-gLTFgroup-WorkingAgreement?node-id=0%3A1)

## glTF Working Group Mission

We aim to create an ecosystem of specifications and tooling for accessible creation and use of durable and portable 3D content.

## OMI glTF Working Group Process

OMI uses 4 stages to represent the maturity of an extension:

### Stage 1

A draft proposal has been submitted to the working group and is receiving feedback. It must have at least one "champion" who are responsible for advancing the proposal to the further stages. At this stage a high-level outline of the extension should be published as a GitHub Pull Request to this repository. The champion(s) should be focused on describing why this extension should be developed further and they should be working on finding additional stakeholders.

### Stage 2

The draft proposal should precisely describe the extension in it's initial form and there should be at least one metaverse implementation of the extension in development and valid sample assets for testing by other potential implementors. This implementation will be used to test the viability of the extension and provide an example for other implementors. Edits to the extension should be voted on and decided by consensus in weekly OMI glTF Working Group meetings.

### Stage 3

The extension has multiple metaverse implementations, a glTF Validator implementation, valid sample assets, and at least one readily available tool for generating content using this extension. The extension at this stage is ready for a vote for ratification. Final modifications should be voted on and decided by consensus in weekly OMI glTF Working Group meetings.

### Stage 4

The extension has been ratified. It has multiple metaverse implementations, a glTF Validator implementation, valid sample assets, and at least one readily available tool for generating content using this extension.

## OMI glTF Vendor Extensions

### Stage 1

### Stage 2
- [OMI_audio_emitter](https://github.com/omigroup/gltf-extensions/pull/1)

### Stage 3

### Stage 4

### Extension Support Table

<table>
  <thead>
    <tr>
      <th>Extension</th>
      <th>Stage</th>
      <th>Validation</th>
      <th>Content Authoring Tools</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Game / Rendering Engines</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Applications / Metaverse Clients</th>
    </tr>
    <tr>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>glTF Validator</th>
      <th>Blender</th>
      <th>&nbsp;</th>
      <th>omi-gltf-transform</th>
      <th>Three.js</th>
      <th>&nbsp;</th>
      <th>Godot</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Unity</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Third Room</th>
    </tr>
    <tr>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Import</th>
      <th>Export</th>
      <th>MOZ_hubs_components -> OMI</th>
      <th>Loader</th>
      <th>Exporter</th>
      <th>Runtime Import</th>
      <th>Runtime Export</th>
      <th>Editor Import</th>
      <th>Editor Export</th>
      <th>Runtime Import</th>
      <th>Runtime Export</th>
      <th>Editor Import</th>
      <th>Editor Export</th>
      <th>&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/pull/1">
          OMI_audio_emitter
        </a>
      </td>
      <td>Stage 2</td>
      <td>✅</td>
      <td>🚧</td>
      <td>🚧</td>
      <td>✅</td>
      <td>✅</td>
      <td>❌</td>
      <td>❓</td>
      <td>❓</td>
      <td>❓</td>
      <td>❓</td>
      <td>❓</td>
      <td>❓</td>
      <td>❓</td>
      <td>❓</td>
      <td>🚧</td>
    </tr>
  </tbody>
</table>
