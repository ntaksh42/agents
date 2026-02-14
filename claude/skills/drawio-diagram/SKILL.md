---
name: drawio-diagram
description: "Create and open Draw.io diagrams from XML, CSV, or Mermaid syntax. Use when creating architecture diagrams, flowcharts, sequence diagrams, ER diagrams, org charts, or network diagrams."
dependencies: "node>=18"
allowed-tools:
  - Bash
  - Read
  - Write
  - Glob
---

# DrawIO Diagram Skill

Create diagrams and open them in the Draw.io editor via the bundled CLI.

## CLI Location

```
{SKILL_DIR}/scripts/drawio-cli.js
```

Execute with: `node {SKILL_DIR}/scripts/drawio-cli.js <command> --content "<content>"`

## Available Commands

| Command | Input | Use Case |
|---------|-------|----------|
| `open-drawio-xml` | Draw.io XML (mxGraph format) | Full control over layout, styling, custom shapes |
| `open-drawio-csv` | CSV with draw.io directives | Org charts, hierarchies from tabular data |
| `open-drawio-mermaid` | Mermaid.js syntax | Quick flowcharts, sequence/class/state/ER diagrams |

## Workflow

1. Determine the best input format based on the diagram type (see Decision Guide below)
2. Generate the diagram content
3. Execute the CLI to open in Draw.io editor
4. Report the result to the user

## Decision Guide

- **Simple flowchart / sequence / class diagram** → Mermaid (fastest, least verbose)
- **Org chart / hierarchy from data** → CSV
- **Precise layout, custom styling, complex diagrams** → XML

## Command Usage

### Mermaid (Recommended for most cases)

```bash
node {SKILL_DIR}/scripts/drawio-cli.js open-drawio-mermaid --content "graph TD; A[Start] --> B{Decision}; B -->|Yes| C[OK]; B -->|No| D[End];"
```

Supported Mermaid diagram types: flowchart, sequence, class, state, ER, gantt, pie, journey.

### XML

```bash
node {SKILL_DIR}/scripts/drawio-cli.js open-drawio-xml --content '<mxfile><diagram name="Page-1"><mxGraphModel><root><mxCell id="0"/><mxCell id="1" parent="0"/><mxCell id="2" value="Hello" style="rounded=1;whiteSpace=wrap;" vertex="1" parent="1"><mxGeometry x="120" y="60" width="120" height="60" as="geometry"/></mxCell></root></mxGraphModel></diagram></mxfile>'
```

**XML注意点:**
- XMLコメント内に `--` (ダブルハイフン) を使わないこと（XMLパーサーが壊れる）
- `style` 属性でスタイルを制御（セミコロン区切り）
- 座標は `mxGeometry` の `x`, `y`, `width`, `height` で指定

### CSV

```bash
node {SKILL_DIR}/scripts/drawio-cli.js open-drawio-csv --content '## label: %name%
## style: shape=%shape%;fillColor=%fill%;strokeColor=%stroke%;
## namespace: csvimport-
## connect: {"from":"manager","to":"name","style":"curved=1;endArrow=blockThin;endFill=1;"}
## width: auto
## height: auto
## padding: 15
name,shape,fill,stroke,manager
CEO,mxgraph.basic.rect,#dae8fc,#6c8ebf,
CTO,mxgraph.basic.rect,#d5e8d4,#82b366,CEO
CFO,mxgraph.basic.rect,#d5e8d4,#82b366,CEO'
```

## Options

| Flag | Description |
|------|-------------|
| `--lightbox true` | Read-only view mode |
| `--dark auto\|true\|false` | Dark mode (default: auto) |
| `--timeout <ms>` | Timeout in ms (default: 30000) |

## XML Style Reference

For XML diagrams, see [references/xml-styles.md](references/xml-styles.md) for common shape styles and color palettes.

## Error Handling

- CLI起動に失敗した場合、`npx @drawio/mcp` の存在を確認
- タイムアウトの場合、`--timeout` を増やす（デフォルト30秒）
- XML解析エラーの場合、`--` がコメント内にないか確認
