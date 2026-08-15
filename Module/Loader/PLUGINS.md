# Writing a plugin

A plugin adds commands to the profile. It can live inside this repository or, more usefully,
outside it — where `Update-Profile` will never touch it.

## Quick start

```powershell
New-ProfilePlugin -Name Gradle -Tool gradle -Description 'Gradle shortcuts'
Enable-ProfilePlugin Gradle
```

Restart your shell. That is the whole loop.

The scaffold lands in `~/.config/powershell-profile/plugins/Gradle/` and contains a working
command you can edit.

## Why not just drop it in `Module/Plugins`?

Because `Update-LocalProfileModuleDirectory` moves the entire `Module` tree aside and replaces it
from the release archive. Anything you added there ends up in `Module.old` and stops loading, with
no warning. That is why plugins are discovered from several roots, only one of which is inside the
repository.

## Where plugins are found

Searched in order, and **later roots win**:

| Order | Root | Scope | Survives an update |
| --- | --- | --- | --- |
| 1 | `Module/Plugins` | `Builtin` | No — replaced wholesale |
| 2 | `~/.config/powershell-profile/plugins` | `User` | Yes |
| 3 | Each entry in `$env:PROFILE_PLUGIN_PATH` | `Environment` | Yes |

Because later wins, naming your plugin after a built-in **overrides** it — so you can replace the
`Git` plugin with your own without forking the repository. The loader says so at startup:

```
note: plugin 'VSCode' from User overrides the Builtin one
```

`Get-ProfilePlugin` shows every plugin found, its scope, and what it shadows.

## The contract

A plugin is a directory containing `plugin.psd1`:

```powershell
@{
    Name                  = 'Gradle'
    Description           = 'Gradle shortcuts'
    Tool                  = 'gradle'
    Module                = 'Gradle.psd1'
    MinimumProfileVersion = '5.1.0'
    LazyCommands          = @()
}
```

Only `Name` is required, and even that defaults to the directory name.

| Key | Meaning |
| --- | --- |
| `Name` | Display name and the name used in `profile.config.psd1`. |
| `Description` | One line, shown by `Get-ProfilePlugin`. |
| `Tool` | Executable that must exist. With `SkipMissingTools = $true` the plugin is skipped when it is absent, so a plugin for a tool you have not installed costs nothing. |
| `Module` | Manifest to import. Defaults to `<Name>.psd1`. |
| `MinimumProfileVersion` | The plugin is skipped, with a warning, against an older profile. |
| `LazyCommands` | Commands that import the plugin on first use rather than at startup. |

A built-in plugin has no `plugin.psd1`; the loader falls back to `<Name>.psd1` and looks the tool
up in its own table. Both forms work.

## Lazy commands

```powershell
LazyCommands = @('gradle', 'gw')
```

Each name becomes a stub. On first call the stub removes every stub for that plugin, imports the
real module, and re-invokes the command. You get the command; you do not pay for the import in
shells that never use it.

This is opt-in per plugin, deliberately. A plugin that fails to import will now fail at the moment
you first use it, rather than at startup — which is a worse place to find out. Use it for plugins
that are expensive and rarely touched, not for ones whose failure you would rather see immediately.

**Do not use it for commands that shadow core cmdlets.** Stubbing `Get-ChildItem` to defer
Terminal-Icons hung the shell during startup, because module auto-loading and tab completion both
depend on it. Gallery modules are deferred to the first prompt instead — see
`DeferExternalModules` in `profile.config.psd1`.

## Enabling and disabling

```powershell
Get-ProfilePlugin                 # everything found
Enable-ProfilePlugin Gradle
Disable-ProfilePlugin Kubectl     # comments it out rather than deleting the line
```

Both edit the `Plugins` array in `profile.config.psd1` through the syntax tree, so every comment
and every commented-out plugin in that file survives. Editing the file by hand remains perfectly
fine.

Changes apply on the next shell. Nothing is imported mid-session, because importing halfway
through gives a different result from a clean start.

## Conventions worth following

- **Do not name a command after a case-variant of another.** PowerShell is case-insensitive here
  and zsh is not; `gcb` and `gcB` collapse onto each other and one silently disappears.
  `Tools/Test-Duplicate.ps1` fails the build on this.
- **Do not claim a name a real executable owns.** `docker` and `claude` were both exported as
  aliases once, which meant `docker ps` opened a browser tab. See `ReservedAliases` in
  `Tools/ExportPolicy.psd1`.
- **Give every parameter marked `ValueFromPipeline` a `process` block**, or only the last piped
  item is used. `Tools/Test-Pipeline.ps1` checks this.
- **Write real comment-based help.** The README command tables are generated from it.
