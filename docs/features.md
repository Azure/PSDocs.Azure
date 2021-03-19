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

## Frequently Asked Questions (FAQ)

### Can PSDocs read from metadata.json?

The Azure Quickstart Templates repository uses an additional `metadata.json` to store template metadata.
PSDocs doesn't require a `metadata.json` file to exist but will fallback to this file if it exists.
For details on `metadata.json` see [Azure Resource Manager QuickStart Templates contributing guide].

PSDocs reads `metadata.json` using the following logic:

1. Metadata is loaded from the template `metadata` property.
2. When `metadata.json` exists, properties are merged with the template metadata.
   - Properties included in template metadata override properties included from `metadata.json`.
   - The `$schema` property from `metadata.json` is ignored.
   - For PSDocs to discover `metadata.json` it must exist in the same directory as the template file.
   When creating `metadata.json` use only lowercase in the file name.

The schema of `metadata.json` differs from template metadata.
To maintain compatibility, PSDocs automatically maps the metadata as described in the following table.

metadata.json     |         | Template metadata | Description
-------------     | ------- | ----------------- | ------
`itemDisplayName` | Maps to | `name`            | Used for markdown page title.
`summary`         | Maps to | `summary`         | Used as a short description for the markdown page.
`description`     | Maps to | `description`     | Used as a detailed description for the markdown page.

For example:

- If `name` exists in template metadata, this will take priority over `itemDisplayName` from `metadata.json`.
- If `name` does not exist in template metadata, `itemDisplayName` from `metadata.json` will be used.

### How do I include a badge image?

To include a badge image, create the `.ps-docs/azure-template-badges.md` file.
Within this file add markdown links to your badge image.

Use the following placeholders to reference unique images per template.

- `{{ template_path }}` - The relative path of the template directory.
- `{{ template_path_encoded }}` - The relative path of the template directory URL encoded.

See [about_PSDocs_Azure_Badges] for additional details.

### Can PSDocs generate badges for documentation?

No.
PSDocs can not generate badge images for you.

Once you have generated a badge, PSDocs can include a link to the badge for displaying directly in markdown.

[about_PSDocs_Azure_Badges]: concepts/en-US/about_PSDocs_Azure_Badges.md
[Azure Resource Manager QuickStart Templates contributing guide]: https://github.com/Azure/azure-quickstart-templates/tree/master/1-CONTRIBUTION-GUIDE#metadatajson
