[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Preserve the colored Scoop restart notice.')]
param(
    [Parameter(Mandatory)]
    [string]$Source,

    [Parameter(Mandatory)]
    [string]$FontFamily,

    [switch]$Global,

    [switch]$ShowRestartNotice
)

$fontInstallDir = if ($global) { "$env:windir\Fonts" } else { "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" }
$registryRoot = if ($global) { "HKLM" } else { "HKCU" }
$registryKey = "${registryRoot}:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
Get-ChildItem $Source -Filter '*.ttf' | ForEach-Object {
    Remove-ItemProperty -Path $registryKey -Name $_.Name.Replace($_.Extension, ' (TrueType)') -Force -ErrorAction SilentlyContinue
    Remove-Item "$fontInstallDir\$($_.Name)" -Force -ErrorAction SilentlyContinue
}
if ($ShowRestartNotice) {
    Write-Host "The '$FontFamily' Font family has been uninstalled and will not be present after restarting your computer." -Foreground Magenta
}
