//////////////////////
// Metadata Section 
//////////////////////
metadata description = 'Creates a appservice'





//////////////////////
// Scope Section 
//////////////////////
targetScope = 'subscription'





//////////////////////
// Param Section 
//////////////////////
@allowed([
  'Dev'
  'Prod'
])
param environment string = 'Dev'

@description('''The resource\'s name
- Helpful bullets using markdown 
  - Makes for less guess work''')
@minLength(3)
@maxLength(11)
param application string = 'my-app'

@description('''deployment().location will not work if scoped to a resourceGroup.
Use resourceGroup().location instead in those scenarios.
''')
param location string = deployment().location







//////////////////////
// Var Section 
//////////////////////
var resourceGroupName = toLower('${environment}-${application}')
var tags = {
  Product: 'Good for cost reports'
}





//////////////////////
// Resource Section 
//////////////////////
resource myResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  tags: tags
  location: location
}





//////////////////////
// Output Section 
//////////////////////
@description('''Great for: 
- Scripting next steps based on outputs  
- When working with Bicep modules''')
output resourceGroupName string = myResourceGroup.name
