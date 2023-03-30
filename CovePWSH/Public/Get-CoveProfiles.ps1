Function Get-CoveProfiles () {
        <#
            .SYNOPSIS
            Get one or all profiles
            
            .DESCRIPTION
            TBFI
            
            .INPUTS
            TBFI
            
            .OUTPUTS
            PSobject

            .EXAMPLE
            TBFI
        #>
        [cmdletBinding()]
        param (
           [int]$customerId,
           [int]$profileId,
           [string]$name # Profile name
        )
        If ($customerId) {
            $i = $customerId
        } else {
            $i = $partnerInfo.Id
        }
        $reqBody = @{
            method = 'EnumerateAccountProfiles'
            params = @{
                partnerId = $i
            }
        }
        $result = Invoke-CoveAPIcall -body $reqBody # -verbose
        if (!$result.result) {
            Throw $result
        }
        if ($name) {
            $r = $result.result | where Name -match $name
        } else {
            $r = $result.result
        }   
        Return $r
    }