<#
.SYNOPSIS
    Disables AD User.
.DESCRIPTION
    This function disables a specified AD Account aswell as performing the following;
    - Moves User to the 'Disabled OU' within Active Directory
.NOTES
    AUTHOR: Sam Parris
    CREATION DATE: 10-November-2021
#>
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseApprovedVerbs", "")]
param()

Function SysAdmin.Disable-ADUser {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)] $UserName
    )
    Begin {
        $ErrorActionPreference = 'Stop'
        $DisabledOU = "OU=Obj-Users,OU=Generic-Disabled Accounts,OU=ORG,DC=invotec-uk,DC=com"
    }
    Process {
        Try {
            $AllUserInfo = Get-ADUser -Properties * -Identity $UserName
        }
        Catch {
            Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        }
        If ($AllUserInfo.Enabled -eq $false) {
            Write-Error "$($UserName) is already disabled within Active Directory."
        }
        Else {
            Write-Host "$($UserName) has been found within Active Directory" -ForegroundColor DarkGreen
            $Credentials = Get-Credential
        }
        Try {
            $NewUserParams = @{
                Enabled     = $false
                Description = "Disabled by $($Credentials.UserName) on $(Get-Date -Format 'dd-MM-yyyy')"
                Credential  = $Credentials
            }
            Set-ADUser -Identity $UserName @NewUserParams
        }
        Catch {
            Write-Error "$($_.Exception.Message) - Line Number: $($_.InvocationInfo.ScriptLineNumber)"
        }
    }
}