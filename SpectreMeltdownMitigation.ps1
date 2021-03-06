#####SPECTRE MELTDOWN#####
#https://support.microsoft.com/en-us/help/4073119/protect-against-speculative-execution-side-channel-vulnerabilities-in
#Enables mitigations for Intel® Transactional Synchronization Extensions (Intel® TSX) Transaction Asynchronous Abort vulnerability (CVE-2019-11135) and Microarchitectural Data Sampling (CVE-2018-11091, CVE-2018-12126, CVE-2018-12127, CVE-2018-12130) along with Spectre (CVE-2017-5753 & CVE-2017-5715) and Meltdown (CVE-2017-5754) variants, including Speculative Store Bypass Disable (SSBD) (CVE-2018-3639) as well as L1 Terminal Fault (L1TF) (CVE-2018-3615, CVE-2018-3620, and CVE-2018-3646) without disabling Hyper-Threading

######SCRIPT FOR FULL INSTALL AND CONFIGURE ON STANDALONE MACHINE#####
#Continue on error
$ErrorActionPreference= 'silentlycontinue'

#Require elivation for script run
#Requires -RunAsAdministrator
Write-Output "Elevating priviledges for this process"
do {} until (Elevate-Privileges SeTakeOwnershipPrivilege)

$GetAnswer = Read-Host "Enable, Disable or Revert Back the Mitigation ? (Type Ena / Dis / Rev)"

If($GetAnswer -eq "Ena") {
    Write-Host "Enabling Mitigation" -ForegroundColor Green
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverride -Type DWORD -Value 72 -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverrideMask -Type DWORD -Value 3 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization" -Name MinVmVersionForCpuBasedMitigations -Type String -Value "1.0" -Force
}
ElseIf($GetAnswer -eq "Dis")
{
    Write-Host "Disable Mitigation" -ForegroundColor Yellow
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverride -Type DWORD -Value 1 -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverrideMask -Type DWORD -Value 3 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization" -Name MinVmVersionForCpuBasedMitigations -Type String -Value "1.0" -Force
}
ElseIf($GetAnswer -eq "Rev")
{
    Write-Host "Revert Back Registry Changes" -ForegroundColor Blue
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverride -Force
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name FeatureSettingsOverrideMask -Force
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization" -Name MinVmVersionForCpuBasedMitigations -Force
}
Else{
    Write-Host "Wrong Input. Please Type Again. Exiting the Program"
}
