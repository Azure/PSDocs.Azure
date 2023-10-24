# Change log

## Unreleased

What's changed since pre-release v0.4.0-B2107030:

- General improvements:
  - Add support for BRM schema changes by @jtracey93.
    [#258](https://github.com/Azure/PSDocs.Azure/pull/258)
  - Add support for min/max values and length for arrays/string properties by @Gabriel123N.
    [#263](https://github.com/Azure/PSDocs.Azure/pull/263)
- Engineering:
  - Bump Newtonsoft.Json to v13.0.3.
    [#241](https://github.com/Azure/PSDocs.Azure/pull/241)

## v0.4.0-B2107030 (pre-release)

What's changed since pre-release v0.4.0-B2107016:

- Engineering:
  - Bump PSDocs to v0.9.0.
    [#102](https://github.com/Azure/PSDocs.Azure/issues/102)

## v0.4.0-B2107016 (pre-release)

What's changed since pre-release v0.4.0-B2107004:

- General improvements:
  - Secret string parameters now include an example Key Vault reference.
    [#94](https://github.com/Azure/PSDocs.Azure/issues/94)
  - Improved output of parameter object default values.
    [#84](https://github.com/Azure/PSDocs.Azure/issues/84)
    - Default values and allowed values now appear in a code block.
  - Allow optional parameters to be skipped in snippet.
    [#96](https://github.com/Azure/PSDocs.Azure/issues/96)
    - To exclude optional parameters from snippets configure `AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER`.
    - See [about_PSDocs_Azure_Configuration] for details.
- Bug fixes:
  - Ignore function default values in snippets.
    [#95](https://github.com/Azure/PSDocs.Azure/issues/95)
    - To include parameters using a function default value configure `AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN`.
    - See [about_PSDocs_Azure_Configuration] for details.

## v0.4.0-B2107004 (pre-release)

What's changed since v0.3.0:

- New Features:
  - Automatically detect templates in a scan path.
    [#85](https://github.com/Azure/PSDocs.Azure/issues/85)
    - To scan templates use `Invoke-PSDocument` with `-InputPath`.

## v0.3.0

What's changed since v0.2.0:

- New Features:
  - Added support for naming document by parent path using conventions.
    [#43](https://github.com/Azure/PSDocs.Azure/issues/43)
    - Add the `-Convention` parameter with `Azure.NameByParentPath` to use.
    - See [about_PSDocs_Azure_Conventions] for details.
- General improvements:
  - Added support for reading template metadata from `metadata.json`.
    [#32](https://github.com/Azure/PSDocs.Azure/issues/32)
    - This adds additional compatibility for the Azure Quickstart templates repository.
    - Additional metadata from `metadata.json` will be read when it exists.
    - Template metadata take priority over `metadata.json`.
  - Added support for the `summary` template metadata property.
    [#60](https://github.com/Azure/PSDocs.Azure/issues/60)
    - The `summary` template metadata property is intended to provide a short description of the template.
    - Use the `description` template metadata property to provide a detailed description of the template.
  - Added ability to detect required or optional for each parameter.
    [#55](https://github.com/Azure/PSDocs.Azure/issues/55)
    - Detects if parameter is either _Optional_ or _Required_ based on the availability of `DefaultValue` or `AllowedValues`.
    - Added a _Required_ column in the parameters table.
    - Added _Required_ and _Optional_ badge for each parameter in the detailed parameter section.

What's changed since pre-release v0.3.0-B2103037:

- No additional changes.

## 0.3.0-B2103037 (pre-release)

What's changed since pre-release v0.3.0-B2103011:

- General improvements:
  - Added ability to detect required or optional for each parameter.
    [#55](https://github.com/Azure/PSDocs.Azure/issues/55)
    - Detects if parameter is either _Optional_ or _Required_ based on the availability of `DefaultValue` or `AllowedValues`.
    - Added a _Required_ column in the parameters table.
    - Added _Required_ and _Optional_ badge for each parameter in the detailed parameter section.

## v0.3.0-B2103011 (pre-release)

What's changed since v0.2.0:

- New Features:
  - Added support for naming document by parent path using conventions.
    [#43](https://github.com/Azure/PSDocs.Azure/issues/43)
    - Add the `-Convention` parameter with `Azure.NameByParentPath` to use.
    - See [about_PSDocs_Azure_Conventions] for details.
- General improvements:
  - Added support for reading template metadata from `metadata.json`.
    [#32](https://github.com/Azure/PSDocs.Azure/issues/32)
    - This adds additional compatibility for the Azure Quickstart templates repository.
    - Additional metadata from `metadata.json` will be read when it exists.
    - Template metadata take priority over `metadata.json`.
  - Added support for the `summary` template metadata property.
    [#60](https://github.com/Azure/PSDocs.Azure/issues/60)
    - The `summary` template metadata property is intended to provide a short description of the template.
    - Use the `description` template metadata property to provide a detailed description of the template.

## v0.2.0

What's changed since v0.1.0:

- New Features:
  - Added the ability to enable manual command line snippet.
    [#40](https://github.com/Azure/PSDocs.Azure/issues/40)
    - To enable parameter file snippet set configuration `AZURE_USE_COMMAND_LINE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.
  - Added the ability to disable parameter file snippet.
    [#31](https://github.com/Azure/PSDocs.Azure/issues/31)
    - To disable parameter file snippet set configuration `AZURE_USE_PARAMETER_FILE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.
  - Added the ability to include badges in template document.
    [#30](https://github.com/Azure/PSDocs.Azure/issues/30)
    - Set the `.ps-docs/azure-template-badges.md` file to include badge content.
    - See [about_PSDocs_Azure_Badges] for details.
  - Template outputs are added to generated document.
    [#28](https://github.com/Azure/PSDocs.Azure/issues/28)
- General Improvements
  - Minor update to the documentation to include OutputPath to generate README.md.
    [#50](https://github.com/Azure/PSDocs.Azure/issues/50)
- Engineering:
  - Bump PSDocs to v0.8.0.
    [#42](https://github.com/Azure/PSDocs.Azure/issues/42)
- Bug fixes:
  - Fixed snippet with short relative template causes exception.
    [#26](https://github.com/Azure/PSDocs.Azure/issues/26)
  - Fixed cannot bind argument when metadata name is not set.
    [#35](https://github.com/Azure/PSDocs.Azure/issues/35)

What's changed since pre-release v0.2.0-B2102012:

- No additional changes.

## v0.2.0-B2102012 (pre-release)

What's changed since pre-release v0.2.0-B2102005:

- New features:
  - Added the ability to enable manual command line snippet.
    [#40](https://github.com/Azure/PSDocs.Azure/issues/40)
    - To enable parameter file snippet set configuration `AZURE_USE_COMMAND_LINE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.

## v0.2.0-B2102005 (pre-release)

What's changed since pre-release v0.2.0-B2101002:

- New features:
  - Added the ability to disable parameter file snippet.
    [#31](https://github.com/Azure/PSDocs.Azure/issues/31)
    - To disable parameter file snippet set configuration `AZURE_USE_PARAMETER_FILE_SNIPPET`.
    - See [about_PSDocs_Azure_Configuration] for details.
  - Added the ability to include badges in template document.
    [#30](https://github.com/Azure/PSDocs.Azure/issues/30)
    - Set the `.ps-docs/azure-template-badges.md` file to include badge content.
    - See [about_PSDocs_Azure_Badges] for details.
- Engineering:
  - Bump PSDocs to v0.8.0.
    [#42](https://github.com/Azure/PSDocs.Azure/issues/42)

## v0.2.0-B2101002 (pre-release)

What's changed since v0.1.0:

- New features:
  - Template outputs are added to generated document.
    [#28](https://github.com/Azure/PSDocs.Azure/issues/28)
- Bug fixes:
  - Fixed snippet with short relative template causes exception.
    [#26](https://github.com/Azure/PSDocs.Azure/issues/26)
  - Fixed cannot bind argument when metadata name is not set.
    [#35](https://github.com/Azure/PSDocs.Azure/issues/35)

## v0.1.0

- Initial release.

What's changed since pre-release v0.1.0-B2012006:

- New features:
  - Added `Get-AzDocTemplateFile` cmdlet to scan for template files within a path.
    [#16](https://github.com/Azure/PSDocs.Azure/issues/16)
- General improvements:
  - Added support for document localization and JSON snippet formatting.
    [#18](https://github.com/Azure/PSDocs.Azure/issues/18)
- Engineering:
  - Bump PSDocs to v0.7.0.

## v0.1.0-B2012006 (pre-release)

- Initial pre-release.

[about_PSDocs_Azure_Configuration]: docs/concepts/en-US/about_PSDocs_Azure_Configuration.md
[about_PSDocs_Azure_Badges]: docs/concepts/en-US/about_PSDocs_Azure_Badges.md
[about_PSDocs_Azure_Conventions]: docs/concepts/en-US/about_PSDocs_Azure_Conventions.md
