ghcup install ghc && ghcup set ghc
ghcup install hls && ghcup set hls
ghcup install cabal && ghcup set cabal
ghcup install stack && ghcup set stack

$extra_include_dirs = "`"$env:GHCUP_MSYS2\mingw64\include`""
$extra_lib_dirs = "`"$env:GHCUP_MSYS2\mingw64\lib`""
$extra_prog_path = @(
    "$env:GHCUP_INSTALL_BASE_PREFIX\ghcup\bin"
    "$env:CABAL_DIR\bin"
    "$env:GHCUP_MSYS2\mingw64\bin"
    "$env:GHCUP_MSYS2\usr\bin"
).ForEach({ "`"$_`"" }) -join ', '

cabal user-config update --augment "extra-include-dirs: $extra_include_dirs"
cabal user-config update --augment "extra-lib-dirs: $extra_lib_dirs"
cabal user-config update --augment "extra-prog-path: $extra_prog_path"
