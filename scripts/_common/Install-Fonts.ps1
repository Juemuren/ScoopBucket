[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Preserve the colored Scoop installation guidance.')]
param(
    [Parameter(Mandatory)]
    [string]$Source,

    [Parameter(Mandatory)]
    [string]$App,

    [switch]$Global
)

$currentBuildNumber = [int] (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuildNumber
$windows10Version1809BuildNumber = 17763
$isPerUserFontInstallationSupported = $currentBuildNumber -ge $windows10Version1809BuildNumber
if (!$isPerUserFontInstallationSupported -and !$global) {
    scoop uninstall $app
    Write-Host ""
    Write-Host "For Windows version before Windows 10 Version 1809 (OS Build 17763)," -Foreground DarkRed
    Write-Host "Font can only be installed for all users." -Foreground DarkRed
    Write-Host ""
    Write-Host "Please use following commands to install '$app' Font for all users." -Foreground DarkRed
    Write-Host ""
    Write-Host "        scoop install sudo"
    Write-Host "        sudo scoop install -g $app"
    Write-Host ""
    throw "Per-user font installation is not supported on this Windows version."
}
$fontInstallDir = if ($global) { "$env:windir\Fonts" } else { "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" }
if (-not $global) {
    # Ensure user font install directory exists and has correct permission settings
    # See https://github.com/matthewjberger/scoop-nerd-fonts/issues/198#issuecomment-1488996737
    New-Item $fontInstallDir -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    $accessControlList = Get-Acl $fontInstallDir
    $allApplicationPackagesAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.SecurityIdentifier]::new("S-1-15-2-1"), "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
    $allRestrictedApplicationPackagesAccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule([System.Security.Principal.SecurityIdentifier]::new("S-1-15-2-2"), "ReadAndExecute", "ContainerInherit,ObjectInherit", "None", "Allow")
    $accessControlList.SetAccessRule($allApplicationPackagesAccessRule)
    $accessControlList.SetAccessRule($allRestrictedApplicationPackagesAccessRule)
    Set-Acl -AclObject $accessControlList $fontInstallDir
}
$registryRoot = if ($global) { "HKLM" } else { "HKCU" }
$registryKey = "${registryRoot}:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
Get-ChildItem $Source -Filter '*.ttf' | ForEach-Object {
    $value = if ($global) { $_.Name } else { "$fontInstallDir\$($_.Name)" }
    New-ItemProperty -Path $registryKey -Name $_.Name.Replace($_.Extension, ' (TrueType)') -Value $value -Force | Out-Null
    Copy-Item -LiteralPath $_.FullName -Destination $fontInstallDir
}
