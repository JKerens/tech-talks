param serverName string
param databaseName string

resource sqlServer 'Microsoft.Sql/servers@2019-06-01-preview' existing = {
  name: toLower(serverName)
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' existing = {
  parent: sqlServer
  name: databaseName

  resource salesSchema 'schemas' existing = {
    name: 'SalesLT'

    resource customerTable 'tables' existing = {
      name: 'Customer'

      resource emailColumn 'columns' existing = {
        name: 'EmailAddress'
      }
    }
  }
}

resource sensitivityLabel 'Microsoft.Sql/servers/databases/schemas/tables/columns/sensitivityLabels@2021-11-01' = {
  parent: sqlDatabase::salesSchema::customerTable::emailColumn
  name: 'current'
  properties: {
    rank: 'None'
    labelName: 'Public'
    informationType: 'Contact Info'
  }
}

output labels object = sensitivityLabel
