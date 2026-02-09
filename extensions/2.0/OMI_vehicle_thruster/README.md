# OMI_vehicle_thruster

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Draft Proposal

## Dependencies

Written against the glTF 2.0 spec.

Designed to be used together with the `OMI_vehicle_body` spec.

## Overview

This extension allows specifying generic thrusters in glTF scenes.

Thrusters as defined by `OMI_vehicle_thruster` are very general-purpose, they emit a force and can optionally gimbal. `OMI_vehicle_thruster` can be used to define rocket engines, jet engines, control thrusters, or any other kind of thruster. This extension does not define fuel, power, or any other resource that the thruster may consume.

Thruster glTF nodes can be added as a descendant of a vehicle body glTF node. A vehicle body is defined as a glTF node with the `OMI_vehicle_body` extension. Then thrusters can be added to the vehicle by adding descendant nodes with the `OMI_vehicle_thruster` extension. Thrusters must be specified on their own glTF nodes as descendants of a vehicle body, not on the same glTF node as the vehicle; this so that they may have their own transform relative to the vehicle, including their own position, and so that they and may optionally rotate for gimbal.

A thruster's force is applied in the local +Z direction of the glTF node, pushing the vehicle in the thruster's local +Z direction, which mimics the "nozzle" pointing in the local -Z direction. The forward direction of a vehicle is the local +Z direction. A thruster with no rotation relative to the vehicle will push the vehicle forward in its local +Z direction, as if shooting propellant out the back (local -Z). To apply thrust in other directions, the thruster must be rotated relative to the vehicle.

Thrusters can optionally gimbal, which means they can rotate to apply thrust in different directions. The maximum angle the thruster can rotate is defined by the `"maxGimbal"` property. When a thruster gimbals, the glTF node MUST rotate to match the gimbal, such that the local +Z direction of the glTF node is always the direction the thruster is applying thrust, and the local -Z direction is the direction the "nozzle" is pointing. This rotation means that any child nodes will also rotate with the thruster, allowing for visual effects like a rotating thruster nozzle mesh.

Thrusters are invisible by default. To give a thruster a visual appearance, you may wish to add another glTF node with a mesh as a child of the thruster.

### Example:

The file [simple_spaceship.gltf](examples/simple_spaceship.gltf) defines a low-poly space ship with thrusters in all 6 directions, each a child node of the ship's vehicle body. The ship can rotate itself with gyroscope torque or gimbal its thrusters to rotate. The ship also has a pilot seat, allowing a player to sit in it to control the vehicle. This can be imported into a game that supports OMI_vehicle_thruster to have a controllable spaceship.

The thruster settings are defined at the document level:

```json
{
    "extensions": {
        "OMI_vehicle_thruster": {
            "thrusters": [
                {
                    "maxForce": 1000,
                    "maxGimbal": 0.25
                },
                {
                    "maxForce": 2000,
                    "maxGimbal": 0.2
                },
                {
                    "maxForce": 5000,
                    "maxGimbal": 0.25
                }
            ]
        }
    }
}
```

This is then referenced by index on thruster glTF nodes. For example, the right main thruster:

```json
{
    "name": "SimpleSpaceshipMainThrusterRight",
    "translation": [-0.5333333, 0, -1.25],
    "extensions": {
        "OMI_vehicle_thruster": {
            "thruster": 2
        }
    }
}
```

The thruster settings at index 2 have a maximum force of 5000 Newtons, and a maximum gimbal of 0.25 radians, which allows this thruster to rotate up to about 14 degrees. The simple spaceship example has several more thrusters, each using one of the items in the thruster settings array.

## glTF Schema Updates

This extension consists of three new data structures for defining thruster specifications on the root glTF document and referencing them on a glTF node. The main data structure defines thruster parameters and is what most of this document describes. The second data structure uses the key `"OMI_vehicle_thruster"` in the document-level `"extensions"` which contains a list of the main data structures of thruster parameters. The third data structure uses the key `"OMI_vehicle_thruster"` in the node-level `"extensions"` which contains an index of the thruster parameters to use from the document-level thruster list.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

### Property Summary

The rest of the document, including this summary, defines the properties for the main data structure.

|                             | Type        | Description                                                                         | Default value        |
| --------------------------- | ----------- | ----------------------------------------------------------------------------------- | -------------------- |
| **gimbalChangeRate**        | `number`    | The rate at which the thruster can change its gimbal angles.                        | 1.0                  |
| **forceChangeRate**         | `number`    | The rate at which the thruster can change its applied force.                        | -1.0                 |
| **linearGimbalAdjustRatio** | `number`    | The ratio of how a vehicle's linear activation should adjust the thruster's gimbal. | 0.0                  |
| **maxForce**                | `number`    | The maximum thrust force in Newtons (kg⋅m/s²) of this thruster.                     | Required, no default |
| **maxGimbal**               | `number`    | The maximum angle the thruster can rotate in radians.                               | 0.0                  |
| **targetForceRatio**        | `number`    | The ratio of the maximum force the thruster is using for propulsion.                | 0.0                  |
| **targetGimbalRatio**       | `number[2]` | The ratios of the maximum gimbal angle the thruster is rotated to.                  | [0.0, 0.0]           |

#### Gimbal Change Rate

The `"gimbalChangeRate"` property is a number that defines the rate at which the thruster can change its gimbal angles, measured in radians per second (rad/s). If not specified, the default value is 1.0 rad/s.

All finite numbers are valid values. A value of 0.0 means the thruster cannot change its gimbal angle at all after initialization, meaning that it would lock the gimbal in place. Any negative value means the thruster MUST instantly change to the desired gimbal angle. Positive values define the maximum rate of change of the gimbal angles in radians per second. With the default value of 1.0 rad/s, a thruster can rotate from 0.0 to 0.5 radians in 0.5 seconds.

For more detail on applying gimbal as rotation, see the `"targetGimbalRatio"` property description below.

#### Max Force

The `"maxForce"` property is a number that defines the maximum thrust force in Newtons (kg⋅m/s²) that the thruster can provide. This property is required and has no default value.

Valid values are positive numbers. Rocket engines in real life have a wide variety of force amounts. Typical rocket engines are usually between one thousand and one million Newtons, but may be much less in the case of small control thrusters, or much more in the case of large main engines. A thruster with zero force is useless. The desired force of a thruster also varies a lot depending on the mass of the vehicle and the desired acceleration and control over it. This wide variety means that there is no sane choice for a default value, so there is no default value.

The target force of the thruster is defined by a combination of this property and the `"targetForceRatio"` property. The actual force applied by the thruster tends towards this target force over time by a rate of `"forceChangeRate"` if specified, or instantly if not specified. In general, thrusters should fire when there is linear input in the same direction the thruster exerts force in, such as rear thrusters providing a forward force when forward input is given.

#### Max Gimbal

The `"maxGimbal"` property is a number that defines the maximum angle in radians that the thruster can rotate. If not specified, the default value is 0.0 radians in both axes, which means the thruster cannot rotate.

Valid values are between 0.0 and τ/2 radians (π or 3.14159265... radians, or 180 degrees). Sane values are between 0.0 and 1.0 radians, while realistic values are between 0.0 and 0.2 radians.

The active gimbal of the thruster is defined by a combination of this property and the `"targetGimbalRatio"` property. In general, thrusters should gimbal when there is angular input in the same direction the thruster gimbals in, such as a rear thruster gimballing its nozzle up when up input is given, causing the thrust direction to angle down, causing the vehicle to pitch up.

For more detail on applying gimbal as rotation, see the `"targetGimbalRatio"` property description below.

#### Linear Gimbal Adjust Ratio

The `"linearGimbalAdjustRatio"` property is a number that defines the maximum ratio of how a vehicle's linear activation should adjust the thruster's gimbal. If not specified, the default value is 0.0, which means the vehicle's linear activation does not affect the thruster's gimbal.

Setting this property to a positive value allows the vehicle's linear activation and dampeners to influence the thruster's gimbal to help achieve the desired linear movement of the vehicle. For example, if the vehicle wants to go forward, and the thruster points downward, and the thruster can gimbal, then it is possible for the thruster to gimbal to shoot its propellant slightly backward to provide some forward thrust to the vehicle.

The default value of 0.0 means that the vehicle's linear activation and dampeners do not affect the thruster's gimbal at all, and the thruster only gimballs based on the vehicle's angular activation and dampeners. Non-hover thrusters have a different default value than hover thrusters because spacecraft using non-hover thrusters usually expect linear inputs to not affect gimbal rotation, while hovercraft critically need gimbal to control their linear movement.

#### Target Force Ratio

The `"targetForceRatio"` property is a number that defines the ratio of `"maxForce"` the thruster is targeting for propulsion. If not specified, the default value is 0.0, which means the thruster is not firing.

This value is expected to be between 0.0 and 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of turbo boost or overdrive. Negative values should not be used since the thrust strength may be different in the opposite direction, so for reverse thrust, a separate thruster should be used facing the opposite direction. For example, a rocket engine will only use one thruster, while a jet engine may have two thrusters, one for forward thrust and one for reverse thrust, with the reverse thruster having lower thrust.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The thruster may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the thruster's force ratio is set by the vehicle's `"linearActivation"` property in the thrust direction, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

#### Target Gimbal Ratio

The `"targetGimbalRatio"` property is an array of two numbers that defines the ratio of `"maxGimbal"` the thruster is targeting to be rotated to. If not specified, the default value is [0.0, 0.0], which means the thruster is not gimballing.

Each number is expected to be between -1.0 and 1.0, and both numbers together should form a vector of length no longer than 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of over-rotation or over-gimbal.

For a thruster in the default orientation (rear thruster providing forward +Z thrust by shooting propellant out the back -Z), due to glTF's right-handed coordinate system, positive X gimbal rotates the thruster's nozzle up (resulting in thrust down), and positive Y gimbal rotates the thruster's nozzle to the right (resulting in thrust to the left). A thruster provides thrust in the direction of its local +Z axis after applying gimbal, which is like the thruster shooting propellant out the back in its local -Z direction.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The gimbal may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the thruster's gimbal ratio is set by the vehicle's `"angularActivation"` property in the gimbal direction, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

The thruster's gimbal values can be converted into a rotation Quaternion using the following pseudocode formula:

```javascript
function getGimbalRotationQuaternion() {
    if (isZeroApprox(_currentGimbalRadians)) {
        return Quaternion.IDENTITY;
    }
    let angleMag = _currentGimbalRadians.length();
    let sinNormAngle = Math.sin(angleMag / 2.0) / angleMag;
    let cosHalfAngle = Math.cos(angleMag / 2.0);
    return new Quaternion(
        _currentGimbalRadians.x * sinNormAngle,
        _currentGimbalRadians.y * sinNormAngle,
        0.0,
        cosHalfAngle
    );
}
```

Where `isZeroApprox` returns true if the vector or number is approximately zero, and `limitLength` returns the same vector when its length is less than or equal to 1.0, or a normalized version of the vector when its length is greater than 1.0. The variable `rotAngles` is the rotation in radians, and `angleMag` is the total angle in radians. The `_currentGimbalRadians` is a private variable that tends towards `targetGimbalRatio` over time by a rate of `"gimbalChangeRate"` if positive, or instantly if negative.

### glTF Object Model

The following JSON pointers are defined representing mutable properties defined by this extension, for use with the glTF Object Model including extensions such as `KHR_animation_pointer` and `KHR_interactivity`:

| JSON Pointer                                                            | Object Model Type |
| ----------------------------------------------------------------------- | ----------------- |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/gimbalChangeRate`        | `float`           |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/forceChangeRate`         | `float`           |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/linearGimbalAdjustRatio` | `float`           |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/maxForce`                | `float`           |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/maxGimbal`               | `float`           |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/targetForceRatio`        | `float`           |
| `/extensions/OMI_vehicle_thruster/thrusters/{}/targetGimbalRatio`       | `float2`          |

Additionally, the following JSON pointers are defined for read-only properties:

| JSON Pointer                                         | Object Model Type |
| ---------------------------------------------------- | ----------------- |
| `/extensions/OMI_vehicle_thruster/thrusters.length`  | `int`             |
| `/nodes/{}/extensions/OMI_vehicle_thruster/thruster` | `int`             |

### JSON Schema

See [glTF.OMI_vehicle_thruster.thruster.schema.json](schema/glTF.OMI_vehicle_thruster.thruster.schema.json) for the main thruster parameter schema, [glTF.OMI_vehicle_thruster.schema.json](schema/glTF.OMI_vehicle_thruster.schema.json) for the document-level list of thruster parameters, and [node.OMI_vehicle_thruster.schema.json](schema/node.OMI_vehicle_thruster.schema.json) for the node-level collider selection.

## Known Implementations

- Basis VR: https://github.com/BasisVR/Basis/pull/442
- Godot Engine: https://github.com/omigroup/omi-godot/tree/main/addons/omi_extensions/vehicle

## Resources

- Kerbal Space Program wiki on engines: https://wiki.kerbalspaceprogram.com/wiki/Parts#Engines
- Space Engineers wiki on thrusters: https://spaceengineers.fandom.com/wiki/Thruster
