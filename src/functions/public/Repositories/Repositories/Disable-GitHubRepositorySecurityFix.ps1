﻿filter Disable-GitHubRepositorySecurityFix {
    <#
        .SYNOPSIS
        Disable automated security fixes

        .DESCRIPTION
        Disables automated security fixes for a repository. The authenticated user must have admin access to the repository.
        For more information, see
        "[Configuring automated security fixes](https://docs.github.com/articles/configuring-automated-security-fixes)".

        .EXAMPLE
        Disable-GitHubRepositorySecurityFix -Owner 'PSModule' -Repository 'GitHub'

        Disables automated security fixes for the repository.

        .NOTES
        [Disable automated security fixes](https://docs.github.com/rest/repos/repos#disable-automated-security-fixes)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('Disable-GitHubRepositorySecurityFixes')]
    param(
        # The account owner of the repository. The name is not case sensitive.
        [Parameter(Mandatory)]
        [Alias('Organization')]
        [Alias('User')]
        [string] $Owner,

        # The name of the repository without the .git extension. The name is not case sensitive.
        [Parameter(Mandatory)]
        [string] $Repository,

        # The context to run the command in. Used to get the details for the API call.
        # Can be either a string or a GitHubContext object.
        [Parameter()]
        [GitHubContextTransform()]
        [object] $Context = (Get-GitHubContext)
    )

    begin {
        $stackPath = Get-PSCallStackPath
        Write-Debug "[$stackPath] - Start"
        Assert-GitHubContext -Context $Context -AuthType IAT, PAT, UAT
    }

    process {
        $inputObject = @{
            Method      = 'DELETE'
            APIEndpoint = "/repos/$Owner/$Repository/automated-security-fixes"
            Context     = $Context
        }

        if ($PSCmdlet.ShouldProcess("Security Fixes for [$Owner/$Repository]", 'Disable')) {
            Invoke-GitHubAPI @inputObject | ForEach-Object {
                Write-Output $_.Response
            }
        }
    }

    end {
        Write-Debug "[$stackPath] - End"
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
