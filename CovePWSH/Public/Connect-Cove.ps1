Function Connect-Cove () {
        <#
            .SYNOPSIS
            Log into the Cove API
            
            .DESCRIPTION
            Create initial conenction to Cove API, using the partner name, id, and secret specified. Once connected, a couple script variables will become available:
            $visa - The Visa to be used in the next API call. Every successful call will return a Visa value, which must be used in the next call. Invoke-CoveAPIcall uses this directly
            $partnerInfo - the information about your root Cove account

            .PARAMETER partnerName
            Full name of the partner
            
            .PARAMETER id
            The API key ID

            .PARAMETER secret
            THe API key secret
            
            .EXAMPLE
            Connect-Cove -partnerName 'Derp IT (bob@derpit.com)' -id 'sadfsdfadsfgaw43wgf' -secret 'as4rws65yt5hgew4fg4wATFG3AGH54HGA34'
            
            .EXAMPLE
            $ConnectionSplat = @{
                partnerName = 'Derp IT (bob@derpit.com)'
                id = 'sadfsdfadsfgaw43wgf'
                secret 'as4rws65yt5hgew4fg4wATFG3AGH54HGA34'
            }
            Connect-Cove @ConnectionSplat
        #>
        [cmdletBinding()]
        param (
            [Parameter(Mandatory=$true)][string]$partnerName,
            [Parameter(Mandatory=$true)][string]$id,
            [Parameter(Mandatory=$true)][string]$secret
        )
        $webReq =  @{
            Method = 'POST'
            ContentType = 'application/json'
            Body = @{
                jsonrpc = '2.0'
                id = '2'
                method = 'Login'
                params = @{
                    partner = $partnerName
                    username = $id
                    password = $secret
                }
            } | ConvertTo-JSON -depth 100
            URI = "https://api.backup.management/jsonapi"
            SessionVariable = 'WebSession'
            UseBasicParsing = $true
        } 
        $result = Invoke-WebRequest @webReq | ConvertFrom-JSON -depth 100
        $cookies = $webSession.Cookies.GetCookies($webReq.URI)
        if (!$result.visa) {
            Throw $result
        }
        $Script:visa = $result.visa
        $Script:partnerInfo = Get-CovePartnerInfo
        Return $True
    }