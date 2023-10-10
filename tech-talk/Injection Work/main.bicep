//////////////////////
// Entry 
//////////////////////
metadata description = 'Creates a appservice'
targetScope = 'subscription'

@description('''Used in the template to match up deployments.
```csharp
string foo = "yo";
```''')
param deploymentId string = deployment().name

@allowed([
  'Dev'
  'Prod'
])
param environment string

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
// Business Logic
//////////////////////
var appFullName = toLower('${environment}-${application}')
var resourceGroupName = appFullName

// New Concept
// Great for values that NEVER CHANGE between deployments (Example: team email)
var config = loadJsonContent('../shared/constants.json')

var tags = {
  Product: config.Product
}

//////////////////////
// The Work 
//////////////////////
resource myResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  tags: tags
  location: location
}

module appserviceDeployment 'modules/appservice.bicep' = {
  scope: myResourceGroup
  name: '${deploymentId}-appservice'
  params: {
    appserviceName: appFullName
    location: myResourceGroup.location
    skuCapacity: 1
    skuName: 'B1'
  }
}

module monitorDeployment 'modules/monitor.bicep' = {
  scope: myResourceGroup
  name: '${deploymentId}-monitor'
  params: {
    appserviceName: appserviceDeployment.outputs.appServiceName
    location: myResourceGroup.location
  }
}

module keyvaultDeployment 'modules/keyvault.bicep' = {
  scope: myResourceGroup
  name: '${deploymentId}-vault'
  params: {
    appserviceName: appserviceDeployment.outputs.appServiceName
    keyvaultName: appserviceDeployment.outputs.appServiceName
    location: myResourceGroup.location
  }
}

module sqlDeployment 'modules/sql.bicep' = {
  scope: myResourceGroup
  name: '${deploymentId}-sql'
  params: {
    keyvaultName: keyvaultDeployment.outputs.keyvaultName
    serverName: appserviceDeployment.outputs.appServiceName
    location: myResourceGroup.location
  }
}

module sqlSensLabelDeployment 'modules/sql-sensitivity-labels.bicep' = {
  scope: myResourceGroup
  name: '${deploymentId}-sql-label'
  params: {
    databaseName: sqlDeployment.outputs.sqlDatabaseName
    serverName: sqlDeployment.outputs.sqlServerName
  }
}

//////////////////////
// The Results
//////////////////////
@description('''Great for: 
- Scripting next steps based on outputs  
- When working with Bicep modules''')
output resourceGroupName string = myResourceGroup.name
