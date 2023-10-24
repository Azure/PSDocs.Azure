---
author: BernieWhite
---

# Installation

PSDocs for Azure supports running within continuous integration (CI) systems or locally.
It is shipped as a PowerShell module which makes it easy to install and distribute updates.

## Running within CI

Continue reading [creating your pipeline][1] to learn more.

  [1]: creating-your-pipeline.md

## Installing locally

PSDocs for Azure can be installed locally from the PowerShell Gallery using PowerShell.
You can also use this option to install on CI workers that are not natively supported.

The following platforms are supported:

- Windows PowerShell 5.1 with .NET Framework 4.7.2 or greater.
- PowerShell 7.3 or greater on MacOS, Linux, and Windows.

PSDocs for Azure requires the PSDocs PowerShell module.
The required version of PSDocs will automatically be installed along-side PSDocs for Azure.

### Installing PowerShell

PowerShell 7.x can be installed on MacOS, Linux, and Windows but is not installed by default.
For a list of platforms that PowerShell 7.3 is supported on and install instructions see [Get PowerShell][3].

  [3]: https://github.com/PowerShell/PowerShell#get-powershell

### Getting the modules

[:octicons-download-24: Module][module]

PSDocs for Azure can be installed or updated from the PowerShell Gallery.
Use the following command line examples from a PowerShell terminal to install or update PSDocs for Azure.

=== "For the current user"
    To install PSDocs for Azure for the current user use:

    ```powershell
    Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope CurrentUser
    ```

    To update PSDocs for Azure for the current user use:

    ```powershell
    Update-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope CurrentUser
    ```

    This will automatically install compatible versions of all dependencies.

=== "For all users"
    To install PSDocs for Azure for all users (requires admin/ root permissions) use:

    ```powershell
    Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope AllUsers
    ```

    To update PSDocs for Azure for all users (requires admin/ root permissions) use:

    ```powershell
    Update-Module -Name 'PSDocs.Azure' -Repository PSGallery -Scope AllUsers
    ```

    This will automatically install compatible versions of all dependencies.

### Pre-release versions

To use a pre-release version of PSDocs for Azure add the `-AllowPrerelease` switch when calling `Install-Module`,
`Update-Module`, or `Save-Module` cmdlets.

!!! tip
    To install pre-release module versions, the latest version of _PowerShellGet_ may be required.

    ```powershell
    # Install the latest PowerShellGet version
    Install-Module -Name PowerShellGet -Repository PSGallery -Scope CurrentUser -Force
    ```

### Building from source

[:octicons-file-code-24: Source][5]

PSDocs for Azure is provided as open source on GitHub.
To build PSDocs for Azure from source code:

1. Clone the GitHub [repository][5].
2. Run `./build.ps1` from a PowerShell terminal in the cloned path.

This build script will compile the module and documentation then output the result into `out/modules/PSDocs.Azure`.

  [5]: https://github.com/Azure/PSDocs.Azure.git

#### Development dependencies

The following PowerShell modules will be automatically install if the required versions are not present:

- PlatyPS
- Pester
- PSScriptAnalyzer
- PowerShellGet
- PackageManagement
- InvokeBuild

These additional modules are only required for building PSDocs for Azure.

Additionally .NET Core SDK v3.1 is required.
.NET Core will not be automatically downloaded and installed.
To download and install the latest SDK see [Download .NET Core 3.1][dotnet].

### Limited access networks

If you are on a network that does not permit Internet access to the PowerShell Gallery,
download the required PowerShell modules on an alternative device that has access.
PowerShell provides the `Save-Module` cmdlet that can be run from a PowerShell terminal to do this.

The following command lines can be used to download the required modules using a PowerShell terminal.
After downloading the modules, copy the module directories to devices with restricted Internet access.

=== "Runtime modules"
    To save PSDocs for Azure for offline use:

    ```powershell
    $modules = @('PSDocs', 'PSDocs.Azure')
    Save-Module -Name $modules -Path '.\modules'
    ```

    This will save PSDocs for Azure and all dependencies into the `modules` sub-directory.

=== "Development modules"
    To save PSDocs for Azure development module dependencies for offline use:

    ```powershell
    $modules = @('PSDocs', 'PlatyPS', 'Pester', 'PSScriptAnalyzer',
      'PowerShellGet', 'PackageManagement', 'InvokeBuild')
    Save-Module -Name $modules -Repository PSGallery -Path '.\modules';
    ```

    This will save required developments dependencies into the `modules` sub-directory.

*[CI]: continuous integration

[module]: https://www.powershellgallery.com/packages/PSDocs.Azure
[dotnet]: https://dotnet.microsoft.com/download/dotnet-core/3.1
