#---------------------------------------------------------------------------------------------------
# NPM - generated command table
#
# One row per pure wrapper: a function whose whole body invokes npm and passes the remaining
# arguments through. This file is the source of truth; the functions are generated into
# NPM.Generated.ps1 by Tools/Update-PluginCommand.ps1.
#
# Param names a leading positional parameter, so a wrapper keeps the named first argument it
# had when these functions were written out by hand.
#
# Invoke-NpmExecute and Invoke-NpmVersion are not here. Execute rewrites PATH around an
# arbitrary command and Version branches on whether it was given arguments, so neither is a
# pure wrapper. Both stay in NPM.psm1.
#---------------------------------------------------------------------------------------------------

@{
    Tool     = 'npm'
    Commands = @(
        @{ Name = 'Invoke-NpmInstallGlobal'; Args = @('install', '-g'); Aliases = @('npmg'); Param = 'PackageName'; ParamHelp = 'Name of the package to install globally.'; Synopsis = 'Install npm packages globally.' }
        @{ Name = 'Invoke-NpmInstallSave'; Args = @('install', '-S'); Aliases = @('npmS'); Param = 'PackageName'; ParamHelp = 'Name of the package to install and save.'; Synopsis = 'Install and save packages to dependencies.' }
        @{ Name = 'Invoke-NpmInstallDev'; Args = @('install', '-D'); Aliases = @('npmD'); Param = 'PackageName'; ParamHelp = 'Name of the package to install and save to dev-dependencies.'; Synopsis = 'Install and save packages to dev-dependencies.' }
        @{ Name = 'Invoke-NpmInstallForce'; Args = @('install', '-f'); Aliases = @('npmF'); Synopsis = 'Force npm to fetch remote resources.' }
        @{ Name = 'Invoke-NpmInstall'; Args = @('install'); Aliases = @(); Synopsis = 'Install npm packages.' }
        @{ Name = 'Invoke-NpmUninstall'; Args = @('uninstall'); Aliases = @(); Synopsis = 'Uninstall npm packages.' }
        @{ Name = 'Invoke-NpmStart'; Args = @('start'); Aliases = @('npmst'); Synopsis = 'Run npm start script.' }
        @{ Name = 'Invoke-NpmTest'; Args = @('test'); Aliases = @('npmt'); Synopsis = 'Run npm test script.' }
        @{ Name = 'Invoke-NpmRun'; Args = @('run'); Aliases = @('npmR'); Param = 'ScriptName'; ParamHelp = 'Name of the script to run.'; Synopsis = 'Run npm scripts.' }
        @{ Name = 'Invoke-NpmRunDev'; Args = @('run', 'dev'); Aliases = @('npmrd'); Synopsis = 'Run npm development script.' }
        @{ Name = 'Invoke-NpmRunBuild'; Args = @('run', 'build'); Aliases = @('npmrb'); Synopsis = 'Run npm build script.' }
        @{ Name = 'Invoke-NpmRunScript'; Args = @('run'); Aliases = @('npmrs'); Synopsis = 'Run custom npm script.' }
        @{ Name = 'Invoke-NpmOutdated'; Args = @('outdated'); Aliases = @('npmO'); Synopsis = 'Check which npm modules are outdated.' }
        @{ Name = 'Invoke-NpmUpdate'; Args = @('update'); Aliases = @('npmU'); Synopsis = 'Update npm packages.' }
        @{ Name = 'Invoke-NpmList'; Args = @('list'); Aliases = @('npmL'); Synopsis = 'List installed packages.' }
        @{ Name = 'Invoke-NpmListTopLevel'; Args = @('ls', '--depth=0'); Aliases = @('npmL0'); Synopsis = 'List top-level installed packages.' }
        @{ Name = 'Invoke-NpmInfo'; Args = @('info'); Aliases = @('npmi'); Param = 'PackageName'; ParamHelp = 'Name of the package to get information about.'; Synopsis = 'Get package information.' }
        @{ Name = 'Invoke-NpmSearch'; Args = @('search'); Aliases = @('npmSe'); Param = 'Query'; ParamHelp = 'Search query for packages.'; Synopsis = 'Search for npm packages.' }
        @{ Name = 'Invoke-NpmPublish'; Args = @('publish'); Aliases = @('npmP'); Synopsis = 'Publish npm package.' }
        @{ Name = 'Invoke-NpmInit'; Args = @('init'); Aliases = @('npminit'); Synopsis = 'Initialize npm package.' }
        @{ Name = 'Invoke-NpmAudit'; Args = @('audit'); Aliases = @('npma'); Synopsis = 'Run npm security audit.' }
        @{ Name = 'Invoke-NpmAuditFix'; Args = @('audit', 'fix'); Aliases = @('npmaf'); Synopsis = 'Fix npm security vulnerabilities.' }
        @{ Name = 'Invoke-NpmCache'; Args = @('cache'); Aliases = @('npmc'); Synopsis = 'Manage npm cache.' }
        @{ Name = 'Invoke-NpmDoctor'; Args = @('doctor'); Aliases = @('npmdoc'); Synopsis = 'Run npm doctor diagnostics.' }
        @{ Name = 'Invoke-NpmWhoami'; Args = @('whoami'); Aliases = @('npmwho'); Synopsis = 'Show current npm user.' }
        @{ Name = 'Invoke-NpmLogin'; Args = @('login'); Aliases = @('npmlogin'); Synopsis = 'Login to npm registry.' }
        @{ Name = 'Invoke-NpmLogout'; Args = @('logout'); Aliases = @('npmlogout'); Synopsis = 'Logout from npm registry.' }
        @{ Name = 'Invoke-NpmPing'; Args = @('ping'); Aliases = @('npmping'); Synopsis = 'Ping npm registry.' }
        @{ Name = 'Invoke-NpmConfigList'; Args = @('config', 'list'); Aliases = @('npmcl'); Synopsis = 'List npm configuration.' }
        @{ Name = 'Invoke-NpmConfigGet'; Args = @('config', 'get'); Aliases = @('npmcg'); Param = 'ConfigName'; ParamHelp = 'Name of the configuration to get.'; Synopsis = 'Get npm configuration value.' }
        @{ Name = 'Invoke-NpmConfigSet'; Args = @('config', 'set'); Aliases = @('npmcs'); Synopsis = 'Set npm configuration value.' }
        @{ Name = 'Invoke-NpmLink'; Args = @('link'); Aliases = @('npmln'); Param = 'PackageName'; ParamHelp = 'Name of the package to link.'; Synopsis = 'Link npm package.' }
        @{ Name = 'Invoke-NpmUnlink'; Args = @('unlink'); Aliases = @('npmunln'); Param = 'PackageName'; ParamHelp = 'Name of the package to unlink.'; Synopsis = 'Unlink npm package.' }
    )
}
