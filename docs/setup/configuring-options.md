# Configuring options

PSDocs for Azure comes with many configuration options.
Additionally, the PSDocs engine includes several options that apply to all rules.
You can visit the [about_PSDocs_Options][1] topic to read about general PSDocs options.

  [1]: https://github.com/microsoft/PSDocs/blob/main/docs/concepts/PSDocs/en-US/about_PSDocs_Options.md

## Setting options

Configuration options are set within the `ps-docs.yaml` file.
If you don't already have a `ps-docs.yaml` file you can create one in the root of your repository.

Configuration can be combined as indented keys.
Use comments to add context.
Here are some examples:

```yaml
configuration:
  # Show command line snippet
  AZURE_USE_COMMAND_LINE_SNIPPET: true

  # Hide parameter file snippet
  AZURE_PARAMETER_FILE_EXPANSION: false
```

!!! Tip
    YAML can be a bit particular about indenting.
    If something is not working, double check that you have consistent spacing in your options file.
