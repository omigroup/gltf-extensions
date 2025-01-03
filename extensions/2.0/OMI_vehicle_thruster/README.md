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

|                        | Type        | Description                                                          | Default value        |
| ---------------------- | ----------- | -------------------------------------------------------------------- | -------------------- |
| **currentForceRatio**  | `number`    | The ratio of the maximum force the thruster is using for propulsion. | 0.0                  |
| **currentGimbalRatio** | `number[2]` | The ratios of the maximum gimbal angle the thruster is rotated to.   | [0.0, 0.0]           |
| **maxForce**           | `number`    | The maximum thrust force in Newtons (kg⋅m/s²) of this thruster.      | Required, no default |
| **maxGimbal**          | `number`    | The maximum angle the thruster can rotate in radians.                | 0.0                  |

#### Current Force Ratio

The `"currentForceRatio"` property is a number that defines the ratio of `"maxForce"` the thruster is using for propulsion. If not specified, the default value is 0.0, which means the thruster is not firing.

This value is expected to be between 0.0 and 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of turbo boost or overdrive. Negative values should not be used since the thrust strength may be different in the opposite direction, so for reverse thrust, a separate thruster should be used facing the opposite direction. For example, a rocket engine will only use one thruster, while a jet engine may have two thrusters, one for forward thrust and one for reverse thrust, with the reverse thruster having lower thrust.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The thruster may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the thruster's force ratio is set by the vehicle's `"linearActivation"` property in the thrust direction, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

#### Current Gimbal Ratio

The `"currentGimbalRatio"` property is an array of two numbers that defines the ratio of `"maxGimbal"` the thruster is rotated to. If not specified, the default value is [0.0, 0.0], which means the thruster is not gimballing.

Each number is expected to be between -1.0 and 1.0, and both numbers together should form a vector of length no longer than 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of over-rotation or over-gimbal.

For a thruster in the default orientation (rear thruster providing forward +Z thrust by shooting propellant out the back -Z), due to glTF's right-handed coordinate system, positive X gimbal rotates the thruster's nozzle up (resulting in thrust down), and positive Y gimbal rotates the thruster's nozzle to the right (resulting in thrust to the left). A thruster provides thrust in the direction of its local +Z axis after applying gimbal, which is like the thruster shooting propellant out the back in its local -Z direction.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The gimbal may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the thruster's gimbal ratio is set by the vehicle's `"angularActivation"` property in the gimbal direction, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

The thruster's gimbal values can be converted into a rotation Quaternion using the following formula:

```javascript
function getGimbalRotationQuaternion() {
    if (isZeroApprox(currentGimbalRatio) || isZeroApprox(maxGimbal)) {
        return Quaternion.IDENTITY;
    }
    let rotAngles = limitLength(currentGimbalRatio).multiply(maxGimbal);
    let angleMag = rotAngles.length();
    let sinNormAngle = Math.sin(angleMag / 2.0) / angleMag;
    let cosHalfAngle = Math.cos(angleMag / 2.0);
    return new Quaternion(rotAngles.x * sinNormAngle, rotAngles.y * sinNormAngle, 0.0, cosHalfAngle);
}
```

Where `isZeroApprox` returns true if the vector or number is approximately zero, and `limitLength` returns the same vector when its length is less than or equal to 1.0, or a normalized version of the vector when its length is greater than 1.0. The variable `rotAngles` is the rotation in radians, and `angleMag` is the total angle in radians.

#### Max Force

The `"maxForce"` property is a number that defines the maximum thrust force in Newtons (kg⋅m/s²) that the thruster can provide. This property is required and has no default value.

Valid values are positive numbers. Rocket engines in real life have a wide variety of force amounts. Typical rocket engines are usually between one thousand and one million Newtons, but may be much less in the case of small control thrusters, or much more in the case of large main engines. A thruster with zero force is useless. The desired force of a thruster also varies a lot depending on the mass of the vehicle and the desired acceleration and control over it. This wide variety means that there is no sane choice for a default value, so there is no default value.

The active force of the thruster is defined by a combination of this property and the `"currentForceRatio"` property. In general, thrusters should fire when there is linear input in the same direction the thruster exerts force in, such as rear thrusters providing a forward force when forward input is given.

#### Max Gimbal

The `"maxGimbal"` property is a number that defines the maximum angle in radians that the thruster can rotate. If not specified, the default value is 0.0 radians in both axes, which means the thruster cannot rotate.

Valid values are between 0.0 and τ/2 radians (π or 3.14159265... radians, or 180 degrees). Sane values are between 0.0 and 1.0 radians, while realistic values are between 0.0 and 0.2 radians.

The active gimbal of the thruster is defined by a combination of this property and the `"currentGimbalRatio"` property. In general, thrusters should gimbal when there is angular input in the same direction the thruster gimbals in, such as a rear thruster gimballing its nozzle up when up input is given, causing the thrust direction to angle down, causing the vehicle to pitch up.

### JSON Schema

See [glTF.OMI_vehicle_thruster.thruster.schema.json](schema/glTF.OMI_vehicle_thruster.thruster.schema.json) for the main thruster parameter schema, [glTF.OMI_vehicle_thruster.schema.json](schema/glTF.OMI_vehicle_thruster.schema.json) for the document-level list of thruster parameters, and [node.OMI_vehicle_thruster.schema.json](schema/node.OMI_vehicle_thruster.schema.json) for the node-level collider selection.

## Known Implementations

-

## Resources:

- Kerbal Space Program wiki on engines: https://wiki.kerbalspaceprogram.com/wiki/Parts#Engines
- Space Engineers wiki on thrusters: https://spaceengineers.fandom.com/wiki/Thruster
