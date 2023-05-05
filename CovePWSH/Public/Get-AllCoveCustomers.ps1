Function Get-AllCoveCustomers () {
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
        Get-AllCoveCustomers
    #>
    [cmdletBinding()]
    #Write-Verbose "+==========="
    #Write-Verbose "Function: Get-AllCoveCustomers"

    $reqBody = @{
        method = 'EnumeratePartners'
        params = @{
            parentPartnerId = $partnerInfo.id
            fetchRecursively = $true
            fields = (0,1,3,4,5,8,9,10,18,20)
        }
    }
    $result = Invoke-CoveAPIcall -body $reqBody # -verbose
    if (!$result.result) {
        Throw $result
    }

    # Make a list of customers first
    $customers = $result.result | where Level -ne 'Site'

    # Then add sites
    foreach ($c in $customers) {
        $sites = $result.result | where {$_.ParentId -eq $c.id -and $_.Level -eq 'Site'}
        write-host $sites | ft
        if ($sites) {
            $c = $c | Add-Member -notePropertyMembers @{sites = $sites}
        }
    }

    Return $customers
}


