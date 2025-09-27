#Requires -Version 7.0

#---------------------------------------------------------------------------------------------------
# MKAbuMattar's PowerShell Profile - Rsync Plugin
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
#       This module provides Rsync plugin for PowerShell Profile - File synchronization and
#       transfer operations. Provides PowerShell functions for common rsync operations including
#       copy, move, update, and synchronize with progress reporting and cross-platform support.
#
# Created: 2025-09-27
# Updated: 2025-09-27
#
# GitHub: https://github.com/MKAbuMattar/powershell-profile
#
# Version: 4.1.0
#---------------------------------------------------------------------------------------------------

function Test-RsyncInstalled {
    <#
    .SYNOPSIS
        Test if rsync is installed and accessible.

    .DESCRIPTION
        Verifies that rsync command is available in the current environment.
        Used internally by other rsync functions to ensure rsync is available.

    .EXAMPLE
        Test-RsyncInstalled
        Returns $true if rsync is available, $false otherwise.

    .OUTPUTS
        Boolean
        Returns $true if rsync is accessible, $false otherwise.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    try {
        $rsyncVersion = & rsync --version 2>$null
        if ($rsyncVersion) {
            Write-Verbose "Rsync is available: $($rsyncVersion[0])"
            return $true
        }
        return $false
    }
    catch {
        Write-Warning "Rsync is not installed or not accessible. Please install rsync to use rsync functions."
        return $false
    }
}

function Show-RsyncProgress {
    <#
    .SYNOPSIS
        Display rsync operation progress information.

    .DESCRIPTION
        Shows information about the rsync operation being performed.
        Used internally to provide user feedback.

    .PARAMETER Operation
        The type of rsync operation being performed.

    .PARAMETER Source
        The source path or pattern.

    .PARAMETER Destination
        The destination path.

    .EXAMPLE
        Show-RsyncProgress -Operation "Copy" -Source "folder/" -Destination "backup/"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Operation,

        [Parameter(Mandatory = $true)]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [string]$Destination
    )

    Write-Host "Rsync $Operation Operation:" -ForegroundColor Cyan
    Write-Host "  Source:      $Source" -ForegroundColor Yellow
    Write-Host "  Destination: $Destination" -ForegroundColor Yellow
    Write-Host "  Starting transfer..." -ForegroundColor Green
}

function Invoke-RsyncCopy {
    <#
    .SYNOPSIS
        Copy files and directories using rsync with archive, verbose, compression, and progress.

    .DESCRIPTION
        Performs rsync copy operation with the flags: -avz --progress -h
        Equivalent to 'rsync-copy' alias in bash. Archives files while preserving 
        permissions, timestamps, and other attributes. Shows progress and uses compression.

    .PARAMETER Source
        The source file or directory path. Can be local or remote (user@host:path).

    .PARAMETER Destination
        The destination file or directory path. Can be local or remote (user@host:path).

    .PARAMETER AdditionalArgs
        Additional rsync arguments to pass to the command.

    .EXAMPLE
        Invoke-RsyncCopy "source/" "destination/"
        Copies source directory to destination with full archive and progress.

    .EXAMPLE
        rsync-copy "user@server:/remote/path/" "./local/"
        Downloads from remote server with progress and compression.

    .EXAMPLE
        Invoke-RsyncCopy "./docs/" "backup/docs/" -AdditionalArgs @("--exclude", "*.tmp")
        Copies with additional exclusion pattern.

    .OUTPUTS
        None
        Executes rsync command with output displayed directly.

    .NOTES
        Equivalent to: rsync -avz --progress -h
        -a: archive mode (recursive, preserves almost everything)
        -v: verbose output
        -z: compress file data during transfer
        --progress: show progress during transfer
        -h: human-readable numbers

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding()]
    [Alias("rsync-copy")]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Source,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Destination,

        [Parameter()]
        [string[]]$AdditionalArgs = @()
    )

    if (-not (Test-RsyncInstalled)) {
        return
    }

    try {
        Show-RsyncProgress -Operation "Copy" -Source $Source -Destination $Destination

        $rsyncArgs = @("-avz", "--progress", "-h") + $AdditionalArgs + @($Source, $Destination)
        
        Write-Verbose "Executing: rsync $($rsyncArgs -join ' ')"
        & rsync @rsyncArgs

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Copy operation completed successfully!" -ForegroundColor Green
        }
        else {
            Write-Error "Rsync copy operation failed with exit code: $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to execute rsync copy: $($_.Exception.Message)"
    }
}

function Invoke-RsyncMove {
    <#
    .SYNOPSIS
        Move files and directories using rsync (copy + remove source files).

    .DESCRIPTION
        Performs rsync move operation with the flags: -avz --progress -h --remove-source-files
        Equivalent to 'rsync-move' alias in bash. Copies files and then removes source files,
        effectively moving them. Shows progress and uses compression.

    .PARAMETER Source
        The source file or directory path. Can be local or remote (user@host:path).

    .PARAMETER Destination
        The destination file or directory path. Can be local or remote (user@host:path).

    .PARAMETER AdditionalArgs
        Additional rsync arguments to pass to the command.

    .EXAMPLE
        Invoke-RsyncMove "old-folder/" "new-folder/"
        Moves old-folder contents to new-folder and removes source files.

    .EXAMPLE
        rsync-move "temp-data/" "archived-data/"
        Moves temporary data to archive location using alias.

    .EXAMPLE
        Invoke-RsyncMove "./uploads/" "user@server:/storage/" -AdditionalArgs @("--dry-run")
        Shows what would be moved without actually moving files.

    .OUTPUTS
        None
        Executes rsync command with output displayed directly.

    .NOTES
        Equivalent to: rsync -avz --progress -h --remove-source-files
        --remove-source-files: remove source files after successful transfer
        
        WARNING: This will delete source files after copying. Use with caution!

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("rsync-move")]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Source,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Destination,

        [Parameter()]
        [string[]]$AdditionalArgs = @()
    )

    if (-not (Test-RsyncInstalled)) {
        return
    }

    # Confirm destructive operation
    if ($PSCmdlet.ShouldProcess($Source, "Move files and remove source")) {
        try {
            Show-RsyncProgress -Operation "Move" -Source $Source -Destination $Destination
            Write-Warning "This operation will remove source files after copying!"

            $rsyncArgs = @("-avz", "--progress", "-h", "--remove-source-files") + $AdditionalArgs + @($Source, $Destination)
            
            Write-Verbose "Executing: rsync $($rsyncArgs -join ' ')"
            & rsync @rsyncArgs

            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Move operation completed successfully!" -ForegroundColor Green
            }
            else {
                Write-Error "Rsync move operation failed with exit code: $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to execute rsync move: $($_.Exception.Message)"
        }
    }
}

function Invoke-RsyncUpdate {
    <#
    .SYNOPSIS
        Update files and directories using rsync (skip existing newer files).

    .DESCRIPTION
        Performs rsync update operation with the flags: -avzu --progress -h
        Equivalent to 'rsync-update' alias in bash. Only transfers files that are newer
        than the destination files or don't exist at destination. Shows progress.

    .PARAMETER Source
        The source file or directory path. Can be local or remote (user@host:path).

    .PARAMETER Destination
        The destination file or directory path. Can be local or remote (user@host:path).

    .PARAMETER AdditionalArgs
        Additional rsync arguments to pass to the command.

    .EXAMPLE
        Invoke-RsyncUpdate "source/" "backup/"
        Updates backup directory with newer files from source.

    .EXAMPLE
        rsync-update "user@server:/data/" "./local-copy/"
        Downloads only newer files from remote server.

    .EXAMPLE
        Invoke-RsyncUpdate "./project/" "backup/project/" -AdditionalArgs @("--exclude", ".git/")
        Updates backup excluding git directory.

    .OUTPUTS
        None
        Executes rsync command with output displayed directly.

    .NOTES
        Equivalent to: rsync -avzu --progress -h
        -u: update - skip files that are newer on the destination

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding()]
    [Alias("rsync-update")]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Source,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Destination,

        [Parameter()]
        [string[]]$AdditionalArgs = @()
    )

    if (-not (Test-RsyncInstalled)) {
        return
    }

    try {
        Show-RsyncProgress -Operation "Update" -Source $Source -Destination $Destination

        $rsyncArgs = @("-avzu", "--progress", "-h") + $AdditionalArgs + @($Source, $Destination)
        
        Write-Verbose "Executing: rsync $($rsyncArgs -join ' ')"
        & rsync @rsyncArgs

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Update operation completed successfully!" -ForegroundColor Green
        }
        else {
            Write-Error "Rsync update operation failed with exit code: $LASTEXITCODE"
        }
    }
    catch {
        Write-Error "Failed to execute rsync update: $($_.Exception.Message)"
    }
}

function Sync-RsyncDirectories {
    <#
    .SYNOPSIS
        Synchronize directories using rsync (two-way sync with deletion).

    .DESCRIPTION
        Performs rsync synchronize operation with the flags: -avzu --delete --progress -h
        Equivalent to 'rsync-synchronize' alias in bash. Makes destination identical to source
        by copying newer files and deleting files that don't exist in source. Shows progress.

    .PARAMETER Source
        The source file or directory path. Can be local or remote (user@host:path).

    .PARAMETER Destination
        The destination file or directory path. Can be local or remote (user@host:path).

    .PARAMETER AdditionalArgs
        Additional rsync arguments to pass to the command.

    .EXAMPLE
        Sync-RsyncDirectories "master/" "backup/"
        Synchronizes backup to exactly match master directory.

    .EXAMPLE
        rsync-synchronize "./local/" "user@server:/remote/"
        Synchronizes remote directory to match local directory.

    .EXAMPLE
        Sync-RsyncDirectories "source/" "dest/" -AdditionalArgs @("--dry-run")
        Shows what would be synchronized without making changes.

    .OUTPUTS
        None
        Executes rsync command with output displayed directly.

    .NOTES
        Equivalent to: rsync -avzu --delete --progress -h
        --delete: delete extraneous files from destination directories
        
        WARNING: This will delete files at destination that don't exist in source!

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias("rsync-synchronize")]
    [OutputType([void])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Source,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Destination,

        [Parameter()]
        [string[]]$AdditionalArgs = @()
    )

    if (-not (Test-RsyncInstalled)) {
        return
    }

    # Confirm destructive operation
    if ($PSCmdlet.ShouldProcess($Destination, "Synchronize and delete extraneous files")) {
        try {
            Show-RsyncProgress -Operation "Synchronize" -Source $Source -Destination $Destination
            Write-Warning "This operation will delete files at destination that don't exist in source!"

            $rsyncArgs = @("-avzu", "--delete", "--progress", "-h") + $AdditionalArgs + @($Source, $Destination)
            
            Write-Verbose "Executing: rsync $($rsyncArgs -join ' ')"
            & rsync @rsyncArgs

            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Synchronization completed successfully!" -ForegroundColor Green
            }
            else {
                Write-Error "Rsync synchronization failed with exit code: $LASTEXITCODE"
            }
        }
        catch {
            Write-Error "Failed to execute rsync synchronization: $($_.Exception.Message)"
        }
    }
}

function Get-RsyncVersion {
    <#
    .SYNOPSIS
        Get the version of installed rsync.

    .DESCRIPTION
        Retrieves and displays the version information for the installed rsync command.
        Useful for troubleshooting and ensuring compatibility.

    .EXAMPLE
        Get-RsyncVersion
        Displays the rsync version information.

    .OUTPUTS
        String
        Returns the rsync version information.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    if (-not (Test-RsyncInstalled)) {
        return
    }

    try {
        $versionInfo = & rsync --version
        Write-Output $versionInfo
    }
    catch {
        Write-Error "Failed to get rsync version: $($_.Exception.Message)"
    }
}

function Test-RsyncPath {
    <#
    .SYNOPSIS
        Test if a path is accessible for rsync operations.

    .DESCRIPTION
        Validates that a local or remote path exists and is accessible for rsync operations.
        Can be used to verify paths before running rsync commands.

    .PARAMETER Path
        The path to test. Can be local or remote (user@host:path format).

    .PARAMETER Remote
        Indicates if the path is a remote path that should be tested via SSH.

    .EXAMPLE
        Test-RsyncPath "./source-folder/"
        Tests if local path exists.

    .EXAMPLE
        Test-RsyncPath "user@server:/remote/path/" -Remote
        Tests if remote path is accessible.

    .OUTPUTS
        Boolean
        Returns $true if path is accessible, $false otherwise.

    .LINK
        https://github.com/MKAbuMattar/powershell-profile/blob/main/Module/Plugins/Rsync/README.md
    #>
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,

        [Parameter()]
        [switch]$Remote
    )

    try {
        $isRemotePath = $Remote -or ($Path -match '.*@.*:')
        
        if ($isRemotePath) {
            $colonIndex = $Path.LastIndexOf(':')
            if ($colonIndex -eq -1) {
                Write-Warning "Invalid remote path format. Expected: user@host:path"
                return $false
            }
            
            $connectionString = $Path.Substring(0, $colonIndex)
            $remotePath = $Path.Substring($colonIndex + 1)
            
            $testCommand = "test -e '$remotePath' && echo 'exists' || echo 'not found'"
            $result = & ssh $connectionString $testCommand 2>$null
            return ($result -eq 'exists')
        }
        else {
            return (Test-Path $Path)
        }
    }
    catch {
        Write-Verbose "Path test failed: $($_.Exception.Message)"
        return $false
    }
}
