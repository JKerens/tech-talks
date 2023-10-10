@description('''Markdown friendly ^_^
```csharp
// WHAAAAAT?!
string foo = "yo";
```
```powershell
$foo = Get-Process -Name "Bicep.exe"
```''')
param deploymentName string = deployment().name

// Example
// module brExample 'br/public:ai/bing-resource:1.0.2' = {

// }

