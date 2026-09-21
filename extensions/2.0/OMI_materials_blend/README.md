# OMI_materials_blend

## Contributors

- Aaron Franke, Godot Engine.
- Andy Baker, Icosa Foundation.

## Status

Open Metaverse Interoperability Group Draft Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows glTF materials to have more alpha blending modes, which can control the transparency and background composability of the material. The `OMI_materials_blend` extension may be used alongside the base glTF PBR materials, or materials defined in glTF extensions. When combined with other materials and techniques, blending may be used to achieve effects like fire, steam, or holograms.

A client that does not implement this extension can ignore the provided material blending settings and use the base glTF material blending settings. When the base glTF alpha blend mode is an acceptable fallback, this extension should not be present in `extensionsRequired`. This will allow clients that do not `OMI_materials_blend` to display the model with the base glTF transparency settings.

## glTF Schema Updates

The `OMI_materials_blend` extension can be added to the extensions of an object in the glTF document-level `"materials"` array.

The following example defines a fire material using the `"ADD"` alpha blend mode. It has a fallback of `"MASK"` so that clients without support for `OMI_materials_blend` will see a cutout instead.

```json
{
    "materials": [
        {
            "alphaMode": "MASK",
            "alphaCutoff": 0.25,
            "doubleSided": true,
            "extensions": {
                "OMI_materials_blend": {
                    "alphaMode": "ADD"
                }
            },
            "name": "Fire"
        }
    ]
}
```

### Property Summary

|                     | Type      | Description                                                            | Default value                   |
| ------------------- | --------- | ---------------------------------------------------------------------- | ------------------------------- |
| **alphaMode**       | `string`  | The alpha blend mode to use. Override for the base glTF `"alphaMode"`. | Use glTF material `"alphaMode"` |
| **alwaysUseCutoff** | `boolean` | If true, always use the glTF `"alphaCutoff"` as a clip mask.           | false                           |

### Alpha Mode

The `"alphaMode"` property is a lowercase string that defines how the material should be blended with the background. This value must be specified, there is no default value. This overrides the base glTF material's `"alphaMode"` property.

The following values are allowed: `"BLEND"`, `"HASH"`, `"PREMULT"`, `"MULTIPLY"`, `"ADD"`, `"SUBTRACT"`, `"REV_SUBTRACT"`, `"MAX"`, `"MIN"`.

- The `"BLEND"` mode is the same as the base glTF `"BLEND"` mode, which exists to allow for using the `"alwaysUseCutoff"` property with `"BLEND"`. Meaning, if this extension is supported, `"BLEND"` with `"alwaysUseCutoff": true` will have the behavior of base glTF `"BLEND"` and `"MASK"`, both at the same time.
- The other modes are new and are not present in the base glTF specification.

The following table lists the alpha blend modes added by this extension along with the base glTF alpha blend modes and the corresponding modes in various engines.

| glTF                     | Unity               | Unreal          | Godot                    | Blender                 | OpenGL                   | Three.JS                | WebGPU             |
| ------------------------ | ------------------- | --------------- | ------------------------ | ----------------------- | ------------------------ | ----------------------- | ------------------ |
| Base glTF "OPAQUE"       | Opaque              | Opaque          | DISABLED                 | Dithered without socket |                          |                         |                    |
| Base glTF "MASK"         | Alpha Clipping      | Masked          | ALPHA_SCISSOR            | Dithered with socket    |                          |                         |                    |
| Base glTF "BLEND"        | Alpha Blend         | Translucent     | ALPHA_DEPTH_PRE_PASS     | Blended                 |                          |                         |                    |
| Extension "HASH"         | Not supported       | Not supported   | ALPHA_HASH               |                         |                          |                         |                    |
| Extension "PREMULT"      | Premultiplied Alpha | Alpha Composite | BLEND_MODE_PREMULT_ALPHA |                         |                          |                         |                    |
| Extension "MULTIPLY"     | Multiplicative      | Modulate        | BLEND_MODE_MUL           | Multiplicative Setup    |                          |                         |                    |
| Extension "ADD"          | Additive            | Additive        | BLEND_MODE_ADD           | Additive Setup          | GL_FUNC_ADD              | AddEquation             | "add"              |
| Extension "SUBTRACT"     |                     |                 | BLEND_MODE_SUB           |                         | GL_FUNC_SUBTRACT         | SubtractEquation        | "subtract"         |
| Extension "REV_SUBTRACT" |                     |                 | Not supported            |                         | GL_FUNC_REVERSE_SUBTRACT | ReverseSubtractEquation | "reverse-subtract" |
| Extension "MAX"          |                     |                 | Not supported            |                         | GL_MAX                   | MaxEquation             | "max"              |
| Extension "MIN"          |                     |                 | Not supported            |                         | GL_MIN                   | MinEquation             | "min"              |

The behavior of each mode is as follows:

| Name           | Description                                                                                                                        |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| "OPAQUE"       | Fully opaque, not transparent. The alpha value is ignored. Default and fastest to render.                                          |
| "MASK"         | The rendered output is either fully opaque or fully transparent depending on the alpha value and the specified alpha cutoff value. |
| "BLEND"        | The rendered output is combined with the background using the "over" operator as described by the base glTF specification.         |
| "HASH"         | Useful for hair rendering. Cuts off all values below a spatially-deterministic threshold, the rest will remain opaque.             |
| "PREMULT"      | Similar to "BLEND" expect the source fragment is assumed to have already been multiplied by the source alpha value.                |
| "MULTIPLY"     | The color of the object is multiplied by the background.                                                                           |
| "ADD"          | The color of the object is added to the background.                                                                                |
| "SUBTRACT"     | The color of the object is subtracted from the background.                                                                         |
| "REV_SUBTRACT" | The color of the background is subtracted from the object.                                                                         |
| "MAX"          | The maximum of the object color and the background color is used.                                                                  |
| "MIN"          | The minimum of the object color and the background color is used.                                                                  |

The most common and important new mode added by this extension, not including ones in the base glTF specification, is the `"ADD"` alpha blend mode. This mode is used for many effects, and is highly recommended to be supported by implementations, or else most `OMI_materials_blend` materials will not render correctly.

### Always Use Cutoff

The `"alwaysUseCutoff"` property is a boolean that defines whether the glTF `"alphaCutoff"` should always be used as a clip mask. This property is optional and defaults to `false`.

The base glTF specification uses the `"alphaCutoff"` property only when the `"alphaMode"` is set to `"MASK"`. However, there is no way to use both `"BLEND"` and a clip mask at the same time. This extension allows for using both at the same time, by setting `"alphaMode"` to `"BLEND"` and `"alwaysUseCutoff"` to `true`. The `"alwaysUseCutoff"` property MUST NOT be set when this extension's `"alphaMode"` is not set and the base glTF specification's `"alphaMode"` is `"OPAQUE"` or `"MASK"` to avoid redundancy with the way the base glTF specification handles these modes.

When `"alwaysUseCutoff"` is true, alpha values below the `"alphaCutoff"` value will be treated as fully transparent, and alpha values above the `"alphaCutoff"` value will be treated as the selected alpha mode (ex: `"BLEND"`, `"ADD"`, etc).

### glTF Object Model

This extension defines no properties that can be read or manipulated by the glTF Object Model.

### JSON Schema

See [schema/material.OMI_materials_blend.schema.json](schema/material.OMI_materials_blend.schema.json) for the schema.

## Known Implementations

None

## Resources

- Khronos glTF Alpha Coverage https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#alpha-coverage
- Khronos OpenGL blend equations https://www.khronos.org/opengl/wiki/Blending#Blend_Equations
- ICOSA UnityGLTF transparency discussion https://github.com/icosa-mirror/UnityGLTF/issues/1
- Unity blend shader command https://docs.unity3d.com/Manual/SL-Blend.html
- Unreal material blend modes https://dev.epicgames.com/documentation/en-us/unreal-engine/material-blend-modes-in-unreal-engine#alphaholdout
- Godot BaseMaterial3D transparency https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html#enum-basematerial3d-transparency
- Godot BaseMaterial3D blend mode https://docs.godotengine.org/en/stable/classes/class_basematerial3d.html#enum-basematerial3d-blendmode
- Three.JS blending equations https://threejs.org/docs/#api/en/constants/CustomBlendingEquations
- Visual glBlendEquation tool https://www.andersriggelsen.dk/glblendfunc.php
