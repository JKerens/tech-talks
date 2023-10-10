param serverName string
param location string = resourceGroup().location

@description('Required to store the admin password')
param keyvaultName string

@secure()
param administratorLoginPassword string = newGuid()

var firewallRules = [{
  name: 'hcss'
  startIpAddress: parseCidr('0.0.0.0/32')
  endIpAddress: parseCidr('0.0.0.0/32')
}]

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' = {
  name: toLower(serverName)
  location: location
  tags: resourceGroup().tags
  properties: {
    administratorLogin: 'sus-sussudo'
    administratorLoginPassword: administratorLoginPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
  resource sqlDatabase 'databases' = {
    name: 'DB1'
    tags: resourceGroup().tags
    location: location
    properties: {
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      sampleName: 'AdventureWorksLT'
    }
    sku: {
      name: 'GP_S_Gen5_1'
      tier: 'GeneralPurpose'
    }
  }
}

resource azureFirewallRules 'Microsoft.Sql/servers/firewallRules@2015-05-01-preview' = [for (item, index) in firewallRules: {
  parent: sqlServer
  name: item.name
  properties: {
    startIpAddress: item.startIpAddress.firstUsable // Thanks to parseCidr()
    endIpAddress: item.endIpAddress.lastUsable
  }
}]

resource keyvaultRef 'Microsoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyvaultName
  resource addSecret 'secrets' = {
    name: 'my-secret-sauce'
    properties: {
      contentType: 'SQL'
      value: administratorLoginPassword
      attributes: {
        enabled: true
      }
    }
  }
}
