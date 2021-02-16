# Change log

## Unreleased

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
