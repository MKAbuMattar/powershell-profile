#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - NPM generated commands
#
# GENERATED FILE. Do not edit.
#
# Source of truth is commands.psd1 beside this file. Add or change a command there and run
# Tools/Update-PluginCommand.ps1. Tools/Test-PluginCommand.ps1 fails CI when the two disagree.
#
# Every function here wraps $Tool and passes the remaining arguments through unchanged.
#---------------------------------------------------------------------------------------------------

function Invoke-NpmInstallGlobal {
    <#
    .SYNOPSIS
        Install npm packages globally.

    .DESCRIPTION
        Runs `npm install -g` with any additional arguments appended.

    .PARAMETER PackageName
        Name of the package to install globally.

    .PARAMETER Arguments
        Passed to `npm install -g` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInstallGlobal
        Runs `npm install -g`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmg')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('install', '-g')
    if ($PackageName) { $all += $PackageName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmInstallSave {
    <#
    .SYNOPSIS
        Install and save packages to dependencies.

    .DESCRIPTION
        Runs `npm install -S` with any additional arguments appended.

    .PARAMETER PackageName
        Name of the package to install and save.

    .PARAMETER Arguments
        Passed to `npm install -S` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInstallSave
        Runs `npm install -S`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmS')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('install', '-S')
    if ($PackageName) { $all += $PackageName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmInstallDev {
    <#
    .SYNOPSIS
        Install and save packages to dev-dependencies.

    .DESCRIPTION
        Runs `npm install -D` with any additional arguments appended.

    .PARAMETER PackageName
        Name of the package to install and save to dev-dependencies.

    .PARAMETER Arguments
        Passed to `npm install -D` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInstallDev
        Runs `npm install -D`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmD')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('install', '-D')
    if ($PackageName) { $all += $PackageName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmInstallForce {
    <#
    .SYNOPSIS
        Force npm to fetch remote resources.

    .DESCRIPTION
        Runs `npm install -f` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm install -f` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInstallForce
        Runs `npm install -f`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmF')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm install -f @Arguments
}

function Invoke-NpmInstall {
    <#
    .SYNOPSIS
        Install npm packages.

    .DESCRIPTION
        Runs `npm install` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm install` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInstall
        Runs `npm install`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm install @Arguments
}

function Invoke-NpmUninstall {
    <#
    .SYNOPSIS
        Uninstall npm packages.

    .DESCRIPTION
        Runs `npm uninstall` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm uninstall` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmUninstall
        Runs `npm uninstall`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm uninstall @Arguments
}

function Invoke-NpmStart {
    <#
    .SYNOPSIS
        Run npm start script.

    .DESCRIPTION
        Runs `npm start` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm start` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmStart
        Runs `npm start`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmst')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm start @Arguments
}

function Invoke-NpmTest {
    <#
    .SYNOPSIS
        Run npm test script.

    .DESCRIPTION
        Runs `npm test` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm test` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmTest
        Runs `npm test`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmt')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm test @Arguments
}

function Invoke-NpmRun {
    <#
    .SYNOPSIS
        Run npm scripts.

    .DESCRIPTION
        Runs `npm run` with any additional arguments appended.

    .PARAMETER ScriptName
        Name of the script to run.

    .PARAMETER Arguments
        Passed to `npm run` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmRun
        Runs `npm run`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmR')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ScriptName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('run')
    if ($ScriptName) { $all += $ScriptName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmRunDev {
    <#
    .SYNOPSIS
        Run npm development script.

    .DESCRIPTION
        Runs `npm run dev` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm run dev` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmRunDev
        Runs `npm run dev`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmrd')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm run dev @Arguments
}

function Invoke-NpmRunBuild {
    <#
    .SYNOPSIS
        Run npm build script.

    .DESCRIPTION
        Runs `npm run build` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm run build` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmRunBuild
        Runs `npm run build`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmrb')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm run build @Arguments
}

function Invoke-NpmRunScript {
    <#
    .SYNOPSIS
        Run custom npm script.

    .DESCRIPTION
        Runs `npm run` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm run` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmRunScript
        Runs `npm run`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmrs')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm run @Arguments
}

function Invoke-NpmOutdated {
    <#
    .SYNOPSIS
        Check which npm modules are outdated.

    .DESCRIPTION
        Runs `npm outdated` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm outdated` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmOutdated
        Runs `npm outdated`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmO')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm outdated @Arguments
}

function Invoke-NpmUpdate {
    <#
    .SYNOPSIS
        Update npm packages.

    .DESCRIPTION
        Runs `npm update` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm update` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmUpdate
        Runs `npm update`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmU')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm update @Arguments
}

function Invoke-NpmList {
    <#
    .SYNOPSIS
        List installed packages.

    .DESCRIPTION
        Runs `npm list` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm list` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmList
        Runs `npm list`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmL')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm list @Arguments
}

function Invoke-NpmListTopLevel {
    <#
    .SYNOPSIS
        List top-level installed packages.

    .DESCRIPTION
        Runs `npm ls --depth=0` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm ls --depth=0` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmListTopLevel
        Runs `npm ls --depth=0`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmL0')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm ls --depth=0 @Arguments
}

function Invoke-NpmInfo {
    <#
    .SYNOPSIS
        Get package information.

    .DESCRIPTION
        Runs `npm info` with any additional arguments appended.

    .PARAMETER PackageName
        Name of the package to get information about.

    .PARAMETER Arguments
        Passed to `npm info` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInfo
        Runs `npm info`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmi')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('info')
    if ($PackageName) { $all += $PackageName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmSearch {
    <#
    .SYNOPSIS
        Search for npm packages.

    .DESCRIPTION
        Runs `npm search` with any additional arguments appended.

    .PARAMETER Query
        Search query for packages.

    .PARAMETER Arguments
        Passed to `npm search` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmSearch
        Runs `npm search`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmSe')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$Query,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('search')
    if ($Query) { $all += $Query }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmPublish {
    <#
    .SYNOPSIS
        Publish npm package.

    .DESCRIPTION
        Runs `npm publish` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm publish` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmPublish
        Runs `npm publish`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmP')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm publish @Arguments
}

function Invoke-NpmInit {
    <#
    .SYNOPSIS
        Initialize npm package.

    .DESCRIPTION
        Runs `npm init` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm init` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmInit
        Runs `npm init`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npminit')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm init @Arguments
}

function Invoke-NpmAudit {
    <#
    .SYNOPSIS
        Run npm security audit.

    .DESCRIPTION
        Runs `npm audit` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm audit` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmAudit
        Runs `npm audit`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npma')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm audit @Arguments
}

function Invoke-NpmAuditFix {
    <#
    .SYNOPSIS
        Fix npm security vulnerabilities.

    .DESCRIPTION
        Runs `npm audit fix` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm audit fix` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmAuditFix
        Runs `npm audit fix`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmaf')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm audit fix @Arguments
}

function Invoke-NpmCache {
    <#
    .SYNOPSIS
        Manage npm cache.

    .DESCRIPTION
        Runs `npm cache` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm cache` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmCache
        Runs `npm cache`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmc')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm cache @Arguments
}

function Invoke-NpmDoctor {
    <#
    .SYNOPSIS
        Run npm doctor diagnostics.

    .DESCRIPTION
        Runs `npm doctor` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm doctor` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmDoctor
        Runs `npm doctor`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmdoc')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm doctor @Arguments
}

function Invoke-NpmWhoami {
    <#
    .SYNOPSIS
        Show current npm user.

    .DESCRIPTION
        Runs `npm whoami` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm whoami` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmWhoami
        Runs `npm whoami`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmwho')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm whoami @Arguments
}

function Invoke-NpmLogin {
    <#
    .SYNOPSIS
        Login to npm registry.

    .DESCRIPTION
        Runs `npm login` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm login` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmLogin
        Runs `npm login`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmlogin')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm login @Arguments
}

function Invoke-NpmLogout {
    <#
    .SYNOPSIS
        Logout from npm registry.

    .DESCRIPTION
        Runs `npm logout` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm logout` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmLogout
        Runs `npm logout`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmlogout')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm logout @Arguments
}

function Invoke-NpmPing {
    <#
    .SYNOPSIS
        Ping npm registry.

    .DESCRIPTION
        Runs `npm ping` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm ping` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmPing
        Runs `npm ping`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmping')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm ping @Arguments
}

function Invoke-NpmConfigList {
    <#
    .SYNOPSIS
        List npm configuration.

    .DESCRIPTION
        Runs `npm config list` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm config list` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmConfigList
        Runs `npm config list`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmcl')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm config list @Arguments
}

function Invoke-NpmConfigGet {
    <#
    .SYNOPSIS
        Get npm configuration value.

    .DESCRIPTION
        Runs `npm config get` with any additional arguments appended.

    .PARAMETER ConfigName
        Name of the configuration to get.

    .PARAMETER Arguments
        Passed to `npm config get` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmConfigGet
        Runs `npm config get`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmcg')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$ConfigName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('config', 'get')
    if ($ConfigName) { $all += $ConfigName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmConfigSet {
    <#
    .SYNOPSIS
        Set npm configuration value.

    .DESCRIPTION
        Runs `npm config set` with any additional arguments appended.

    .PARAMETER Arguments
        Passed to `npm config set` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmConfigSet
        Runs `npm config set`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmcs')]
    [OutputType([void])]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    & npm config set @Arguments
}

function Invoke-NpmLink {
    <#
    .SYNOPSIS
        Link npm package.

    .DESCRIPTION
        Runs `npm link` with any additional arguments appended.

    .PARAMETER PackageName
        Name of the package to link.

    .PARAMETER Arguments
        Passed to `npm link` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmLink
        Runs `npm link`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmln')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('link')
    if ($PackageName) { $all += $PackageName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}

function Invoke-NpmUnlink {
    <#
    .SYNOPSIS
        Unlink npm package.

    .DESCRIPTION
        Runs `npm unlink` with any additional arguments appended.

    .PARAMETER PackageName
        Name of the package to unlink.

    .PARAMETER Arguments
        Passed to `npm unlink` unchanged.

    .INPUTS
        None.

    .OUTPUTS
        None. Writes whatever npm writes.

    .EXAMPLE
        Invoke-NpmUnlink
        Runs `npm unlink`.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile
    #>
    [CmdletBinding()]
    [Alias('npmunln')]
    [OutputType([void])]
    param(
        [Parameter(Position = 0)]
        [string]$PackageName,

        [Parameter(ValueFromRemainingArguments)]
        [string[]]$Arguments
    )

    $all = @('unlink')
    if ($PackageName) { $all += $PackageName }
    if ($Arguments) { $all += $Arguments }

    & npm @all
}
