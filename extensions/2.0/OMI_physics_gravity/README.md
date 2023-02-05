# OMI_physics_gravity

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

Depends on the `OMI_physics_body` and `OMI_physics_shape` specs for per-node gravity volumes.

## Overview

This extension allows specifying gravity volumes on trigger glTF nodes and specifying the global world gravity at the document level.

Global world gravity is always directional. A document-level extension may define the magnitude and direction of the global world gravity. Only one or zero instanced glTF files should have the document-level extension. The intention is to use the document-level extension only on the main "map" glTF. If multiple glTF files have the document-level gravity extension, use the most recently instanced glTF model's gravity (when instancing, override the previous gravity).

For a per-node gravity volume, the `OMI_physics_gravity` extension MUST be defined on an `OMI_physics_body` node that is a base trigger node. Meaning, the glTF node has a trigger property, does not have motion or collider properties, and must not be a child shape of a compound trigger, as only one gravity definition is allowed per compound trigger. The shape of where the gravity influence is experienced is defined by the trigger shapes. The details of which way the gravity points can be specified in a variety of types, which are described in more detail below.

Whether or not a rigid body is influenced by a gravity volume is determined by the priority/replace/stop settings of each gravity volume the body is inside of. The priority integer determines the order in which gravity volumes are calculated, with higher values being calculated first, and the global world gravity is always calculated last. The replace boolean controls whether or not to keep gravity already calculated so far from higher priority nodes. The stop boolean controls whether or not to continue calculating gravity from any lower priority nodes and the global world gravity. If only the default settings are used, where replace and stop are both false, the gravity is combined from all gravity volumes and the global world gravity.

### Example:

This example defines a scene with a millionth-scale Earth planet in space. This is the same as [earth_millionth_scale.gltf](examples/earth_millionth_scale/earth_millionth_scale.gltf) except slimmed down to only a single glTF node, the one related to gravity. It is a fully complete file that can be loaded into any app that supports this extension.

In this example, the global world gravity is set to zero to mimic space. There is an Earth object with point gravity and a radius of 6.37814. The gravity strength is 9.80665 at the unit distance of 6.37814. The area of effect is a sphere with a radius of 40 units, which means the gravity cuts off to zero at a distance of 40 units from the center. Dynamic objects overlapping this sphere will be pulled towards the center by an amount determined by their distance and the field's gravity and unit distance, following the inverse square law.

```json
{
    "asset": {
        "version": "2.0"
    },
    "extensions": {
        "OMI_physics_gravity": {
            "gravity": 0.0
        },
        "OMI_physics_shape": {
            "shapes": [
                {
                    "type": "sphere",
                    "radius": 40.0
                }
            ]
        }
    },
    "extensionsUsed": [
        "OMI_physics_body",
        "OMI_physics_gravity",
        "OMI_physics_shape"
    ],
    "nodes": [
        {
            "name": "EarthGravity",
            "extensions": {
                "OMI_physics_body": {
                    "trigger": {
                        "shape": 0
                    }
                },
                "OMI_physics_gravity": {
                    "gravity": 9.80665,
                    "point": {
                        "unitDistance": 6.37814
                    },
                    "type": "point"
                }
            }
        }
    ],
    "scene": 0,
    "scenes": [{ "nodes": [0] }]
}
```

More example assets can be found in the [examples/](examples/) folder.

## glTF Schema Updates

This extension consists of two new data structures for defining gravity.

- For the root glTF document, the key `"OMI_physics_gravity"` in the document-level `"extensions"` defines global gravity for the whole world, including the entire glTF scene and any other instanced scenes. The global gravity is always directional.

- For a glTF node, the key `"OMI_physics_gravity"` in the node-level `"extensions"` defines gravity for a trigger volume as defined by `OMI_physics_body`. The area of effect is determined by the trigger volume's shapes. Objects in this volume may be affected by its gravity, depending on the priority, replace, and stop settings of gravity volumes affecting this part of space. The type of gravity determines which way the gravity points within the gravity field, and how strongly.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

### Property Summary

The following properties apply to the document-level extension defining the world gravity:

|               | Type        | Description                                                                   | Default value        | Valid on     |
| ------------- | ----------- | ----------------------------------------------------------------------------- | -------------------- | ------------ |
| **gravity**   | `number`    | The gravity amount in meters per second squared. Can be zero or negative.     | Required, no default | Always valid |
| **direction** | `number[3]` | The normalized direction of the gravity. World gravity is always directional. | [0.0, -1.0, 0.0]     | Always valid |

Note: Only one or zero instanced glTF files should have the document-level gravity extension. The intention is to only use the document-level extension on the main "map" glTF. If multiple glTF files have the document-level gravity extension, use the most recently instanced glTF file's gravity.

The following properties apply to the gravity of each node, and is a superset of the world gravity properties:

|              | Type      | Description                                                               | Default value        | Valid on     |
| ------------ | --------- | ------------------------------------------------------------------------- | -------------------- | ------------ |
| **type**     | `string`  | The type of the gravity as a string.                                      | Required, no default | Always valid |
| **gravity**  | `number`  | The gravity amount in meters per second squared. Can be zero or negative. | Required, no default | Always valid |
| **priority** | `number`  | The process priority of this gravity node. Must be an integer.            | 0                    | Always valid |
| **replace**  | `boolean` | If true, replace the current gravity instead of adding to it.             | false                | Always valid |
| **stop**     | `boolean` | If true, stop checking more nodes for gravity.                            | false                | Always valid |

In addition to the type, a key with the same name as the type can be used to define a sub-JSON with the details of the shape. Which sub-properties are allowed depend on which shape type is being used. The possible properties are described in the following table.

|                  | Type        | Description                                                                                           | Default value    | Valid on        |
| ---------------- | ----------- | ----------------------------------------------------------------------------------------------------- | ---------------- | --------------- |
| **direction**    | `number[3]` | The normalized direction of the gravity relative to this node's transform.                            | [0.0, -1.0, 0.0] | Directional     |
| **unitDistance** | `number`    | The distance from the nearest point at which the experienced gravity equals the **gravity** property. | 0.0              | Non-directional |
| **radius**       | `number`    | The radius of the circle to attract gravity towards.                                                  | 1.0              | Disc, torus     |
| **points**       | `number[]`  | The points that make up the line segments of a line type gravity field.                               | []               | Line            |
| **shape**        | `number`    | The integer ID of a physics shape used to define the gravity direction.                               | -1               | Shaped          |

### Type

The `"type"` property is a string that defines the type of the gravity. This property is only valid on node gravity, for world gravity the type is always directional.

The type value may be set to `"directional"`, `"point"`, `"disc"`, `"torus"`, `"line"`, or `"shaped"`.

On a node, the type property must be set to one of the below values, otherwise the behavior is undefined. Further details of the gravity type are defined in a sub-JSON with the same name as the type. The possible properties in this sub-JSON are defined in the above table. If the sub-JSON is not present or is missing a property, the default value should be used.

The type property is not to be confused with the shape of the gravity volume. The trigger body's shape nodes define the area in which the gravity will affect objects. The type property defines which way the gravity points and how it scales with distance.

The directional and point gravity types are the easiest to implement and fastest to calculate. Preference should be given to these types when they are suitable for the desired use case.

#### Directional

`"directional"` gravity defines uniform parallel gravity with a given direction at the given strength. The direction is defined relative to the node's transform with the `"direction"` property.

#### Point

`"point"` gravity defines gravity that points towards a single point, the trigger volume's origin. The `"unitDistance"` property defines the distance from the center at which the actual gravity equals the `"gravity"` property, unless `"unitDistance"` is zero, in which case the gravity is constant regardless of distance.

The vector to the trigger body's origin determines the direction of gravity. The gravity strength is determined by that vector and the `"unitDistance"` property, unless `"unitDistance"` is zero, in which case the gravity is constant regardless of distance.

The point type can be used to define gravity for a spherical planet, with the unit distance property being set to the radius of the planet.

#### Disc

`"disc"` gravity defines gravity that points toward the nearest point in a filled circle. The `"radius"` property defines the radius of the circle. The orientation of the circle is flat on the local XZ plane of the node.

The vector to the nearest point in the filled circle determines the direction of gravity. The gravity strength is determined by that vector and the `"unitDistance"` property, unless `"unitDistance"` is zero, in which case the gravity is constant regardless of distance.

The disc type can be conceptually thought of as two directional gravity fields on either side of the circle, connected by a smooth semicircle transition on the edge.

#### Torus

`"torus"` gravity defines gravity that points toward the nearest point on the edge of a hollow circle. The `"radius"` property defines the radius of the circle. The orientation of the circle is flat on the local XZ plane of the node.

The vector to the nearest point on the edge of the hollow circle determines the direction of gravity. The gravity strength is determined by that vector and the `"unitDistance"` property, unless `"unitDistance"` is zero, in which case the gravity is constant regardless of distance.

The torus type can be used to define gravity for a toroidal planet, with the major radius of the torus being the radius property, and the minor radius of the torus being the unit distance property (or in the case of constant gravity, the minor radius does not need to be set to any parameter).

#### Line

`"line"` gravity defines gravity using series of line segments defined by a series of points. The `"points"` property is an array of numbers that defines these points relative to the node's transform. The size of `"points"` must be a multiple of 3 numbers and must contain at least 6 numbers.

The vector to the nearest point on any of the line segments determines the direction of gravity. The gravity strength is determined by that vector and the `"unitDistance"` property, unless `"unitDistance"` is zero, in which case the gravity is constant regardless of distance.

The line type is a flexible type that defines gravity towards arbitrary lines. It can be used with only 2 points to define simple shapes like gravity for cylinder or capsule planets, or with many points to define a complex snake-like gravity field.

#### Shaped

`"shaped"` gravity defines gravity towards the nearest point on a physics shape. This is not to be confused with the trigger shape that defines the area of effect. The `"shape"` property references the ID of a shape as defined by `OMI_physics_shape`.

The vector to the nearest point on the shape determines the direction of gravity. The gravity strength is determined by that vector and the `"unitDistance"` property, unless `"unitDistance"` is zero, in which case the gravity is constant regardless of distance.

The shaped type is a flexible type that can be used to create things like cube-shaped planets or giving gravity to arbitrary surfaces with minimal effort.

### Gravity

The `"gravity"` property is a number that defines the gravity strength in meters per second squared. Required. Can be zero or negative. If negative, the gravity points in the opposite direction of the direction vector in the case of directional gravity, or away from the nearest point of the other gravity types.

### Direction

The `"direction"` property is a vector as a three-number array. It is only valid for directional gravity.

It defines the direction of the gravity relative to this node's transform. Should be normalized. If not specified, the default value is a unit vector pointing downwards, `[0.0, -1.0, 0.0]`.

### Unit Distance

The `"unitDistance"` property is a number that defines how gravity scales with distance. It is only valid for non-directional gravity.

It defines how the gravity strength should scale based on the distance to the nearest point. If zero, the gravity is constant regardless of distance. This value should not be negative. If not specified, the default value is 0.0.

If positive, it defines the distance from the center point in meters at which the actual gravity equals the gravity amount. The gravity should have squared falloff following the [inverse square law](https://en.wikipedia.org/wiki/Inverse-square_law). For example, if the unit distance is 10 meters and the physics body is 20 meters away, then the experienced gravity magnitude is one quarter of the gravity property. Similarly, if the unit distance is 10 meters and the physics body is 5 meters away, then the experienced gravity magnitude is four times the gravity property.

### Radius

The `"radius"` property is a number that defines the radius of the circle to attract gravity towards. It is only valid for disc and torus gravity.

The orientation of the circle is flat on the local XZ plane of the node. If not specified, the default value is 1.0.

### Points

The `"points"` property is an array of vectors, each made of 3 numbers. It is only valid for line gravity.

The size of `"points"` must be a multiple of 3 numbers and must contain at least 6 numbers. If not specified, the default value is an empty array, which is an invalid value and will have no effect.

### Shape

The `"shape"` property is an integer that defines the ID of a physics shape as defined by `OMI_physics_shape`. It is only valid for shaped gravity.

Defines the shape which is used to determine the direction of gravity. If not specified, the default value is -1, meaning the shape is invalid and will have no effect.

### Priority

The `"priority"` property is an integer that defines the process order of this gravity node. Must be an integer.

Higher priority gravity nodes are processed first. The world gravity is always processed last, after all gravity nodes. If not specified, the default value is 0.

Asset creators are highly encouraged to use priority numbers with large gaps, such as thousands or hundreds. This allows for adding new priority values in-between later. For example, a glTF file could have gravity nodes with priorities 1000 and 2000, then another gravity node can later be inserted in-between with a priority of 1500 without changing the existing gravity nodes. This can be repeated for adding a gravity node between 1000 and 1500, etc. If there are small volumes expected to be processed first, they should have very high priority values (positive thousands), while maps and other large volumes that are expected to be processed last should have very low negative priority (negative thousands).

### Replace

The `"replace"` property is a boolean. If not specified, the default value is false.

If true, the gravity of this gravity volume replaces the calculated gravity instead of adding to it. This discards all previously applied gravity of higher priority nodes.

### Stop

The `"stop"` property is a boolean. If not specified, the default value is false.

If true, stop checking more gravity volume nodes for gravity. This means that lower priority gravity nodes will be ignored. This also ignores the world gravity, which is always calculated last.

### Additional Examples

The gravity types described above can be used in a variety of ways to create a wide variety of gravity types. Here are some examples of how to use the above gravity types to define other gravity shapes.

| Example name | Description                                                                                            |
| ------------ | ------------------------------------------------------------------------------------------------------ |
| Capsule      | Line gravity with 2 points where the line spans the mid-height and is fully inside the trigger volume. |
| Cylinder     | Line gravity with 2 points where the line touches or surpasses the ends of the trigger volume.         |
| Wedge        | Line gravity with 2 points where the line is defined at the corner edge of a trigger volume.           |
| Cone         | Line gravity with 2 points, plus directional gravity pointing towards the large end of the cone.       |

### JSON Schema

See [schema/glTF.OMI_physics_gravity.schema.json](schema/glTF.OMI_physics_gravity.schema.json) for document-level gravity, [schema/node.OMI_physics_gravity.schema.json](schema/node.OMI_physics_gravity.schema.json) for node-level gravity, and the `schema/node.OMI_physics_gravity.*.schema.json` files for the sub-JSON schemas for gravity types.

## Known Implementations

- Godot Engine add-on

## Resources:

- Godot Area3D: https://docs.godotengine.org/en/latest/classes/class_area3d.html
- Gravity in Super Mario Galaxy: https://www.youtube.com/watch?v=QLH_0T_xv3I
