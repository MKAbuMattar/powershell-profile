#---------------------------------------------------------------------------------------------------
# Git - generated command table
#
# One row per pure wrapper: a function whose whole body invokes the tool and passes the
# remaining arguments through. This file is the source of truth; the functions themselves are
# generated into *.Generated.psm1 by Tools/Update-PluginCommand.ps1.
#
# Adding a command means adding a row here and re-running the generator.
#---------------------------------------------------------------------------------------------------

@{
    Tool     = 'git'
    Commands = @(
        @{ Name = 'g'; Args = @(); Aliases = @(); Synopsis = 'A PowerShell function that wraps the `git` command.' }
        @{ Name = 'ga'; Args = @('add'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git add`.' }
        @{ Name = 'gaa'; Args = @('add', '--all'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git add --all`.' }
        @{ Name = 'gapa'; Args = @('add', '--patch'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git add --patch`.' }
        @{ Name = 'gau'; Args = @('add', '--update'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git add --update`.' }
        @{ Name = 'gav'; Args = @('add', '--verbose'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git add --verbose`.' }
        @{ Name = 'gam'; Args = @('am'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git am`.' }
        @{ Name = 'gama'; Args = @('am', '--abort'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git am --abort`.' }
        @{ Name = 'gamc'; Args = @('am', '--continue'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git am --continue`.' }
        @{ Name = 'gamscp'; Args = @('am', '--show-current-patch'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git am --show-current-patch`.' }
        @{ Name = 'gams'; Args = @('am', '--skip'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git am --skip`.' }
        @{ Name = 'gap'; Args = @('apply'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git apply`.' }
        @{ Name = 'gapt'; Args = @('apply', '--3way'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git apply --3way`.' }
        @{ Name = 'gbs'; Args = @('bisect'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect`.' }
        @{ Name = 'gbsb'; Args = @('bisect', 'bad'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect bad`.' }
        @{ Name = 'gbsg'; Args = @('bisect', 'good'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect good`.' }
        @{ Name = 'gbsn'; Args = @('bisect', 'new'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect new`.' }
        @{ Name = 'gbso'; Args = @('bisect', 'old'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect old`.' }
        @{ Name = 'gbsr'; Args = @('bisect', 'reset'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect reset`.' }
        @{ Name = 'gbss'; Args = @('bisect', 'start'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git bisect start`.' }
        @{ Name = 'gbl'; Args = @('blame', '-w'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git blame -w`.' }
        @{ Name = 'gb'; Args = @('branch'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch`.' }
        @{ Name = 'gba'; Args = @('branch', '--all'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch --all`.' }
        @{ Name = 'gbd'; Args = @('branch', '--delete'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch --delete`.' }
        @{ Name = 'gbdf'; Args = @('branch', '--delete', '--force'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch --delete --force`.' }
        @{ Name = 'gbm'; Args = @('branch', '--move'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch --move`.' }
        @{ Name = 'gbnm'; Args = @('branch', '--no-merged'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch --move --no-ff`.' }
        @{ Name = 'gbr'; Args = @('branch', '--remote'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git branch --remote`.' }
        @{ Name = 'gco'; Args = @('checkout'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git checkout`.' }
        @{ Name = 'gcor'; Args = @('checkout', '--recurse-submodules'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git checkout --recurse-submodules`.' }
        @{ Name = 'gcb'; Args = @('checkout', '-b'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git checkout -b`.' }
        @{ Name = 'gcbf'; Args = @('checkout', '-B'); Aliases = @(); Synopsis = 'A PowerShell function that wraps `git checkout -B`.' }
        @{ Name = 'gcp'; Args = @('cherry-pick'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcpa'; Args = @('cherry-pick', '--abort'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcpc'; Args = @('cherry-pick', '--continue'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gclean'; Args = @('clean', '--interactive', '-d'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcl'; Args = @('clone', '--recurse-submodules'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gclf'; Args = @('clone', '--recursive', '--shallow-submodules', '--filter=blob:none', '--also-filter-submodules'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcam'; Args = @('commit', '--all', '--message'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcas'; Args = @('commit', '--all', '--signoff'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcasm'; Args = @('commit', '--all', '--signoff', '--message'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcs'; Args = @('commit', '--gpg-sign'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcss'; Args = @('commit', '--gpg-sign', '--signoff'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcssm'; Args = @('commit', '--gpg-sign', '--signoff', '--message'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcmsg'; Args = @('commit', '--message'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcsm'; Args = @('commit', '--signoff', '--message'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcv'; Args = @('commit', '--verbose'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gca'; Args = @('commit', '--verbose', '--all'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcf'; Args = @('config', '--list'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcfu'; Args = @('commit', '--fixup'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gd'; Args = @('diff'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gdca'; Args = @('diff', '--cached'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gdcw'; Args = @('diff', '--cached', '--word-diff'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gds'; Args = @('diff', '--staged'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gdw'; Args = @('diff', '--word-diff'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gdt'; Args = @('diff-tree', '--no-commit-id', '--name-only', '-r'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gf'; Args = @('fetch'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gfa'; Args = @('fetch', '--all', '--tags', '--prune'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gfo'; Args = @('fetch', 'origin'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gg'; Args = @('gui', 'citool'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gga'; Args = @('gui', 'citool', '--amend'); Aliases = @(); Synopsis = '' }
        @{ Name = 'ghh'; Args = @('help'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glgg'; Args = @('log', '--graph'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glgga'; Args = @('log', '--graph', '--decorate', '--all'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glgm'; Args = @('log', '--graph', '--max-count=10'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glo'; Args = @('log', '--oneline', '--decorate'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glog'; Args = @('log', '--oneline', '--decorate', '--graph'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gloga'; Args = @('log', '--oneline', '--decorate', '--graph', '--all'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glg'; Args = @('log', '--stat'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glgp'; Args = @('log', '--stat', '--patch'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gfg'; Args = @('ls-files', '|', 'grep'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gm'; Args = @('merge'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gma'; Args = @('merge', '--abort'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gmc'; Args = @('merge', '--continue'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gms'; Args = @('merge', '--squash'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gmff'; Args = @('merge', '--ff-only'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gmtl'; Args = @('mergetool', '--no-prompt'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gmtlvim'; Args = @('mergetool', '--no-prompt', '--tool=vimdiff'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gl'; Args = @('pull'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpr'; Args = @('pull', '--rebase'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gprv'; Args = @('pull', '--rebase', '-v'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpra'; Args = @('pull', '--rebase', '--autostash'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gprav'; Args = @('pull', '--rebase', '--autostash', '-v'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gp'; Args = @('push'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpd'; Args = @('push', '--dry-run'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpv'; Args = @('push', '--verbose'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpod'; Args = @('push', 'origin', '--delete'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpu'; Args = @('push', 'upstream'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grb'; Args = @('rebase'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grba'; Args = @('rebase', '--abort'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbc'; Args = @('rebase', '--continue'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbi'; Args = @('rebase', '--interactive'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbo'; Args = @('rebase', '--onto'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbs'; Args = @('rebase', '--skip'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grf'; Args = @('reflog'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gr'; Args = @('remote'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grv'; Args = @('remote', '--verbose'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gra'; Args = @('remote', 'add'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grrm'; Args = @('remote', 'remove'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grmv'; Args = @('remote', 'rename'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grset'; Args = @('remote', 'set-url'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grup'; Args = @('remote', 'update'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grh'; Args = @('reset'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gru'; Args = @('reset', '--'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grhh'; Args = @('reset', '--hard'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grhk'; Args = @('reset', '--keep'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grhs'; Args = @('reset', '--soft'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grs'; Args = @('restore'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grss'; Args = @('restore', '--source'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grst'; Args = @('restore', '--staged'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grev'; Args = @('revert'); Aliases = @(); Synopsis = '' }
        @{ Name = 'greva'; Args = @('revert', '--abort'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grevc'; Args = @('revert', '--continue'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grm'; Args = @('rm'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grmc'; Args = @('rm', '--cached'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcount'; Args = @('shortlog', '--summary', '--numbered'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsh'; Args = @('show'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsps'; Args = @('show', '--pretty=short', '--show-signature'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstall'; Args = @('stash', '--all'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstaa'; Args = @('stash', 'apply'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstc'; Args = @('stash', 'clear'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstd'; Args = @('stash', 'drop'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstl'; Args = @('stash', 'list'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstp'; Args = @('stash', 'pop'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsts'; Args = @('stash', 'show', '--patch'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gstu'; Args = @('stash', '--include-untracked'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gst'; Args = @('status'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gss'; Args = @('status', '--short'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsb'; Args = @('status', '--short', '--branch'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsi'; Args = @('submodule', 'init'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsu'; Args = @('submodule', 'update'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsd'; Args = @('svn', 'dcommit'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsr'; Args = @('svn', 'rebase'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gsw'; Args = @('switch'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gswc'; Args = @('switch', '--create'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gta'; Args = @('tag', '--annotate'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gts'; Args = @('tag', '--sign'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gtv'; Args = @('tag', '|', 'Sort-Object', '-V'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gignore'; Args = @('update-index', '--assume-unchanged'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gunignore'; Args = @('update-index', '--no-assume-unchanged'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gwch'; Args = @('whatchanged', '-p', '--abbrev-commit', '--pretty=medium'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gwt'; Args = @('worktree'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gwta'; Args = @('worktree', 'add'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gwtls'; Args = @('worktree', 'list'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gwtmv'; Args = @('worktree', 'move'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gwtrm'; Args = @('worktree', 'remove'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcd'; Args = @('checkout', '(Get-GitDevelopBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gcm'; Args = @('checkout', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gswd'; Args = @('switch', '(Get-GitDevelopBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gswm'; Args = @('switch', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbd'; Args = @('rebase', '(Get-GitDevelopBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbm'; Args = @('rebase', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbom'; Args = @('rebase', '"origin/$(Get-GitMainBranch)"'); Aliases = @(); Synopsis = '' }
        @{ Name = 'grbum'; Args = @('rebase', '"upstream/$(Get-GitMainBranch)"'); Aliases = @(); Synopsis = '' }
        @{ Name = 'ggsup'; Args = @('branch', '--set-upstream-to="origin/$(Get-GitCurrentBranch)"'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gmom'; Args = @('merge', '"origin/$(Get-GitMainBranch)"'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gmum'; Args = @('merge', '"upstream/$(Get-GitMainBranch)"'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gprom'; Args = @('pull', '--rebase', 'origin', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpromi'; Args = @('pull', '--rebase=interactive', 'origin', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gprum'; Args = @('pull', '--rebase', 'upstream', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gprumi'; Args = @('pull', '--rebase=interactive', 'upstream', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'ggpull'; Args = @('pull', 'origin', '(Get-GitCurrentBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'ggpush'; Args = @('push', 'origin', '(Get-GitCurrentBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gpsup'; Args = @('push', '--set-upstream', 'origin', '(Get-GitCurrentBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'groh'; Args = @('reset', '"origin/$(Get-GitCurrentBranch)"', '--hard'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gluc'; Args = @('pull', 'upstream', '(Get-GitCurrentBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glum'; Args = @('pull', 'upstream', '(Get-GitMainBranch)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'gdct'; Args = @('describe', '--tags', '(git', 'rev-list', '--tags', '--max-count=1)'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glods'; Args = @('log', '--graph', '--pretty="%Cred%h%Creset', '-%C(auto)%d%Creset', '%s', '%Cgreen(%ad)', '%C(bold', 'blue)<%an>%Creset"', '--date=short'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glod'; Args = @('log', '--graph', '--pretty="%Cred%h%Creset', '-%C(auto)%d%Creset', '%s', '%Cgreen(%ad)', '%C(bold', 'blue)<%an>%Creset"'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glola'; Args = @('log', '--graph', '--pretty="%Cred%h%Creset', '-%C(auto)%d%Creset', '%s', '%Cgreen(%ar)', '%C(bold', 'blue)<%an>%Creset"', '--all'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glols'; Args = @('log', '--graph', '--pretty="%Cred%h%Creset', '-%C(auto)%d%Creset', '%s', '%Cgreen(%ar)', '%C(bold', 'blue)<%an>%Creset"', '--stat'); Aliases = @(); Synopsis = '' }
        @{ Name = 'glol'; Args = @('log', '--graph', '--pretty="%Cred%h%Creset', '-%C(auto)%d%Creset', '%s', '%Cgreen(%ar)', '%C(bold', 'blue)<%an>%Creset"'); Aliases = @(); Synopsis = '' }
    )
}
