//based on https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.web/web-app-loganalytics/main.bicep

@description('''The complete name of the website
- Ensure all prefixes are added already (Example: dev-myapp)
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftweb''')
@minLength(2)
@maxLength(60)
param appserviceName string

/*
Or you could do this and make max length 60 - 11 - 1 = 59 (extra minus 1 for the dash in dev + '-' + app.com)
@allowed([
  'Production' // Length 10 chars
  'Development' // Length 11 chars
])
param environment string
*/

@description('Which Pricing tier our App Service Plan to')
@allowed([
  'B1'
  'S1'
  'P1V2'
])
param skuName string = 'S1'

@description('How many instances of our app service will be scaled out to')
param skuCapacity int = 1

@description('Location for all resources.')
param location string = resourceGroup().location

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appserviceName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  tags: resourceGroup().tags
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: appserviceName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: resourceGroup().tags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
    }
  }
}

output appServiceName string = appService.name
