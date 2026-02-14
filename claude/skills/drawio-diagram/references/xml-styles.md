# Draw.io XML Style Reference

## XML Basic Structure

```xml
<mxfile>
  <diagram name="Page-1">
    <mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="827">
      <root>
        <mxCell id="0"/>
        <mxCell id="1" parent="0"/>
        <!-- shapes and edges here -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
```

## Shape (vertex)

```xml
<mxCell id="2" value="Label" style="STYLE_STRING" vertex="1" parent="1">
  <mxGeometry x="100" y="100" width="120" height="60" as="geometry"/>
</mxCell>
```

## Edge (connector)

```xml
<mxCell id="3" value="" style="STYLE_STRING" edge="1" source="2" target="4" parent="1">
  <mxGeometry relative="1" as="geometry"/>
</mxCell>
```

## Common Shape Styles

| Shape | Style |
|-------|-------|
| Rectangle | `rounded=0;whiteSpace=wrap;` |
| Rounded Rect | `rounded=1;whiteSpace=wrap;` |
| Ellipse | `ellipse;whiteSpace=wrap;` |
| Diamond | `rhombus;whiteSpace=wrap;` |
| Cylinder | `shape=cylinder3;whiteSpace=wrap;boundedLbl=1;size=15;` |
| Cloud | `ellipse;shape=cloud;whiteSpace=wrap;` |
| Hexagon | `shape=hexagon;perimeter=hexagonPerimeter2;whiteSpace=wrap;` |
| Parallelogram | `shape=parallelogram;perimeter=parallelogramPerimeter;whiteSpace=wrap;` |
| Process | `shape=process;whiteSpace=wrap;` |
| Document | `shape=document;whiteSpace=wrap;boundedLbl=1;size=0.27;` |

## Color Palette (Draw.io Defaults)

| Color | Fill | Stroke | Use |
|-------|------|--------|-----|
| Blue | `#dae8fc` | `#6c8ebf` | Primary / Input |
| Green | `#d5e8d4` | `#82b366` | Success / Output |
| Orange | `#ffe6cc` | `#d6b656` | Warning / Process |
| Red | `#f8cecc` | `#b85450` | Error / Critical |
| Purple | `#e1d5e7` | `#9673a6` | External / API |
| Gray | `#f5f5f5` | `#666666` | Neutral / Container |
| Yellow | `#fff2cc` | `#d6b656` | Highlight / Note |

## Style Properties

| Property | Values | Description |
|----------|--------|-------------|
| `fillColor` | `#hex` | Background color |
| `strokeColor` | `#hex` | Border color |
| `fontColor` | `#hex` | Text color |
| `fontSize` | number | Font size (default: 12) |
| `fontStyle` | `0\|1\|2\|4` | 0=normal, 1=bold, 2=italic, 4=underline |
| `align` | `left\|center\|right` | Horizontal alignment |
| `verticalAlign` | `top\|middle\|bottom` | Vertical alignment |
| `opacity` | `0-100` | Opacity percentage |
| `shadow` | `0\|1` | Drop shadow |
| `dashed` | `0\|1` | Dashed border |
| `dashPattern` | `n n` | Dash pattern (e.g. `8 8`) |

## Edge Styles

| Property | Values | Description |
|----------|--------|-------------|
| `edgeStyle` | `orthogonalEdgeStyle\|elbowEdgeStyle\|entityRelationEdgeStyle` | Edge routing |
| `curved` | `0\|1` | Curved edges |
| `endArrow` | `block\|classic\|open\|oval\|diamond\|none` | Arrow type |
| `endFill` | `0\|1` | Filled arrow head |
| `startArrow` | same as endArrow | Start arrow |
| `strokeWidth` | number | Line width |

## Container / Group

```xml
<mxCell id="group1" value="Group" style="group;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;" vertex="1" parent="1">
  <mxGeometry x="50" y="50" width="300" height="200" as="geometry"/>
</mxCell>
<mxCell id="child1" value="Inside" style="rounded=1;" vertex="1" parent="group1">
  <mxGeometry x="20" y="40" width="100" height="40" as="geometry"/>
</mxCell>
```

## Architecture Diagram Icons

Use `shape=mxgraph.` prefix for built-in icon libraries:

| Category | Example Shape |
|----------|--------------|
| AWS | `shape=mxgraph.aws4.resourceIcon;resIcon=mxgraph.aws4.lambda` |
| Azure | `shape=mxgraph.azure.virtual_machine` |
| GCP | `shape=mxgraph.gcp2.compute_engine` |
| Network | `shape=mxgraph.cisco.router` |
| General | `shape=mxgraph.general.server`, `shape=mxgraph.general.database` |
