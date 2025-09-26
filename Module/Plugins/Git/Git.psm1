#---------------------------------------------------------------------------------------------------
# Import the custom Git modules
#---------------------------------------------------------------------------------------------------
$GitCoreModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Core/Git-Core.psd1'
if (Test-Path $GitCoreModulePath) {
  Import-Module $GitCoreModulePath -Force -Global
}
else {
  Write-Warning "Git-Core module not found at: $GitCoreModulePath"
}

$GitUtilityModulePath = Join-Path -Path $PSScriptRoot -ChildPath 'Utility/Git-Utility.psd1'
if (Test-Path $GitUtilityModulePath) {
  Import-Module $GitUtilityModulePath -Force -Global
}
else {
  Write-Warning "Git-Utility module not found at: $GitUtilityModulePath"
}

function g {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  git @Arguments
}

function  grt {
  [CmdletBinding()]
  [OutputType([void])]
  param()

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  Set-Location (git rev-parse --show-toplevel)
}

function ga {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git add @Arguments
}

function gaa {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git add --all @Arguments
}

function gapa {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git add --patch @Arguments
}

function gau {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git add --update @Arguments
}

function gav {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git add --verbose @Arguments
}

function gam {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git am @Arguments
}

function gama {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git am --abort @Arguments
}

function gamc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git am --continue @Arguments
}

function gamscp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git am --show-current-patch @Arguments
}

function gams {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git am --skip @Arguments
}

function gap {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git apply @Arguments
}

function gapt {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git apply --3way @Arguments
}

function gbs {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect @Arguments
}

function gbsb {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect bad @Arguments
}

function gbsg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect good @Arguments
}

function gbsn {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect new @Arguments
}

function gbso {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect old @Arguments
}

function gbsr {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect reset @Arguments
}

function gbss {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git bisect start @Arguments
}

function gbl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git blame -w @Arguments
}

function gb {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch @Arguments
}

function gba {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --all @Arguments
}

function gbd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --delete @Arguments
}

function gbD {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --delete --force @Arguments
}

function gbm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --move @Arguments
}

function gbnm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --no-merged @Arguments
}

function gbr {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --remote @Arguments
}

function gco {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git checkout @Arguments
}

function gcor {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git checkout --recurse-submodules @Arguments
}

function gcb {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git checkout -b @Arguments
}

function gcB {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git checkout -B @Arguments
}

function gcp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git cherry-pick @Arguments
}

function gcpa {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git cherry-pick --abort @Arguments
}

function gcpc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git cherry-pick --continue @Arguments
}

function gclean {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  git clean --interactive -d @Arguments
}

function gcl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  git clone --recurse-submodules @Arguments
}

function gclf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  git clone --recursive --shallow-submodules --filter=blob:none --also-filter-submodules @Arguments
}

function gcam {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --all --message @Arguments
}

function gcas {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --all --signoff @Arguments
}

function gcasm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --all --signoff --message @Arguments
}

function gcs {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --gpg-sign @Arguments
}

function gcss {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --gpg-sign --signoff @Arguments
}

function gcssm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --gpg-sign --signoff --message @Arguments
}

function gcmsg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --message @Arguments
}

function gcsm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --signoff --message @Arguments
}

function gcv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --verbose @Arguments
}

function gca {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --verbose --all @Arguments
}

function gcf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git config --list @Arguments
}

function gcfu {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git commit --fixup @Arguments
}

function gd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff @Arguments
}

function gdca {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff --cached @Arguments
}

function gdcw {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff --cached --word-diff @Arguments
}

function gds {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff --staged @Arguments
}

function gdw {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff --word-diff @Arguments
}

function gdup {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff '@{upstream}' @Arguments
}

function gdt {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff-tree --no-commit-id --name-only -r @Arguments
}

function  gf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git fetch @Arguments
}

function gfa {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git fetch --all --tags --prune @Arguments
}

function gfo {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git fetch origin @Arguments
}

function gg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git gui citool @Arguments
}

function gga {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git gui citool --amend @Arguments
}

function ghh {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  git help @Arguments
}

function glgg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph @Arguments
}

function glgga {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --decorate --all @Arguments
}

function glgm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --max-count=10 @Arguments
}

function glo {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --oneline --decorate @Arguments
}

function glog {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --oneline --decorate --graph @Arguments
}

function gloga {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --oneline --decorate --graph --all @Arguments
}

function glg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --stat @Arguments
}

function glgp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --stat --patch @Arguments
}

function gfg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git ls-files | grep @Arguments
}

function gm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge @Arguments
}

function gma {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge --abort @Arguments
}

function gmc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge --continue @Arguments
}

function gms {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge --squash @Arguments
}

function gmff {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge --ff-only @Arguments
}

function gmtl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git mergetool --no-prompt @Arguments
}

function gmtlvim {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git mergetool --no-prompt --tool=vimdiff @Arguments
}

function gl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull @Arguments
}

function gpr {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase @Arguments
}

function gprv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase -v @Arguments
}

function gpra {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase --autostash @Arguments
}

function gprav {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase --autostash -v @Arguments
}

function gp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push @Arguments
}

function gpd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push --dry-run @Arguments
}


function gpf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if (Test-GitVersionAtLeast -RequiredVersion "2.30") {
    git push --force-with-lease --force-if-includes @Arguments
  }
  else {
    git push --force-with-lease @Arguments
  }
}

function gpv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push --verbose @Arguments
}

function gpoat {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push origin --all; git push origin --tags
}

function gpod {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push origin --delete @Arguments
}

function gpu {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push upstream @Arguments
}

function grb {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase @Arguments
}

function grba {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase --abort @Arguments
}

function grbc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase --continue @Arguments
}

function grbi {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase --interactive @Arguments
}

function grbo {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase --onto @Arguments
}

function grbs {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase --skip @Arguments
}

function grf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reflog @Arguments
}

function gr {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote @Arguments
}

function grv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote --verbose @Arguments
}

function gra {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote add @Arguments
}

function grrm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote remove @Arguments
}

function grmv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote rename @Arguments
}

function grset {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote set-url @Arguments
}

function grup {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git remote update @Arguments
}

function grh {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset @Arguments
}

function gru {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset -- @Arguments
}

function grhh {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset --hard @Arguments
}

function grhk {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset --keep @Arguments
}

function grhs {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset --soft @Arguments
}

function grs {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git restore @Arguments
}

function grss {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git restore --source @Arguments
}

function grst {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git restore --staged @Arguments
}

function grev {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git revert @Arguments
}

function greva {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git revert --abort @Arguments
}

function grevc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git revert --continue @Arguments
}

function grm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rm @Arguments
}

function grmc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rm --cached @Arguments
}

function gcount {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git shortlog --summary --numbered @Arguments
}

function gsh {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git show @Arguments
}

function gsps {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git show --pretty=short --show-signature @Arguments
}

function gstall {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash --all @Arguments
}

function gstaa {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash apply @Arguments
}

function gstc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash clear @Arguments
}

function gstd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash drop @Arguments
}

function gstl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash list @Arguments
}

function gstp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash pop @Arguments
}

function gsta {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if (Test-GitVersionAtLeast -RequiredVersion "2.13") {
    git stash push @Arguments
  }
  else {
    git stash save @Arguments
  }
}

function gsts {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash show --patch @Arguments
}

function gstu {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git stash --include-untracked @Arguments
}

function gst {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git status @Arguments
}

function gss {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git status --short @Arguments
}

function gsb {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git status --short --branch @Arguments
}

function gsi {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git submodule init @Arguments
}

function gsu {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git submodule update @Arguments
}

function gsd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git svn dcommit @Arguments
}

function gsr {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git svn rebase @Arguments
}

function gsw {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git switch @Arguments
}

function gswc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git switch --create @Arguments
}

function gta {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git tag --annotate @Arguments
}

function gts {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git tag --sign @Arguments
}

function gtv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git tag | Sort-Object -V @Arguments
}

function gignore {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git update-index --assume-unchanged @Arguments
}

function gunignore {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git update-index --no-assume-unchanged @Arguments
}

function gwch {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git whatchanged -p --abbrev-commit --pretty=medium @Arguments
}

function gwt {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git worktree @Arguments
}

function gwta {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git worktree add @Arguments
}

function gwtls {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git worktree list @Arguments
}

function gwtmv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git worktree move @Arguments
}

function gwtrm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git worktree remove @Arguments
}

function gwip {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git add -A
  git rm (git ls-files --deleted) 2>$null
  git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]" @Arguments
}

function gunwip {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  $commitMessage = git rev-list --max-count=1 --format="%s" HEAD
  if ($commitMessage -match "--wip--") {
    git reset HEAD~1
  }
}

function gcd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git checkout (Get-GitDevelopBranch) @Arguments
}

function gcm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git checkout (Get-GitMainBranch) @Arguments
}

function gswd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git switch (Get-GitDevelopBranch) @Arguments
}

function gswm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git switch (Get-GitMainBranch) @Arguments
}

function grbd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase (Get-GitDevelopBranch) @Arguments
}

function grbm {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase (Get-GitMainBranch) @Arguments
}

function grbom {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase "origin/$(Get-GitMainBranch)" @Arguments
}

function grbum {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git rebase "upstream/$(Get-GitMainBranch)" @Arguments
}

function ggsup {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --set-upstream-to="origin/$(Get-GitCurrentBranch)" @Arguments
}

function gmom {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge "origin/$(Get-GitMainBranch)" @Arguments
}

function gmum {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git merge "upstream/$(Get-GitMainBranch)" @Arguments
}

function gprom {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase origin (Get-GitMainBranch) @Arguments
}

function gpromi {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase=interactive origin (Get-GitMainBranch) @Arguments
}

function gprum {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase upstream (Get-GitMainBranch) @Arguments
}

function gprumi {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull --rebase=interactive upstream (Get-GitMainBranch) @Arguments
}

function ggpull {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull origin (Get-GitCurrentBranch) @Arguments
}

function ggpush {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push origin (Get-GitCurrentBranch) @Arguments
}

function gpsup {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git push --set-upstream origin (Get-GitCurrentBranch) @Arguments
}

function gpsupf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if (Test-GitVersionAtLeast -RequiredVersion "2.30") {
    git push --set-upstream origin (Get-GitCurrentBranch) --force-with-lease --force-if-includes @Arguments
  }
  else {
    git push --set-upstream origin (Get-GitCurrentBranch) --force-with-lease @Arguments
  }
}

function groh {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset "origin/$(Get-GitCurrentBranch)" --hard @Arguments
}

function gluc {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull upstream (Get-GitCurrentBranch) @Arguments
}

function  glum {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git pull upstream (Get-GitMainBranch) @Arguments
}

function gdct {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git describe --tags (git rev-list --tags --max-count=1) @Arguments
}

function gdnolock {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff @Arguments ":(exclude)package-lock.json" ":(exclude)*.lock"
}
function gdv {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git diff -w @Arguments | Out-Host
}

function gpristine {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset --hard; git clean --force -dfx
}

function gwipe {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git reset --hard; git clean --force -df
}

function gignored {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git ls-files -v | Where-Object { $_ -match "^[a-z]" }
}

function gbda {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  $mainBranch = Get-GitMainBranch
  $developBranch = Get-GitDevelopBranch
  git branch --no-color --merged | Where-Object {
    $_ -notmatch "^[\*\+]" -and
    $_ -notmatch "^\s*($mainBranch|$developBranch)\s*$"
  } | ForEach-Object {
    git branch --delete $_.Trim() 2>$null
  }
}

function gbds {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  $defaultBranch = Get-GitMainBranch
  if ($LASTEXITCODE -ne 0) { $defaultBranch = Get-GitDevelopBranch }

  git for-each-ref refs/heads/ "--format=%(refname:short)" | ForEach-Object {
    $branch = $_
    $mergeBase = git merge-base $defaultBranch $branch
    $cherry = git cherry $defaultBranch (git commit-tree (git rev-parse "$branch^{tree}") -p $mergeBase -m "_")
    if ($cherry -match "^-") {
      git branch -D $branch
    }
  }
}

function gbgd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --no-color -vv | Where-Object { $_ -match ": gone\]" } | ForEach-Object {
    $branchName = ($_ -replace "^.{3}" -split "\s+")[0]
    git branch -d $branchName
  }
}

function gbgD {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch --no-color -vv | Where-Object { $_ -match ": gone\]" } | ForEach-Object {
    $branchName = ($_ -replace "^.{3}" -split "\s+")[0]
    git branch -D $branchName
  }
}

function gbg {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git branch -vv | Where-Object { $_ -match ": gone\]" }
}

function gccd {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  $repo = $args | Where-Object { $_ -match "(ssh://|git://|ftp(s)?://|http(s)?://|.*@)" }
  if (!$repo) { $repo = $args[-1] }

  git clone --recurse-submodules @Arguments
  if ($LASTEXITCODE -eq 0) {
    if (Test-Path $args[-1]) {
      Set-Location $args[-1]
    }
    else {
      $repoName = [System.IO.Path]::GetFileNameWithoutExtension($repo)
      Set-Location $repoName
    }
  }
}

function ggpnp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -eq 0) {
    ggl; ggp

  }
  else {
    ggl @Arguments; ggp @Arguments
  }
}

function ggu {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -eq 0) {
    $branch = Get-GitCurrentBranch
    git pull --rebase origin $branch
  }
  else {
    git pull --rebase origin @Arguments
  }
}

function ggl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -eq 0) {
    $branch = Get-GitCurrentBranch
    git pull origin $branch
  }
  else {
    git pull origin @Arguments
  }
}

function ggp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -eq 0) {
    $branch = Get-GitCurrentBranch
    git push origin $branch
  }
  else {
    git push origin @Arguments
  }
}

function ggf {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -eq 0) {
    $branch = Get-GitCurrentBranch
    git push --force origin $branch
  }
  else {
    git push --force origin @Arguments
  }
}

function ggfl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -eq 0) {
    $branch = Get-GitCurrentBranch
    git push --force-with-lease origin $branch
  }
  else {
    git push --force-with-lease origin @Arguments
  }
}

function glods {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" --date=short @Arguments
}

function glod {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset" @Arguments
}

function glola {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all @Arguments
}

function glols {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --stat @Arguments
}

function glol {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" @Arguments
}


function glp {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  if ($Arguments.Count -gt 0) {
    git log --pretty=$Arguments[0]
  }
  else {
    git log
  }
}

function gtl {
  [CmdletBinding()]
  [OutputType([void])]
  param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Arguments
  )

  if (-not (Test-IsGitRepository)) {
    Write-Error "Not a git repository (or any of the parent directories): .git"
    return
  }

  $pattern = if ($Arguments.Count -gt 0) { "$($Arguments[0])*" } else { "*" }
  git tag --sort=-v:refname -n --list $pattern
}
