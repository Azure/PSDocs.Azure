# PSDocs for Azure

Generate markdown from Azure infrastructure as code (IaC) artifacts.

![ci-badge]

## Getting started

### Building locally

```powershell
./build.ps1
```

### Running locally

```powershell
Import-Module .\out\modules\PSDocs.Azure;

$publishPath = Join-Path -Path . -ChildPath out/docs/;
foreach ($template in (Get-ChildItem -Path templates/ -Filter template.json -Recurse -File)) {
    $parentPath = $template.Directory.FullName;
    $templateName = $template.Directory.Parent.Name;
    $version = $template.Directory.Name;
    $docName = "$($templateName)_$version";
    Invoke-PSDocument -Module PSDocs.Azure -OutputPath $publishPath -InputObject $template.FullName -InstanceName $docName -Name 'README' -Verbose;
}
```

## Changes and versioning

Modules in this repository will use the [semantic versioning](http://semver.org/) model to declare breaking changes from v1.0.0.
Prior to v1.0.0, breaking changes may be introduced in minor (0.x.0) version increments.
For a list of module changes please see the [change log](CHANGELOG.md).

> Pre-release module versions are created on major commits and can be installed from the PowerShell Gallery.
> Pre-release versions should be considered experimental.
> Modules and change log details for pre-releases will be removed as standard releases are made available.

## Contributing

This project welcomes contributions and suggestions.
If you are ready to contribute, please visit the [contribution guide](CONTRIBUTING.md).

## Code of Conduct

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/)
or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Maintainers

- [Bernie White](https://github.com/BernieWhite)
- [Vic Perdana](https://github.com/vicperdana)

## License

This project is [licensed under the MIT License](LICENSE).

[issue]: https://github.com/https://github.com/Azure/PSDocs.Azure/issues
[install]: docs/scenarios/install-instructions.md
[ci-badge]: https://dev.azure.com/bewhite/PSDocs.Azure/_apis/build/status/PSDocs.Azure-CI?branchName=main
[module]: https://www.powershellgallery.com/packages/PSDocs.Azure
[engine]: https://github.com/BernieWhite/PSDocs
