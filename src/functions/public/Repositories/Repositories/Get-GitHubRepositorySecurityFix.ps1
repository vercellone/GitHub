﻿filter Get-GitHubRepositorySecurityFix {
    <#
        .SYNOPSIS
        Check if automated security fixes are enabled for a repository

        .DESCRIPTION
        Shows whether automated security fixes are enabled, disabled or paused for a repository.
        The authenticated user must have admin read access to the repository. For more information, see
        "[Configuring automated security fixes](https://docs.github.com/articles/configuring-automated-security-fixes)".

        .EXAMPLE
        Get-GitHubRepositorySecurityFix -Owner 'PSModule' -Repo 'GitHub'

        Gets the automated security fixes status for the GitHub repository.

        .NOTES
        [Check if automated security fixes are enabled for a repository](https://docs.github.com/rest/repos/repos#check-if-automated-security-fixes-are-enabled-for-a-repository)
    #>
    #SkipTest:FunctionTest:Will add a test for this function in a future PR
    [Alias('Get-GitHubRepoSecurityFixes')]
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidLongLines', '', Justification = 'Contains a long link.')]
    param(
        # The account owner of the repository. The name is not case sensitive.
        [Parameter()]
        [Alias('org')]
        [string] $Owner,

        # The name of the repository without the .git extension. The name is not case sensitive.
        [Parameter()]
        [string] $Repo,

        # The context to run the command in. Used to get the details for the API call.
        # Can be either a string or a GitHubContext object.
        [Parameter()]
        [object] $Context = (Get-GitHubContext)
    )

    begin {
        $stackPath = Get-PSCallStackPath
        Write-Debug "[$stackPath] - Start"
        $Context = Resolve-GitHubContext -Context $Context
        Assert-GitHubContext -Context $Context -AuthType IAT, PAT, UAT

        if ([string]::IsNullOrEmpty($Owner)) {
            $Owner = $Context.Owner
        }
        Write-Debug "Owner: [$Owner]"

        if ([string]::IsNullOrEmpty($Repo)) {
            $Repo = $Context.Repo
        }
        Write-Debug "Repo: [$Repo]"
    }

    process {
        try {
            $inputObject = @{
                Context     = $Context
                APIEndpoint = "/repos/$Owner/$Repo/automated-security-fixes"
                Method      = 'GET'
            }

            Invoke-GitHubAPI @inputObject | ForEach-Object {
                Write-Output $_.Response
            }
        } catch {
            throw $_
        }
    }

    end {
        Write-Debug "[$stackPath] - End"
    }
}
