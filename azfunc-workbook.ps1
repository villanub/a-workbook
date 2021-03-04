Connect-AzAccount 

Invoke-webrequest -uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-functions-managed-identity/azuredeploy.json -OutFile "$env:temp\template.json"

$template = "$env:temp\template.json"

$RG = New-AzResourceGroup -Name ben-func-work2 -Location "South Central US" -Force

$principal = New-AzResourceGroupDeployment -Name Func-Work -ResourceGroupName ben-func-work2 -TemplateFile $template  

$Context = Get-AzContext

New-AzRoleAssignment -ObjectId "$($principal.Outputs.Values.value)" -RoleDefinitionName Contributor -Scope "/subscriptions/$($Context.Subscription)"

