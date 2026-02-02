# Configuring snippets

PSDocs for Azure supports a number of snippets that can be included in documentation.
This feature can be enabled by using the following configuration options.

## Configuration

!!! Tip
    Each of these configuration options are set within the `ps-docs.yaml` file.
    To learn how to set configuration options see [Configuring options][1].

  [1]: configuring-options.md

### Skip function default value parameters

:octicons-milestone-24: v0.4.0

This configuration option determines if parameters with a function defaultValue are included in snippets.
By default, a parameters with a function default value are not included in snippets.
i.e. If a parameter default value is set to `[resourceGroup.location]` it is not included in snippets.

Syntax:

```yaml
configuration:
  AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN: bool # Either true or false
```

Default:

```yaml
# YAML: The default AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN configuration option
configuration:
  AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN: true
```

Example:

```yaml
# YAML: Include parameters with a function default value in snippets.
configuration:
  AZURE_SNIPPET_SKIP_DEFAULT_VALUE_FN: false
```

### Skip optional parameters

:octicons-milestone-24: v0.4.0

This configuration option determines optional parameters are included in snippets.
By default, optional parameters are included in snippets.
To ignore optional parameter, set this option to `false`.

Syntax:

```yaml
configuration:
  AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER: bool # Either true or false
```

Default:

```yaml
# YAML: The default AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER configuration option
configuration:
  AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER: false
```

Example:

```yaml
# YAML: Do not include optional parameters in snippets
configuration:
  AZURE_SNIPPET_SKIP_OPTIONAL_PARAMETER: true
```

### Parameter file snippet

:octicons-milestone-24: v0.2.0

This configuration option determines if a parameter file snippet is added to documentation.
By default, a snippet is generated.
To prevent a parameter file snippet being generated, set this option to `false`.

Syntax:

```yaml
configuration:
  AZURE_USE_PARAMETER_FILE_SNIPPET: bool
```

Default:

```yaml
# YAML: The default AZURE_USE_PARAMETER_FILE_SNIPPET configuration option
configuration:
  AZURE_USE_PARAMETER_FILE_SNIPPET: false
```

Example:

```yaml
# YAML: Set the AZURE_USE_PARAMETER_FILE_SNIPPET configuration option to enable expansion
configuration:
  AZURE_USE_PARAMETER_FILE_SNIPPET: true
```

### Command line snippet

:octicons-milestone-24: v0.2.0

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
