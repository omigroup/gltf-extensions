# OMI_vehicle_body

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Draft Proposal

## Dependencies

Written against the glTF 2.0 spec.

Depends on the `OMI_physics_body` spec, and is designed to be used with `OMI_vehicle_wheel` and `OMI_seat`.

## Overview

This extension allows for specifying additional specialized details of a vehicle body.

To use this extension, place `OMI_vehicle_body` on the same glTF node as an `OMI_physics_body`. The `OMI_vehicle_body` extension can be empty if it does not need any of the parameters defined, its existence indicates that the glTF node is a vehicle body.

The front of the vehicle faces +Z. The pilot seat is expected to face +Z to have the pilot facing towards the front of the vehicle. A stable ground vehicle like a car is expected to have its parts mostly above the center of mass, so that the vehicle is bottom-heavy.

### Example:

The file [minimal_vehicle_body.gltf](examples/minimal_vehicle_body.gltf) defines a very minimal vehicle with no wheels, thrusters, or other functional parts. It only has a body, collider, pilot seat, and some gyroscope torque. The vehicle body is defined as a dynamic physics body node with the `OMI_vehicle_body` extension added on the same node:

```json
{
    "children": [1, 2],
    "name": "MinimalVehicle",
    "extensions": {
        "OMI_physics_body": {
            "motion": {
                "type": "dynamic",
                "mass": 1000
            }
        },
        "OMI_vehicle_body": {
            "gyroTorque": [1000, 1000, 1000],
            "pilotSeat": 1
        }
    }
}
```

The vehicle body refers to a pilot seat glTF node by index, which is defined using the `OMI_seat` extension on a glTF node:

```json
{
    "name": "SeatPilot",
    "translation": [0.4, 0.4, 0.6],
    "extensions": {
        "OMI_physics_body": {
            "trigger": {
                "shape": 0
            }
        },
        "OMI_seat": {
            "back": [0, 0, -0.3],
            "foot": [0, -0.5, 0.3],
            "knee": [0, 0, 0.3]
        }
    }
}
```

The trigger shape is not required, but provides a way for players to interact with the seat; if no trigger shape is defined, and the implementation allows for characters to pilot vehicles, then the implementation should provide another way for players to enter the pilot seat, such as interacting with the entire vehicle body. Also note, the pilot seat itself is not required to be used by an implementation; if an implementation does not allow for characters to pilot the vehicle, the pilot seat can be ignored.

The minimal vehicle in this file is not functional. It exists to showcase the `OMI_vehicle_body` extension by itself, but it has no parts that can move or exert a thrust, except for the built-in gyroscope torque. In order to make the vehicle functional, additional parts would need to be attached, such as a wheel or thruster. See the example files in the `OMI_vehicle_wheel` spec or the `OMI_vehicle_thruster` spec. A vehicle without wheels, thrusters, gyroscope torque, or other functional parts will not have a way to propel itself.

## glTF Schema Updates

This extension consists of a new `OMI_vehicle_body` data structure which can be added to the extensions of an `OMI_physics_body` glTF node.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

The extension is intended to be used together with `OMI_seat`.

### Property Summary

|                       | Type        | Description                                                                      | Default value   |
| --------------------- | ----------- | -------------------------------------------------------------------------------- | --------------- |
| **angularActivation** | `number[3]` | The input value controlling the ratio of the vehicle's angular forces.           | [0.0, 0.0, 0.0] |
| **linearActivation**  | `number[3]` | The input value controlling the ratio of the vehicle's linear forces.            | [0.0, 0.0, 0.0] |
| **gyroTorque**        | `number[3]` | The gyroscope torque intrinsic to the vehicle, excluding torque from parts.      | [0.0, 0.0, 0.0] |
| **maxSpeed**          | `number`    | The speed at which the vehicle should stop driving acceleration further.         | -1.0            |
| **pilotSeat**         | `number`    | The index of the `OMI_seat` glTF node to use as the pilot / driver seat.         | -1 (no seat)    |
| **angularDampeners**  | `boolean`   | If true, the vehicle should slow its rotation when not given angular activation. | true            |
| **linearDampeners**   | `boolean`   | If true, the vehicle should slow down when not given linear activation.          | true            |
| **useThrottle**       | `boolean`   | If true, the vehicle should use a throttle for linear movement.                  | false           |

#### Angular Activation

The `"angularActivation"` property is an array of three numbers that defines the input value controlling the ratio of the vehicle's angular forces. If not specified, the default value is [0.0, 0.0, 0.0], which means that the vehicle should not drive itself with angular forces.

The three numbers represent the ratio of activation of the vehicle's angular forces around the X, Y, and Z axes, respectively. The values are expected to be between -1.0 and 1.0. The behavior of values outside of this range is implementation-defined, they may be clamped to this range, or be allowed to go beyond this range for some kind of turbo boost or overdrive.

For example, a value of [0.0, 1.0, 0.0] would mean that the vehicle should try to spin around its local Y axis to the left at full speed. For a car, this would mean wheels used for steering are turned to the left. For an aircraft or sea ship, this would mean turning the rudder so that the vehicle rotates to the left. For a spacecraft, this may activate gyroscopes or small RCS thrusters to rotate the vehicle to the left. If an angular direction is not applicable to the vehicle, the value should be ignored, such as a car ignoring X and Z angular activations since it can only steer left and right.

Note that due to glTF's right-handed coordinate system with +Z as forward, positive X rotations rotate down, positive Y rotations rotate to the left, and positive Z rotations rotate clockwise.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input source for angular activation is implementation-defined. The control scheme may be keyboard buttons, gamepad joysticks, buttons in the UI, in-game objects such as a steering wheel, or anything else. The input source may be from a player in the pilot seat, such as a user pressing buttons, an NPC controlling the vehicle, or a script such as `KHR_interactivity`.

#### Linear Activation

The `"linearActivation"` property is an array of three numbers that defines the input value controlling the ratio of the vehicle's linear forces. If not specified, the default value is [0.0, 0.0, 0.0], which means that the vehicle should not drive itself with linear forces.

The three numbers represent the ratio of activation of the vehicle's linear forces in the X, Y, and Z directions, respectively. The values are expected to be between -1.0 and 1.0. The behavior of values outside of this range is implementation-defined, they may be clamped to this range, or be allowed to go beyond this range for some kind of turbo boost or overdrive.

For example, a value of [0.0, 0.0, 1.0] would mean that the vehicle should propel itself forward on its local +Z axis at full speed. For a car, this would mean driving the wheels forward with maximum force. For an aircraft or sea ship, this would mean activating main propellers or turbines at full power. For a spaceship, this would mean firing the rear thrusters at full power. If a linear direction is not applicable to the vehicle, the value should be ignored, such as a car ignoring X and Y linear activations since it can only drive forward and backward.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input source for linear activation is implementation-defined. The control scheme may be keyboard buttons, gamepad joysticks, buttons in the UI, in-game objects such as a gas pedal, or anything else. The input source may be from a player in the pilot seat, such as a user pressing buttons, an NPC controlling the vehicle, or a script such as `KHR_interactivity`.

#### Gyro Torque

The `"gyroTorque"` property is an array of three numbers that defines the gyroscope torque intrinsic to the vehicle, excluding torque from parts such as thrusters. If not specified, the default value is [0.0, 0.0, 0.0], meaning that the vehicle does not have any gyroscopic torque ability.

Gyroscope torque is not commonly used for land, sea, and air-based vehicles, but is common for spacecraft. Cars usually rotate themselves by turning their wheels, while sea ships and aircraft usually rotate themselves with control surfaces such as rudders and flaps. Spacecraft need to rotate themselves in space where there is no matter to push against, so they can only rotate themselves using gyroscopes or thrusters. If an implementation does not allow for spacecraft or other vehicles with gyroscope torque, such as a racing game importing cars, this property can be ignored.

Gyroscope torque is a type of torque, and therefore is measured in Newton-meters per radian (kg⋅m²/s²/rad). The amount specified here is the maximum torque; the actual value applied to the vehicle depends on this value, the `"angularActivation"` input, and the `"linearDampeners"` setting. Also note, the rotational effect of the torque depends on the vehicle's mass and rotational inertia, so this value may need to be increased for large vehicles. The torque should be applied local to the vehicle's own reference frame.

Some space games such as Kerbal Space Program and Space Engineers have gyroscopes as placeable parts (called SAS in KSP). The net effect of all gyroscopes on the vehicle is the sum of all the gyroscopes' torques. When exporting from those games to OMI_vehicle_body, the gyroscope torque from all of those parts should be summed up and written to this property. Allowing for individual gyroscopes to break off or otherwise become detached from the vehicle, and therefore changing the vehicle's total gyro torque, is not defined by this extension, but another extension may alter this value at runtime.

#### Pilot Seat

The `"pilotSeat"` property is an integer that defines the index of the glTF node to use as a pilot seat, also known as driver's seat in the context of cars. The node that `"pilotSeat"` points to should be a seat as defined by the `OMI_seat` extension. If not specified or set to -1, this vehicle does not have a pilot seat.

A character sitting in the pilot seat is called the pilot. The pilot should be given control of the vehicle through whatever control scheme the implementation desires. The pilot seat is expected to face +Z to have the pilot facing towards the front of the vehicle. If an implementation does not allow for characters to pilot the vehicle, this property can be ignored.

The pilot seat node is usually a child of the vehicle body node, but it does not have to be. A pilot seat node that is not a descendant of the vehicle body allows for a remote-controlled vehicle, such as a drone.

#### Max Speed

The `"maxSpeed"` property is a number that defines the speed in meters per second at which the vehicle should stop driving acceleration further in that direction. If not defined or negative, the vehicle should not have a maximum speed.

This only affects the maximum speed at which the vehicle can accelerate to under its own power, in all directions. If the vehicle is already moving faster than this speed, the vehicle does not need to use its own thrust to slow down, but it is allowed to do so if given input to thrust in the opposite direction, or if inertia dampeners are enabled.

Note that this only affects how the vehicle is driven, not how it is simulated. The physics engine should still simulate the vehicle at any speed. For example, if a vehicle is driven off a cliff, it may accelerate due to gravity, unrelated to the maximum speed.

#### Angular Dampeners

The `"angularDampeners"` property is a boolean that defines whether the vehicle should slow its rotation down when not given angular activation input for a specific rotation. If not specified, the default value is true.

When angular inertia dampeners are enabled, and any number inside of `"angularActivation"` is zero, it indicates that the vehicle should attempt to stop rotating in that rotational plane. This can be accomplished by straightening the wheels on a car, turning the rudder back to center on a boat, or using gyroscope torque or thruster gimbal on a spaceship. This value is true by default, because it is almost always desired for vehicles to stop rotating when the pilot stops giving input.

The reference frame used to determine what "stop" and "not rotating" mean is implementation-defined, and usually determined at runtime. Inertia dampeners may be relative to global coordinates, or relative to some object, such as a planet, moon, space station, or another vehicle. Angular dampeners are called SAS stabilization in Kerbal Space Program, and Rotational Correction in Elite Dangerous, and both of those games allow the dampeners to be relative to different reference frames.

#### Linear Dampeners

The `"linearDampeners"` property is a boolean that defines whether the vehicle should slow itself down when not given linear activation input for a specific direction. If not specified, the default value is true.

When linear inertia dampeners are enabled, and any number inside of `"linearActivation"` is zero, it indicates that the vehicle should attempt to come to a stop in that direction. This may be the brakes on a car, the reverse thrusters on a spaceship, or some other mechanism. For example, a spaceship with inertia dampeners should use its thrusters to slow down and stop moving when the pilot stops giving input, rather than continuing to drift in space forever.

The reference frame used to determine what "stop" and "not moving" mean is implementation-defined, and usually determined at runtime. Inertia dampeners may be relative to global coordinates, or relative to some object, such as a planet, moon, space station, or another vehicle. Linear dampeners are called Inertia Dampeners in Space Engineers, and Flight Assist in Elite Dangerous, and both of those games allow the dampeners to be relative to different reference frames.

#### Use Throttle

The `"useThrottle"` property is a boolean that defines whether the vehicle should use a throttle for forward movement. This controls how input affects the vehicle's linear activation.

Throttle is a common feature of airplanes and boats, but may be used on other kinds of vehicles. When using throttle, the linear activation is usually between 0.0 and 1.0, where 0.0 is no throttle and 1.0 is full throttle. See the `"linearActivation"` property for more details.

For example, consider the case where the vehicle is given input to move forward, such as a player pressing the <kbd>W</kbd> key, or any other input method.

- Without a throttle, the vehicle's linear activation Z is set to 1.0, so the vehicle should accelerate as fast as it can in the forward direction, up to the maximum speed; then when <kbd>W</kbd> is released, the vehicle's linear activation Z is set to 0.0, the vehicle should stop accelerating forward, either continuing at the same speed, or if inertia dampeners are enabled, slowing down.
- With a throttle, the <kbd>W</kbd> key should increase the linear activation Z (gradually rising towards 1.0), and the <kbd>S</kbd> key should decrease the linear activation Z (gradually falling towards 0.0), allowing the player to control how fast the vehicle accelerates; when the keys are no longer pressed, the throttle stays at its value. The rate of throttle change is implementation-defined.

The actual control scheme is implementation-defined. It may be <kbd>W</kbd> and <kbd>S</kbd> keys, a gamepad joystick, a slider in a UI, or some other method. It is also common to bind a "cut throttle" key, such as <kbd>X</kbd>, to set the throttle to 0.0 instantly. Another option useful for VR implementations is to have a 3D model of a throttle lever that the player can grab and move. The input source may be a player pressing buttons, an NPC controlling the vehicle, or a script such as `KHR_interactivity`.

Aside from `"useThrottle"` determining how input affects activation, there is also the matter of how throttle affects the vehicle's thrust. If `"maxSpeed"` is non-negative, the throttle should be a ratio of that speed, with the thrust adjusting so that the vehicle meets the target speed. Otherwise, the throttle should be a ratio of the thrust power, allowing the throttle to control the ratio of the vehicle's acceleration power.

### JSON Schema

See [schema/node.OMI_vehicle_body.schema.json](schema/node.OMI_vehicle_body.schema.json).

## Known Implementations

- Godot Engine

## Resources:

See the [mapping document](mappings.md) for how this extension maps to other games, game engines, and platforms.

- Godot VehicleBody3D: https://docs.godotengine.org/en/stable/classes/class_vehiclebody3d.html
- Hyperfy Car: https://madjin.github.io/hyperfy-docs/docs/worlds/apps/objects/#car
- Space Engineers Flight Seat: https://spaceengineers.wiki.gg/wiki/Flight_Seat
- Elite Dangerous Flight Assist: https://elite-dangerous.fandom.com/wiki/Flight_Assist
