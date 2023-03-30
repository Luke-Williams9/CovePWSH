Function Get-CovePartnerInfo () {
        <#
            .SYNOPSIS
            Returns Cove Partner info
            
            .DESCRIPTION
            Returns the result of method 'GetPartnerInfo' or 'GetPartnerInfoByID. It will take either the id or the name, and favor using the id over the name.
            
            .PARAMETER name
            The Partner name    

            .PARAMETER id
            The partner id
            
            .OUTPUTS
            PSobject result from the API

            .EXAMPLE
            Get-CovePartnerInfo

            .EXAMPLE
            Get-CovePartnerInfo -id 45056
            
            .EXAMPLE
            Get-CovePartnerInfo -name 'Contoso'
        #>
        
        [cmdletBinding()]
        param (
            [string]$name,
            [int]$id
        )
        $reqBody = @{
            method = 'GetPartnerInfo'
            params = @{}
        }
        <#
        . ./Library-Cove.ps1
        . ./GetAPI-Cove.ps1
        Get-CovePartnerInfo -id 2578460
        Get-CovePartnerInfo -id 2578460

        #>
        
        # If no params are provided, then return the root partner info
        if (!$name -and !$id) {
            $reqBody.params = @{ name = $partnerName }
        }
        
        # if a name was provided, use it
        if ($name) {
            $reqBody.params = @{ name = $name }
        }
        
        # if an id was provided, then use it. If both id and name were provided then use id over name
        if ($id) {
            $reqBody.method = 'GetPartnerInfoById'
            $reqBody.params = @{ partnerId = $id }
        }

        Return (Invoke-CoveAPIcall -body $reqBody).result
    }