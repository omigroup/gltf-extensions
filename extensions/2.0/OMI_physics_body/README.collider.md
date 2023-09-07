# OMI_physics_body Collider Property

If a node has the `"collider"` property defined, it is a solid collider node that objects can collide with.

## Collider Properties

|           | Type      | Description                                           | Default value |
| --------- | --------- | ----------------------------------------------------- | ------------- |
| **shape** | `integer` | The index of the shape to use as the collision shape. | -1            |

### Shape

The `"shape"` property is an integer index that references a shape in the document-level shapes array as defined by the `OMI_physics_shape` extension. If not specified or -1, this node has no collider shape, but may be the parent of other nodes that do have collider shapes, and can combine those nodes into one collider (this may be a body or compound collider depending on the engine).

## JSON Schema

See [schema/node.OMI_physics_body.collider.schema.json](schema/node.OMI_physics_body.collider.schema.json) for the collider properties JSON schema.
