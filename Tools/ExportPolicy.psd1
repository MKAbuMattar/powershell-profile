#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Export Policy
#
# Single source of truth for what a module is allowed to export. Read by:
#
#   Tools/Update-Manifest.ps1   generates FunctionsToExport / AliasesToExport from this + the AST
#   Tools/Test-Manifest.ps1     fails CI when a committed manifest drifts from what would be generated
#   Module/Loader/Loader.psm1   applies the same rules at import time
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

@{
    # Functions that exist to support other functions in the same module. They stay internal and
    # are never written into FunctionsToExport.
    PrivateFunctions = @(
        'Get-GitHubDirectoryFiles'
        'Get-DockerComposeCommand'
        'Get-PipCommand'
        'Get-ClockPython'
        'Get-QRCodePython'
        'Invoke-SearchEngine'
        'Show-RsyncProgress'
    )

    # Alias names that must never be exported because a real executable owns them.
    #
    # PowerShell resolves Alias before Application, so exporting any of these silently replaces
    # the tool the user installed. `docker` and `claude` are the sharp cases: WebSearch declared
    # both, which meant `docker ps` opened a browser tab to Docker Hub.
    ReservedAliases  = @(
        'docker'
        'claude'
        'code'
        'git'
        'node'
        'npm'
        'python'
        'pip'
        'kubectl'
        'helm'
        'terraform'
        'aws'
        'gcloud'
        'curl'
        'wget'
        'ssh'
        'sudo'
    )

    # Names owned by the GNU tools that Microsoft coreutils installs. Whether the profile is
    # allowed to take them is a user decision, not a repository default: see PreferNativeTools
    # in profile.config.psd1. Listing them here lets the loader detect the collision at runtime.
    NativeToolNames  = @(
        'cat'
        'cp'
        'date'
        'df'
        'du'
        'echo'
        'env'
        'find'
        'grep'
        'head'
        'hostname'
        'ln'
        'ls'
        'mkdir'
        'mv'
        'printf'
        'pwd'
        'rm'
        'rmdir'
        'sed'
        'seq'
        'sleep'
        'sort'
        'split'
        'stat'
        'tail'
        'tee'
        'test'
        'touch'
        'tr'
        'uniq'
        'uptime'
        'wc'
        'xargs'
    )

    # Built-in PowerShell aliases. A module FUNCTION with one of these names is unreachable,
    # because the built-in alias wins resolution. The loader warns unless the user opts into
    # shadowing via AllowBuiltinShadowing in profile.config.psd1.
    BuiltinAliases   = @(
        'gcb'
        'gcm'
        'gcs'
        'gl'
        'gm'
        'gp'
        'gpv'
        'h'
        'ps'
        'sl'
        'gc'
        'gi'
        'gu'
        'sp'
        'si'
    )
}
