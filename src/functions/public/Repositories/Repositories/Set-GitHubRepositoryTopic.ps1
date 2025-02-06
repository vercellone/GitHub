﻿filter Set-GitHubRepositoryTopic {
    <#
        .SYNOPSIS
        Replace all repository topics

        .DESCRIPTION
        Replace all repository topics

        .EXAMPLE
        Set-GitHubRepositoryTopic -Owner 'octocat' -Repository 'hello-world' -Names 'octocat', 'octo', 'octocat/hello-world'

        Replaces all topics for the repository 'octocat/hello-world' with the topics 'octocat', 'octo', 'octocat/hello-world'.

        .NOTES
        [Replace all repository topics](https://docs.github.com/rest/repos/repos#replace-all-repository-topics)
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The account owner of the repository. The name is not case sensitive.
        [Parameter(Mandatory)]
        [Alias('Organization')]
        [Alias('User')]
        [string] $Owner,

        # The name of the repository without the .git extension. The name is not case sensitive.
        [Parameter(Mandatory)]
        [string] $Repository,

        # The number of results per page (max 100).
        [Parameter()]
        [Alias('Topics')]
        [string[]] $Names = @(),

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
            names = $Names | ForEach-Object { $_.ToLower() }
        }

        $inputObject = @{
            Method      = 'PUT'
            APIEndpoint = "/repos/$Owner/$Repository/topics"
            Body        = $body
            Context     = $Context
        }

        if ($PSCmdlet.ShouldProcess("topics for repo [$Owner/$Repository]", 'Set')) {
            Invoke-GitHubAPI @inputObject | ForEach-Object {
                Write-Output $_.Response.names
            }
        }
    }

    end {
        Write-Debug "[$stackPath] - End"
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
