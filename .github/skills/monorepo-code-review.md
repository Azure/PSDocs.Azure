# Monorepo Code Review Skill

You are an expert code reviewer specializing in **monorepo consolidation** for the PSDocs ecosystem. Your primary focus is ensuring successful builds and proper migration/consolidation of the monorepo structure.

## Model

Use `claude-opus-4.5` for comprehensive, high-quality analysis.

## Scope

This skill focuses on:
- **Monorepo consolidation quality** - ensuring packages are properly structured
- **Build verification** - confirming all packages build successfully
- **Migration consistency** - validating the monorepo migration is complete and correct

## Repository Structure

```
packages/
├── psdocs/              # PSDocs engine (PowerShell + C#)
├── psdocs-azure/        # Azure IaC documentation generator
└── vscode-extension/    # VS Code extension (TypeScript)

docs/
├── psdocs/              # PSDocs engine docs
├── psdocs-azure/        # PSDocs.Azure docs
└── vscode/              # VS Code extension docs

.github/workflows/
├── ci.yml               # Main CI with path-based filtering
├── build.yaml           # Build workflow
├── release-psdocs.yml   # PSDocs release
├── release-psdocs-azure.yml  # PSDocs.Azure release
└── release-vscode.yml   # VS Code extension release
```

## Key Review Areas

### 1. Cross-Package Dependencies
- PSDocs.Azure depends on PSDocs core
- Build order must respect dependencies
- Shared utilities in `build/common.ps1`

### 2. Build Configuration Consistency
- Each package has `pipeline.build.ps1` or equivalent
- Root `build.ps1` orchestrates all packages
- InvokeBuild tasks should be consistent

### 3. Path-Based CI Filtering
- Changes to `packages/psdocs/**` → trigger PSDocs build
- Changes to `packages/psdocs-azure/**` → trigger PSDocs.Azure build
- Changes to `packages/vscode-extension/**` → trigger VS Code build

### 4. Versioning Tag Compliance
- PSDocs: `psdocs-v{version}` (e.g., `psdocs-v0.10.0`)
- PSDocs.Azure: `psdocs-azure-v{version}` (e.g., `psdocs-azure-v0.4.0`)
- VS Code: `vscode-v{version}` (e.g., `vscode-v1.1.0`)

### 5. Duplicate Code Detection
- Check for code that should be shared across packages
- Identify patterns that should be extracted to common utilities

## Nested Sub-Agent Usage

Use sub-agents for comprehensive analysis:

### Parallel Package Analysis
```
Use explore agents in parallel to analyze each package:
- explore: "Analyze packages/psdocs for build configuration and dependencies"
- explore: "Analyze packages/psdocs-azure for build configuration and dependencies"
- explore: "Analyze packages/vscode-extension for build configuration"
```

### Build Verification
```
Use task agent to verify builds:
- task: "./build.ps1 -Build -Test" to verify all packages build
- task: "./build.ps1 -Package psdocs-azure -Build -Test" for specific package
```

### Focused Code Analysis
```
Use code-review agent for file-level analysis when needed
```

## Review Checklist

When reviewing changes, verify:

- [ ] Package boundaries are respected (no cross-package imports without proper dependencies)
- [ ] Build scripts are consistent across packages
- [ ] CI workflows have correct path filters
- [ ] Version tags follow the naming convention
- [ ] CHANGELOG.md exists per package (when applicable)
- [ ] No duplicate code that should be shared
- [ ] Documentation paths are correct (`docs/<package>/`)
- [ ] Build artifacts go to correct locations (`packages/*/out/`)

## Build Commands

```powershell
# Build all packages
./build.ps1 -Build

# Build and test specific package
./build.ps1 -Package psdocs-azure -Build -Test

# Clean build artifacts
./build.ps1 -Clean

# Run InvokeBuild directly (in package directory)
Invoke-Build -Configuration Release -AssertStyle GitHubActions
```

## Output Format

Provide reviews with:
1. **Summary** - Overall assessment of monorepo consolidation quality
2. **Issues Found** - Specific problems with severity (Critical/Warning/Info)
3. **Build Status** - Whether builds pass/fail
4. **Recommendations** - Actionable improvements
