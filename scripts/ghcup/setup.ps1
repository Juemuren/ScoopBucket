param(
    [switch]$ConfigureOnly
)

if (!$ConfigureOnly) {
    ghcup install ghc && ghcup set ghc
    ghcup install hls && ghcup set hls
    ghcup install cabal && ghcup set cabal
    ghcup install stack && ghcup set stack
}

# Quoted Cabal paths must not contain unescaped Windows backslashes.
$msys_path = $env:GHCUP_MSYS2.Replace('\', '/')
$ghcup_path = $env:GHCUP_INSTALL_BASE_PREFIX.Replace('\', '/')
$cabal_path = $env:CABAL_DIR.Replace('\', '/')
$extra_include_dirs = "`"$msys_path/mingw64/include`""
$extra_lib_dirs = "`"$msys_path/mingw64/lib`""
$extra_prog_path = @(
    "$ghcup_path/ghcup/bin"
    "$cabal_path/bin"
    "$msys_path/mingw64/bin"
    "$msys_path/usr/bin"
).ForEach({ "`"$_`"" }) -join ', '

cabal user-config update --augment "extra-include-dirs: $extra_include_dirs"
cabal user-config update --augment "extra-lib-dirs: $extra_lib_dirs"
cabal user-config update --augment "extra-prog-path: $extra_prog_path"
