targetScope = 'subscription'

param location string
param rgName string
param aiSearchSku string
param aiSearchName string = 'ai-search-workshop'
param storageAccountName string
param openaiName string = 'openai-workshop'
param openaiSku string = 'S0'

resource rg 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: location
}

module aiSearch './modules/aisearch.bicep' = {
  name: 'aiSearch'
  scope: rg
  params: {
    aiSearchName: aiSearchName
    storageAccountName: storageAccountName
    location: location
    aiSearchSku: aiSearchSku
  }
}

module openAI './modules/openai.bicep' = {
  name: 'openAI'
  scope: rg
  params: {
    location: location
    resourceName: openaiName
    skuName: openaiSku
  }
}

output aiSearchEndpoint string = aiSearch.outputs.aiSearchEndpoint
output aiSearchKey string = aiSearch.outputs.aiSearchKey
output azureStudioUrl string = openAI.outputs.azureStudioUrl
output openAiKey string = openAI.outputs.openAiKey
