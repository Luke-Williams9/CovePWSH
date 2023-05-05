Function Invoke-CoveAPIcall () {
            <#
            .SYNOPSIS
            POST an API call to Cove
            
            .DESCRIPTION
            POST an API call to Cove

            .PARAMETER Body
            Hashtable of the request body
            
            .Parameter raw
            Switch parameter to tell function to return the raw result (IE intead of $result.result or $result.error )

            .EXAMPLE
            TBFI
        #>
        [cmdletBinding()]
        param (
            [Parameter(Mandatory=$true)]$body,
            [switch]$raw
        )
        if ($visa -eq '') {
            Throw 'No visa found. Did you authenticate? run Connect-Cove'
        }
        Write-Verbose "---------------"
        Write-Verbose "Function :: Cove-APIcall"
        Write-Verbose ("Method :: " + $body.method)
        Write-Verbose "Using Partner info:"
        Write-Verbose $partnerInfo | FL
        $webReq =  @{
            Method = 'POST'
            ContentType = 'application/json'
            Body = @{}
            URI = "https://api.backup.management/jsonapi"
            SessionVariable = 'WebSession'
            UseBasicParsing = $true
        }
        $body.jsonrpc = '2.0'
        $body.id = '2'
        $body.visa = $visa
        $webReq.Body = $body | ConvertTo-JSON -depth 100
        Write-Verbose "Request Body JSON:"
        Write-Verbose $webReq.Body
        $rawresult = Invoke-WebRequest @webReq
        $result = $rawresult | ConvertFrom-JSON -depth 100

        # Save the visa for future API calls
        if ($result.visa) {
            Write-Verbose "Visa found"
            $Global:visa = $result.visa
        }
        if ($result.error) {
            Write-Verbose "Error found in result"
            Throw $result.error
        }
        Write-Verbose "Result success"
        Write-Verbose $result
        Write-Verbose $rawresult
        if ($result.result -and !($raw)) {
            Return $result.result
        } else {
            Return $result
        }
    }