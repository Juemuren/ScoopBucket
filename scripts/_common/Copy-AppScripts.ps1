param(
    [Parameter(Mandatory)]
    [string]$Source,

    [Parameter(Mandatory)]
    [string]$Destination
)

Copy-Item -Path (Join-Path $Source '*') -Destination $Destination
