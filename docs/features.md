# PSDocs for Azure features

The following sections describe key features of PSDocs for Azure.

- [Ready to go](#ready-to-go)
- [DevOps](#devops)
- [Cross-platform](#cross-platform)

## Ready to go

PSDocs for Azure automatically generates documentation for Azure infrastructure as code (IaC) artifacts.
It does this by, reading then processing each artifacts with one or more included documentation templates.
Documentation is outputted as _markdown_ a standard easy to read, easy to render format for modern documentation.

Currently the following infrastructure code artifacts are supported:

- Azure Resource Manager (ARM) template files.

As new features are added and improved, download the latest PowerShell module to start using them.

## DevOps

Azure infrastructure code such as ARM template supports a number of ways to self document in code.
PSDocs uses these existing features and makes them easier to consume.

Document generation can be integrated into a continuous integration (CI) pipeline to:

- **Shift-left:** Identify documentation issues and provide fast feedback in pull requests.

## Cross-platform

PSDocs uses modern PowerShell libraries at its core, allowing it to go anywhere PowerShell can go.
PSDocs runs on MacOS, Linux and Windows.

PowerShell makes it easy to integrate PSDocs into popular CI systems.
To install, use the `Install-Module` cmdlet within PowerShell.
For installation options see [install instructions](install-instructions.md).
