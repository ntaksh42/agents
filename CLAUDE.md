# CLAUDE.md — AI Assistant Guide for `agents` Repository

This file provides essential context for AI assistants (Claude Code and similar tools) working in this repository. Read this before making any changes.

---

## Project Overview

This repository is a **Claude Code skills and agents collection** focused on C#/C++ desktop application development. It contains:

- **78+ pre-built skills** in `.claude/skills/` for use with Claude Code
- **5 custom skills** in `claude/skills/` tailored to this project's workflows
- **Agent definitions** (planned) for specialized C#/C++ development tasks
- **Installation and hook scripts** for Windows (PowerShell)
- **Documentation** covering setup, agent development, and integrations

**Primary language**: Japanese (project documentation), English (skill definitions)
**Target platform**: Windows (primary), with Linux/macOS support documented
**Target users**: C#/C++ developers, DevOps engineers, Azure DevOps users

---

## Repository Structure

```
agents/
├── CLAUDE.md                        # This file
├── README.md                        # Project overview (Japanese)
├── docs/                            # Documentation
│   ├── setup.md                    # Environment setup guide (Japanese)
│   ├── agent-development-guide.md  # How to create new agents (Japanese)
│   ├── lsp-setup-guide.md          # LSP configuration for Claude Code
│   ├── mcp-integration-plan.md     # MCP server integration roadmap
│   ├── tech-intelligence-skills-design.md
│   ├── research-findings.md
│   ├── github-copilot-quality-guide.md
│   ├── vscode-slash-command.md
│   ├── vscode-github-copilot-guide.md
│   ├── copilot-instructions-guide.md
│   └── agent-enhancement-plan.md
├── claude/                          # Claude Code dotfiles & project-specific skills
│   ├── settings.template.json      # Claude Code settings template (copy → ~/.claude/settings.json)
│   ├── install.ps1                 # Windows installer script
│   ├── hooks/                      # Claude Code hook scripts (PowerShell)
│   │   ├── claude-notification.ps1
│   │   ├── dangerous-command-guard.ps1
│   │   ├── instruction-compliance-hook.ps1
│   │   ├── reset-compliance-counter.ps1
│   │   └── statusline.ps1
│   └── skills/                     # Project-specific custom skills
│       ├── ado-operation/          # Azure DevOps operations
│       ├── copilot-delegate/       # GitHub Copilot delegation
│       ├── drawio-diagram/         # DrawIO diagram creation
│       ├── presentation-creator/   # Marp presentation creation
│       └── skill-generator/        # Framework for creating new skills
├── .claude/                         # User skill library (installed skills)
│   └── skills/                     # 78 pre-built skills (see Skills Catalog below)
└── tools/
    └── Update-GitRepositories.ps1  # Batch git update utility (PowerShell)
```

---

## Skills Architecture

### How Skills Work

Skills are modular instruction sets that extend Claude's capabilities. Each skill is a directory with a required `SKILL.md` file:

```
skill-name/
├── SKILL.md          (required) — YAML frontmatter + markdown instructions
├── scripts/          (optional) — Executable Python/Bash scripts
├── references/       (optional) — Reference documentation loaded on demand
└── assets/           (optional) — Templates, images, fonts used in output
```

**SKILL.md frontmatter structure:**
```yaml
---
name: skill-name              # kebab-case, max 64 chars (required)
description: "..."            # Trigger description, max 200 chars ideal (required)
license: MIT                  # (optional)
dependencies: "python>=3.8"   # Runtime deps (optional)
compatibility: "..."          # Environment requirements (optional)
allowed-tools: [Read, Bash]   # Tool restrictions (optional)
metadata: {}                  # Additional metadata (optional)
---
```

### Three-Level Progressive Disclosure

Skills load in stages to preserve context window space:
1. **Metadata** (name + description) — always in context (~100 words)
2. **SKILL.md body** — loaded when the skill triggers (<5k words recommended)
3. **Bundled resources** — loaded by Claude only when needed

**Keep SKILL.md body under 500 lines.** Move detailed content to `references/` files.

### Skills Catalog

**Pre-built skills** (`.claude/skills/`):

| Category | Skills |
|----------|--------|
| AI & Content | `ai-content-quality-checker`, `ai-feedback-loop-optimizer`, `ai-output-validator`, `ai-response-refiner` |
| Architecture & Review | `architecture-reviewer`, `code-reviewer`, `code-smell-detector`, `refactoring-suggester`, `tech-debt-analyzer` |
| Azure DevOps | `azure-artifacts-manager`, `azure-boards-helper`, `azure-dashboard-creator`, `azure-devops-cli`, `azure-devops-migration`, `azure-pipelines-generator`, `azure-release-pipeline`, `azure-repos-helper`, `azure-service-connections`, `azure-test-plans`, `azure-variable-groups`, `azure-wiki-generator` |
| CI/CD & DevOps | `ci-cd-generator`, `dockerfile-generator`, `kubernetes-helper`, `multi-stage-pipeline`, `terraform-azure-devops`, `yaml-pipeline-validator` |
| Data & Analysis | `d3-visualization`, `data-converter`, `data-visualization`, `log-analyzer`, `performance-analyzer`, `sql-query-helper`, `synthetic-data-generator` |
| Development Workflows | `brainstorming`, `commit-message-generator`, `executing-plans`, `git-workflow-helper`, `pr-description-generator`, `requesting-code-review`, `receiving-code-review`, `subagent-driven-development`, `systematic-debugging`, `test-driven-development`, `using-git-worktrees`, `verification-before-completion`, `writing-plans` |
| Documentation | `api-docs-generator`, `changelog-generator`, `document-formatter`, `document-summarizer`, `markdown-table-generator`, `meeting-notes` |
| File Processing | `docx-processor`, `excel-processor`, `pdf-processor`, `pptx-generator` |
| Infrastructure | `config-file-generator`, `environment-manager`, `rest-client-generator` |
| Language & Localization | `dotnet-cpp-localizer`, `translator` |
| Security | `security-audit`, `dependency-analyzer` |
| Testing | `test-generator` |
| Visualization | `algorithmic-art`, `graphql-schema-generator`, `html-presentation`, `mermaid-diagram`, `plantuml-diagram`, `uml-diagram` |
| Web & APIs | `seo-optimizer` |
| Miscellaneous | `automation-script-generator`, `prompt-engineering-helper`, `regex-helper`, `tech-article-extractor` |

**Project-specific skills** (`claude/skills/`):
- `skill-generator` — Create, validate, and package new skills
- `ado-operation` — Azure DevOps CLI operations
- `copilot-delegate` — Delegate tasks to GitHub Copilot
- `drawio-diagram` — Generate DrawIO (diagrams.net) diagrams
- `presentation-creator` — Create Marp presentations

---

## Planned Agents (Development Roadmap)

The following agents are planned but not yet implemented (status: `🚧 開発予定`):

| Priority | Agent | Purpose |
|----------|-------|---------|
| High | Memory Safety Analyzer | C++ memory leak, dangling pointer, buffer overflow detection |
| High | Interop Expert | C#/C++ interop, P/Invoke code generation, marshaling |
| High | Build System Helper | CMake, MSBuild, vcpkg configuration |
| Medium | Windows Desktop Expert | WPF/WinForms XAML, Win32 API, MVVM patterns |
| Medium | Performance Profiler Assistant | Bottleneck analysis, SIMD, parallelism |
| Medium | Unit Test Generator | xUnit/NUnit/MSTest (C#), Google Test/Catch2 (C++) |
| Low | Legacy Code Modernizer | Modernize old C#/C++ codebases |
| Low | API Documentation Generator | Auto-generate API docs |
| Low | Cross-Platform Compatibility Checker | Platform compatibility analysis |
| Low | Dependency Analyzer | Dependency audit and optimization |

### Agent Directory Structure (when implemented)

```
agents/agent-name/
├── README.md              # Agent description (Japanese)
├── prompts/
│   ├── system.md         # System prompt defining agent behavior
│   └── examples/         # Input/output examples
├── tools/                 # Custom tools (optional)
├── tests/                 # Test cases
└── config.json           # Configuration (optional)
```

---

## Configuration

### Claude Code Settings (`claude/settings.template.json`)

Key settings:
- **Model**: `opus` (Claude Opus)
- **Language**: Japanese (`"language": "Japanese"`)
- **Thinking**: Always enabled (`"alwaysThinkingEnabled": true`)
- **Allowed Bash commands**: Comprehensive whitelist covering git, npm, Python, .NET, CMake, Azure CLI, PowerShell, and more

### Installing the Configuration (Windows)

```powershell
# Run the installer from the repo root
.\claude\install.ps1
```

This script:
1. Copies skills to `~/.claude/skills/`
2. Installs hooks to `~/.claude/`
3. Generates `~/.claude/settings.json` from `settings.template.json`
4. Sets the `ENABLE_TOOL_SEARCH` environment variable

### Hooks

Hooks run automatically during Claude Code sessions:

| Hook | Trigger | Purpose |
|------|---------|---------|
| `claude-notification.ps1` | `Notification` event | Windows system notification |
| `dangerous-command-guard.ps1` | `PreToolUse(Bash)` | Block dangerous shell commands |
| `instruction-compliance-hook.ps1` | — | Monitor instruction compliance |
| `reset-compliance-counter.ps1` | — | Reset compliance counters |
| `statusline.ps1` | Status line | Show custom status information |

---

## Development Workflows

### Creating a New Skill

Use the `skill-generator` skill or follow this process manually:

**Step 1: Define the skill**
- What problem does it solve?
- What would a user say to trigger it?
- Does it need scripts, references, or assets, or just a SKILL.md?

**Step 2: Initialize**
```bash
# Using the skill-generator's init script
python claude/skills/skill-generator/scripts/init_skill.py <skill-name> --path .claude/skills/
```

**Step 3: Edit SKILL.md**
- Write a clear, specific `description` (this is the trigger)
- Keep body under 500 lines
- Use imperative/infinitive form for instructions
- Move verbose content to `references/` files

**Step 4: Validate**
```bash
python claude/skills/skill-generator/scripts/quick_validate.py .claude/skills/<skill-name>/
```

**Step 5: Package (for distribution)**
```bash
python claude/skills/skill-generator/scripts/package_skill.py .claude/skills/<skill-name>/
```

### Creating a New Agent

Follow the [agent development guide](docs/agent-development-guide.md):

1. Create directory: `agents/<agent-name>/`
2. Write `prompts/system.md` defining the agent's role, tasks, constraints, and output format
3. Add examples in `prompts/examples/`
4. Add test cases in `tests/`
5. Optionally create `config.json` for adjustable parameters

### Git Workflow

**Branch naming**: Feature branches use `claude/` prefix (e.g., `claude/add-claude-documentation-54Hfc`)

**Commit style**: Use conventional commits in Japanese or English:
```
fix: skill-generatorをベストプラクティスに準拠するよう改善
feat: DrawIO図作成スキル(drawio-diagram)を追加
```

**Allowed git operations** (per settings.template.json):
- All standard git operations EXCEPT `git push` (removed from allow list for safety)
- Push requires explicit user approval

**Batch repository updates**:
```powershell
.\tools\Update-GitRepositories.ps1
```

---

## Key Conventions

### Skill Design Principles

1. **Concise is key** — Context window is shared. Only include what Claude doesn't already know.
2. **Start simple** — Begin with just a SKILL.md. Add scripts/references/assets only when needed.
3. **Design for composition** — Skills may run alongside other skills. Avoid conflicting assumptions.
4. **Progressive disclosure** — Keep metadata minimal; load details only when needed.
5. **No README.md in skills** — Do not create auxiliary docs inside skill directories. Only `SKILL.md` and functional resources.

### Security Conventions

- **Never hardcode secrets** in skill files, hooks, or configuration templates
- Use environment variables for API keys and tokens
- The `dangerous-command-guard.ps1` hook blocks high-risk bash commands
- `git push` is intentionally removed from the Bash allow list — requires explicit permission
- Review third-party skills before enabling them

### Code Quality Standards (for generated code)

Skills that generate C#/C++ code should follow:
- SOLID principles
- RAII patterns for C++ (prefer smart pointers over raw pointers)
- Async/await patterns for C# I/O operations
- MVVM pattern for WPF applications
- MSTest/xUnit for C# tests; Google Test/Catch2 for C++ tests

### Documentation Language

- **Japanese**: README.md, docs/*.md, agent prompts, commit messages
- **English**: SKILL.md files, technical code comments, CLAUDE.md (this file)

---

## Environment Requirements

### Required

- Claude Code CLI or Claude Agent SDK
- Git

### For C++ Agents/Skills

- GCC 9+, Clang 10+, or MSVC 2019+
- CMake 3.15+
- vcpkg (optional)

### For C# Agents/Skills

- .NET SDK 6.0+ or .NET Framework 4.7.2+
- NuGet CLI (optional)

### For Skills with Python Scripts

- Python 3.8+
- Dependencies declared in skill frontmatter (`dependencies` field)

### For Azure DevOps Integration

- Azure CLI (`az`) with DevOps extension
- Valid Azure DevOps organization URL and PAT token
- Environment variable: `AZURE_DEVOPS_EXT_PAT`

---

## MCP Integration (Planned)

The [MCP integration plan](docs/mcp-integration-plan.md) outlines planned Model Context Protocol server integrations:

| Phase | MCP Server | Timeline |
|-------|-----------|----------|
| Phase 1 | GitHub MCP Server | Immediate |
| Phase 2 | Playwright MCP, CI/CD MCP | 1-2 weeks |
| Phase 3 | Sentry MCP, AWS MCP | 1 month |

---

## Common Tasks for AI Assistants

### When asked to add a new skill

1. Check if a similar skill already exists in `.claude/skills/`
2. Use the `skill-generator` skill or the init script
3. Write a concise, triggerable `description` in the frontmatter
4. Keep `SKILL.md` under 500 lines
5. Validate with `quick_validate.py` before committing

### When asked to add a new agent

1. Create the directory under `agents/`
2. Follow the structure in `docs/agent-development-guide.md`
3. Write the system prompt in Japanese
4. Add at least 3 examples in `prompts/examples/`
5. Update `README.md` agent catalog

### When modifying hooks

- Hooks are PowerShell scripts (`.ps1`) — Windows-only
- Test changes by triggering the relevant Claude Code event
- The `dangerous-command-guard.ps1` hook runs before every Bash call — be careful not to break it

### When updating configuration

- Edit `claude/settings.template.json` (the template)
- Re-run `install.ps1` to apply changes to the active Claude Code settings
- Never add `git push` back to the allow list without explicit discussion

---

## Repository History Notes

- Repository initialized: 2025-11-22
- Remote: `http://local_proxy@127.0.0.1:31303/git/ntaksh42/agents`
- 23 commits as of latest snapshot
- Active development: skills are regularly added and improved
- The `master` branch is the stable branch; feature branches use `claude/` prefix
