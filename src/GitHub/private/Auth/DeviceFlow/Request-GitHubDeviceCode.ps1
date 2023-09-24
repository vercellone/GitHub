﻿function Request-GitHubDeviceCode {
    <#
        .SYNOPSIS
        Request a GitHub Device Code.

        .DESCRIPTION
        Request a GitHub Device Code.

        .EXAMPLE
        Request-GitHubDeviceCode -ClientID $ClientID -Mode $Mode

        This will request a GitHub Device Code.

        .NOTES
        For more info about the Device Flow visit:
        https://docs.github.com/en/apps/creating-github-apps/writing-code-for-a-github-app/building-a-cli-with-a-github-app
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        # The Client ID of the GitHub App.
        [Parameter(Mandatory)]
        [string] $ClientID,

        # The scope of the access token, when using OAuth authentication.
        # Provide the list of scopes as space-separated values.
        # For more information on scopes visit:
        # https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps
        [Parameter()]
        [string] $Scope = 'gist, read:org, repo, workflow'
    )

    $headers = @{
        Accept = 'application/json'
    }

    $body = @{
        client_id = $ClientID
        scope     = $Scope
    }

    $RESTParams = @{
        Uri     = 'https://github.com/login/device/code'
        Method  = 'POST'
        Body    = $body
        Headers = $headers
    }

    try {
        Write-Verbose ($RESTParams.GetEnumerator() | Out-String)

        $deviceCodeResponse = Invoke-RestMethod @RESTParams -Verbose:$false
        return $deviceCodeResponse
    } catch {
        Write-Error $_
        throw $_
    }
}

