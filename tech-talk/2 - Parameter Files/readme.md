# Notes

If you run into an issue using the `-TemplateParameterFile` parameter you can use bicep to compile the parameter file before using it.

```powershell
bicep build-params .\dev.bicepparam
New-AzDeployment -Name "$((New-Guid).Guid)" -Location eastus -TemplateFile '.\main.bicep' -TemplateParameterFile '.\dev.json' -WhatIf
```
