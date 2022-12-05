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
To use the OMI_spawn_point extension, you need to add the "OMI_spawn_point" property to the "extensions" object in the glTF file. The "OMI_spawn_point" property should be an object that contains the "position" and "rotation" property, which specifies the XYZ and XYZW coordinates of the spawn point in the scene.

```json
{
  "asset": {
    "version": "2.0"
  },
  "extensions": {
    "OMI_spawn_point": {
      "position": [0, 1, 0],
      "rotation": [0, 0, 0, 1]
    }
  }
}
```

In this example, the OMI_spawn_point extension is added to the "extensions" object in the glTF file. The "position" and "rotation" properties are added to the "OMI_spawn_point" object, which specifies the position and orientation of the spawn point in the global coordinate system of the scene.

The "position" property is set to [0, 1, 0], which specifies that the spawn point is located at the origin (0, 0, 0) and is one unit above the ground plane (0, 1, 0) in the global coordinate system of the scene. The "rotation" property is set to [0, 0, 0, 1], which specifies that the spawn point has no rotation.


### `position`

The "position" property is a required property that is an array of three numbers, which represent the X, Y, and Z coordinates of the spawn point in the scene. The coordinates are defined in the local coordinate system of the node that contains the "position" property, so they may need to be transformed to the global coordinate system of the scene in order to properly place the visitor at the spawn point.

### `rotation`

The "rotation" property is a required property that is an array of four numbers, which represent the X, Y, Z, and W components of a quaternion that defines the rotation of the spawn point. This quaternion defines the orientation of the spawn point in the local coordinate system of the node that contains the "rotation" property, so it may need to be transformed to the global coordinate system of the scene in order to properly orient the visitor at the spawn point.

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
		  "position": {
			"type": "array",
			"description": "The XYZ coordinates of the spawn point in the scene.",
			"items": {
			  "type": "number"
			},
			"minItems": 3,
			"maxItems": 3
		  },
		  "rotation": {
			"type": "array",
			"description": "The XYZW components of the quaternion that defines the rotation of the spawn point.",
			"items": {
			  "type": "number"
			},
			"minItems": 4,
			"maxItems": 4
		  }
		},
		"required": ["position", "rotation"],
		"additionalProperties": false
	  }
	},
	"required": ["OMI_spawn_point"],
	"additionalProperties": false
  }
```

This schema defines the structure and attributes of the OMI_spawn_point extension, including the "position" and "rotation" properties that specifies the XYZ position and XYZW rotation coordinates of the spawn point in the scene. It also includes constraints and requirements that ensure that the "position" and "rotation" propertues are properly defined and used in a glTF file.


## Known Implementations
Interested Implementations:
* INTERESTED AND PENDING - Third Room - https://github.com/thirdroom/thirdroom
* INTERESTED AND PENDING - Three Object Viewer (WordPress Plugin) - https://wordpress.org/plugins/three-object-viewer/
