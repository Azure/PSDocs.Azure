# PSDocs for Azure

Generate markdown from Azure infrastructure as code (IaC) artifacts.

![ci-badge]

Features of PSDocs for Azure include:

- [Ready to go](docs/features.md#ready-to-go) - Use pre-built templates.
- [DevOps](docs/features.md#devops) - Generate within a continuous integration (CI) pipeline.
- [Cross-platform](docs/features.md#cross-platform) - Run on MacOS, Linux, and Windows.

## Support

This project uses GitHub Issues to track bugs and feature requests.
Please search the existing issues before filing new issues to avoid duplicates.

- For new issues, file your bug or feature request as a new [issue].
- For help, discussion, and support questions about using this project, join or start a [discussion].

If you have any problems with the [PSDocs][engine] engine, please check the project GitHub [issues](https://github.com/BernieWhite/PSDocs/issues) page instead.

Support for this project/ product is limited to the resources listed above.

## Getting the modules

This project requires the `PSDocs` PowerShell module. For details on each see [install].

You can download and install these modules from the PowerShell Gallery.

Module             | Description | Downloads / instructions
------             | ----------- | ------------------------
PSDocs.Azure | Generate documentation from Azure infrastructure as code (IaC) artifacts. | [latest][module] / [instructions][install]

## Getting started

### Building locally

```powershell
./build.ps1
```

### Running locally

```powershell
Import-Module .\out\modules\PSDocs.Azure;

Get-AzDocTemplateFile -Path templates/ | ForEach-Object {
    $template = Get-Item -Path $_.TemplateFile;
    $templateName = $template.Directory.Parent.Name;
    $version = $template.Directory.Name;
    $docName = "$($templateName)_$version";
    Invoke-PSDocument -Module PSDocs.Azure -OutputPath out/docs -InputObject $template.FullName -InstanceName $docName;
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

[issue]: https://github.com/Azure/PSDocs.Azure/issues
[discussion]: https://github.com/Azure/PSDocs.Azure/discussions
[install]: docs/install-instructions.md
[ci-badge]: https://dev.azure.com/PSDocs/PSDocs.Azure/_apis/build/status/PSDocs.Azure-CI?branchName=main
[module]: https://www.powershellgallery.com/packages/PSDocs.Azure
[engine]: https://github.com/BernieWhite/PSDocs
