# OMI_vehicle_hover_thruster

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Draft Proposal

## Dependencies

Written against the glTF 2.0 spec.

Designed to be used together with the `OMI_vehicle_body` spec.

## Overview

This extension allows specifying generic thrusters in glTF scenes.

Hover thrusters as defined by `OMI_vehicle_hover_thruster` use hover energy for propulsion and can optionally gimbal. The experienced force is proportional to both the hover energy and the distance from the ground - the closer to the ground, the more force they provide. The `"maxHoverEnergy"` property is measured in Newton-meters (N⋅m or kg⋅m²/s²), so dividing this number by the amount of meters above the ground will give the force in Newtons (N). This extension does not define fuel, power, or any other resource that the hover thruster may consume.

Hover thruster glTF nodes can be added as a descendant of a vehicle body glTF node. A vehicle body is defined as a glTF node with the `OMI_vehicle_body` extension. Then hover thrusters can be added to the vehicle by adding descendant nodes with the `OMI_vehicle_hover_thruster` extension. Hover thrusters must be specified on their own glTF nodes as descendants of a vehicle body, not on the same glTF node as the vehicle; this so that they may have their own transform relative to the vehicle, including their own position, and so that they and may optionally rotate for gimbal.

A hover thruster's force is applied in the local +Z direction of the glTF node, pushing the vehicle in the hover thruster's local +Z direction, which mimics the "nozzle" pointing in the local -Z direction. The forward direction of a vehicle is the local +Z direction. A hover thruster with no rotation relative to the vehicle will push the vehicle forward in its local +Z direction, as if shooting propellant out the back (local -Z). To apply hover thrust in other directions, the hover thruster must be rotated relative to the vehicle.

Hover thrusters can optionally gimbal, which means they can rotate to apply hover thrust in different directions. The maximum angle the hover thruster can rotate is defined by the `"maxGimbal"` property. When a hover thruster gimbals, the glTF node MUST rotate to match the gimbal, such that the local +Z direction of the glTF node is always the direction the hover thruster is applying thrust, and the local -Z direction is the direction the "nozzle" is pointing. This rotation means that any child nodes will also rotate with the hover thruster, allowing for visual effects like a rotating hover thruster nozzle mesh.

Hover thrusters are invisible by default. To give a thruster a visual appearance, you may wish to add another glTF node with a mesh as a child of the thruster.

### Example:

The file [hovercraft.gltf](examples/hovercraft.gltf) defines a chrome-colored hovercraft with 4 hover thrusters at the bottom corners of the hovercraft, each a child node of the hovercraft's vehicle body. The hovercraft can rotate itself by gimballing its hover thrusters. The hovercraft also has a pilot seat, allowing a player to sit in it to control the vehicle. This can be imported into a game that supports OMI_vehicle_thruster to have a controllable hovercraft.

For this example, the only source of thrust of any kind is the hover thrusters, so it will struggle to do things like moving up a steep hill. To enhance the handling of the hovercraft, one could add some gyroscope torque and/or non-hover thrusters. However, a proper implementation of OMI_vehicle_hover_thruster should be able to handle a hovercraft with only hover thrusters, including stable hovering over flat ground, controlled angular movement such as pitch, yaw, and roll, preventing the hovercraft from flipping over, and controlled linear movement forward/back/left/right with a bit of up/down movement.

The hover thruster settings are defined at the document level:

```json
{
    "extensions": {
        "OMI_vehicle_hover_thruster": {
            "hoverThrusters": [
                {
                    "maxGimbal": 0.25,
                    "maxHoverEnergy": 30000
                }
            ]
        }
    },
}
```

This is then referenced by index on hover thruster glTF nodes. For example, the front right thruster:

```json
{
    "name": "HoverThrusterFR",
    "rotation": [-0.17670360207558, 0.81949108839035, 0.426600247621536, 0.33944433927536],
    "translation": [-1.2, -0.25, 2.1],
    "extensions": {
        "OMI_vehicle_hover_thruster": { "hoverThruster": 0 }
    }
}
```

The hover thruster settings at index 0 have a maximum hover energy of 30000 Newton-meters, and a maximum gimbal of 0.25 radians, which allows this hover thruster to rotate up to about 14 degrees. The hovercraft example has 4 thrusters, each using the same thruster settings, so this example file has only one entry in the document-level hover thruster settings array.

## glTF Schema Updates

This extension consists of three new data structures for defining hover thruster specifications on the root glTF document and referencing them on a glTF node. The main data structure defines hover thruster parameters and is what most of this document describes. The second data structure uses the key `"OMI_vehicle_hover_thruster"` in the document-level `"extensions"` which contains a list of the main data structures of thruster parameters. The third data structure uses the key `"OMI_vehicle_hover_thruster"` in the node-level `"extensions"` which contains an index of the thruster parameters to use from the document-level thruster list.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

### Property Summary

The rest of the document, including this summary, defines the properties for the main data structure.

|                        | Type        | Description                                                                 | Default value        |
| ---------------------- | ----------- | --------------------------------------------------------------------------- | -------------------- |
| **currentHoverRatio**  | `number`    | The ratio of the maximum hover energy the thruster is using for propulsion. | 0.0                  |
| **currentGimbalRatio** | `number[2]` | The ratios of the maximum gimbal angle the hover thruster is rotated to.    | [0.0, 0.0]           |
| **maxHoverEnergy**     | `number`    | The maximum hover energy in Newton-meters (kg⋅m²/s²) of this thruster.      | Required, no default |
| **maxGimbal**          | `number`    | The maximum angle the hover thruster can rotate in radians.                 | 0.0                  |

#### Current Hover Ratio

The `"currentHoverRatio"` property is a number that defines the ratio of `"maxHoverEnergy"` the hover thruster is using for propulsion. If not specified, the default value is 0.0, which means the hover thruster is not firing.

This value is expected to be between 0.0 and 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of turbo boost or overdrive. Negative values should not be used since the hover thrust strength may be different in the opposite direction, so for reverse thrust, a separate hover thruster should be used facing the opposite direction. For example, a hovercraft may have some hover thrusters on the front and some on the rear, with the rear hover thrusters propelling the vehicle forward, and the front hover thrusters propelling the vehicle backward.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The thruster may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the hover thruster's force ratio is calculated using the vehicle's `"angularActivation"` and `"linearActivation"` properties, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

#### Current Gimbal Ratio

The `"currentGimbalRatio"` property is an array of two numbers that defines the ratio of `"maxGimbal"` the thruster is rotated to. If not specified, the default value is [0.0, 0.0], which means the thruster is not gimballing.

Each number is expected to be between -1.0 and 1.0, and both numbers together should form a vector of length no longer than 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of over-rotation or over-gimbal.

For a hover thruster in the default orientation (rear hover thruster providing forward +Z hover thrust by "shooting propellant" out the back -Z), due to glTF's right-handed coordinate system, positive X gimbal rotates the thruster's nozzle up (resulting in hover thrust down), and positive Y gimbal rotates the thruster's nozzle to the right (resulting in hover thrust to the left). A hover thruster provides hover thrust in the direction of its local +Z axis after applying gimbal, which is like the hover thruster shooting propellant out the back in its local -Z direction.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The gimbal may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the thruster's gimbal ratio is calculating using the vehicle's `"angularActivation"` and `"linearActivation"` properties, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

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

#### Max Hover Energy

The `"maxHoverEnergy"` property is a number that defines the maximum hover energy that the hover thruster can provide, measured in Newton-meters (N⋅m), or kg⋅m²/s² in SI base units, or simply Joules. This property is required and has no default value.

Valid values are positive numbers. Hover energy is a sci-fi concept, so there is no real-world equivalent. The desired hover energy of a thruster varies a lot depending on the mass of the vehicle, the desired distance above the ground to hover at, and the desired acceleration and handling characteristics. This wide variety means that there is no sane choice for a default value, so there is no default value. A hover thruster with zero hover energy is useless.

As an example, if a vehicle has a mass of 1000 kg, and is designed for hovering a maximum 4 meters between the thrusters and the ground in 10 m/s² gravity, then the minimum total hover energy required is 1000 kg * 4 m * 10 m/s² = 40000 N⋅m = 40000 J. The [hovercraft.gltf](examples/hovercraft.gltf) example has a mass of 2000 kg and 4 hover thrusters with 30000 N⋅m of hover energy each, which can sustain a hover height of (4 * 30000 N⋅m) / (2000 kg * 10 m/s²) = 6 meters above the ground. Note that the hovercraft may hover lower than this if the hover thrusters are not firing at full power or if the thrusters are not pointing directly down, in practice the example hovercraft hovers at around 4 to 5 meters above the ground.

The active force of the hover thruster is defined by a combination of this property, the distance between the hover thruster and the ground, and the `"currentForceRatio"` property. In general, hover thrusters should fire when there is input in the same direction the thruster exerts force in, such as rear hover thrusters providing forward hover energy when forward input is given.

#### Max Gimbal

The `"maxGimbal"` property is a number that defines the maximum angle in radians that the hover thruster can rotate. If not specified, the default value is 0.0 radians in both axes, which means the hover thruster cannot rotate.

Valid values are between 0.0 and τ/2 radians (π or 3.14159265... radians, or 180 degrees). Sane values are between 0.0 and 1.0 radians, while realistic values are between 0.0 and 0.2 radians.

The active gimbal of the hover thruster is defined by a combination of this property and the `"currentGimbalRatio"` property. In general, hover thrusters should gimbal when there is angular input in the same direction the hover thruster gimbals in, such as a rear hover thruster gimballing its nozzle up when up input is given, causing the thrust direction to angle down, causing the vehicle to pitch up.

### JSON Schema

See [glTF.OMI_vehicle_hover_thruster.thruster.schema.json](schema/glTF.OMI_vehicle_hover_thruster.thruster.schema.json) for the main thruster parameter schema, [glTF.OMI_vehicle_hover_thruster.schema.json](schema/glTF.OMI_vehicle_hover_thruster.schema.json) for the document-level list of thruster parameters, and [node.OMI_vehicle_hover_thruster.schema.json](schema/node.OMI_vehicle_hover_thruster.schema.json) for the node-level collider selection.

## Known Implementations

- Godot Engine

## Resources:

- None
