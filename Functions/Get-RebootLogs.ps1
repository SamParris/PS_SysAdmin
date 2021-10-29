<#
.SYNOPSIS
    Pull System Event Logs for ID 1074 (Reboots).
.DESCRIPTION
    This function pulls event logs for either the current system, or a remote system (using -ComputerName) and displays all ID 1074 (Reboot) logs.
.PARAMETER ComputerName
    Allows you to specify a remote computer to pull event logs from.
.PARAMETER EventCount
    Allows you to specify the maximum number of event logs to show.
.NOTES
    AUTHOR: Sam Parris
    CREATION DATE: 28-October-2021
#>

Function Get-RebootLogs {
    [CmdletBinding()]
    Param(
        [Parameter()] $ComputerName = $env:COMPUTERNAME,
        [Parameter()] [int] $EventCount
    )
    Process {
        Try {
            $Params = @{
                FilterHashTable = @{
                    LogName = 'System'
                    ID      = '1074'
                }
                ComputerName    = $ComputerName.ToUpper()
                ErrorAction     = 'SilentlyContinue'
                Verbose         = $VerbosePreference
            }
            If ($EventCount) {
                $Params['MaxEvents'] = $EventCount
            }
            Write-Host "Collecting reboot logs from $($ComputerName)...." -ForegroundColor Cyan
            Get-WinEvent @Params
        } Catch {
            Write-Error "$($_.Exception.Message)"
        }
    }
}