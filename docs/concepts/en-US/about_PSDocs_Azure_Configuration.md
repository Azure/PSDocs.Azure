# PSDocs_Azure_Configuration

## about_PSDocs_Azure_Configuration

## SHORT DESCRIPTION

Describes PSDocs configuration options specific to `PSDocs.Azure`.

## LONG DESCRIPTION

PSDocs exposes configuration options that can be used to customize execution of document generation.
This topic describes what configuration options are available.

PSDocs configuration options can be specified by setting the configuration option in `ps-docs.yaml`.
Additionally, configuration options can be configured in a baseline or set at runtime.
For details of setting configuration options see [PSDocs options][options]

The following configurations options are available for use:

- [AZURE_USE_PARAMETER_FILE_SNIPPET](#azure_use_parameter_file_snippet)

### AZURE_USE_PARAMETER_FILE_SNIPPET

This configuration option determines if a parameter file snippet is added to documentation.
By default, a snippet is generated.
To prevent a parameter file snippet being generated, set this option to `false`.

Syntax:

```yaml
configuration:
  AZURE_USE_PARAMETER_FILE_SNIPPET: bool # Either true or false
```

Default:

```yaml
# YAML: The default AZURE_USE_PARAMETER_FILE_SNIPPET configuration option
configuration:
  AZURE_USE_PARAMETER_FILE_SNIPPET: true
```

Example:

```yaml
# YAML: Prevent parameter file snippet from being generated
configuration:
  AZURE_USE_PARAMETER_FILE_SNIPPET: false
```


- [AZURE_USE_COMMAND_LINE_SNIPPET](#azure_use_command_line_snippet)

### AZURE_USE_COMMAND_LINE_SNIPPET

This configuration option determines if a command line snippet is added to documentation.
By default, this command line snippet is not generated.
To generate command line snippet, set this option to `true`.

Syntax:

```yaml
configuration:
  AZURE_USE_COMMAND_LINE_SNIPPET: bool # Either true or false
```

Default:

```yaml
# YAML: The default AZURE_USE_COMMAND_LINE_SNIPPET configuration option is to disable generation
configuration:
  AZURE_USE_COMMAND_LINE_SNIPPET: false
```

Example:

```yaml
# YAML: To enable command line snippet
configuration:
  AZURE_USE_COMMAND_LINE_SNIPPET: true
```

## NOTE

An online version of this document is available at https://github.com/Azure/PSDocs.Azure/blob/main/docs/concepts/en-US/about_PSDocs_Azure_Configuration.md.

## KEYWORDS

- Configuration
- Document
- Snippet

[options]: https://github.com/BernieWhite/PSDocs/blob/main/docs/concepts/PSDocs/en-US/about_PSDocs_Configuration.md
