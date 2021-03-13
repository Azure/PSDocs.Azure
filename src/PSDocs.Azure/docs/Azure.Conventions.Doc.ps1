# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Synopsis: Name documents by parent path.
Export-PSDocumentConvention 'Azure.NameByParentPath' {
    $template = Get-Item -Path $PSDocs.TargetObject;

    # Get parent directory paths where <name>/v<version>/template.json
    $version = $template.Directory.Name;
    $name = $template.Directory.Parent.Name;

    # Name the document <name>_<version>.md
    $docName = $version;
    if ($version -like 'v[0-9]*') {
        $docName = [String]::Concat($name, '_', $version);
    }
    $PSDocs.Document.InstanceName = $docName;
}
