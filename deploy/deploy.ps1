$result = az deployment sub create -l eastus -f .\bicep\template.bicep --parameters location=eastus | ConvertFrom-Json
$stAccountName = 'stexpechws'
az storage blob upload --account-name $stAccountName --container-name assets --name to-analyze.png --file ./assets/to-analyze.png --auth-mode login --overwrite
az storage blob upload --account-name $stAccountName --container-name documents --name go-from-the-beginning.pdf --file .\assets\go-from-the-beginning.pdf --auth-mode login --overwrite
"openAIKey: $($result.properties.outputs.openAiKey.value)"
"azureAISearchKey: $($result.properties.outputs.aiSearchKey.value)"
"azureAIEndpoint: $($result.properties.outputs.aiSearchEndpoint.value)"
"azureAIStudio: $($result.properties.outputs.azureStudioUrl.value)"

