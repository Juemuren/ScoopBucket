# Throws if an installed font is locked by another application.
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Preserve the colored Scoop font lock diagnostics.')]
param(
    [Parameter(Mandatory)]
    [string]$Source,

    [Parameter(Mandatory)]
    [string]$App,

    [switch]$Global
)

$fontInstallDir = if ($global) { "$env:windir\Fonts" } else { "$env:LOCALAPPDATA\Microsoft\Windows\Fonts" }
Get-ChildItem $Source -Filter '*.ttf' | ForEach-Object {
    Get-ChildItem $fontInstallDir -Filter $_.Name | ForEach-Object {
        try {
            Rename-Item $_.FullName $_.FullName -ErrorAction Stop
        }
        catch {
            Write-Host ""
            Write-Host " Error " -Background DarkRed -Foreground White -NoNewline
            Write-Host ""
            Write-Host " Cannot uninstall '$app' font." -Foreground DarkRed
            Write-Host ""
            Write-Host " Reason " -Background DarkCyan -Foreground White -NoNewline
            Write-Host ""
            Write-Host " The '$app' font is currently being used by another application," -Foreground DarkCyan
            Write-Host " so it cannot be deleted." -Foreground DarkCyan
            Write-Host ""
            Write-Host " Suggestion " -Background Magenta -Foreground White -NoNewline
            Write-Host ""
            Write-Host " Close all applications that are using '$app' font (e.g. vscode)," -Foreground Magenta
            Write-Host " and then try again." -Foreground Magenta
            Write-Host ""
            throw "Cannot uninstall '$app': an installed font is in use."
        }
    }
}
