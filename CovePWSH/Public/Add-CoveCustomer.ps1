Function Add-CoveCustomer () {
        <#
            .SYNOPSIS
            Returns Cove Partner info
            
            .DESCRIPTION
            Returns the result of method 'GetPartnerInfo'
            
            .INPUTS
            None
            
            .OUTPUTS
            PSobject

            .EXAMPLE
            Get-CovePartnerInfo
        #>
        [cmdletBinding()]
        param (
            [string]$name,
            [string]$country = "Canada",
            [string]$state = 'InTrial' # Change to InProduction once we buy in?
        )
        $reqBody = @{
            method = 'AddPartner'
            params = @{
                partnerInfo = @{
                    ParentId = $partnerInfo.id
                    Name = $name
                    Level = 'EndCustomer'
                    ServiceType = 'AllInclusive'
                    State = $state
                    ChildServiceTypes = @(
                        'AllInclusive'
                    )
                    Country = $country
                }
            }
        }
        $result = Invoke-CoveAPIcall -body $reqBody -verbose
        Return $result
    }