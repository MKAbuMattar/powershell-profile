#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - PSScriptAnalyzer Settings
#
# The manifests declare CompatiblePSEditions = Desktop, Core and PowerShellVersion = 5.0,
# so the syntax check targets both 5.1 and 7.0.
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#---------------------------------------------------------------------------------------------------

@{
    Rules        = @{
        PSUseCompatibleSyntax                       = @{
            Enable         = $true
            TargetVersions = @('5.1', '7.0')
        }

        # Profile functions are thin wrappers around external tools (git, kubectl, docker).
        # They deliberately do not implement -WhatIf/-Confirm.
        PSUseShouldProcessForStateChangingFunctions = @{ Enable = $false }

        # Plugin names mirror their upstream CLI verbs (Get-GComputeZones, Invoke-KubectlGetPods).
        PSUseSingularNouns                          = @{ Enable = $false }
    }

    ExcludeRules = @(
        # Console output is the point of a shell profile; these functions render, they do not return.
        'PSAvoidUsingWriteHost',

        # Short aliases (g, ga, gst) are the entire purpose of the plugin modules.
        'PSAvoidUsingCmdletAliases',

        # Tracked as F5 and handled at load time by the reserved-name guard in Module/Loader.
        # Enabling it here would flag every oh-my-zsh git alias on every run.
        'PSAvoidOverwritingBuiltInCmdlets'
    )
}
