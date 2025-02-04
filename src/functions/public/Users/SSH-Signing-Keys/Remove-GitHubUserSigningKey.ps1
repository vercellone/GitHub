﻿filter Remove-GitHubUserSigningKey {
    <#
        .SYNOPSIS
        Delete an SSH signing key for the authenticated user

        .DESCRIPTION
        Deletes an SSH signing key from the authenticated user's GitHub account.
        You must authenticate with Basic Authentication, or you must authenticate with OAuth with at least
        `admin:ssh_signing_key` scope. For more information, see
        "[Understanding scopes for OAuth apps](https://docs.github.com/apps/building-oauth-apps/understanding-scopes-for-oauth-apps/)."

        .EXAMPLE
        Remove-GitHubUserSigningKey -ID '1234567'

        Removes the SSH signing key with the ID of `1234567` from the authenticated user's GitHub account.

        .NOTES
        [Delete an SSH signing key for the authenticated user](https://docs.github.com/rest/users/ssh-signing-keys#delete-an-ssh-signing-key-for-the-authenticated-user)
    #>
    [OutputType([pscustomobject])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidLongLines', '', Justification = 'Contains a long link.')]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The unique identifier of the SSH signing key.
        [Parameter(
            Mandatory
        )]
        [Alias('ssh_signing_key_id')]
        [string] $ID,

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
        try {
            $inputObject = @{
                Context     = $Context
                APIEndpoint = "/user/ssh_signing_keys/$ID"
                Method      = 'DELETE'
            }

            if ($PSCmdlet.ShouldProcess("SSH signing key with ID [$ID]", 'Delete')) {
                $null = Invoke-GitHubAPI @inputObject | ForEach-Object {
                    Write-Output $_.Response
                }
            }
        } catch {
            throw $_
        }
    }

    end {
        Write-Debug "[$stackPath] - End"
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
