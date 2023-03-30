Function Edit-CoveProfile-test () {
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
        #param (
        #    [Parameter(Mandatory=$true)][int]$profileId
        #)   
        
        #Write-Verbose "+==========="
        #Write-Verbose "Function: Get-AllCoveCustomers"
        #param (
        #   [Parameter(Mandatory=$true)][int]$partnerId
        #)
        <# Old exclusion filter
        /Users/*/Library/CloudStorage/*|/Users/*/Library/Biome/*|/Users/*/Library/*/NSFileProtectionCompleteUnlessOpen/*|/Users/*/Library/Caches/com.apple.AppleMediaServices/*|/System/Volumes/*
        
        Profile API methods
        EnumerateAccountProfiles
        GetAccountProfileInfo
        ModifyAccountProfile
        #>
        
        $pdata = (Get-CoveProfiles -name 'MacOS')[0]
        $pData.name = $pData.name + ' - clone ' + ((1000..9999) | Get-Random)
        ($pdata.ProfileData.BackupDataSourceSettings | where DataSource -eq 'WorkstationFileSystem').ExclusionFilter = $excl
        $reqBody = @{
            method = 'AddAccountProfile'
            params = @{
                accountProfileInfo = $pData
            }
        }
        $result = Cove-APIcall -body $reqBody -verbose
        if (!$result.result) {
            Throw $result
        }
    
        Return $result.result

    }