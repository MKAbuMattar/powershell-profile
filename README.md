# My PowerShell Profile

A modular PowerShell profile: plugins for the tools I use, utilities backed by small Python scripts, and a loader that only loads what I ask it to.

## Table of Contents

- [Quick Setup (Windows)](#quick-setup-windows)
- [Configuring what loads](#configuring-what-loads)
- [Name conflicts](#name-conflicts)
- [Modules](#modules)
- [Development](#development)
- [Contributing](#contributing)

## Quick Setup (Windows)

```powershell
irm "https://raw.githubusercontent.com/MKAbuMattar/powershell-profile/main/setup.ps1" | iex
```

Then install what the profile depends on:

```powershell
Install-ProfileDependency            # Gallery modules and CLI tools
Install-ProfileDependency -IncludePython   # also the Python packages
```

`Install-ProfileDependency -WhatIf` lists what it would install without installing anything.

## Configuring what loads

Everything the profile loads is named in [`profile.config.psd1`](./profile.config.psd1). This is the
counterpart to the `PLUGINS` / `UTILS` / `ALIASES` arrays in my `.zshrc`. Comment a name out and it
stops loading; nothing loads unless it is listed.

```powershell
Plugins = @(
    'Git'
    'Docker'
    # 'Terragrunt'      <- commented out, never parsed
)
```

Plugins are also gated on their tool. With `SkipMissingTools = $true`, the Kubectl plugin costs
nothing on a machine without `kubectl`, so leaving it enabled is harmless.

To see what a change cost or saved:

```powershell
Measure-ProfileLoad          # what loaded, slowest first
Measure-ProfileLoad -All     # including plugins skipped for a missing tool
```

To see what commands you actually have:

```powershell
Show-ProfileHelp                        # every loaded module
Show-ProfileHelp -Section Git           # one module
Show-ProfileHelp -Section Git -Detailed # with a description of each command
```

`Show-ProfileHelp` reads the live session, so it can only show commands that really loaded.

## Name conflicts

A shell profile that defines nine hundred aliases will collide with things you already have. Three
kinds of collision are handled explicitly, all configurable in `profile.config.psd1`.

**Reserved names.** Some aliases would take a name a real executable owns. `docker` and `claude`
were both declared by the WebSearch module, which meant `docker ps` opened a browser tab. Names on
the reserved list in [`Tools/ExportPolicy.psd1`](./Tools/ExportPolicy.psd1) are never exported.

**Native tools.** If you have [Microsoft coreutils](https://github.com/microsoft/coreutils)
installed, `grep`, `head`, `tail`, `touch` and `sed` are real GNU tools. `PreferNativeTools = $true`
leaves those names alone. Set it to `$false` to get the PowerShell implementations instead; they
are always available under their full names (`Get-ContentMatching`, `Get-FileHead`, and so on).

**Built-in aliases.** Seven Git plugin functions are named after built-in PowerShell aliases:
`gcb gcm gcs gl gm gp gpv`. PowerShell resolves an alias before a function, so `gl` runs
`Get-Location`, not `git pull`. `AllowBuiltinShadowing = $true` removes those built-ins so the Git
functions win, matching zsh. It defaults to `$false`, and the loader tells you which commands are
affected.

## Modules

- [Directory](./Module/Directory/README.md)
- [Environment](./Module/Environment/README.md)
- [Loader](./Module/Loader/README.md)
- [Logging](./Module/Logging/README.md)
- [Network](./Module/Network/README.md)
- [Plugins](./Module/Plugins/README.md)
- [Process](./Module/Process/README.md)
- [Starship](./Module/Starship/README.md)
- [Update](./Module/Update/README.md)
- [Utility](./Module/Utility/README.md)

## Development

Export lists are generated, not maintained by hand. After adding, renaming or removing a function:

```powershell
./Tools/Update-Manifest.ps1      # regenerate FunctionsToExport / AliasesToExport
```

These checks run in CI and can be run locally:

| Check | What it catches |
| --- | --- |
| `./Tools/Test-Syntax.ps1` | A file that does not parse. A stray backslash once killed the whole WebSearch module silently. |
| `./Tools/Test-Manifest.ps1` | A manifest that no longer matches its code. Kubectl once exported 91 functions nobody had written. |
| `./Tools/Test-Load.ps1` | A module that parses but will not import, such as Conda's malformed GUID. |
| `./Tools/Test-Pipeline.ps1` | A `ValueFromPipeline` parameter with no `process` block, which silently keeps only the last piped item. |
| `./Tools/Test-Readme.ps1` | A module README whose command table no longer matches the code. |
| `./Tools/Invoke-Analyzer.ps1` | PSScriptAnalyzer findings, using [`PSScriptAnalyzerSettings.psd1`](./PSScriptAnalyzerSettings.psd1). |
| `./Tools/Invoke-Pester.ps1` | The load contract in [`Tests/`](./Tests) — tests over manifests, imports, alias safety and pipeline behaviour. |

Three helpers apply fixes rather than report them:

| Tool | Purpose |
| --- | --- |
| `./Tools/Update-Manifest.ps1` | Regenerate every export list from source. Run after adding or renaming a function. |
| `./Tools/Update-Readme.ps1` | Regenerate every module README's command table from comment-based help. |
| `./Tools/Add-ProcessBlock.ps1` | Wrap pipeline-bound function bodies in a `process` block. |

Comment-based help is the single source of truth for documentation. The command table in each
module README sits between `<!-- BEGIN GENERATED COMMANDS -->` and
`<!-- END GENERATED COMMANDS -->`; everything outside those markers is hand-written and preserved.

`Test-ProfileAliasContention` reports aliases claimed by more than one loaded module — PNPM,
Pipenv and Poetry all want the `p*` namespace, and load order decides the winner.

## Contributing

See [CONTRIBUTING](.github/CONTRIBUTING.md).

## License

MIT. See [LICENSE](./LICENSE).
