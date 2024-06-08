param location string
param aiSearchSku string = 'standard'
param aiSearchName string
param storageAccountName string

resource aiSearch 'Microsoft.Search/searchServices@2024-03-01-preview' = {
  name: aiSearchName
  location: location
  sku: {
    name: aiSearchSku
  }
  properties: {
    hostingMode: 'default'
    partitionCount: 1
    replicaCount: 1
  }
}

resource storageAccount  'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-04-01' = {
  parent: storageAccount
  name: 'default'
}

resource assetsBlobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-04-01' = {
  parent: blobService
  name: 'assets'
  properties: {
    publicAccess: 'Container'
  }
}

resource documentsBlobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-04-01' = {
  parent: blobService
  name: 'documents'
  properties: {
    publicAccess: 'Container'
  }
}

output aiSearchEndpoint string = 'https://portal.azure.com/#@${tenant().tenantId}/resource${aiSearch.id}/overview'
output aiSearchKey string = aiSearch.listQueryKeys().value[0].key
