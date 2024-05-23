# OMI glTF Extensions

This repository is used by the [Open Metaverse Interoperability Group](https://omigroup.org/) to develop and document extensions for the [glTF 3D model format](https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md).

Extensions in this repository are intended to extend the glTF format with features useful for 3D virtual worlds. These extensions could include things related audio, physics, avatars, animations, behaviors, and more.

Vendor extensions are developed and approved via the W3C Metaverse Interoperability Community Group [process](https://github.com/omigroup/OMI/blob/main/PROCESS.md). Our intentions are to create OMI specific vendor extensions, but common extensions that make sense within the greater glTF community may be proposed to the Khronos 3D Formats Working Group at a later date. Our goal with this repository is to prototype and standardize extensions useful for the portability of 3D metaverse media.

## Meetings

OMI's glTF extensions subgroup weekly meetings take place each week on Thursday in the omi-weekly-meeting channel on the [OMI Discord](https://discord.gg/J4vyAWFgkj).

This is the time to chat about glTF extensions with OMI, including those developed by OMI and those developed by other groups. You can find the weekly notes and agenda [here](https://github.com/omigroup/gltf-extensions/discussions).

These meetings take place at 22:30 UTC in the winter (2:30 PM PST) and 21:30 UTC in the summer (2:30 PM PDT).

You can add these meetings to your calendar [here](https://calendar.google.com/calendar/u/1?cid=Y18wZHB1Z2Y5ZjgzZXE0cWVrbWI2b21xYmptZ0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t).

## Working agreement

Our sub-group has drafted a working agreement that highlights who we are, our purpose, how we communicate, and when we meet. Working agreements are living documents meant to be revisited and revised as needed. To view our working agreement, please visit this [figjam by figma file](https://www.figma.com/file/ns8eBTPfq330lZR3DfsOvD/OMI-gLTFgroup-WorkingAgreement?node-id=0%3A1)

## glTF Working Group Mission

We aim to create an ecosystem of specifications and tooling for accessible creation and use of durable and portable 3D content.

## OMI glTF Working Group Process

OMI uses 5 stages to represent the maturity of an extension:

### Stage 1

A draft proposal has been submitted to the working group and is receiving feedback. It must have at least one "champion" who are responsible for advancing the proposal to the further stages. At this stage a high-level outline of the extension should be published as a GitHub Pull Request to this repository. The champion(s) should be focused on describing why this extension should be developed further and they should be working on finding additional stakeholders. The [W3C Community Contributor License Agreement](https://www.w3.org/community/about/process/cla/) must be signed by all contributors before the proposal can enter Stage 1.

#### Requirements

- [ ] High level outline published as a GitHub PR in this repository
- [ ] [Signed W3C CLA](https://www.w3.org/community/about/process/cla/)

### Stage 2

The draft proposal should precisely describe the extension in it's initial form and there should be at least one metaverse implementation of the extension in development and valid sample assets for testing by other potential implementors. The proposal should contain valid a JSON schema describing the extension in its entirety as well as a markdown document explaining the purpose, features, and properties of the extension. This implementation will be used to test the viability of the extension and provide an example for other implementors. Edits to the extension should be voted on and decided by consensus in weekly OMI glTF Working Group meetings.

#### Requirements

- [ ] Previous requirements from Stage 1
- [ ] One metaverse implementation of the extension in development.
- [ ] Valid and publicly acessible sample assets
- [ ] Valid JSON schema describing the extension in its entirety
- [ ] Markdown document explaining the purpose, features, and properties of the extension

### Stage 3

The extension has multiple metaverse implementations, a glTF Validator implementation, valid sample assets, and at least one readily available tool for generating content using this extension. The implementations, sample assets, and content creation tool should all consume or produce assets that can be verified by the glTF Validator. The extension at this stage is ready for a vote for ratification. Final proposal modifications should be voted on and decided by consensus in weekly OMI glTF Working Group meetings.

#### Requirements

- [ ] Previous requirements from Stage 2
- [ ] Two or more metaverse implementations
- [ ] glTF Validator implementation
- [ ] Publicly availible content creation tool for generating assets for this extension
- [ ] All implementations, sample assets, and content creation tools should consume or produce assets that pass validation.

### Stage 4

The extension has been ratified. It has multiple metaverse implementations, a glTF Validator implementation, valid sample assets, and at least one readily available tool for generating content using this extension. Once ratified, non-substantive changes to a specification via a consensus vote. However, breaking changes to an extension are not allowed and should be addressed by creating a proposal for a new extension with a different extension identifier.

#### Requirements

- [ ] Previous requirements from Stage 3
- [ ] The extension has passed a consensus vote for ratification.

### Stage 5

The extension has been submitted and merged as an OMI vendor extension. Alternately, if the extension is intended to be used outside the scope of OMI, it can be submitted and ratified as a KHR or EXT extension. The extension must be published to the [Khronos 3D Formats Working Group](https://github.com/KhronosGroup/glTF) repository to enter stage 5.

#### Requirements

- [ ] Previous requirements from Stage 4
- [ ] Listing on the [Khronos glTF repository](https://github.com/KhronosGroup/glTF/tree/main/extensions) proving the extension has been approved or ratified.

## OMI glTF Vendor Extensions

### Stage 0

### Stage 1

- [OMI_link](extensions/2.0/OMI_link)
- [OMI_personality](extensions/2.0/OMI_personality)
- [OMI_physics_body](extensions/2.0/OMI_physics_body/README.md)
- [OMI_physics_gravity](extensions/2.0/OMI_physics_gravity/README.md)
- [OMI_physics_joint](extensions/2.0/OMI_physics_joint/README.md)
- [OMI_physics_shape](extensions/2.0/OMI_physics_shape/README.md)
- [OMI_spawn_point](extensions/2.0/OMI_spawn_point)

### Stage 2

- [OMI_seat](extensions/2.0/OMI_seat/README.md)

### Stage 3

### Stage 4

### Stage 5

### Graduated to Khronos Extension

- [KHR_audio_emitter](https://github.com/KhronosGroup/glTF/pull/2137)

### Archived Extensions

- [OMI_collider](extensions/2.0/Archived/OMI_collider): Superseded by [OMI_physics_shape](extensions/2.0/OMI_physics_shape)

### Extension Support Table

<table>
  <thead>
    <tr>
      <th>Extension</th>
      <th>Stage</th>
      <th>glTF Validator</th>
      <th>Blender</th>
      <th>&nbsp;</th>
      <th>Three.js</th>
      <th>&nbsp;</th>
      <th>Godot</th>
      <th>&nbsp;</th>
      <th>Unity</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Third Room</th>
      <th>3OV</th>
    </tr>
    <tr>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
      <th>Import</th>
      <th>Export</th>
      <th>Loader</th>
      <th>Exporter</th>
      <th>Import</th>
      <th>Export</th>
      <th>Runtime Import</th>
      <th>Runtime Export</th>
      <th>Editor Import</th>
      <th>Editor Export</th>
      <th>&nbsp;</th>
      <th>&nbsp;</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <a href="https://github.com/KhronosGroup/glTF/pull/2137">
          KHR_audio_emitter
        </a>
      </td>
      <td>KHR</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://thirdroom.io/docs/gltf/">🚧🏆</a></td>
      <td>❌</td>
      <td><a href="https://github.com/godotengine/godot/pull/88204">🚧🏆</a></td>
      <td><a href="https://github.com/godotengine/godot/pull/88204">🚧🏆</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/matrix-org/thirdroom/blob/main/src/asset-pipeline/extensions/KHRAudioExtension.ts">🚧🏆</a></td>
      <td><a href="https://wordpress.org/plugins/three-object-viewer/">🚧🏆</a></td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_link">
          OMI_link
        </a>
      </td>
      <td>Stage 1</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_personality">
          OMI_personality
        </a>
      </td>
      <td>Stage 1</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_physics_body">
          OMI_physics_body
        </a>
      </td>
      <td>Stage 1</td>
      <td><a href="https://github.com/omigroup/glTF-Validator/pull/2">❌</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/godotengine/godot/pull/78967">✅🏆</a></td>
      <td><a href="https://github.com/godotengine/godot/pull/78967">✅🏆</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_physics_gravity">
          OMI_physics_gravity
        </a>
      </td>
      <td>Stage 1</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/omigroup/omi-godot/pull/5">🚧🧩</a></td>
      <td><a href="https://github.com/omigroup/omi-godot/pull/5">🚧🧩</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/omi_physics_joint">
          OMI_physics_joint
        </a>
      </td>
      <td>Stage 1</td>
      <td><a href="https://github.com/omigroup/glTF-Validator/pull/3">❌</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/omigroup/omi-godot/tree/main/addons/omi_extensions/physics_joint">✅🧩</a></td>
      <td><a href="https://github.com/omigroup/omi-godot/tree/main/addons/omi_extensions/physics_joint">✅🧩</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_physics_shape">
          OMI_physics_shape
        </a>
      </td>
      <td>Stage 1</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/godotengine/godot/pull/78967">✅🏆</a></td>
      <td><a href="https://github.com/godotengine/godot/pull/78967">✅🏆</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_seat">
          OMI_seat
        </a>
      </td>
      <td>Stage 2</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/omigroup/omi-godot/blob/main/addons/omi_extensions/misc/omi_seat.gd">✅🧩</a></td>
      <td><a href="https://github.com/omigroup/omi-godot/blob/main/addons/omi_extensions/misc/omi_seat.gd">🚧🧩</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
    </tr>
    <tr>
      <td>
        <a href="https://github.com/omigroup/gltf-extensions/tree/main/extensions/2.0/OMI_spawn_point">
          OMI_spawn_point
        </a>
      </td>
      <td>Stage 1</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://github.com/omigroup/omi-godot/blob/main/addons/omi_extensions/misc/omi_spawn_point.gd">✅🧩</a></td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td>❌</td>
      <td><a href="https://wordpress.org/plugins/three-object-viewer/">✅🏆</a></td>
    </tr>
  </tbody>
</table>

Emoji Key:

- ✅ = Done, available and ready to use.
- 🏆 = Available directly in the engine.
- 🧩 = Available as a plugin / add-on.
- 🚧 = Work in progress or not yet merged.
- ❌ = Not available or not started.
