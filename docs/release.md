# Release process for PSDocs for Azure

The following sections describe the process for making a new release.

- Update [CHANGELOG](..\CHANGELOG.MD) with all changes since the last release (including all pre-release versions)
- Submit a Pull Request for review
- Navigate to [Releases](https://github.com/Azure/PSDocs.Azure/releases) and select **Draft a new release**
- [SemVer](https://semver.org/) is used to version the releases.  To use the correct release/tag the following options are used:
  - A stable release: increment from the previous release *e.g. v0.2.0*
  - A pre-release: select the **This is a pre-release** option and select the build version from the previous build in Azure DevOps Pipelines.  This version can be found from previous build run. *E.g.,  for the recent Pull Request go to Pull Request -> Checks -> Analyze -> Azure Pipelines -> PSDocs.Azure-CI Build **[#0.2.0-B2103003](https://github.com/Azure/PSDocs.Azure/pull/52/checks?check_run_id=2066087539)***
  - Wait for the deployment to be released in [PowerShell Gallery](https://www.powershellgallery.com/packages/PSDocs.Azure/)
- After a successful release, create another PR updating:
  - [.azure-pipelines/azure-pipelines.yaml](https://github.com/Azure/PSDocs.Azure/blob/main/.azure-pipelines/azure-pipelines.yaml) with the next version increment *e.g. if the newly released version is 0.2.0, set this to `version: '0.3.0'`*


