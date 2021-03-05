# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()

# The 'IsPastDue' porperty is 'true' when the current function invocation is later than scheduled.
if ($Timer.IsPastDue) {
    Write-Host "PowerShell timer is running late!"
}

# Write an information log with the current time.
Write-Host "PowerShell timer trigger function ran! TIME: $currentUTCtime"

Write-Host "Github Action"
$RG = New-AzResourceGroup -Name ben-func-work3 -Location "South Central US" -Force

Invoke-webrequest -uri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/101-functions-managed-identity/azuredeploy.json -OutFile "$env:temp\template.json"

$template = "$env:temp\template.json"

#$RG = New-AzResourceGroup -Name ben-func-work2 -Location "South Central US" -Force

$principal = New-AzResourceGroupDeployment -Name Func-Work -ResourceGroupName ben-func-work3 -TemplateFile $template  

$Context = Get-AzContext

New-AzRoleAssignment -ObjectId "$($principal.Outputs.Values.value)" -RoleDefinitionName Contributor -Scope "/subscriptions/$($Context.Subscription)"


