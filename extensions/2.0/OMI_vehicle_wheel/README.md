# OMI_vehicle_wheel

## Contributors

- Aaron Franke, Godot Engine.

## Status

Open Metaverse Interoperability Group Draft Proposal

## Dependencies

Written against the glTF 2.0 spec.

Designed to be used together with the `OMI_vehicle_body` spec.

## Overview

This extension allows specifying vehicle wheels in glTF scenes.

Wheel glTF nodes can be added as a descendant of a vehicle body glTF node. A vehicle body is defined as a glTF node with the `OMI_vehicle_body` extension. Then wheels can be added to the vehicle by adding descendant nodes with the `OMI_vehicle_wheel` extension. Wheels must be specified on their own glTF nodes as descendants of a vehicle body, not on the same glTF node as the vehicle; this so that they may have their own transform relative to the vehicle, including their own position, and so that they and may optionally rotate for steering.

Wheels are circles on the local YZ plane, or optionally cylinders if the width property is specified, and are invisible by default. To give a wheel a visual appearance, add another glTF node with a mesh as a child of the wheel. The forward direction of both a vehicle and its wheels is the local +Z direction.

### Example:

The file [simple_car.gltf](examples/simple_car.gltf) defines a low-poly simple car with 4 wheels, and 4 seats, one of which is the pilot seat. This example uses `OMI_physics_body`, `OMI_physics_shape`, `OMI_seat`, `OMI_vehicle_body`, and `OMI_vehicle_wheel`.

The wheel settings are defined at the document level:

```json
{
    "extensions": {
        "OMI_vehicle_wheel": {
            "wheels": [
                {
                    "radius": 0.35,
                    "maxSteeringAngle": 0.5
                },
                {
                    "radius": 0.35,
                    "maxForce": 2000
                }
            ]
        }
    }
}
```

This is then referenced by index on wheel glTF nodes. For example, the front right wheel:

```json
{
    "children": [14],
    "name": "WheelFrontRight",
    "translation": [-0.8, 0, 1.5],
    "extensions": {
        "OMI_vehicle_wheel": {
            "wheel": 0
        }
    }
}
```

The wheel settings at index 0 have a radius of 0.35 meters and a maximum steering angle of 0.5 radians, which allows this wheel to rotate up to about 28 degrees around the Y axis (ZX plane). The front left wheel uses the same settings. The rear wheels use settings index 1 instead, which does not have a maximum steering angle, but does have a maximum force of 2000 Newtons, which allows those wheels to provide thrust when in contact with the ground.

## glTF Schema Updates

This extension consists of three new data structures for defining wheel specifications on the root glTF document and referencing them on a glTF node. The main data structure defines wheel parameters and is what most of this document describes. The second data structure uses the key `"OMI_vehicle_wheel"` in the document-level `"extensions"` which contains a list of the main data structures of wheel parameters. The third data structure uses the key `"OMI_vehicle_wheel"` in the node-level `"extensions"` which contains an index of the wheel parameters to use from the document-level wheel list.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

### Property Summary

The rest of the document, including this summary, defines the properties for the main data structure.

|                                  | Type     | Description                                                                | Default value    |
| -------------------------------- | -------- | -------------------------------------------------------------------------- | ---------------- |
| **currentForceRatio**            | `number` | The ratio of the maximum force the wheel is using for propulsion.          | 0.0              |
| **currentSteeringRatio**         | `number` | The ratio of the maximum steering angle the wheel is rotated to.           | 0.0              |
| **maxForce**                     | `number` | The maximum thrust force in Newtons (kg⋅m/s²) of this wheel.               | 0.0              |
| **maxSteeringAngle**             | `number` | The maximum angle in radians that the wheel can steer or rotate.           | 0.0              |
| **physicsMaterial**              | `number` | The index of the physics material in the top level physicsMaterials array. | -1 (no material) |
| **radius**                       | `number` | The radius of the wheel in meters.                                         | 0.25             |
| **suspensionDampingCompression** | `number` | The resistance to the velocity of the suspension in kg/s when compressing. | 2000.0           |
| **suspensionDampingRebound**     | `number` | The resistance to the velocity of the suspension in kg/s when extending.   | 2000.0           |
| **suspensionStiffness**          | `number` | The resistance to traveling away from the start point in kg/s².            | 20000.0          |
| **suspensionTravel**             | `number` | The distance the suspension can move up or down in meters.                 | 0.25             |
| **width**                        | `number` | The width of the wheel in meters.                                          | 0.125            |

#### Current Force Ratio

The `"currentForceRatio"` property is a number that defines the ratio of the `"maximumForce"` the wheel is using for propulsion. If not specified, the default value is 0.0, which means the wheel is not providing any force.

This value is expected to be between -1.0 and 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of turbo boost or overdrive.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The wheel may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the wheel's force ratio is set by the vehicle's `"linearActivation"` property in the direction the wheel is facing, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script.

#### Current Steering Ratio

The `"currentSteeringRatio"` property is a number that defines the ratio of the `"maximumSteeringAngle"` the wheel is rotated to. If not specified, the default value is 0.0, which means the wheel is not rotated.

This value is expected to be between -1.0 and 1.0. The behavior of values outside of this range is implementation-defined, it may be clamped to this range, or be allowed to go beyond this range for some kind of oversteer. Due to glTF's right-handed coordinate system, positive values should rotate the wheel to the left, and negative values should rotate the wheel to the right.

This value is expected to dynamically change at runtime. This is not usually saved in the glTF file, but it is allowed to be. The input used to set this value is implementation-defined. The wheel may be used on its own without a vehicle, but usually it is used for child nodes of a vehicle. In the common case of a vehicle, the wheel's steering ratio is set by the vehicle's `"angularActivation"` property in the direction the wheel is facing, as defined by `OMI_vehicle_body` extension. However, this value may be set by other means, such as a `KHR_interactivity` script. The exact calculation is determined by the implementation, it may be as simple as using the distance on the vehicle's local Z axis, or as complex as Ackermann steering geometry. For example, a car with all-wheel steering would have the rear wheels rotate in the opposite direction of the front wheels.

#### Max Force

The `"maxForce"` property is a number that defines the maximum thrust force in Newtons (kg⋅m/s²) that the wheel can transfer to the ground. If not specified, the default value is 0.0 Newtons, which means the wheel cannot provide any force.

For a realistic normal car with rear-wheel drive and two rear wheels, the rear wheels should be given a maximum force value that is half the maximum force of the car's engine. The ideal value varies depending on the mass of the vehicle, the desired acceleration, and the amount of wheels.

#### Max Steering Angle

The `"maxSteeringAngle"` property is a number that defines the maximum angle in radians that the wheel can steer. If not specified, the default value is 0.0 radians, which means the wheel cannot steer.

For a realistic normal car with front-wheel steering, the front wheels should be given a maximum steering angle value up to 0.5 radians, or 28.6478897565... degrees, or a smaller value than this. The ideal value varies depending on the vehicle's desired turning radius, the location of the wheel relative to the center of mass, and the desired handling characteristics.

#### Physics Material

The `"physicsMaterial"` property is an integer that defines the index of the physics material used by the wheel, as defined in the top-level physicsMaterials array in the `OMI_physics_body` or `KHR_physics_rigid_bodies` extensions. If not specified or -1, this wheel should use a default physics material defined by the implementation.

#### Radius

The `"radius"` property is a number that defines the radius of the wheel in meters. A wheel is a circle centered on the glTF node's origin, with this radius, aligned on the local YZ plane. If not specified, the default radius is 0.25 meters, which is 0.5 meters in diameter.

#### Suspension Damping Compression

The `"suspensionDampingCompression"` property is a number that defines the damping of the suspension, the resistance to the velocity of the suspension when compressing. If not specified, the default damping is 2000.0 Newton-seconds per meter, or 2000.0 kg/s in SI base units, which is a sane default that reflects real-world cars.

#### Suspension Damping Rebound

The `"suspensionDampingRebound"` property is a number that defines the damping of the suspension, the resistance to the velocity of the suspension when rebounding, also known as extending or relaxing. If not specified, the default damping is 2000.0 Newton-seconds per meter, or 2000.0 kg/s in SI base units, which is a sane default that reflects real-world cars.

#### Suspension Stiffness

The `"suspensionStiffness"` property is a number that defines the stiffness of the suspension, the resistance to moving up or down. If not specified, the default stiffness is 20000.0 Newtons per meter, or 20000.0 kg/s² in SI base units (twenty thousand), which is a sane default that reflects real-world cars.

#### Suspension Travel

The `"suspensionTravel"` property is a number that defines the distance in meters the wheel can move up or down. If not specified, the default travel is 0.25 meters, which is a sane default that reflects real-world cars.

### JSON Schema

See [glTF.OMI_vehicle_wheel.wheel.schema.json](schema/glTF.OMI_vehicle_wheel.wheel.schema.json) for the main wheel parameter schema, [glTF.OMI_vehicle_wheel.schema.json](schema/glTF.OMI_vehicle_wheel.schema.json) for the document-level list of wheel parameters, and [node.OMI_vehicle_wheel.schema.json](schema/node.OMI_vehicle_wheel.schema.json) for the node-level collider selection.

## Known Implementations

- Godot Engine:

## Resources:

- Godot VehicleWheel3D: https://docs.godotengine.org/en/latest/classes/class_vehiclewheel3d.html
- Hyperfy Car: https://madjin.github.io/hyperfy-docs/docs/worlds/apps/objects/#car
- Space Engineers Wheel Suspension: https://spaceengineers.fandom.com/wiki/Wheel_Suspension_5x5#Wheel_Suspension_Controls
- Wikipedia Ackermann steering geometry: https://en.wikipedia.org/wiki/Ackermann_steering_geometry
