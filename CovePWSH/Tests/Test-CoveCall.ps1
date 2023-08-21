Function Test-CoveCall () {
        <#
            .SYNOPSIS
            To be filled in
            
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
        #Write-Verbose "+==========="
        #Write-Verbose "Function: Get-AllCoveCustomers"
        param (
        [string]$method,
        $params
        )
        $reqBody = @{
            method = $method
            params = $params
        }
        Return Invoke-CoveAPIcall -body $reqBody -raw -verbose
}