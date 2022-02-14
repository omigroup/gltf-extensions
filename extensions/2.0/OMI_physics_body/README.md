# OMI_physics_body

## Contributors

* Mauve Signweaver, Mauve Software Inc.
* YOUR NAME HERE

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

Depends on the OMI_collider spec.

## Overview

This extension allows for setting basic physics properties on Nodes in glTF scenes.

Nodes may be specified as having a physics body (or as being a trigger) which will work together with any Colliders defined via the OMI_collider spec.

Note that each body can either have it's collider specified on the same node, or on nodes that are direct children of the body. In the case of there being child nodes, those colliders should be treated as "Compound Colliders" in those game engines that support it.

### Example:

This example defines a node which contains a single "sphere" collider which is being marked as a "rigid body" for the physics engine.

```json=
{
    "nodes": [{
        "name": "Ball",
        "extensions": {
            "OMI_physics_body": {
                "type": "dynamic"
            },
            "OMI_collider": {
                "type": "sphere",
                "radius": 0.5
            }
        }
    }]
}
```

## glTF Scheme Updates

### Example:

### Physics Types

There are different types of physics bodies that have different interactions with physics systems and other bodies within a scene.

Here is a table listing the mapping between the GLTF object type and the equivalent properties in major game engines.

| Shape     | Unity                 | Godot         | Unreal       |
| --------- | --------------------- | ------------- | ------------ |
| Static    | Collider              | StaticBody    | WorldStatic  |
| Kinematic | RigidBody.isKinematic | KinematicBody | WorldDynamic |
| Dynamic   | RigidBody             | RigidBody     | PhysicsBody  |
| Trigger   | Collider.isTrigger    | Area          | Overlap:true |

#### Static

Static bodies are used to define bodies that can be collided with, but that do not move according to physics. This is usually used for level geometry.

#### Kinematic

Kinematic bodies behave like static bodies with the exception that they can be moved using scripts. e.g. moving platforms. You should mark nodes that are meant to be animated either with animations or a script.

#### Dynamic

Rigid bodies are affected by physics and can collide with each other and with Static bodies. This can be used for things like items that can be interacted with, falling objects in a scene, etc.

#### Trigger

Trigger bodies (aka collision area, aka overlap) do not interact with the physics system, but can generate events when another physics body "enters" them. This is useful to trigger events when an object enteres an area. E.g: A "goal" area which triggers whenever a ball gets thrown into it. In Unity this is set with the `trigger` property on a collider in Unity, setting the `overlap` property in Unreal, or using an Area object in Godot.

### JSON Schema
```json=
{
    "$schema": "http://json-schema.org/draft-04/schema",
    "title": "PhysicsBody",
    "type": "object",
    "required": ["type"],
    "properties": {
        "type": {
            "type": "string",
            "description": "The type of body this node represents",
            "enum": [
                "static",
                "dynamic",
                "kinematic"
                "trigger"
            ]
        }
    }
}
```

## Known Implementations

TODO

## Resources:

Unity colliders: https://docs.unity3d.com/Manual/CollidersOverview.html
Unreal Engine Physics: https://docs.unrealengine.com/4.27/en-US/InteractiveExperiences/Physics/Collision/Overview/
Godot Physics Body: https://docs.godotengine.org/en/stable/classes/class_physicsbody.html#class-physicsbody
Godot Area: https://docs.godotengine.org/en/stable/classes/class_area.html#area
