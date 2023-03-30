Function Add-CoveCustomerSite () {
        <#
            .SYNOPSIS
            Adds a site to a Cove customer
            
            .DESCRIPTION
            Uses the 'AddPartner' endpoint, with the ParentId specified
            .PARAMETER name
            The name of the site to be added
            
            .PARAMETER country
            The sites country. Is optional, defaults to Canada

            .PARAMETER parentId
            The ID of the parent customer

            .OUTPUTS
            PSobject

            .EXAMPLE
            Add-CoveCustomerSite -name 'Main Office' -parentId 493892
        #>
        [cmdletBinding()]
        param (
            [string]$name,
            [string]$country = "Canada",
            [int]$parentId
        )
        $reqBody = @{
            method = 'AddPartner'
            params = @{
                partnerInfo = @{
                    ParentId = $ParentId
                    Name = $name
                    Level = 'Site'
                    ServiceType = 'AllInclusive'
                }
            }
        }
        $result = Invoke-CoveAPIcall -body $reqBody -verbose
        Return $result
    }