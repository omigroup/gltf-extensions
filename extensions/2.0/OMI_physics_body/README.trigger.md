# OMI_physics_body Trigger Property

A useful construct in a physics engine is a non-solid volume of space which does not generate impulses when overlapping with other volumes. These objects are typically called "triggers", "sensors", "phantoms", or "overlap volumes" in physics simulation engines. Triggers allow specifying such volumes either as a single shape or combination of nodes with shapes.

A trigger is added to a glTF node by specifying the `"trigger"` property inside of a node's `"OMI_physics_body"` extension.

A `"trigger"` may specify a `"shape"` property which references a geometric shape defined by the `OMI_physics_shape` extension. Alternatively, a `"trigger"` may have a `"nodes"` property, which is an array of glTF nodes which make up a compound trigger on this glTF node. The nodes in this array must be descendent nodes which must have `"trigger"` properties. At least one of `"shape"` or `"nodes"` must be set to a valid value.

As the name "trigger" suggests, implementations may use these shapes as sensors that generate overlap events, which can be used to trigger things. What behavior gets triggered is outside the scope of this extension, but may be defined in other glTF extensions or application-specific logic.

## Trigger Properties

|           | Type        | Description                                                                                                         | Default value |
| --------- | ----------- | ------------------------------------------------------------------------------------------------------------------- | ------------- |
| **shape** | `integer`   | The index of the shape to use as the trigger shape.                                                                 | -1            |
| **nodes** | `integer[]` | For compound triggers, the set of descendant glTF nodes with a trigger property that make up this compound trigger. | []            |

### Shape

The `"shape"` property is an integer index that references a shape in the document-level shapes array as defined by the `OMI_physics_shape` extension. If not specified or -1, this node has no trigger shape, but may have `"nodes"` defined to create a compound trigger.

### Nodes

The `"nodes"` property is an array of integer indices that reference descendant glTF nodes with a trigger property, which make up a compound trigger on this glTF node. If not specified or empty, this node is not a compound trigger.

When this property is set and contains valid items, this indicates that this glTF node is a compound trigger. Each item is the index of a glTF node that must have its own OMI_physics_body trigger property, and must be a descendant of this node.

## JSON Schema

See [schema/node.OMI_physics_body.trigger.schema.json](schema/node.OMI_physics_body.trigger.schema.json) for the trigger properties JSON schema.
