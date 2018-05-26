$PSVersionTable.PSVersion
Get-AzureSubscription
Import-Module PowerShellGet
Install-Module PowerShellGet -Force

Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Get-Module -Name PowerShellGet -ListAvailable | Select-Object -Property Name,Version,Path

# Install the Azure Resource Manager modules from the PowerShell Gallery
Install-Module -Name AzureRM -AllowClobber -Force
Install-Module -Name AzureRM  -Force

Get-ExecutionPolicy
Get-ExecutionPolicy -List
Save-Module -Name PowerShellGet -Path 'C:\install\ps'


$env:ProgramFiles\WindowsPowerShell\Modules\PowerShellGet\
$env:ProgramFiles\WindowsPowerShell\Modules\PackageManagement\

Connect-AzureRmAccount
Get-AzureRmSubscription
get-azurermvm
Get-AzureRMResourceGroup | ft

