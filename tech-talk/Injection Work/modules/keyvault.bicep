@minLength(3)
@maxLength(24)
param keyvaultName string
param appserviceName string
param location string = resourceGroup().location

resource appserviceRef 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appserviceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyvaultName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    accessPolicies: []
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
  resource addIdentityScope 'accessPolicies' = {
    name: 'add'
    properties: {
      accessPolicies: [
        {
          tenantId: appserviceRef.identity.tenantId
          objectId: appserviceRef.identity.principalId
          permissions: {
            secrets:[
              'get'
              'list'
            ]
          }
        }
      ] 
    }
  }
}

output keyvaultName string = keyVault.name
