# OMI_vehicle mappings

This document describes how the OMI_vehicle extensions map to different games, game engines, and platforms.

The term "import" refers to bringing the OMI_vehicle extension data into a game or game engine. The term "export" refers to taking objects from a game or game engine and converting them into OMI_vehicle extension data.

In general, every property in the OMI_vehicle extensions is listed in the tables below, except that the "current" properties are omitted in most cases, because these are usually determined at runtime and do not have any special notes for import/export.

In alphabetical order:

- [Empyrion Galactic Survival](#empyrion-galactic-survival)
- [Godot Engine](#godot-engine)
- [Hyperfy](#hyperfy)
- [Jolt Physics](#jolt-physics)
- [Kerbal Space Program](#kerbal-space-program)
- [Space Engineers](#space-engineers)
- [VRChat SaccFlightAndVehicles](#vrchat-saccflightandvehicles)

## Empyrion Galactic Survival

Empyrion Galactic Survival has space vessels and hover vessels, and no wheeled vehicles except for the motorbike.

| OMI_vehicle_body     | Empyrion      | Additional Notes                                                                             |
| -------------------- | ------------- | -------------------------------------------------------------------------------------------- |
| **gyroTorque**       | RCS block     | Comes in various sizes from 50 kNm to 150 MNm. On export, sum the torque of all RCS blocks.  |
| **maxSpeed**         | 60 to 130 m/s | Depends on type of vessel and the environment (space/atmosphere).                            |
| **pilotSeat**        | Cockpit block | The cockpit block is the pilot seat.                                                         |
| **angularDampeners** | Pilot Mode    | Enabling Pilot Mode will hold a specific rotational speed. This is the inverse of dampeners. |
| **linearDampeners**  | Auto Brake    | Hover engines always have dampeners, Auto Brake only controls non-hover thrusters.           |
| **useThrottle**      | Not available | Empyrion does not have throttle controls.                                                    |

Empyrion also has "Auto Rotate", which is a button that can be held to automatically rotate the vessel to be upright. Neither this nor Pilot Mode are perfect matches for the OMI_vehicle_body `"angularDampeners"` property. However, note that the vehicle can also be powered off to disable all dampeners.

| OMI_vehicle_thruster | Empyrion                 | Additional Notes                             |
| -------------------- | ------------------------ | -------------------------------------------- |
| **maxForce**         | Depends on thruster type | Comes in various sizes from 55 kN to 920 MN. |
| **maxGimbal**        | Not available            | Empyrion thrusters do not gimbal.            |

Empyrion allows toggling thrusters on and off, but does not have an override for the current force and current gimbal of a thruster.

For hover thrusters, Empyrion's hover engines have a force measured in kN, the same as non-hover thrusters, but are handicapped so that they stop working beyond a certain height above the ground. For OMI_vehicle_hover_thruster, there is no artificial height limit, instead they operate with a force that is proportional to the distance from the ground - the closer to the ground, the more force they provide. The OMI_vehicle_hover_thruster `maxHoverEnergy` property is measured in Newton-meters (N⋅m or kg⋅m²/s² or Joules), so dividing this number by the amount of meters above the ground will give the force in Newtons (N).

## Godot Engine

Godot Engine's built-in vehicles are designed to be cars, but its feature set is extended by the Godot implementation of the OMI_vehicle extensions.

| OMI_vehicle_body     | Godot Engine      | Additional Notes                                                                         |
| -------------------- | ----------------- | ---------------------------------------------------------------------------------------- |
| **gyroTorque**       | Gyroscope Torque  | Part of PilotedVehicleBody3D, provided by the OMI_vehicle_body extension implementation. |
| **maxSpeed**         | Max Speed         | Part of PilotedVehicleBody3D, provided by the OMI_vehicle_body extension implementation. |
| **pilotSeat**        | Pilot Seat Node   | Refers to a PilotSeat3D node in the scene, provided by the OMI_vehicle_body extension.   |
| **angularDampeners** | Angular Dampeners | Part of PilotedVehicleBody3D, provided by the OMI_vehicle_body extension implementation. |
| **linearDampeners**  | Linear Dampeners  | Part of PilotedVehicleBody3D, provided by the OMI_vehicle_body extension implementation. |
| **useThrottle**      | Use Throttle      | Part of PilotedVehicleBody3D, provided by the OMI_vehicle_body extension implementation. |

Note: Godot's built-in VehicleBody3D system is designed for body-wide motion parameters, but OMI specifies all motion as per-part. As a result, there is not a lot of overlap between VehicleBody3D's built-in parameters and what is actually used by the OMI_vehicle_body extension implementation in Godot. The OMI_vehicle extensions were designed to be very general-purpose for all kinds of vehicles, not just cars.

| OMI_vehicle_wheel                | Godot Engine Wheels  | Additional Notes                                                                            |
| -------------------------------- | -------------------- | ------------------------------------------------------------------------------------------- |
| **maxForce**                     | Max Force            | Part of PilotedVehicleWheel3D, provided by the OMI_vehicle_wheel extension implementation.  |
| **maxSteeringAngle**             | Max Steering Angle   | Part of PilotedVehicleWheel3D, provided by the OMI_vehicle_wheel extension implementation.  |
| **physicsMaterial**              | Wheel Friction Sleep | Godot only specifies friction, not other material properties.                               |
| **radius**                       | Wheel Radius         | Vanilla Godot VehicleWheel3D.                                                               |
| **suspensionDampingCompression** | Damping Compression  | Vanilla Godot VehicleWheel3D. Godot's units are in Mg/s while OMI_vehicle_wheel uses kg/s.  |
| **suspensionDampingRebound**     | Damping Relaxation   | Vanilla Godot VehicleWheel3D. Godot's units are in Mg/s while OMI_vehicle_wheel uses kg/s.  |
| **suspensionStiffness**          | Suspension Stiffness | Vanilla Godot VehicleWheel3D. Godot is Mg/s² (N/mm), while OMI_vehicle_wheel us kg/s² (N/m) |
| **suspensionTravel**             | Suspension Travel    | Vanilla Godot VehicleWheel3D.                                                               |
| **width**                        | Not available        | Godot Engine wheels are infinitely thin discs.                                              |

Additionally, the OMI_vehicle_thruster extension has a 1:1 mapping with the VehicleThruster3D node provided by the OMI_vehicle_thruster extension implementation in Godot. Since it is identical, a table is not provided for it.

## Hyperfy

Hyperfy vehicles are strictly cars, not aircraft, spacecraft, etc.

| OMI_vehicle_body     | Hyperfy Vehicle Body | Additional Notes                                                                            |
| -------------------- | -------------------- | ------------------------------------------------------------------------------------------- |
| **gyroTorque**       | Anti-roll            | Gyroscope torque can be used to prevent rolling.                                            |
| **maxSpeed**         | Max Speed            |                                                                                             |
| **pilotSeat**        | Seat #1 (Driver)     | Use glTF nodes for all transforms. Use OMI_seat for seats.                                  |
| **angularDampeners** | Unknown              |                                                                                             |
| **linearDampeners**  | Brake Force          | Linear dampeners stop linear motion, which is the same as braking.                          |
| **useThrottle**      | Not available        | Hyperfy does not have throttle controls.                                                    |
| Not available        | Power Curve          | OMI_vehicle_body does not specify acceleration of the vehicle as a whole, only wheel force. |
| Not available        | Turn Speed / Curve   | OMI_vehicle_body does not specify turning of the vehicle as a whole, only the wheels.       |

| OMI_vehicle_wheel                | Hyperfy Vehicle Wheels | Additional Notes                                                                            |
| -------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------- |
| **maxForce**                     | Body (Ac/De)celeration | OMI_vehicle_body does not specify acceleration of the vehicle as a whole, only wheel force. |
| **maxSteeringAngle**             | Body Turn Angle        | OMI_vehicle_body does not specify turning of the vehicle as a whole, only the wheels.       |
| **physicsMaterial**              | Grip Curve             | Very different, but describes the same thing.                                               |
| **radius**                       | Tire Radius            |                                                                                             |
| **suspensionDampingCompression** | Spring Damper          | Hyperfy docs do not specify the unit. OMI_vehicle_wheel uses N⋅s/m or kg/s.                 |
| **suspensionDampingRebound**     | Spring Damper          | Hyperfy docs do not specify the unit. OMI_vehicle_wheel uses N⋅s/m or kg/s.                 |
| **suspensionStiffness**          | Spring Strength        | Hyperfy docs do not specify the unit. OMI_vehicle_wheel uses N/m or kg/s².                  |
| **suspensionTravel**             | Spring Length          |                                                                                             |
| **width**                        | Not available          | Hyperfy wheels are infinitely thin discs.                                                   |
| glTF node position               | Axle Y / Z / Width     | Use glTF nodes for all transforms.                                                          |
| Per-wheel force settings         | Body Mode              | Hyperfy has "FWD", "RWD", and "4WD" modes. For glTF, specify this per-wheel.                |

| Other                              | Hyperfy                | Additional Notes                                                           |
| ---------------------------------- | ---------------------- | -------------------------------------------------------------------------- |
| OMI_physics_body center of mass    | Center Of Mass         | Handled by the OMI_physics_body extension.                                 |
| Calculated from shapes             | Drag & Angular Drag    | Handled by the OMI_physics_body extension.                                 |
| Not available                      | Engine Sound           | Needs discussion for what this will look like in glTF.                     |
| Not available                      | Label                  | Use the glTF node name for naming a vehicle.                               |
| glTF mesh, shapes, etc.            | Model & Size           | The appearance and size are determined by the meshes etc in the glTF file. |
| Not available                      | On Enter & On Exit     | Needs to wait for KHR_interactivity.                                       |
| glTF body node position/rotation   | Position & Rotation    | Use glTF nodes for all transforms.                                         |
| Not available                      | Prefab                 | Configure properties of specific parts intead.                             |
| Not available                      | Reset Time             | Reset functionality is not specified in the OMI extensions.                |
| glTF node position of pilot seat   | Seat #1 Position X/Y/Z | Use glTF nodes for all transforms. Use OMI_seat for seats.                 |
| glTF node rotation of pilot seat   | Seat #1 Rotation       | Use glTF nodes for all transforms. Use OMI_seat for seats.                 |
| glTF node positions of other seats | Seat #2/3/4 Pos X/Y/Z  | Use glTF nodes for all transforms. Use OMI_seat for seats.                 |
| glTF node rotations of other seats | Seat #2/3/4 Rotation   | Use glTF nodes for all transforms. Use OMI_seat for seats.                 |
| Not available                      | Seat #1/2/3/4 Enabled  | OMI_seat does not have an enabled property.                                |

## Jolt Physics

Jolt is a physics engine which has a built-in vehicle system, designed for cars and other wheeled vehicles. Jolt's vehicle controller is very low-level and does not map to the OMI_vehicle_body properties, so another system would need to be built on top to support OMI_vehicle_body's input and handling properties.

| OMI_vehicle_wheel                | Jolt Physics                  | Additional Notes                                                                  |
| -------------------------------- | ----------------------------- | --------------------------------------------------------------------------------- |
| **currentForceRatio**            | Unknown                       |                                                                                   |
| **currentSteeringRatio**         | Steer Angle                   |                                                                                   |
| **maxForce**                     | Unknown                       |                                                                                   |
| **maxSteeringAngle**             | WheelSettingsWV MaxSteerAngle | Radians.                                                                          |
| **physicsMaterial**              | WheelSettingsWV Friction      | Separate LongitudinalFriction and LateralFriction settings in Jolt.               |
| **radius**                       | Radius                        | Meters.                                                                           |
| **suspensionDampingCompression** | SpringSettings Damping        |                                                                                   |
| **suspensionDampingRebound**     | SpringSettings Damping        |                                                                                   |
| **suspensionStiffness**          | SpringSettings Stiffness      | Newtons per meter (N/m) or kilograms per second squared (kg/s²) for both.         |
| **suspensionTravel**             | Suspension Length             | Meters.                                                                           |
| **width**                        | Width                         | Meters.                                                                           |
| Always down                      | Suspension Direction          | OMI_vehicle_wheel suspension always points down, while Jolt may be any direction. |
| Not available                    | WheelSettingsWV Inertia       | OMI_vehicle_wheel does not define wheel inertia.                                  |

## Kerbal Space Program

Kerbal Space Program vehicles can be rockets, planes, rovers, and more.

| OMI_vehicle_body     | Kerbal Space Program | Additional Notes                                                                                            |
| -------------------- | -------------------- | ----------------------------------------------------------------------------------------------------------- |
| **gyroTorque**       | SAS Torque           | Provided by SAS modules or command pods. On export, sum the torque of all SAS modules and command pods.     |
| **maxSpeed**         | Infinite             | Kerbal Space Program does not have a speed limit. On export, do not set this property.                      |
| **pilotSeat**        | Command pod          | Crafts are controlled by Kerbals sitting in command pods, or unmanned command modules such as probe cores.  |
| **angularDampeners** | SAS Enabled          | SAS is a system that automatically stabilizes the craft. The user controls it with the T key.               |
| **linearDampeners**  | Brakes               | Press B to toggle brakes on rovers and aircraft. Spacecraft behave realistically and do not have dampeners. |
| **useThrottle**      | Always enabled       | Kerbal Space Program always has throttle controls.                                                          |

| OMI_vehicle_wheel                | KSP Wheels            | Additional Notes                                                                              |
| -------------------------------- | --------------------- | --------------------------------------------------------------------------------------------- |
| **currentForceRatio**            | Motor settings        | Motors can be toggled, and are otherwise controlled by the vehicle-wide linear activation.    |
| **currentSteeringRatio**         | Steering settings     | Steering can be toggled, and are otherwise controlled by the vehicle-wide angular activation. |
| **maxForce**                     | Depends on wheel type | Kerbal Space Program provides several pre-set wheels.                                         |
| **maxSteeringAngle**             | Depends on wheel type | Kerbal Space Program provides several pre-set wheels.                                         |
| **physicsMaterial**              | Friction Control      | Kerbal Space Program only has wheel friction, not other material properties.                  |
| **radius**                       | Depends on wheel type | Kerbal Space Program provides several pre-set wheels.                                         |
| **suspensionDampingCompression** | Damper Strength       | Kerbal Space Program wiki does not specify the unit. OMI_vehicle_wheel uses N⋅s/m or kg/s.    |
| **suspensionDampingRebound**     | Damper Strength       | Kerbal Space Program wiki does not specify the unit. OMI_vehicle_wheel uses N⋅s/m or kg/s.    |
| **suspensionStiffness**          | Spring Strength       | Kerbal Space Program wiki does not specify the unit. OMI_vehicle_wheel uses N/m or kg/s².     |
| **suspensionTravel**             | Depends on wheel type | Kerbal Space Program provides several pre-set wheels.                                         |
| **width**                        | Depends on wheel type | Kerbal Space Program provides several pre-set wheels.                                         |

| OMI_vehicle_thruster   | KSP Engines              | Additional Notes                                                              |
| ---------------------- | ------------------------ | ----------------------------------------------------------------------------- |
| **currentForceRatio**  | Throttle settings        | Engine thrust can be toggled and limited, up to the throttle amount.          |
| **currentGimbalRatio** | Gimbal settings          | Engines can gimbal like real rocket engines. Gimbal can be limited or locked. |
| **maxForce**           | Depends on thruster type | Kerbal Space Program provides many pre-set thrusters.                         |
| **maxGimbal**          | Depends on thruster type | Kerbal Space Program provides many pre-set thrusters.                         |

## Space Engineers

Space Engineers vehicles are general-purpose. They can be spacecraft, cars, and more.

| OMI_vehicle_body     | Space Engineers            | Additional Notes                                                    |
| -------------------- | -------------------------- | ------------------------------------------------------------------- |
| **gyroTorque**       | Gyroscope blocks           | On export, sum the torque of all gyroscopes.                        |
| **maxSpeed**         | Constant 100 m/s           | Some Space Engineers mods increase this limit.                      |
| **pilotSeat**        | Flight Seat, Cockpit, etc. | If one is set to "Main Cockpit", that one should be the pilot seat. |
| **angularDampeners** | Always enabled             |                                                                     |
| **linearDampeners**  | Inertia Dampeners / Brakes | Press Z to toggle in Space Engineers.                               |
| **useThrottle**      | Not available              | Space Engineers does not have throttle controls.                    |

| OMI_vehicle_wheel                | Space Engineers Wheels | Additional Notes                                                                              |
| -------------------------------- | ---------------------- | --------------------------------------------------------------------------------------------- |
| **currentForceRatio**            | Propulsion Override    | Space Engineers allows overriding force per-wheel directly by the player.                     |
| **currentSteeringRatio**         | Steer Override         | Space Engineers allows overriding steering per-wheel directly by the player.                  |
| **maxForce**                     | Power & Propulsion     | Each wheel type can go up to a certain force, and the Power setting is a multiplier (0-1).    |
| **maxSteeringAngle**             | Steering Angle         | This is the maximum.                                                                          |
| **physicsMaterial**              | Friction               | Space Engineers only specifies friction, not other material properties.                       |
| **radius**                       | Depends on wheel type  | Space Engineers provides several pre-set wheel sizes.                                         |
| **suspensionDampingCompression** | Not available          | Space Engineers does not have a numeric value for wheel suspension damping.                   |
| **suspensionDampingRebound**     | Not available          | Space Engineers does not have a numeric value for wheel suspension damping.                   |
| **suspensionStiffness**          | Strength               | Space Engineers wiki does not specify the unit. OMI_vehicle_wheel uses N/m or kg/s².          |
| **suspensionTravel**             | Height offset          | Space Engineers uses centimeters, OMI_vehicle_wheel uses meters.                              |
| **width**                        | Depends on wheel type  | Space Engineers provides several pre-set wheel sizes.                                         |
| OMI_vehicle_body maxSpeed        | Speed Limit            | Space Engineers has a global speed limit, but also a per-wheel limit, in km/h instead of m/s. |
| Damping and travel settings      | AirShock               | No perfect mapping, some experimentation may be needed.                                       |

| OMI_vehicle_thruster   | Space Engineers Thrusters | Additional Notes                                                                                   |
| ---------------------- | ------------------------- | -------------------------------------------------------------------------------------------------- |
| **currentForceRatio**  | Thrust Override           | Space Engineers allows overriding per-thruster thrust directly by the player.                      |
| **currentGimbalRatio** | Not available             | Space Engineers thrusters do not gimbal.                                                           |
| **maxForce**           | Depends on thruster type  | Space Engineers provides several pre-set thrusters (ion: 14.4 kN, 172.8 kN, 345.6 kN, and 4.3 MN). |
| **maxGimbal**          | Not available             | Space Engineers thrusters do not gimbal.                                                           |

## VRChat SaccFlightAndVehicles

VRChat does not have built-in vehicles, but there are third-party solutions built in VRChat's Udon scripting language. SaccFlightAndVehicles is one such solution. SaccFlightAndVehicles supports ground vehicles (cars/etc), air vehicles, and sea vehicles.

| OMI_vehicle_body     | SaccFlightAndVehicles   | Additional Notes                                                                         |
| -------------------- | ----------------------- | ---------------------------------------------------------------------------------------- |
| **gyroTorque**       | Pitch/Yaw/Roll settings | Sacc air vehicles have an extensive rotation system.                                     |
| **maxSpeed**         | Speed settings          | Sacc has a speed system with many parameters.                                            |
| **pilotSeat**        | Steering controls       | Sacc allows controlling steering in many ways including grabbing a steering wheel in VR. |
| **angularDampeners** | Pitch/Yaw/Roll settings | Sacc air vehicles have an extensive rotation system.                                     |
| **linearDampeners**  | Brake settings          | Sacc has a brake system with many parameters.                                            |
| **useThrottle**      | Throttle settings       | Sacc has a throttle system with many parameters.                                         |

| OMI_vehicle_wheel                | Sacc Wheels            | Additional Notes                                                                           |
| -------------------------------- | ---------------------- | ------------------------------------------------------------------------------------------ |
| **currentForceRatio**            | Throttle controls      | Sacc allows controlling throttle in many ways.                                             |
| **currentSteeringRatio**         | Steering controls      | Sacc allows controlling steering in many ways including grabbing a steering wheel in VR.   |
| **maxForce**                     | Engine Influence       | Sacc also requires a wheel to be a drive wheel for it to apply force.                      |
| **maxSteeringAngle**             | Steering Wheel Degrees | Sacc defines this per-body using degrees, OMI_vehicle_wheel uses radians and is per-wheel. |
| **physicsMaterial**              | Wheel Slow Down & Grip | Sacc defines "CurrentGrip" and "CurrentWheelSlowDown" instead of friction.                 |
| **radius**                       | Wheel Radius           |                                                                                            |
| **suspensionDampingCompression** | Damping Force Multi    |                                                                                            |
| **suspensionDampingRebound**     | Damping Force Multi    |                                                                                            |
| **suspensionStiffness**          | Max Suspension Force   |                                                                                            |
| **suspensionTravel**             | Suspension Distance    |                                                                                            |
| **width**                        | Not available          | Sacc wheels are infinitely thin discs.                                                     |
| glTF node position               | Wheel Point            | Use glTF nodes for all transforms.                                                         |

Note: SaccFlightAndVehicles has many hundreds more properties that are very specific and don't map to any of the OMI_vehicle extension properties. They have been omitted for brevity.
