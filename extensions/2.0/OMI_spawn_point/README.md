# OMI_spawn_point

## Contributors

* OMI glTF Extensions Group
* Robert Long, The Matrix.org Foundation
* Anthony Burchell, Individual Contributor

## Status

Draft Specification

Open Metaverse Interoperability Group Stage 1 Proposal

## Dependencies

Written against the glTF 2.0 spec.

## Introduction

The OMI_spawn_point extension allows you to specify a spawn point in a glTF scene, which defines the initial position and orientation of a visitor in the scene. This can be useful for VR or AR experiences, where the viewer's starting position and orientation can have a significant impact on the overall experience.

### Example / Usage

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
          "name": "Spawn Point 1",
          "team": "Red Team"
        }
      }
    }
  ]
}
```

In the example above, the "OMI_spawn_point" extension is applied to a node named "spawn_point_node". The node's position and rotation data can be used to determine the location of the spawn point in the scene. The name and team properties are optional and can be used to provide additional information about the spawn point.

## Properties

The "OMI_spawn_point" extension includes the following properties:

- `name` (string, optional): The name of the spawn point, if specified.
- `team` (string, optional): The team that the spawn point is associated with, if specified.

### JSON Schema

The OMI_spawn_point extension is defined by the following JSON schema:

```json
{
	"$schema": "http://json-schema.org/draft-07/schema#",
	"title": "OMI_spawn_point",
	"description": "An extension for the glTF format that defines a spawn point in a scene.",
	"type": "object",
	"properties": {
	  "OMI_spawn_point": {
		"type": "object",
		"properties": {
		  "name": {
			"type": "string",
			"description": "The name of the spawn point.",
			"maxLength": 128
		  },
		  "team": {
			"type": "string",
			"description": "The team that this spawn point belongs to, if any.",
			"maxLength": 128
		  }
		},
		"additionalProperties": false
	  }
	},
	"required": ["OMI_spawn_point"],
	"additionalProperties": false
  }
```


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
```


## Known Implementations
Interested Implementations:
* INTERESTED AND PENDING - Third Room - https://github.com/thirdroom/thirdroom
* INTERESTED AND PENDING - Three Object Viewer (WordPress Plugin) - https://wordpress.org/plugins/three-object-viewer/
