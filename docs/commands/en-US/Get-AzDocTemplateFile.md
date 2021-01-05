---
external help file: PSDocs.Azure-help.xml
Module Name: PSDocs.Azure
online version: https://github.com/Azure/PSDocs.Azure/blob/main/docs/commands/en-US/Get-AzDocTemplateFile.md
schema: 2.0.0
---

# Get-AzDocTemplateFile

## SYNOPSIS

Get Azure template files.

## SYNTAX

```text
Get-AzDocTemplateFile [[-InputPath] <String[]>] [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

Gets any Azure Resource Manager (ARM) template files found within the search path.
By default, the current working path is used.

When a JSON file is found the schema is compared to determine if it is a valid ARM template file.
JSON files without a valid schema are ignored.

## EXAMPLES

### Example 1

```powershell
PS C:\> Get-AzDocTemplateFile
```

Get a list of template files within the current working directory.

## PARAMETERS

### -InputPath

A filter for finding template files within the search path.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: f, TemplateFile, FullName

Required: False
Position: 1
Default value: *.json
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: True
```

### -Path

The path to search for template files within.
By default, the current working path is used.

```yaml
Type: String
Parameter Sets: (All)
Aliases: p

Required: False
Position: 0
Default value: $PWD
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### PSDocs.Azure.Data.Metadata.ITemplateLink

## NOTES

## RELATED LINKS
