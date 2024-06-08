param location string 
param resourceName string
param skuName string = 'S0'

resource openAIResource 'Microsoft.CognitiveServices/accounts@2023-10-01-preview' = {
  name: resourceName
  location: location
  sku: {
    name: skuName
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: resourceName
    publicNetworkAccess: 'Enabled'
  }
}

resource adaModel 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openAIResource
  name: 'ada002'
  properties: {
    model: {
      format: 'OpenAI'
      name: 'text-embedding-ada-002'
      version: '1'
    }
    raiPolicyName: 'Microsoft.Default'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
  sku: {
    name: 'Standard'
    capacity: 120 
  }
}

resource chatGptModel 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openAIResource
  name: 'gtp4o'
  dependsOn: [
    adaModel
  ]
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: '2024-05-13'
    }
    raiPolicyName: 'Microsoft.Default'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
  sku: {
    name: 'Standard'
    capacity: 20 
  }
}

resource dalle3 'Microsoft.CognitiveServices/accounts/deployments@2023-10-01-preview' = {
  parent: openAIResource
  name: 'dalle3'
  dependsOn: [
    chatGptModel
  ]
  properties: {
    model: {
      format: 'OpenAI'
      name: 'dall-e-3'
      version: '3.0'
    }
    raiPolicyName: 'Microsoft.Default'
    versionUpgradeOption: 'OnceNewDefaultVersionAvailable'
  }
  sku: {
    name: 'Standard'
    capacity: 2
  }
}

output azureStudioUrl string = 'https://oai.azure.com/portal/${openAIResource.properties.internalId}?tenantid=${tenant().tenantId}'
output openAiKey string = openAIResource.listKeys().key1

