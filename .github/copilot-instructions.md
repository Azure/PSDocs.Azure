# Copilot Instructions for PSDocs.Azure Monorepo

## Code Review Guidelines

When performing a code review, prioritize CI/CD correctness, build scripts, and monorepo structure changes.

### Focus review comments on:
- `build.ps1` - Root build orchestrator
- `build/common.ps1` - Shared build utilities
- `.github/workflows/**` - CI/CD workflows
- `.github/skills/**` - Copilot skills
- `packages/psdocs-azure/**` - Core PSDocs.Azure module
- `MONOREPO_MIGRATION.md` - Migration documentation

### Treat these paths as imported/vendored (git subtree). Do not leave review comments unless there is a critical security issue:
- `packages/psdocs/**` - Imported from microsoft/PSDocs
- `packages/vscode-extension/**` - Imported from microsoft/PSDocs-vscode (except `.github/workflows/` changes)

## Build System

This is a PowerShell-based monorepo using InvokeBuild:

```powershell
# Build all packages
./build.ps1 -Build

# Build specific package
./build.ps1 -Package psdocs-azure -Build -Test
```

## Versioning

Each component uses independent versioning with prefixed tags:
- PSDocs: `psdocs-v{version}`
- PSDocs.Azure: `psdocs-azure-v{version}`
- VS Code Extension: `vscode-v{version}`

## CI/CD

Path-based filtering triggers builds only for changed packages:
- `packages/psdocs/**` → PSDocs build
- `packages/psdocs-azure/**` → PSDocs.Azure build
- `packages/vscode-extension/**` → VS Code extension build
