#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Conda Plugin
#
#
#                             .
#         ..                .''
#         .,'..,.         ..,;,'
#          ,;;;;,,       .,,;;;
#           ,;;;;;'    .',;;;
#            ,;;;;,'...,;;;,
#             ,;;;;;,,;;;;.
#              ,;;;;;;;;;
#              .,;;;;;;;
#              .,;;;;;;;'
#              .,;;;;;;;,'
#            .',;;;;;;;;;;,.
#          ..,;;;;;;;;;;;;;,.
#         .';;;;;.   ';;;;;;,'
#        .,;;;;.      ,; .;; .,
#        ',;;;.        .
#        .,;;.
#        ,;
#        .
#
#      "The only way to do great work is to love what you do."
#                           - Steve Jobs
#
#
# Author: Mohammad Abu Mattar
#
# Description:
#       This module provides Conda CLI shortcuts and utility functions for Python environment
#       and package management in PowerShell environments. Supports environment lifecycle
#       management, package installation, configuration management, and comprehensive Conda
#       workflow automation for data science and Python development.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Get-CondaVersion {
    <#
    .SYNOPSIS
        Gets the installed Conda version.

    .DESCRIPTION
        Returns the version of Conda that is currently installed and accessible.

    .OUTPUTS
        System.String
        The Conda version string, or $null if Conda is not available.

    .EXAMPLE
        Get-CondaVersion
        Returns the Conda version (e.g., "conda 23.7.4").

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $versionOutput = conda --version 2>$null
        return $versionOutput.Trim()
    }
    catch {
        return $null
    }
}

function Get-CondaInfo {
    <#
    .SYNOPSIS
        Gets Conda system information.

    .DESCRIPTION
        Returns detailed information about the Conda installation and current configuration.

    .OUTPUTS
        System.String
        The Conda info output, or $null if Conda is not available.

    .EXAMPLE
        Get-CondaInfo
        Shows detailed Conda system information.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        $infoOutput = conda info 2>$null
        return $infoOutput
    }
    catch {
        return $null
    }
}

function Get-CondaEnvs {
    <#
    .SYNOPSIS
        Gets list of Conda environments.

    .DESCRIPTION
        Returns a list of all available Conda environments.

    .OUTPUTS
        System.String[]
        Array of environment names, or $null if Conda is not available.

    .EXAMPLE
        Get-CondaEnvs
        Returns list of all Conda environments.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [OutputType([string[]])]
    param()

    try {
        $envOutput = conda env list --json 2>$null | ConvertFrom-Json
        return $envOutput.envs | ForEach-Object { Split-Path $_ -Leaf }
    }
    catch {
        return $null
    }
}

function Get-CurrentCondaEnv {
    <#
    .SYNOPSIS
        Gets the currently active Conda environment.

    .DESCRIPTION
        Returns the name of the currently active Conda environment.

    .OUTPUTS
        System.String
        The active environment name, or $null if no environment is active.

    .EXAMPLE
        Get-CurrentCondaEnv
        Returns the active environment name.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    try {
        return $env:CONDA_DEFAULT_ENV
    }
    catch {
        return $null
    }
}

function Invoke-Conda {
    <#
    .SYNOPSIS
        Base Conda command wrapper.

    .DESCRIPTION
        Executes Conda commands with all provided arguments. Serves as the base wrapper
        for all Conda operations and ensures Conda is available before execution.

    .PARAMETER Arguments
        All arguments to pass to Conda command.

    .EXAMPLE
        Invoke-Conda --version
        Shows Conda version.

    .EXAMPLE
        Invoke-Conda env list
        Lists all environments.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cn")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    & conda @Arguments
}

function Invoke-CondaActivate {
    <#
    .SYNOPSIS
        Activate Conda environment.

    .DESCRIPTION
        Activates the specified Conda environment.
        Equivalent to 'conda activate' or 'cna' shortcut.

    .PARAMETER EnvironmentName
        Name of the environment to activate.

    .PARAMETER Arguments
        Additional arguments to pass to conda activate.

    .EXAMPLE
        Invoke-CondaActivate myenv
        Activates the myenv environment.

    .EXAMPLE
        cna base
        Activates base environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cna")]
    [OutputType([void])]
    param(
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('activate') + $Arguments
    & conda @allArgs
}

function Invoke-CondaActivateBase {
    <#
    .SYNOPSIS
        Activate base Conda environment.

    .DESCRIPTION
        Activates the base Conda environment.
        Equivalent to 'conda activate base' or 'cnab' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda activate base.

    .EXAMPLE
        Invoke-CondaActivateBase
        Activates base environment.

    .EXAMPLE
        cnab
        Activates base environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnab")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('activate', 'base') + $Arguments
    & conda @allArgs
}

function Invoke-CondaDeactivate {
    <#
    .SYNOPSIS
        Deactivate current Conda environment.

    .DESCRIPTION
        Deactivates the currently active Conda environment.
        Equivalent to 'conda deactivate' or 'cnde' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda deactivate.

    .EXAMPLE
        Invoke-CondaDeactivate
        Deactivates current environment.

    .EXAMPLE
        cnde
        Deactivates current environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnde")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('deactivate') + $Arguments
    & conda @allArgs
}

function Invoke-CondaCreate {
    <#
    .SYNOPSIS
        Create Conda environment.

    .DESCRIPTION
        Creates a new Conda environment with specified parameters.
        Equivalent to 'conda create' or 'cnc' shortcut.

    .PARAMETER Arguments
        Arguments to pass to conda create.

    .EXAMPLE
        Invoke-CondaCreate -n myenv python=3.9
        Creates environment named myenv with Python 3.9.

    .EXAMPLE
        cnc -n datascience python pandas numpy
        Creates datascience environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('create') + $Arguments
    & conda @allArgs
}

function Invoke-CondaCreateFromFile {
    <#
    .SYNOPSIS
        Create Conda environment from file.

    .DESCRIPTION
        Creates a new Conda environment from an environment file.
        Equivalent to 'conda env create -f' or 'cncf' shortcut.

    .PARAMETER Arguments
        Arguments to pass to conda env create -f.

    .EXAMPLE
        Invoke-CondaCreateFromFile environment.yml
        Creates environment from environment.yml file.

    .EXAMPLE
        cncf environment.yml
        Creates environment from file using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('env', 'create', '-f') + $Arguments
    & conda @allArgs
}

function Invoke-CondaCreateName {
    <#
    .SYNOPSIS
        Create Conda environment with name.

    .DESCRIPTION
        Creates a new Conda environment with the specified name.
        Equivalent to 'conda create -n' or 'cncr' shortcut.

    .PARAMETER Arguments
        Environment name and packages to install.

    .EXAMPLE
        Invoke-CondaCreateName myenv python=3.9
        Creates environment named myenv with Python 3.9.

    .EXAMPLE
        cncr datascience python pandas numpy
        Creates datascience environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('create', '-n') + $Arguments
    & conda @allArgs
}

function Invoke-CondaCreateNameYes {
    <#
    .SYNOPSIS
        Create Conda environment with name (auto-confirm).

    .DESCRIPTION
        Creates a new Conda environment with the specified name, automatically confirming installation.
        Equivalent to 'conda create -y -n' or 'cncn' shortcut.

    .PARAMETER Arguments
        Environment name and packages to install.

    .EXAMPLE
        Invoke-CondaCreateNameYes myenv python=3.9
        Creates environment named myenv with Python 3.9 without prompts.

    .EXAMPLE
        cncn datascience python pandas numpy
        Creates datascience environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncn")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('create', '-y', '-n') + $Arguments
    & conda @allArgs
}

function Invoke-CondaCreatePath {
    <#
    .SYNOPSIS
        Create Conda environment at path.

    .DESCRIPTION
        Creates a new Conda environment at the specified path.
        Equivalent to 'conda create -y -p' or 'cncp' shortcut.

    .PARAMETER Arguments
        Environment path and packages to install.

    .EXAMPLE
        Invoke-CondaCreatePath ./myenv python=3.9
        Creates environment at ./myenv with Python 3.9.

    .EXAMPLE
        cncp C:\envs\datascience python pandas
        Creates environment at specific path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('create', '-y', '-p') + $Arguments
    & conda @allArgs
}

function Invoke-CondaRemoveEnv {
    <#
    .SYNOPSIS
        Remove Conda environment.

    .DESCRIPTION
        Removes the specified Conda environment completely.
        Equivalent to 'conda remove --all' or base for other remove operations.

    .PARAMETER Arguments
        Arguments for environment removal.

    .EXAMPLE
        Invoke-CondaRemoveEnv -n myenv --all
        Removes myenv environment completely.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('remove') + $Arguments
    & conda @allArgs
}

function Invoke-CondaRemoveEnvName {
    <#
    .SYNOPSIS
        Remove Conda environment by name.

    .DESCRIPTION
        Removes the specified Conda environment by name with all packages.
        Equivalent to 'conda remove -y --all -n' or 'cnrn' shortcut.

    .PARAMETER Arguments
        Environment name to remove.

    .EXAMPLE
        Invoke-CondaRemoveEnvName myenv
        Removes myenv environment completely.

    .EXAMPLE
        cnrn old-env
        Removes old-env environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnrn")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('remove', '-y', '--all', '-n') + $Arguments
    & conda @allArgs
}

function Invoke-CondaRemoveEnvPath {
    <#
    .SYNOPSIS
        Remove Conda environment by path.

    .DESCRIPTION
        Removes the specified Conda environment by path with all packages.
        Equivalent to 'conda remove -y --all -p' or 'cnrp' shortcut.

    .PARAMETER Arguments
        Environment path to remove.

    .EXAMPLE
        Invoke-CondaRemoveEnvPath ./myenv
        Removes environment at ./myenv completely.

    .EXAMPLE
        cnrp C:\envs\old-env
        Removes environment at path using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnrp")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('remove', '-y', '--all', '-p') + $Arguments
    & conda @allArgs
}

function Invoke-CondaEnvList {
    <#
    .SYNOPSIS
        List Conda environments.

    .DESCRIPTION
        Lists all available Conda environments.
        Equivalent to 'conda env list' or 'cnel' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda env list.

    .EXAMPLE
        Invoke-CondaEnvList
        Lists all environments.

    .EXAMPLE
        cnel --json
        Lists environments in JSON format using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnel")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('env', 'list') + $Arguments
    & conda @allArgs
}

function Invoke-CondaEnvExport {
    <#
    .SYNOPSIS
        Export Conda environment.

    .DESCRIPTION
        Exports the current or specified environment to a file.
        Equivalent to 'conda env export' or 'cnee' shortcut.

    .PARAMETER Arguments
        Arguments to pass to conda env export.

    .EXAMPLE
        Invoke-CondaEnvExport > environment.yml
        Exports current environment to file.

    .EXAMPLE
        cnee -n myenv > myenv.yml
        Exports specific environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnee")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('env', 'export') + $Arguments
    & conda @allArgs
}

function Invoke-CondaEnvUpdate {
    <#
    .SYNOPSIS
        Update Conda environment from file.

    .DESCRIPTION
        Updates the current environment from an environment file.
        Equivalent to 'conda env update' or 'cneu' shortcut.

    .PARAMETER Arguments
        Arguments to pass to conda env update.

    .EXAMPLE
        Invoke-CondaEnvUpdate -f environment.yml
        Updates environment from file.

    .EXAMPLE
        cneu -f environment.yml
        Updates environment using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cneu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('env', 'update') + $Arguments
    & conda @allArgs
}

function Invoke-CondaInstall {
    <#
    .SYNOPSIS
        Install packages with Conda.

    .DESCRIPTION
        Installs one or more packages using Conda.
        Equivalent to 'conda install' or 'cni' shortcut.

    .PARAMETER Arguments
        Packages to install and additional arguments.

    .EXAMPLE
        Invoke-CondaInstall numpy pandas
        Installs numpy and pandas packages.

    .EXAMPLE
        cni python=3.9 -c conda-forge
        Installs Python 3.9 from conda-forge using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cni")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('install') + $Arguments
    & conda @allArgs
}

function Invoke-CondaInstallYes {
    <#
    .SYNOPSIS
        Install packages with Conda (auto-confirm).

    .DESCRIPTION
        Installs one or more packages using Conda without prompting for confirmation.
        Equivalent to 'conda install -y' or 'cniy' shortcut.

    .PARAMETER Arguments
        Packages to install and additional arguments.

    .EXAMPLE
        Invoke-CondaInstallYes numpy pandas
        Installs numpy and pandas without prompts.

    .EXAMPLE
        cniy matplotlib seaborn
        Installs visualization packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cniy")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('install', '-y') + $Arguments
    & conda @allArgs
}

function Invoke-CondaRemove {
    <#
    .SYNOPSIS
        Remove packages with Conda.

    .DESCRIPTION
        Removes one or more packages using Conda.
        Equivalent to 'conda remove' or 'cnr' shortcut.

    .PARAMETER Arguments
        Packages to remove and additional arguments.

    .EXAMPLE
        Invoke-CondaRemove numpy
        Removes numpy package.

    .EXAMPLE
        cnr matplotlib seaborn
        Removes visualization packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('remove') + $Arguments
    & conda @allArgs
}

function Invoke-CondaRemoveYes {
    <#
    .SYNOPSIS
        Remove packages with Conda (auto-confirm).

    .DESCRIPTION
        Removes one or more packages using Conda without prompting for confirmation.
        Equivalent to 'conda remove -y' or 'cnry' shortcut.

    .PARAMETER Arguments
        Packages to remove and additional arguments.

    .EXAMPLE
        Invoke-CondaRemoveYes numpy
        Removes numpy package without prompts.

    .EXAMPLE
        cnry matplotlib seaborn
        Removes packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnry")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('remove', '-y') + $Arguments
    & conda @allArgs
}

function Invoke-CondaUpdate {
    <#
    .SYNOPSIS
        Update packages with Conda.

    .DESCRIPTION
        Updates one or more packages using Conda.
        Equivalent to 'conda update' or 'cnu' shortcut.

    .PARAMETER Arguments
        Packages to update and additional arguments.

    .EXAMPLE
        Invoke-CondaUpdate numpy
        Updates numpy package.

    .EXAMPLE
        cnu --all
        Updates all packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnu")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('update') + $Arguments
    & conda @allArgs
}

function Invoke-CondaUpdateAll {
    <#
    .SYNOPSIS
        Update all packages with Conda.

    .DESCRIPTION
        Updates all packages in the current environment.
        Equivalent to 'conda update --all' or 'cnua' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda update --all.

    .EXAMPLE
        Invoke-CondaUpdateAll
        Updates all packages in current environment.

    .EXAMPLE
        cnua
        Updates all packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnua")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('update', '--all') + $Arguments
    & conda @allArgs
}

function Invoke-CondaUpdateConda {
    <#
    .SYNOPSIS
        Update Conda itself.

    .DESCRIPTION
        Updates Conda to the latest version.
        Equivalent to 'conda update conda' or 'cnuc' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda update conda.

    .EXAMPLE
        Invoke-CondaUpdateConda
        Updates Conda to latest version.

    .EXAMPLE
        cnuc
        Updates Conda using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnuc")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('update', 'conda') + $Arguments
    & conda @allArgs
}

function Invoke-CondaList {
    <#
    .SYNOPSIS
        List installed packages.

    .DESCRIPTION
        Lists all packages installed in the current environment.
        Equivalent to 'conda list' or 'cnl' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda list.

    .EXAMPLE
        Invoke-CondaList
        Lists all installed packages.

    .EXAMPLE
        cnl numpy
        Lists numpy package info using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('list') + $Arguments
    & conda @allArgs
}

function Invoke-CondaListExport {
    <#
    .SYNOPSIS
        Export package list.

    .DESCRIPTION
        Exports the list of installed packages in a format suitable for environment recreation.
        Equivalent to 'conda list --export' or 'cnle' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda list --export.

    .EXAMPLE
        Invoke-CondaListExport > requirements.txt
        Exports package list to file.

    .EXAMPLE
        cnle > packages.txt
        Exports packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnle")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('list', '--export') + $Arguments
    & conda @allArgs
}

function Invoke-CondaListExplicit {
    <#
    .SYNOPSIS
        Export explicit package list.

    .DESCRIPTION
        Exports explicit package specifications to a spec file.
        Equivalent to 'conda list --explicit > spec-file.txt' or 'cnles' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda list --explicit.

    .EXAMPLE
        Invoke-CondaListExplicit > spec-file.txt
        Creates explicit spec file.

    .EXAMPLE
        cnles
        Creates spec file using alias (outputs to spec-file.txt).

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnles")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    if ($Arguments.Count -eq 0) {
        conda list --explicit > spec-file.txt
    }
    else {
        $allArgs = @('list', '--explicit') + $Arguments
        & conda @allArgs
    }
}

function Invoke-CondaSearch {
    <#
    .SYNOPSIS
        Search for packages.

    .DESCRIPTION
        Searches for packages in Conda repositories.
        Equivalent to 'conda search' or 'cnsr' shortcut.

    .PARAMETER Arguments
        Package name to search for and additional arguments.

    .EXAMPLE
        Invoke-CondaSearch numpy
        Searches for numpy package.

    .EXAMPLE
        cnsr pandas
        Searches for pandas using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnsr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('search') + $Arguments
    & conda @allArgs
}

function Invoke-CondaConfig {
    <#
    .SYNOPSIS
        Manage Conda configuration.

    .DESCRIPTION
        Manages Conda configuration settings.
        Equivalent to 'conda config' or 'cnconf' shortcut.

    .PARAMETER Arguments
        Configuration arguments.

    .EXAMPLE
        Invoke-CondaConfig --show
        Shows current configuration.

    .EXAMPLE
        cnconf --add channels conda-forge
        Adds conda-forge channel using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnconf")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('config') + $Arguments
    & conda @allArgs
}

function Invoke-CondaConfigShowSources {
    <#
    .SYNOPSIS
        Show Conda configuration sources.

    .DESCRIPTION
        Shows Conda configuration with source information.
        Equivalent to 'conda config --show-sources' or 'cncss' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda config --show-sources.

    .EXAMPLE
        Invoke-CondaConfigShowSources
        Shows configuration sources.

    .EXAMPLE
        cncss
        Shows config sources using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncss")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('config', '--show-sources') + $Arguments
    & conda @allArgs
}

function Invoke-CondaConfigGet {
    <#
    .SYNOPSIS
        Get Conda configuration value.

    .DESCRIPTION
        Gets the value of a specific Conda configuration option.
        Equivalent to 'conda config --get' or 'cnconfg' shortcut.

    .PARAMETER Arguments
        Configuration key to get.

    .EXAMPLE
        Invoke-CondaConfigGet channels
        Gets current channels configuration.

    .EXAMPLE
        cnconfg auto_activate_base
        Gets auto_activate_base setting using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnconfg")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('config', '--get') + $Arguments
    & conda @allArgs
}

function Invoke-CondaConfigSet {
    <#
    .SYNOPSIS
        Set Conda configuration value.

    .DESCRIPTION
        Sets a Conda configuration option to a specific value.
        Equivalent to 'conda config --set' or 'cnconfs' shortcut.

    .PARAMETER Arguments
        Configuration key and value to set.

    .EXAMPLE
        Invoke-CondaConfigSet auto_activate_base false
        Disables auto-activation of base environment.

    .EXAMPLE
        cnconfs channel_priority strict
        Sets channel priority using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnconfs")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('config', '--set') + $Arguments
    & conda @allArgs
}

function Invoke-CondaConfigRemove {
    <#
    .SYNOPSIS
        Remove Conda configuration value.

    .DESCRIPTION
        Removes a value from a Conda configuration list.
        Equivalent to 'conda config --remove' or 'cnconfr' shortcut.

    .PARAMETER Arguments
        Configuration key and value to remove.

    .EXAMPLE
        Invoke-CondaConfigRemove channels defaults
        Removes defaults channel.

    .EXAMPLE
        cnconfr channels conda-forge
        Removes conda-forge channel using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnconfr")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('config', '--remove') + $Arguments
    & conda @allArgs
}

function Invoke-CondaConfigAdd {
    <#
    .SYNOPSIS
        Add Conda configuration value.

    .DESCRIPTION
        Adds a value to a Conda configuration list.
        Equivalent to 'conda config --add' or 'cnconfa' shortcut.

    .PARAMETER Arguments
        Configuration key and value to add.

    .EXAMPLE
        Invoke-CondaConfigAdd channels conda-forge
        Adds conda-forge channel.

    .EXAMPLE
        cnconfa channels bioconda
        Adds bioconda channel using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cnconfa")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('config', '--add') + $Arguments
    & conda @allArgs
}

function Invoke-CondaClean {
    <#
    .SYNOPSIS
        Clean Conda caches and unused packages.

    .DESCRIPTION
        Removes unused packages and caches to free up disk space.
        Equivalent to 'conda clean' or 'cncl' shortcut.

    .PARAMETER Arguments
        Arguments to pass to conda clean.

    .EXAMPLE
        Invoke-CondaClean --all
        Cleans all caches and unused packages.

    .EXAMPLE
        cncl --packages
        Cleans unused packages using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncl")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('clean') + $Arguments
    & conda @allArgs
}

function Invoke-CondaCleanAll {
    <#
    .SYNOPSIS
        Clean all Conda caches and unused packages.

    .DESCRIPTION
        Removes all unused packages, caches, and temporary files to free up maximum disk space.
        Equivalent to 'conda clean --all' or 'cncla' shortcut.

    .PARAMETER Arguments
        Additional arguments to pass to conda clean --all.

    .EXAMPLE
        Invoke-CondaCleanAll
        Cleans everything to free up space.

    .EXAMPLE
        cncla
        Cleans all using alias.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Conda/README.md
    #>
    [CmdletBinding()]
    [Alias("cncla")]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Arguments = @()
    )

    $allArgs = @('clean', '--all') + $Arguments
    & conda @allArgs
}
