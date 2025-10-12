# Scoop Bucket

[![Tests](https://github.com/Juemuren/ScoopBucket/actions/workflows/ci.yml/badge.svg)](https://github.com/Juemuren/ScoopBucket/actions/workflows/ci.yml) [![Excavator](https://github.com/Juemuren/ScoopBucket/actions/workflows/excavator.yml/badge.svg)](https://github.com/Juemuren/ScoopBucket/actions/workflows/excavator.yml)

My bucket for [Scoop](https://scoop.sh), the Windows command-line installer.

Because I was dissatisfied with the installation method of some software in the **official bucket**, I made this bucket for my own use.

## Available manifests

### command-line tools

- git
- graphviz
- juliaup
- miktex
- mise
- postgresql
- rustup

### nerd-fonts

- Sarasa-Mono-SC

## How do I install these manifests?

```pwsh
scoop bucket add <bucket-name> https://github.com/Juemuren/ScoopBucket
scoop install <bucket-name>/<manifest-name>
```
