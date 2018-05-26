#========================================================================

Connect-AzureRmAccount
Get-AzureRmSubscription

#========================================================================

$rgname = "datalakeproj"
$location = "uksouth"
$projecttag = "datalakeproj"

#========================================================================

New-AzureRmResourceGroup `
   -Name $rgname `
   -Location $location `
   -Tag @{Project=$projecttag}

#Get-AzureRMResourceGroup | ft
#where {$_.Tags.Name -contains "AutoShutdownSchedule"}

Get-AzureRmResourceGroup | where ResourceGroupName -eq $rgname

#========================================================================

Remove-AzureRmResourceGroup -Name $rgname
