# OMI_spawn_point

## Contributors

* OMI glTF Extensions Group
* Robert Long, The Matrix.org Foundation
* Anthony Burchell, Individual Contributor
* Aaron Franke, The Mirror Megaverse Inc.

## Status

Draft Specification

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Overview

The OMI_spawn_point extension allows you to specify a spawn point in a glTF scene, which is a place where spawnable objects can be created, such as characters. This extension can be used on game maps to mark a room or any other location as a spawn point by placing an OMI_spawn_point glTF node at the desired location. This can be useful for VR or AR experiences, where the viewer's starting position and orientation can have a significant impact on the overall experience.

### Example

To use the "OMI_spawn_point" extension, you must first specify it in the extensionsUsed property of your glTF file.

```json
{
    "extensionsUsed": ["OMI_spawn_point"]
}
```

Next, apply the extension to a child node of the glTF file. The node's position and rotation data can be used to determine the location of the spawn point in the scene.

```json
{
    "nodes": [
        {
            "name": "spawn_point_node",
            "translation": [0, 0, 1],
            "rotation": [0, 0, 0, 1],
            "extensions": {
                "OMI_spawn_point": {
                    "title": "Hill East",
                    "team": "Red",
                    "group": "Hill"
                }
            }
        }
    ]
}
```

In the example above, the "OMI_spawn_point" extension is applied to a node named "spawn_point_node". The node's position and rotation data can be used to determine the location of the spawn point in the scene. The title, team, and group properties are optional and can be used to provide additional information about the spawn point.

## Properties

All of the properties are optional. An empty JSON object is a valid spawn point. All properties have a default value of null.

|           | Type     | Description                                                                                                   |
| ----------| -------- | ------------------------------------------------------------------------------------------------------------- |
| **title** | `string` | The title of the spawn point. This can be used as a user-facing name for the spawn point.                     |
| **team**  | `string` | The team that the spawn point is associated with. Ex: "Red", "Blue", "Humans", "Aliens", "Axis", "Allies".    |
| **group** | `string` | The group that the spawn point is associated with. This can be used to combine together related spawn points. |

How each application decides to use the properties, or if they are used at all, is up to that specific implementation's needs.

* A game that does not display a menu for spawning does not have to display the title.
* A game that displays a menu for spawning can generate custom text from the team, group, and/or node name if the title is not specified.
* A game with no teams does not need to read or use the team property.
* A game with teams can consider a spawn point without a team assigned as a fallback for when a player is not on a team.
* A game with no reason to group together spawn points can ignore the group property.

### JSON Schema

See [schema/node.OMI_spawn_point.schema.json](schema/node.OMI_spawn_point.schema.json) for the schema.

## Known Implementations

Example Three.js implementation - probably not to be included in final proposal

```js
// Create a new Three.js scene
const scene = new THREE.Scene();

// Set up a perspective camera
const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
);

// Load the glTF file
const gltfLoader = new THREE.GLTFLoader();
gltfLoader.load('my-omi-spawn-file.gltf', (gltf) => {
    // Add the scene from the glTF file to the Three.js scene
    scene.add(gltf.scene);

    // Find the "OMI_spawn_point" node
    let spawnPointNode = null;
    scene.traverse((node) => {
        if (node.isObject3D && node.userData.OMI_spawn_point) {
            spawnPointNode = node;
        }
    });

    // Set the position of the camera to the spawn point position from the source node data.
    if (spawnPointNode) {
        camera.position.copy(spawnPointNode.position);
    }
});
```

## Known Implementations

Interested Implementations:
* INTERESTED AND PENDING - Third Room - https://github.com/thirdroom/thirdroom
* INTERESTED AND PENDING - Three Object Viewer (WordPress Plugin) - https://wordpress.org/plugins/three-object-viewer/
* NOT YET PUBLIC - The Mirror https://www.themirror.space/
