$config_path = "$env:MSYS_ROOT\etc\nsswitch.conf"
(Get-Content $config_path) -replace '^db_home:.*$', 'db_home: windows' | Set-Content $config_path -Encoding ascii

msys2 -c 'pacman --needed --noconfirm -S zsh'
