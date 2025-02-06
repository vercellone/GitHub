﻿filter Get-GitHubRepositoryFork {
    <#
        .SYNOPSIS
        List forks

        .DESCRIPTION
        List forks of a named repository.

        .EXAMPLE
        Get-GitHubRepositoryFork -Owner 'octocat' -Repository 'Hello-World'

        List forks of the 'Hello-World' repository owned by 'octocat'.

        .NOTES
        [List forks](https://docs.github.com/rest/repos/forks#list-forks)
    #>
    [CmdletBinding()]
    param(
        # The account owner of the repository. The name is not case sensitive.
        [Parameter(Mandatory)]
        [Alias('Organization')]
        [Alias('User')]
        [string] $Owner,

        # The name of the repository without the .git extension. The name is not case sensitive.
        [Parameter(Mandatory)]
        [string] $Repository,

        # The direction to sort the results by.
        [Parameter()]
        [ValidateSet('newest', 'oldest', 'stargazers', 'watchers')]
        [string] $Sort = 'newest',

        # The number of results per page.
        [Parameter()]
        [ValidateRange(0, 100)]
        [int] $PerPage,

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
        $body = @{
            sort     = $Sort
            per_page = $PerPage
        }
        $body | Remove-HashtableEntry -NullOrEmptyValues

        $inputObject = @{
            Method      = 'GET'
            APIEndpoint = "/repos/$Owner/$Repository/forks"
            Body        = $body
            Context     = $Context
        }

        Invoke-GitHubAPI @inputObject | ForEach-Object {
            Write-Output $_.Response
        }
    }

    end {
        Write-Debug "[$stackPath] - End"
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
