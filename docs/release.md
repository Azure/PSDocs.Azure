# Release process for PSDocs for Azure

The following sections describe the process for making a new release.

- Update [CHANGELOG](..\CHANGELOG.MD) with all changes since the last release (including all pre-release versions)
- Submit a Pull Request for review
- Navigate to [Releases](https://github.com/Azure/PSDocs.Azure/releases) and select **Draft a new release**
- SemVer is used to version the releases.  To use the correct release/tag the following options are used:
  - A stable release: increment from the previous release e.g. v0.2.0
  - A pre-release: the last release plus a suffix of `<B><Year><Month>0<date>` e.g. v0.2.0<b>B2102012</b>
- Wait for the deployment to be released in [PowerShell Gallery](https://www.powershellgallery.com/packages/PSDocs.Azure/)
- After a successful release, create another PR updating:
  - [.azure-pipelines/azure-pipelines.yaml](https://github.com/Azure/PSDocs.Azure/blob/main/.azure-pipelines/azure-pipelines.yaml) with the next version increment e.g. if the newly released version is 0.2.0 then set it to `version: '0.3.0'`


