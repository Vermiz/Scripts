#Script for removing devices (phones) from AAD that have not contacted our tenant for more than 30 days.
#if you want delete all device like Windows delete line: -and $_.DeviceOSType -notlike "Windows"

#Microsoft Docmunetation: https://docs.microsoft.com/pl-pl/azure/active-directory/devices/manage-stale-devices
#Github: https://github.com/Vermiz/Scripts

#Requirements:
#1. Module: AzureAD
#2. Folder name "m365" on disk c:

#Connect
Connect-AzureAD

#Number of days without contact
$deletionTresholdDays= 30
#Date convert
$datestring = (Get-Date).ToString(“s”).Replace(“:”,”-“)
$deletionTreshold= (Get-Date).AddDays(-$deletionTresholdDays)
#Device list
$allDevices=Get-AzureADDevice -All:$true | Where {$_.ApproximateLastLogonTimeStamp -le $deletionTreshold -and $_.DeviceOSType -notlike "Windows"}
#Export device for remove
$exportPath="c:\m365\devicelist-olderthan-30days-AAD_$datestring.csv"
$allDevices | Select-Object -Property DisplayName, ObjectId, ApproximateLastLogonTimeStamp, DeviceOSType, DeviceOSVersion, AccountEnabled, DeviceId, DeviceTrustType, IsCompliant, IsManaged `
| Export-Csv $exportPath -UseCulture -NoTypeInformation

Write-Output "Report for delete device location: $exportPath"

$confirmDelete=$null
#Accept if you want remove device
while ($confirmDelete -notmatch "[y|n]"){

    $confirmDelete = Read-Host "Delete all Azure AD devices which haven't contacted your tenant since $deletionTresholdDays days (Y/N)?"
    
}

if ($confirmDelete -eq "y"){

    $allDevices | ForEach-Object {

        Write-Output "Remove device... $($PSItem.ObjectId)"
        Remove-AzureADDevice -ObjectId $PSItem.ObjectId
        
    }

} else {
   
    Write-Output "Exit..."
}