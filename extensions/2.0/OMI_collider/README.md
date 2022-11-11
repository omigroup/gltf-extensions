<!-- Based on structure of the OMI_audio_emitter -->

# OMI_collider

## Contributors

* Mauve Signweaver, Mauve Software Inc.
* Robert Long, The Matrix.org Foundation

## Status

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

This extension allows for the addition of colliders to gLTF scenes.

Colliders can be added to GLTF nodes along with information about the "type" of collider it is representing.

This extension does not perscribe what Colliders should do within a scene, but engines may choose to treat colliders as Static physics bodies by default.
For a more thorough physics body specification, implement the `OMI_physics_body` extension.

### Example:

```json
{
  "extensionsUsed": [
    "OMI_collider"
  ],
  "scene": 0,
  "scenes": [
    {
      "nodes": [0]
    }
  ],
  "nodes": [
    {
      "name": "ball",
      "extensions": {
        "OMI_collider": {
          "collider": 0
        }
      }
    }
  ],
  "extensions": {
    "OMI_collider": {
      "colliders": [
        {
          "type": "sphere",
          "radius": 0.5
        }
      ]
    }
  }
}
```

## glTF Schema Updates

This extension consists of a new `Collider` data structure which can be added to the root glTF and referenced on a glTF `Node`.

The extension must also be added to the glTF's `extensionsUsed` array and because it is optional, it does not need to be added to the `extensionsRequired` array.

### `isTrigger`

Specifying `"isTrigger": true` in the collider hints to engines that this collider should not be used for physics interactions and should exist as a "trigger volume" which emits events when an entity intersects with it.
By default an engine may assume that the collider is a static (or rigid) physics body.

### Collider Types

We've looked at the different types of collision shapes between major game engines (Unity/Unreal/Godot) and looked at what properties are common between them.

Colliders inherit whatever transform is given to them by the `node` they are attached to. This includes rotation and translation, however it is discouraged to scale these nodes as that can cause problems in some physics engines.

TODO: There's limits on the sorts of transforms, Unreal can't rotate colliders, has to be axis aligned (local axis to the game component) Maybe only more restrictive only when on a rigid body direcly.

Here is a table of what the shapes can be represented with in different game engines:

| Shape    | Unity        | Godot                 | Unreal  | Ammo       |
| -------- | ------------ | --------------------- | ------- | ---------- |
| Box      | Box          | BoxShape              | Box     | Box        |
| Sphere   | Sphere       | SphereShape           | Sphere  | Sphere     |
| Capsule  | Capsule      | CapsuleShape          | Capsule | Capsule    |
| Hull     | Mesh(convex) | ConvexPolygonShape    | Mesh?   | ConvexHull |
| Mesh     | Mesh         | ConcavePolygonShape   | Mesh    | Mesh       |
| Compound | Compound     | Add mutiple colliders | ???     | ???        |


#### Box

This represents a "box" shape which can either be a cube or an arbitrary rectangular prism. You can specify an `extents` property which is an array that contains the `[x, y, z]` sizes.

#### Sphere

This represents a "ball" shape which has a `radius` property which must be set to 0.5 if a `radius` field is omitted.

#### Capsule

This represents a "pill" shape which has a `radius` and `height` property. By default the `capsule`'s height is aligned with the vertical axis. If you wish to align it along a different axis, apply the appropriate transform to the `node`. The `radius` field must be set to `0.5` if omitted, and the `height` must be set to `1` if omitted. The final height of the capsule is `height + radius * 2`. TODO: Improve wording?

#### Hull

This type represents "convex hull" meshes which can be used to represent complex shapes in 3D. Note that it being "convex" means that it cannot have "holes" or divots that lead inside. This use can can be optimized by most if not all physics engines to improve speeds compared to doing collision detection on all faces within the mesh. Hulls are computed automatically at runtime using the specified algorithm.

**TODO:** Specify hull algorithm

#### Mesh

Avoid using this type unless you're absolutely sure you need this level of detail.
Most objects can be represented with a convex hull (or a combination of convex hulls) or a set of primitives and will perform drastically better. It is recommended to use one or more convex hull mesh or primitive collider.

This type represents an arbitrary 3D mesh for collision detection which can be useful for shapes that cannot be represented by a convex hull. (e.g. something you can go inside of).

The `mesh` property of the extension must be used to link to an element in the `meshes` array. Note that the mesh MUST be a `trimesh` to work.

TODO: Same limits as regular meshes in glTF

#### Compound

Compound colliders can be used to group several colliders together in order to give an entity a complex shape using several primitives without resorting to an entire mesh.

A `Node` set to be a `compund` collider will use any direct child nodes with the `OMI_collider` extension as part of it's collision shape.

### Using Colliders

TODO

## Known Implementations

[Third Room Unity Exporter](https://github.com/matrix-org/thirdroom-unity-exporter/blob/main/Runtime/Scripts/OMI_collider/OMI_ColliderExtension.cs)
[Third Room glTF Transform](https://github.com/matrix-org/thirdroom/blob/main/src/asset-pipeline/extensions/OMIColliderExtension.ts)
[Third Room glTF Loader](https://github.com/matrix-org/thirdroom/blob/main/src/engine/gltf/OMI_collider.ts)

## Resources:

- Godot Collision Shapes (Box, Sphere, Capsule, Convvex, Concave): https://docs.godotengine.org/en/stable/classes/class_sphereshape.html#class-sphereshape
- Unity Colliders (Box, Sphere, Capsule, Mesh / Convex Hull): https://docs.unity3d.com/Manual/CollidersOverview.html
- Unreal Engine Collision Shapes (Sphere, Capsule, Box, or Line): https://docs.unrealengine.com/4.27/en-US/API/Runtime/PhysicsCore/FCollisionShape/
- Unreal Engine Mesh Collisions: https://docs.unrealengine.com/4.27/en-US/WorkingWithContent/Types/StaticMeshes/HowTo/SettingCollision/
- Mozilla Hubs ammo-shape (Box, Sphere, Hull, Mesh): https://github.com/MozillaReality/hubs-blender-exporter/blob/bb28096159e1049b6b80da00b1ae1534a6ca0855/default-config.json#L608
- Babylon AmmoJS MeshBuilder (Box, Capsule, Cylinder, ???): https://doc.babylonjs.com/typedoc#meshbuilder
