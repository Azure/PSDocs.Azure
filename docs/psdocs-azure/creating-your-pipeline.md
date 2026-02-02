# Creating your pipeline

You can use PSDocs for Azure to generate documentation from within a continuous integration (CI) pipeline.

!!! Abstract
    This topic covers creating a pipeline to automatically build documentation with PSDocs for Azure.
    The pipeline:

    - Installs the `PSDocs.Azure` module
    - Generates markdown for each Azure template in the `templates/` sub-directory.

Within the root directory of your Infrastructure as Code (IaC) repository:

=== "GitHub Actions"

    Create a new GitHub Actions workflow by creating `.github/workflows/publish-docs.yaml`.
    Add the following code to the workflow file.

    ```yaml
    name: Publish docs
    on:
      push:
        branches: [ main ]
    jobs:
      publish:
        name: Publish
        runs-on: ubuntu-latest
        steps:

        - uses: actions/checkout@v2

        # Generate markdown files using PSDocs
        # Scan for Azure template file recursively in sub-directories
        # Then generate a docs using a standard naming convention. i.e. <name>_<version>.md
        - name: Generate docs
          uses: microsoft/ps-docs@main
          with:
            conventions: Azure.NameByParentPath
            modules: PSDocs,PSDocs.Azure
            inputPath: templates/
            outputPath: out/docs/
            prerelease: true
    ```

    This will automatically install compatible versions of all dependencies.

=== "Azure Pipelines"

    Create a new Azure DevOps YAML pipeline by creating `.azure-pipelines/publish-docs.yaml`.
    Add the following code to the YAML pipeline file.

    ```yaml
    jobs:
    - job: 'Publish'
      displayName: 'Generate ARM template docs'
      pool:
        vmImage: 'windows-2019'
      steps:

      # Generate markdown files using PSDocs
      # Scan for Azure template file recursively in the templates/ directory
      # Then generate a docs using a standard naming convention. i.e. <name>_<version>.md
      - powershell: |
          Install-Module -Name 'PSDocs.Azure' -Repository PSGallery -Force;
          Get-AzDocTemplateFile -Path templates/ | ForEach-Object {
            Invoke-PSDocument -Module PSDocs.Azure -OutputPath out/docs/ -InputObject $_.TemplateFile -Convention 'Azure.NameByParentPath';
          }
        displayName: 'Generate docs'
    ```

    This will automatically install compatible versions of all dependencies.
