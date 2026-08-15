#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PSScriptAnalyzer Settings
#
# The manifests declare PowerShellVersion = 7.0 and CompatiblePSEditions = Core, so the syntax
# check targets 7.0 only. They previously claimed 5.1, which was never true: the code uses
# Remove-Alias, the background `&` operator and PS7 parse-level syntax throughout.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

@{
    Rules        = @{
        PSUseCompatibleSyntax = @{
            Enable         = $true
            TargetVersions = @('7.0')
        }
    }

    # Rules are disabled here, not with Enable = $false inside Rules. That form is silently
    # ignored: PSUseShouldProcessForStateChangingFunctions was set that way and carried on
    # reporting 53 warnings regardless.
    ExcludeRules = @(
        # Profile functions are thin wrappers around external tools (git, kubectl, docker).
        # They deliberately do not implement -WhatIf/-Confirm.
        'PSUseShouldProcessForStateChangingFunctions',

        # Plugin names mirror their upstream CLI verbs (Get-GComputeZones, Invoke-KubectlGetPods).
        'PSUseSingularNouns',

        # Console output is the point of a shell profile; these functions render, they do not return.
        'PSAvoidUsingWriteHost',

        # Short aliases (g, ga, gst) are the entire purpose of the plugin modules.
        'PSAvoidUsingCmdletAliases',

        # Tracked as F5 and handled at load time by the reserved-name guard in Module/Loader.
        # Enabling it here would flag every oh-my-zsh git alias on every run.
        'PSAvoidOverwritingBuiltInCmdlets'
    )
}
