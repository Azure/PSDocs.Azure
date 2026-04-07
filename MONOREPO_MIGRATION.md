# Monorepo Migration Guide

## Overview

This repository has been restructured to serve as a monorepo for the complete PSDocs ecosystem, consolidating:
- **PSDocs** (core engine from microsoft/PSDocs)
- **PSDocs.Azure** (existing content, now in packages/psdocs-azure/)
- **VS Code Extension** (from microsoft/PSDocs-vscode)

## Repository Structure

```
packages/
├── psdocs/              # PSDocs engine (to be added via git subtree)
├── psdocs-azure/        # Azure IaC documentation generator (existing content)
└── vscode-extension/    # VS Code extension (to be added via git subtree)

docs/
├── psdocs/              # PSDocs engine docs (to be added via git subtree)
├── psdocs-azure/        # PSDocs.Azure docs (existing content)
└── vscode/              # VS Code extension docs

build/
└── common.ps1           # Shared build utilities

.github/workflows/
├── ci.yml                      # Main CI workflow with path-based filtering
├── vscode-ci.yml               # VS Code extension CI (build, test, preview publish)
├── codeql.yml                  # CodeQL security scanning
├── release-psdocs.yml          # Release workflow for PSDocs engine
├── release-psdocs-azure.yml    # Release workflow for PSDocs.Azure
└── release-vscode.yml          # Release workflow for VS Code extension (stable)
```

## Building the Monorepo

### Build all packages

```powershell
./build.ps1 -Build
```

### Build specific package

```powershell
# Build PSDocs engine only
./build.ps1 -Package psdocs -Build

# Build PSDocs.Azure (also builds PSDocs if needed)
./build.ps1 -Package psdocs-azure -Build -Test

# Build VS Code extension
./build.ps1 -Package vscode -Build
```

### Clean build artifacts

```powershell
./build.ps1 -Clean
```

## CI/CD Workflows

### CI Workflow

The CI workflow (`.github/workflows/ci.yml`) uses path-based filtering to only build packages that have changed:

- Changes to `packages/psdocs/**` trigger the PSDocs build
- Changes to `packages/psdocs-azure/**` trigger the PSDocs.Azure build (which depends on PSDocs)
- Changes to `packages/vscode-extension/**` trigger the VS Code extension build

### Release Workflows

Each component has its own release workflow triggered by version-tagged commits:

- **PSDocs**: Tag format `psdocs-v{version}` (e.g., `psdocs-v0.10.0`)
- **PSDocs.Azure**: Tag format `psdocs-azure-v{version}` (e.g., `psdocs-azure-v0.4.0`)
- **VS Code Extension**: Tag format `vscode-v{version}` (e.g., `vscode-v1.1.0`)

## Versioning Strategy

Each component is versioned independently:

- Each package maintains its own CHANGELOG.md
- Version tags are prefixed to identify the component
- Releases are published separately to their respective platforms:
  - PSDocs and PSDocs.Azure → PowerShell Gallery
  - VS Code Extension → Visual Studio Marketplace

## Development Workflow

### Working on PSDocs.Azure

1. Make changes in `packages/psdocs-azure/`
2. Test locally: `./build.ps1 -Package psdocs-azure -Build -Test`
3. Commit and push - CI will automatically build and test
4. Tag for release: `git tag psdocs-azure-v{version}`

### Working on PSDocs Engine

1. Make changes in `packages/psdocs/`
2. Test locally: `./build.ps1 -Package psdocs -Build -Test`
3. Test PSDocs.Azure still works: `./build.ps1 -Package psdocs-azure -Test`
4. Tag for release: `git tag psdocs-v{version}`

### Working on VS Code Extension

1. Make changes in `packages/vscode-extension/`
2. Test locally: `./build.ps1 -Package vscode -Build`
3. Tag for release: `git tag vscode-v{version}`

## Migration Notes

### Path Updates

All documentation and template paths have been updated in the main README:
- `docs/` → `docs/psdocs-azure/`
- `templates/` → `packages/psdocs-azure/templates/`
- `examples/` → `packages/psdocs-azure/examples/`

### Build Artifacts

Build artifacts are now generated in:
- `packages/psdocs/out/` - PSDocs engine
- `packages/psdocs-azure/out/` - PSDocs.Azure module
- `packages/vscode-extension/*.vsix` - VS Code extension package

### Gitignore Updates

The `.gitignore` has been updated to exclude:
- `packages/*/out/` - Build artifacts from all packages
- `packages/*/node_modules/` - Node.js dependencies
- `packages/*/*.vsix` - VS Code extension packages
- `*.nupkg` - NuGet packages

## Future Subtree Updates

To pull updates from the source repositories later:

```bash
# Update PSDocs engine
git subtree pull --prefix=packages/psdocs https://github.com/microsoft/PSDocs.git main --squash

# Update VS Code extension
git subtree pull --prefix=packages/vscode-extension https://github.com/microsoft/PSDocs-vscode.git main --squash
```

## Workflow Migration

The following legacy workflows were removed as part of the monorepo migration, replaced by new workflows with path-based filtering:

| Removed Workflow | Replacement | Reason |
|-----------------|-------------|--------|
| `build.yaml` | `ci.yml` | Old single-package build; incompatible with monorepo `build.ps1` orchestrator |
| `analyze.yaml` | `codeql.yml` | Replaced with updated CodeQL security scanning workflow |

The following workflows were **kept** as they are independent of the build structure:

| Kept Workflow | Purpose |
|--------------|---------|
| `docs.yaml` | Documentation site generation (publishes to GitHub Pages) |
| `stale.yaml` | Stale issue management (automated issue lifecycle) |

## Questions?

For questions about:
- PSDocs engine: See `packages/psdocs/README.md` (after subtree merge)
- PSDocs.Azure: See `packages/psdocs-azure/src/PSDocs.Azure/README.md`
- VS Code extension: See `packages/vscode-extension/README.md` (after subtree merge)
- Monorepo structure: File an issue on this repository
