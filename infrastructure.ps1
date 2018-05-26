<#
 .SYNOPSIS
    Deploys a template to Azure

 .DESCRIPTION
    Deploys an Azure Resource Manager template

 .PARAMETER subscriptionId
    The subscription id where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter values based on template.
#>
#========================================================================
param(
 [Parameter(Mandatory=$True)]
 [string]
 $subscriptionId,

 [Parameter(Mandatory=$True)]
 [string]
 $resourceGroupName,

 [string]
 $resourceGroupLocation,

 [Parameter(Mandatory=$True)]
 [string]
 $deploymentName,

 [string]
 $templateFilePath = "template.json",

 [string]
 $parametersFilePath = "parameters.json"
)

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************

$ErrorActionPreference = "Stop"

# sign in
Write-Host "Logging in...";
Login-AzureRmAccount;

#Connect-AzureRmAccount

# select subscription
Write-Host "Selecting subscription '$subscriptionId'";
Get-AzureRmSubscription
Select-AzureRmSubscription -SubscriptionID $subscriptionId;

#========================================================================

$rgname = "datalakeproj"
$location = "uksouth"
$projecttag = "datalakeproj"
$vmname = "datalakeprojvm" `

$templatePath = "vmtemplate.json"
$parametersPath = "vmparam.json"


# Set the name of the storage account and the SKU name. 
$storageAccountName = "datalakeprojstorage"
$skuName = "Standard_LRS"


#========================================================================

#Create or check for existing resource group
$resourceGroup = Get-AzureRmResourceGroup -Name $rgname -ErrorAction SilentlyContinue
if(!$resourceGroup)
{
    Write-Host "Resource group '$resourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$location) {
        $location = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$rgname' in location '$location'";
    New-AzureRmResourceGroup `
        -Name $rgname `
        -Location $location `
        -Tag @{Project=$projecttag}
}
else{
    Write-Host "Using existing resource group '$rgname'";
}


#Get-AzureRMResourceGroup | ft
#where {$_.Tags.Name -contains "AutoShutdownSchedule"}

Get-AzureRmResourceGroup | where ResourceGroupName -eq $rgname

# Create the storage account.
$storageAccount = New-AzureRmStorageAccount -ResourceGroupName $rgname `
  -Name $storageAccountName `
  -Location $location `
  -SkuName $skuName
<#
New-AzureRmResourceGroupDeployment `
    -ResourceGroupName $rgname `
    -Name $vmname `
    -TemplateUri $templatePath `
    -TemplateParameterUri $parametersPath
#>

# Start the deployment

Write-Host "Starting VM deployment...";
if(Test-Path $parametersPath) {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $rgname `
        -TemplateFile $templatePath `
        -TemplateParameterFile $parametersPath;
} else {
    New-AzureRmResourceGroupDeployment -ResourceGroupName $rgname `
    -TemplateFile $templatePath;
}

#******************************************************************************
# Cleanup section
# 
#******************************************************************************
#dladmin-Gibkolomaz7!
Remove-AzureRmResourceGroup -Name $rgname
