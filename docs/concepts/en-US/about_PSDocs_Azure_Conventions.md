# PSDocs_Azure_Conventions

## about_PSDocs_Azure_Conventions

## SHORT DESCRIPTION

Describes how to use conventions included in `PSDocs.Azure`.

## LONG DESCRIPTION

PSDocs for Azure includes conventions that can be included when generating documentation.
Conventions alter the default pipeline to customize it for a specific situation.

When running `Invoke-PSDocument` add the `-Convention` parameter to specify one or more conventions.
For example:

```powershell
Invoke-PSDocument -Convention 'Azure.NameByParentPath';
```

### Azure.NameByParentPath

This convention can be used to change the default naming for documents.
By default new documents are generated with the `README.md` file name.

When the template file is stored under a well-known path `<name>/<version>/template.json` or `<name>/template.json`.
i.e. `templates/storage/v1/template.json` or `templates/storage/template.json`

The `name` and `version` can be used to name the output file.
The resulting file name is updated to `<name>_<version>.md`.
i.e. `storage_v1.md`

For `version` to be detected, the version sub-directory must start with `v` and be followed by a number.
When the version sub-directory a not detected the resulting file name is updated to `<name>.md`.
i.e. `storage.md`

## NOTE

An online version of this document is available at https://github.com/Azure/PSDocs.Azure/blob/main/docs/concepts/en-US/about_PSDocs_Azure_Conventions.md.

## KEYWORDS

- Convention
- NameByParentPath
