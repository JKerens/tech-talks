@description('''The complete name of the website
- Ensure all prefixes are added already (Example: dev-myapp)
- https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules#microsoftweb''')
@minLength(4)
@maxLength(60)
param appserviceName string

@description('Location for all resources.')
param location string = resourceGroup().location

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appserviceName
  location: location
  kind: 'string'
  tags: resourceGroup().tags
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' existing = {
  name: appserviceName
}

resource appServiceSiteExtension 'Microsoft.Web/sites/siteextensions@2020-06-01' = {
  parent: appService
  // Explicit dependencies are not recommended but sometimes needed
  // I left this to show the functionality (TL;DR avoid when possible)
  // https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/resource-dependencies#explicit-dependency
  name: 'Microsoft.ApplicationInsights.AzureWebSites'
  dependsOn: [
    appInsights
  ]
}

@description('''Warning this can cause an application restart
- Avoid deploying config changes to production
- An option is to try deploying to a slot then swapping to avoid this
''')
resource appServiceLogging 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
  }
  dependsOn: [
    appServiceSiteExtension
  ]
}

resource appServiceAppSettings 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: appService
  name: 'logs'
  properties: {
    applicationLogs: {
      fileSystem: {
        level: 'Warning'
      }
    }
    httpLogs: {
      fileSystem: {
        retentionInMb: 40
        enabled: true
      }
    }
    failedRequestsTracing: {
      enabled: true
    }
    detailedErrorMessages: {
      enabled: true
    }
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: appService.name
  location: location
  tags: resourceGroup().tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 120
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}
