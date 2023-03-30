Function Modify-CoveCustomer () {
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
        # I don't think this one is finished yet
        #Write-Verbose "+==========="
        #Write-Verbose "Function: Get-AllCoveCustomers"
        param (
            [Parameter(Mandatory=$true)][int]$partnerInfo
        )
        $reqBody = @{
            method = 'ModifyPartner'
            params = @{
                parentPartnerId = $partnerId
                fetchRecursively = $true
                fields = (0,1,3,4,5,8,9,10,18,20)
            }
        }
        $result = Invoke-CoveAPIcall -body $reqBody # -verbose
        if (!$result.result) {
            Throw $result
        }

        Return $result.result

    }