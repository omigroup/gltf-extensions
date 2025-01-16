# OMI_environment_sky

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Draft Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows defining the skybox of a glTF asset, and how the sky provides environment lighting. The sky can be a gradient, panorama, physical sky, or plain sky. The sky can be used to light the scene, provide a background, or both. To add suns to the sky, use the `KHR_lights_punctual` extension to define directional lights.

### Example:

This example defines a panorama sky with an equirectangular texture. It is a subset of [examples/epic_blue_sunset_equirectangular.gltf](examples/epic_blue_sunset_equirectangular.gltf):

```json
{
    "extensions": {
        "OMI_environment_sky": {
            "panorama": {
                "equirectangular": 0
            },
            "type": "panorama"
        }
    },
    "images": [
        {
            "mimeType": "image/jpeg",
            "name": "allskyfree_epic_blue_sunset",
            "uri": "epic_blue_sunset/allskyfree_epic_blue_sunset.jpg"
        }
    ],
    "textures": [{ "source": 0 }]
}
```

This example defines a gradient sky, black all around, with a red dwarf star huge in the sky thanks to the sun curve and a red directional light. It is a subset of [examples/space_black_gradient.gltf](examples/space_black_gradient.gltf):

```json
{
    "extensions": {
        "KHR_lights_punctual": {
            "lights": [
                {
                    "color": [1, 0.05, 0.05],
                    "intensity": 0.5,
                    "type": "directional"
                }
            ]
        },
        "OMI_environment_sky": {
            "gradient": {
                "bottomColor": [0.01, 0.01, 0.01],
                "horizonColor": [0.01, 0.01, 0.01],
                "sunAngleMax": 0.25,
                "sunCurve": 4,
                "topColor": [0.01, 0.01, 0.01]
            },
            "type": "gradient"
        }
    },
    "extensionsUsed": ["KHR_lights_punctual", "OMI_environment_sky"],
    "nodes": [
        {
            "extensions": { "KHR_lights_punctual": { "light": 0 } },
            "name": "SunDimRed",
            "rotation": [-0.129410669207573, 0.836515367031097, 0.482963532209396, 0.22414530813694]
        }
    ],
    "scene": 0,
    "scenes": [{ "nodes": [0] }]
}
```

More example assets can be found in the [examples/](examples/) folder.

## glTF Schema Updates

This extension consists of one new data structure for defining the environment sky, `"OMI_environment_sky"`. The key `"OMI_environment_sky"` can be added to the document-level `"extensions"` to define the environment sky of the glTF asset.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

### Property Summary

|                            | Type        | Description                                                                             | Default value        |
| -------------------------- | ----------- | --------------------------------------------------------------------------------------- | -------------------- |
| **ambientLightColor**      | `number[3]` | The color of the ambient light, if sky contribution is less than 1.0.                   | `[0.0, 0.0, 0.0]`    |
| **ambientSkyContribution** | `number`    | The ratio of contribution the sky makes to the ambient light.                           | 1.0                  |
| **type**                   | `string`    | The type of sky as a string (`"gradient"`, `"panorama"`, `"physical"`, `"plain"`). | Required, no default |
| **gradient**               | `object`    | If the type is `"gradient"`, the gradient sky properties.                               | `null`               |
| **panorama**               | `object`    | If the type is `"panorama"`, the panorama sky properties.                               | `null`               |
| **physical**               | `object`    | If the type is `"physical"`, the physical sky properties.                               | `null`               |
| **plain**             | `object`    | If the type is `"plain"`, the plain color sky properties.                          | `null`               |

#### Ambient Light Color

The `"ambientLightColor"` property is an array of three numbers that defines the color of the ambient light. The default value is `[0.0, 0.0, 0.0]`, which is black.

This only has an effect if the `"ambientSkyContribution"` is less than 1.0. The ambient color may have values greater than 1.0, which indicate high energy, HDR, or overbright ambient light, but usually, the values are between 0.0 and 1.0.

#### Ambient Sky Contribution

The `"ambientSkyContribution"` property is a number that defines the ratio of contribution between the ambient color and the sky color. The default value is 1.0, which means that the ambient color is the same as the sky color.

Valid values are on a range of 0.0 to 1.0, inclusive. A value of 0.0 means that all ambient light is the ambient color, and no sky color is added. A value of 1.0 means that all ambient light is the sky color, and the `"ambientLightColor"` property is ignored. A value between 0.0 and 1.0 is a mix of the two colors. Unity only supports 0.0 and 1.0, while Godot supports the full range of values in-between.

#### Type

The `"type"` property is a string enum that defines the type of sky. It is required and has no default value. The possible values are `"panorama"`, `"physical"`, and `"gradient"`.

Here is a comparison of the types of sky in `OMI_environment_sky` and the corresponding sky types in various engines:

| Sky Type    | Unity                     | Unreal        | Godot                   | Blender |
| ----------- | ------------------------- | ------------- | ----------------------- | ------- |
| Gradient    | Skybox/Procedural         | Skydome Mesh  | ProceduralSkyMaterial   |         |
| Panorama    | Skybox/Panoramic          | Skydome Mesh  | PanoramaSkyMaterial     |         |
| Physical    | HDRP Physically Based Sky | SkyAtmosphere | PhysicalSkyMaterial     |         |
| Plain Color |                           |               | Background Custom Color |         |

In Unity, only Panorama and Gradient skies are supported in all pipelines. Physical sky requires the High Definition Render Pipeline (HDRP).

In Unreal, only Physical skies are directly supported. Panorama and Gradient skies can be implemented with a skydome mesh; the material must have the "Shading Model" set to "Unlit" and "Is Sky" set to true.

### Gradient Sky Properties

Gradient skies use color gradients to define the sky colors. The `"gradient"` property is an object that contains the gradient sky properties:

|                  | Type        | Description                                                     | Default value        |
| ---------------- | ----------- | --------------------------------------------------------------- | -------------------- |
| **bottomColor**  | `number[3]` | The color of the sky at the bottom, also known as the nadir.    | Required, no default |
| **bottomCurve**  | `number`    | The transition curve between the bottom and the horizon colors. | 0.02                 |
| **horizonColor** | `number[3]` | The color of the sky at the horizon.                            | Required, no default |
| **topColor**     | `number[3]` | The color of the sky at the top, also known as the zenith.      | Required, no default |
| **topCurve**     | `number`    | The transition curve between the top and the horizon colors.    | 0.15                 |
| **sunAngleMax**  | `number`    | The maximum radius angle of the sun(s) in radians.              | 0.5                  |
| **sunCurve**     | `number`    | The transition curve between the sun(s) and the sky colors.     | 0.15                 |

#### Bottom Color

The `"bottomColor"` property is an array of three numbers that defines the color of the sky at the bottom, also known as the nadir. This property is required for gradient skies and has no default value.

The bottom color may have values greater than 1.0, which indicate high energy, HDR, or overbright bottom color, but usually, the values are between 0.0 and 1.0.

#### Bottom Curve

The `"bottomCurve"` property is a number that defines the transition curve between the bottom and the horizon colors. It is a unitless number. If not specified, the default value is 0.02.

A curve value of 1.0 is a linear transition. Values between 0.0 and 1.0 make the bottom color more dominant, while values between 1.0 and infinity make the horizon color more dominant. The value must be a positive number.

#### Horizon Color

The `"horizonColor"` property is an array of three numbers that defines the color of the sky at the horizon. This property is required for gradient skies and has no default value.

The horizon color may have values greater than 1.0, which indicate high energy, HDR, or overbright horizon color, but usually, the values are between 0.0 and 1.0.

#### Top Color

The `"topColor"` property is an array of three numbers that defines the color of the sky at the top, also known as the zenith. This property is required for gradient skies and has no default value.

The top color may have values greater than 1.0, which indicate high energy, HDR, or overbright top color, but usually, the values are between 0.0 and 1.0.

#### Top Curve

The `"topCurve"` property is a number that defines the transition curve between the top and the horizon colors. It is a unitless number. If not specified, the default value is 0.15.

A curve value of 1.0 is a linear transition. Values between 0.0 and 1.0 make the top color more dominant, while values between 1.0 and infinity make the horizon color more dominant. The value must be a positive number.

#### Sun Angle Max

The `"sunAngleMax"` property is a number that defines the maximum radius angle of the sun in radians. If not specified, the default value is 0.5, or about 28.6479 degrees.

Note that this defines the outermost maximum angle that the sun would have if the sun curve was infinity.

#### Sun Curve

The `"sunCurve"` property is a number that defines the transition curve between the sun and the sky colors. It is a unitless number. If not specified, the default value is 0.15.

A curve value of 1.0 is a linear transition. Values between 0.0 and 1.0 make the sky color more dominant, while values between 1.0 and infinity make the sun color more dominant. The value must be a positive number.

### Panorama Sky Properties

Panorama skies use a texture or set of textures to represent the sky. The `"panorama"` property is an object that contains the panorama sky properties:

|                     | Type         | Description                                                               |
| ------------------- | ------------ | ------------------------------------------------------------------------- |
| **cubemap**         | `integer[6]` | The indices of 6 textures making up a cubemap in the `textures` array.    |
| **equirectangular** | `integer`    | The index of an equirectangular panorama texture in the `textures` array. |

#### Cubemap

The `"cubemap"` property is an array of 6 integer indices that reference textures in the glTF document-level textures array. If not specified, this sky does not have a cubemap texture.

Cubemap skybox textures are not recommended because not all game engines support them. Unity does, while Unreal and Godot do not. If an engine does not support cubemap skyboxes, an importer may either convert the cubemap to an equirectangular texture, or use a mesh to represent the skybox. Additionally, if the glTF file includes both a cubemap and equirectangular texture, the equirectangular texture may be loaded as a fallback. If present, the value must be a 6-element array of integers which refer to 6 textures. The indices of the textures in the array are in the order +X, -X, +Y, -Y, +Z, -Z.

#### Equirectangular

The `"equirectangular"` property is an integer index that references a texture in the glTF document-level textures array. If not specified, this sky does not have an equirectangular texture.

The equirectangular skybox texture is projected with the top of the texture in the +Y direction, the middle of the texture in the +Z direction, and the left of the texture in the +X direction. It may seem odd to have the left be +X, but since this is a skybox, it is viewed from the inside; this ensures that the texture is not flipped when viewed from the inside. For example, if the skybox image has text on it, the text would be readable on the skybox. This is consistent with what all major 3D engines do.

### Physical Sky Properties

Physical skies use a physically-based model to simulate the scattering of light in the atmosphere. The `"physical"` property is an object that contains the physical sky properties:

|                   | Type        | Description                                                           | Default value     |
| ----------------- | ----------- | --------------------------------------------------------------------- | ----------------- |
| **groundColor**   | `number[3]` | The color of the ground (not part of the atmospheric simulation).     | `[0.3, 0.2, 0.1]` |
| **mieAnisotropy** | `number`    | The anisotropy of Mie scattering (the thing that makes clouds white). | 0.8               |
| **mieColor**      | `number[3]` | The color of Mie scattering (the thing that makes clouds white).      | `[1.0, 1.0, 1.0]` |
| **mieScale**      | `number`    | The scale of Mie scattering (the thing that makes clouds white).      | 0.000005          |
| **rayleighColor** | `number[3]` | The color of Rayleigh scattering (the thing that makes the sky blue). | `[0.3, 0.5, 1.0]` |
| **rayleighScale** | `number`    | The scale of Rayleigh scattering (the thing that makes the sky blue). | 0.00003           |

#### Ground Color

The `"groundColor"` property is an array of three numbers that defines the color of the ground. The default value is `[0.3, 0.2, 0.1]`, which is a sane default for Earth-like skies.

This color is not part of the atmospheric simulation, but it is used to provide a color for the bottom part of the skybox. Realistically, the bottom of the skybox should be obscured by a planet's terrain, but there are cases where the bottom of the skybox is visible, or there is a need for the scene to have ambient light from below.

#### Mie Anisotropy

The `"mieAnisotropy"` property is a number that defines the anisotropy of Mie scattering, also known as eccentricity. It is a unitless number between -1.0 and 1.0, inclusive. If not specified, the default value is 0.8, which is a sane default for Earth-like skies.

A value of 0.0 is isotropic scattering, all light scatters equally in all directions. A value of 1.0 is forward scattering, where light scatters more in the forward direction. A value of -1.0 is backward scattering, where light scatters more in the backward direction. Realistic skies usually have a value between 0.6 and 0.9. Large particle sizes will have a higher value, such as rain droplets reflecting light to make a rainbow. Unreal does not support negative anisotropy values, while Godot does.

#### Mie Color

The `"mieColor"` property is an array of three numbers that defines the color of Mie scattering, which is the thing that makes clouds white. The default value is `[1.0, 1.0, 1.0]`, which is a sane default for Earth-like skies.

#### Mie Scale

The `"mieScale"` property is a number that defines the scale of Mie scattering, also known as the coefficient of Mie scattering. It has a unit of inverse meters (m⁻¹). If not specified, the default value is 0.000005, which is a sane default for Earth-like skies.

The Mie scattering settings affect the color of the sky itself. In clear skies, Mie scattering is usually quite weak. In cases where there is a lot of dust, smoke, haze, fog, pollution, or other particles in the air, the Mie scattering can be stronger.

Note: Game engines may use different scales for the units. glTF uses only base metric units, so it is in inverse meters. However, Unreal and Godot use inverse kilometers, so a glTF value of 0.000005 needs to be multiplied by 1000 on import to 0.005. Unreal defaults to 0.003996, and Godot defaults to 0.005.

#### Rayleigh Color

The `"rayleighColor"` property is an array of three numbers that defines the color of Rayleigh scattering, which is the thing that makes the sky blue. The default value is `[0.3, 0.5, 1.0]`, which is a sane default for Earth-like skies.

#### Rayleigh Scale

The `"rayleighScale"` property is a number that defines the scale of Rayleigh scattering, also known as the coefficient of Rayleigh scattering. It has a unit of inverse meters (m⁻¹). If not specified, the default value is 0.00003, which is a sane default for Earth-like skies.

Note: Game engines may use different scales for the units. glTF uses only base metric units, so it is in inverse meters. However, Unreal uses inverse kilometers, so a glTF value of 0.00003 needs to be multiplied by 1000 on import to 0.03. Godot uses inverse hundred kilometers, so a glTF value of 0.00003 needs to be multiplied by 100000 on import to 3.0. Unreal defaults to 0.0331, and Godot defaults to 2.0.

#### Plain Sky Properties

Plain color skies use a single color to represent the sky. Plain color skies are the simplest type, and are useful for making a single neutral color sky for previewing a scene, among other uses. The `"plain"` property is an object that contains the plain color sky properties:

|           | Type        | Description           | Default value     |
| --------- | ----------- | --------------------- | ----------------- |
| **color** | `number[3]` | The color of the sky. | `[0.0, 0.0, 0.0]` |

#### Color

The `"color"` property is an array of three numbers that defines the color of the sky. If not specified, the default value is `[0.0, 0.0, 0.0]`, which is black.

### JSON Schema

See [schema/glTF.OMI_environment_sky.schema.json](schema/glTF.OMI_environment_sky.schema.json) for the main schema, and the following for the sub-schemas:

- Gradient: [schema/glTF.OMI_environment_sky.gradient.schema.json](schema/glTF.OMI_environment_sky.gradient.schema.json)
- Panorama: [schema/glTF.OMI_environment_sky.panorama.schema.json](schema/glTF.OMI_environment_sky.panorama.schema.json)
- Physical: [schema/glTF.OMI_environment_sky.physical.schema.json](schema/glTF.OMI_environment_sky.physical.schema.json)
- Plain: [schema/glTF.OMI_environment_sky.plain.schema.json](schema/glTF.OMI_environment_sky.plain.schema.json)

## Known Implementations

- Godot Engine add-on https://github.com/omigroup/omi-godot/pull/15

## Resources:

- Unity Procedural Skybox: https://docs.unity3d.com/2022.3/Documentation/Manual/shader-skybox-procedural.html
- Unity Physically Based Sky HDRP: https://docs.unity3d.com/Packages/com.unity.render-pipelines.high-definition@12.1/manual/Override-Physically-Based-Sky.html
- Unreal Sky Atmosphere: https://dev.epicgames.com/documentation/en-us/unreal-engine/sky-atmosphere-component-in-unreal-engine#renderingtheskyusingaskydomemesh
- Godot Sky and Sky Material: https://docs.godotengine.org/en/stable/classes/class_sky.html#class-sky-property-sky-material
