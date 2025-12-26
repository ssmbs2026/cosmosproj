param location string = resourceGroup().location
param accountName string = 'cosmos-${uniqueString(resourceGroup().id)}'
param databaseName string = 'FileStorageDb'

resource cosmosAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: accountName
  location: location
  kind: 'MongoDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    enableFreeTier: true    // IMPORTANT: Enable Free Tier
    locations: [
      {
        locationName: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    apiProperties: {
      serverVersion: '4.2'
    }
    capabilities: [
      {
        name: 'EnableMongo'
      }
    ]
  }
}

resource database 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2024-05-15' = {
  parent: cosmosAccount
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2024-05-15' = {
  parent: database
  name: 'fs.files' // Common name for GridFS or generic file storage
  properties: {
    resource: {
      id: 'fs.files'
      shardKey: {
        _id: 'Hash'
      }
      indexes: [
        {
          key: {
            keys: [
              '_id'
            ]
          }
        }
      ]
    }
    options: {
      throughput: 400 // Minimum throughput
    }
  }
}

output cosmosAccountName string = cosmosAccount.name
output cosmosConnectionString string = cosmosAccount.listConnectionStrings().connectionStrings[0].connectionString
