#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Load Configuration
#
# This is the PowerShell counterpart to the PLUGINS / UTILS / ALIASES arrays in .zshrc.
# Comment a name out to stop loading it. Nothing loads unless it is listed here.
#
# After editing, run `Measure-ProfileLoad` to see what the change cost or saved.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

@{
    #-----------------------------------------------------------------------------------------------
    # Core modules. These are not tool-gated and load in the order given.
    #-----------------------------------------------------------------------------------------------
    Modules               = @(
        'Coreutils'
        'Directory'
        'Environment'
        'Logging'
        'Network'
        'Process'
        'Starship'
        'Update'
    )

    #-----------------------------------------------------------------------------------------------
    # Tool plugins. With SkipMissingTools = $true a plugin whose CLI is absent costs nothing,
    # so leaving one enabled on a machine without the tool is harmless.
    #-----------------------------------------------------------------------------------------------
    Plugins               = @(
        'Git'
        'NPM'
        'PIP'
        'UV'
        'VSCode'
        # 'AWS'
        # 'Conda'
        # 'Deno'
        'Docker'
        'DockerCompose'
        # 'Flutter'
        # 'GCP'
        # 'Helm'
        'Kubectl'
        # 'Pipenv'
        'PNPM'
        # 'Poetry'
        # 'Rsync'
        # 'Ruby'
        # 'Rust'
        'Terraform'
        # 'Terragrunt'
        'Yarn'
    )

    #-----------------------------------------------------------------------------------------------
    # Utility modules. Several shell out to the bundled Python scripts in Module/Utility/*.
    #-----------------------------------------------------------------------------------------------
    Utilities             = @(
        'Base64'
        'Clock'
        'GitIgnore'
        'Misc'
        'QRCode'
        'RandomQuote'
        'Utility'
        'WeatherForecast'
        'WebSearch'
        # 'Matrix'
        # 'PrayerTimes'
    )

    #-----------------------------------------------------------------------------------------------
    # Modules from the PowerShell Gallery. These dominate startup, so the measured cost of each
    # is listed. Install anything missing with Install-ProfileDependency.
    #-----------------------------------------------------------------------------------------------
    ExternalModules       = @(
        'Terminal-Icons'        #  250 ms  file-type icons in Get-ChildItem
        'PSReadLine'            #   50 ms  line editing, history, prediction
        'CompletionPredictor'   #   30 ms  IntelliSense predictions from command history

        # 'Posh-Git'            #  220 ms  redundant: starship.toml already renders git_branch,
        #                       #          git_commit, git_state, git_metrics and git_status, and
        #                       #          nothing in this repository calls a posh-git function.
    )

    # Import the Chocolatey helper module. It exists only to give `choco` tab completion and
    # costs about 70 ms. Off by default; choco itself works without it.
    LoadChocolateyProfile = $false

    #-----------------------------------------------------------------------------------------------
    # Conflict policy
    #-----------------------------------------------------------------------------------------------

    # Skip a plugin whose command-line tool is not on PATH. This is where most of the startup
    # saving comes from: on a machine without kubectl, the Kubectl plugin is never parsed.
    SkipMissingTools      = $true

    # Let the GNU tools from Microsoft coreutils keep their own names. With this on, the profile
    # does not export grep, head, tail, touch or sed as aliases, so `grep` stays GNU grep.
    #
    # Set to $false to get the PowerShell implementations (Get-ContentMatching, Get-FileHead,
    # Get-FileTail, Set-FreshFile, Set-ContentMatching) on those names instead. They remain
    # callable by their full names either way.
    PreferNativeTools     = $true

    # Seven Git plugin functions are named after built-in PowerShell aliases and are therefore
    # unreachable: gcb gcm gcs gl gm gp gpv. PowerShell resolves an alias before a function, so
    # `gl` runs Get-Location, not `git pull`.
    #
    # Set to $true to remove those built-in aliases so the Git functions win, matching zsh.
    # Get-Command, Get-Member and friends remain available by their full cmdlet names.
    AllowBuiltinShadowing = $false

    #-----------------------------------------------------------------------------------------------
    # Startup behaviour
    #-----------------------------------------------------------------------------------------------

    # Print a warning when a module fails to import. Leave this on. The profile used to import
    # with -ErrorAction SilentlyContinue, which is how a syntax error in WebSearch.psm1 went
    # unnoticed while the whole module quietly failed to load.
    ReportLoadFailures    = $true

    # Record per-module import timings so Measure-ProfileLoad has something to show.
    # Costs well under a millisecond.
    TrackTimings          = $true
}
