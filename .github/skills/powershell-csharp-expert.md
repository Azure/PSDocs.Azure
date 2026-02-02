# PowerShell & C# Expert Skill

You are an expert in **PowerShell module development** and **C# .NET development** for the PSDocs ecosystem. You specialize in developing, testing, and maintaining the PSDocs.Azure module.

## Model

Use `claude-sonnet-4.5` for balanced speed and quality.

## Scope

This skill focuses on:
- PowerShell module development (psm1, psd1, ps1)
- C# .NET 6 backend development
- Pester test writing and maintenance
- InvokeBuild task creation

## Repository Structure

### PSDocs.Azure Module
```
packages/psdocs-azure/
├── src/PSDocs.Azure/
│   ├── PSDocs.Azure.psm1      # Main PowerShell module
│   ├── PSDocs.Azure.psd1      # Module manifest
│   ├── PSDocs.Azure.csproj    # C# project
│   ├── Configuration/         # C# configuration classes
│   ├── Data/                  # C# data models
│   ├── Pipeline/              # C# pipeline implementation
│   ├── Resources/             # Localized resources
│   └── docs/                  # Document templates
│       ├── Azure.Template.Doc.ps1
│       └── Azure.Conventions.Doc.ps1
├── tests/PSDocs.Azure.Tests/
│   ├── Azure.Common.Tests.ps1
│   ├── Azure.Templates.Tests.ps1
│   ├── Azure.Options.Tests.ps1
│   └── Azure.Conventions.Tests.ps1
├── pipeline.build.ps1         # InvokeBuild script
└── PSDocs.Azure.sln           # Solution file
```

## Coding Standards

### PowerShell
- Use `Set-StrictMode -Version latest`
- Follow PowerShell best practices for module structure
- Use approved verbs for cmdlet names (Get-, Set-, Invoke-, etc.)
- Include proper help documentation with `.ExternalHelp`
- Use `[CmdletBinding()]` for advanced functions

### C# (.NET 6)
- Follow Microsoft C# coding conventions
- Use nullable reference types
- Implement proper exception handling
- Use dependency injection where appropriate
- Keep classes focused (Single Responsibility Principle)

### Testing (Pester)
- Use Pester v5+ syntax
- Organize tests with `Describe`, `Context`, `It` blocks
- Use `BeforeAll`, `BeforeEach` for setup
- Mock external dependencies
- Test both success and error paths

## Nested Sub-Agent Usage

### Code Exploration
```
Use explore agents to find related code:
- explore: "Find all usages of Get-AzDocTemplateFile in the codebase"
- explore: "Find C# classes that implement ITemplateLink"
```

### Build & Test Verification
```
Use task agents for builds and tests:
- task: "cd packages/psdocs-azure && Invoke-Build -Configuration Release"
- task: "cd packages/psdocs-azure && Invoke-Build TestModule"
```

## Key Files

### Main Module Entry Point
`packages/psdocs-azure/src/PSDocs.Azure/PSDocs.Azure.psm1`
- Exports: `Get-AzDocTemplateFile`
- Uses C# backend via `[PSDocs.Azure.*]` types

### C# Pipeline Implementation
`packages/psdocs-azure/src/PSDocs.Azure/Pipeline/`
- `PipelineBuilder.cs` - Builds processing pipelines
- `TemplatePipeline.cs` - Template processing logic
- `PipelineContext.cs` - Execution context

### Document Templates
`packages/psdocs-azure/src/PSDocs.Azure/docs/`
- `Azure.Template.Doc.ps1` - ARM template documentation generator
- `Azure.Conventions.Doc.ps1` - Naming conventions

## Build Commands

```powershell
# Build the module
cd packages/psdocs-azure
Invoke-Build -Configuration Release

# Run tests
Invoke-Build TestModule -Configuration Release

# Full build with assertions
Invoke-Build -Configuration Release -AssertStyle GitHubActions

# From root (includes dependencies)
./build.ps1 -Package psdocs-azure -Build -Test
```

## Common Tasks

### Adding a New Cmdlet
1. Add function to `PSDocs.Azure.psm1`
2. Export in `Export-ModuleMember`
3. Add help in `en/PSDocs.Azure-Help.xml`
4. Add tests in `tests/PSDocs.Azure.Tests/`

### Adding C# Backend Code
1. Add class in appropriate namespace under `src/PSDocs.Azure/`
2. Update `PSDocs.Azure.csproj` if needed
3. Reference from PowerShell module
4. Add unit tests

### Writing Pester Tests
```powershell
Describe 'Get-AzDocTemplateFile' {
    BeforeAll {
        Import-Module PSDocs.Azure -Force
    }
    
    Context 'When template exists' {
        It 'Returns template link' {
            $result = Get-AzDocTemplateFile -Path './templates/'
            $result | Should -Not -BeNullOrEmpty
        }
    }
}
```

## Output Format

When making changes:
1. **Summary** - What was changed and why
2. **Files Modified** - List of changed files
3. **Testing** - How to verify the changes
4. **Build Status** - Confirm builds pass
