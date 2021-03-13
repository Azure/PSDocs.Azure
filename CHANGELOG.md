# Change log

## Unreleased

What's changed since v0.2.0:

- New Features:
  - Added support for naming document by parent path using conventions. [#43](https://github.com/Azure/PSDocs.Azure/issues/43)
    - Add the `-Convention` parameter with `Azure.NameByParentPath` to use.
    - See [about_PSDocs_Azure_Conventions] for details.
- General improvements:
  - Added support for reading template metadata from `metadata.json`. [#32](https://github.com/Azure/PSDocs.Azure/issues/32)
    - This adds additional compatibility for the Azure Quickstart templates repository.
    - Additional metadata from `metadata.json` will be read when it exists.
    - Template metadata take priority over `metadata.json`.
  - Added support for the `summary` template metadata property. [#60](https://github.com/Azure/PSDocs.Azure/issues/60)
    - The `summary` template metadata property is intended to provide a short description of the template.
    - Use the `description` template metadata property to provide a detailed description of the template.

## v0.2.0

What's changed since v0.1.0:

- New Features:
  - Added the ability to enable manual command line snippet. [#40](https://github.com/Azure/PSDocs.Azure/issues/40)
    - To enable parameter file snippet set configuration `AZURE_USE_COMMAND_LINE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.
  - Added the ability to disable parameter file snippet. [#31](https://github.com/Azure/PSDocs.Azure/issues/31)
    - To disable parameter file snippet set configuration `AZURE_USE_PARAMETER_FILE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.
  - Added the ability to include badges in template document. [#30](https://github.com/Azure/PSDocs.Azure/issues/30)
    - Set the `.ps-docs/azure-template-badges.md` file to include badge content.
    - See [about_PSDocs_Azure_Badges] for details.
  - Template outputs are added to generated document. [#28](https://github.com/Azure/PSDocs.Azure/issues/28)
- General Improvements
  - Minor update to the documentation to include OutputPath to generate README.md [#50](https://github.com/Azure/PSDocs.Azure/issues/50)
- Engineering:
  - Bump PSDocs dependency to v0.8.0. [#42](https://github.com/Azure/PSDocs.Azure/issues/42)
- Bug fixes:
  - Fixed snippet with short relative template causes exception. [#26](https://github.com/Azure/PSDocs.Azure/issues/26)
  - Fixed cannot bind argument when metadata name is not set. [#35](https://github.com/Azure/PSDocs.Azure/issues/35)

What's changed since pre-release v0.2.0-B2102012:

- No additional changes.

## v0.2.0-B2102012 (pre-release)

What's changed since pre-release v0.2.0-B2102005:

- New features:
  - Added the ability to enable manual command line snippet. [#40](https://github.com/Azure/PSDocs.Azure/issues/40)
    - To enable parameter file snippet set configuration `AZURE_USE_COMMAND_LINE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.

## v0.2.0-B2102005 (pre-release)

What's changed since pre-release v0.2.0-B2101002:

- New features:
  - Added the ability to disable parameter file snippet. [#31](https://github.com/Azure/PSDocs.Azure/issues/31)
    - To disable parameter file snippet set configuration `AZURE_USE_PARAMETER_FILE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.
  - Added the ability to include badges in template document. [#30](https://github.com/Azure/PSDocs.Azure/issues/30)
    - Set the `.ps-docs/azure-template-badges.md` file to include badge content.
    - See [about_PSDocs_Azure_Badges] for details.
- Engineering:
  - Bump PSDocs dependency to v0.8.0. [#42](https://github.com/Azure/PSDocs.Azure/issues/42)

## v0.2.0-B2101002 (pre-release)

What's changed since v0.1.0:

- New features:
  - Template outputs are added to generated document. [#28](https://github.com/Azure/PSDocs.Azure/issues/28)
- Bug fixes:
  - Fixed snippet with short relative template causes exception. [#26](https://github.com/Azure/PSDocs.Azure/issues/26)
  - Fixed cannot bind argument when metadata name is not set. [#35](https://github.com/Azure/PSDocs.Azure/issues/35)

## v0.1.0

- Initial release.

What's changed since pre-release v0.1.0-B2012006:

- New features:
  - Added `Get-AzDocTemplateFile` cmdlet to scan for template files within a path. [#16](https://github.com/Azure/PSDocs.Azure/issues/16)
- General improvements:
  - Added support for document localization and JSON snippet formatting. [#18](https://github.com/Azure/PSDocs.Azure/issues/18)
- Engineering:
  - Bump PSDocs dependency to v0.7.0.

## v0.1.0-B2012006 (pre-release)

- Initial pre-release.

[about_PSDocs_Azure_Configuration]: docs/concepts/en-US/about_PSDocs_Azure_Configuration.md
[about_PSDocs_Azure_Badges]: docs/concepts/en-US/about_PSDocs_Azure_Badges.md
[about_PSDocs_Azure_Conventions]: docs/concepts/en-US/about_PSDocs_Azure_Conventions.md
