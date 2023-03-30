Function Get-CoveDevices () {
        <#
            .SYNOPSIS
            Returns all devices in Cove
            
            .DESCRIPTION
            Returns the result of method 'EnumerateAccountStatistics'
            
            .INPUTS
            None
            
            .OUTPUTS
            PSobject

            .EXAMPLE
            Get-CovePartnerInfo
        #>
        # Doesn't work yet
        [cmdletBinding()]
        $partner = Get-CovePartnerInfo
        Write-Verbose ($partner | FL)
        $reqBody = @{
            method = 'EnumerateAccountStatistics'
            params = @{
                query = @{
                    PartnerId = [int]$partner.id
                    SelectionMode = "PerInstallation"
                    Filter = "AT == 1" # Exclude M365 devices
                    Columns = @("AU","AR","AN","PF","LN","OP","OI","OS","OT","PD","AP","PN","AA843","MN","TS","EI","IP","MO","MF","CD","VN","II","IM","RTG","RP")
                    OrderBy = "T7 ASC"
                    StartRecordNumber = 0
                    RecordsCount = $devicecount
                    Totals = @("COUNT(AT==1)","SUM(T3)","SUM(US)")
                }
            }
        }
        $result = (Invoke-CoveAPIcall -body $reqBody).result
        <#
        $deviceDetails = foreach ($DeviceResult in $results) {
            [PSCustomObject] @{
                AccountID      = [String]$DeviceResult.AccountId
                PartnerID      = [string]$DeviceResult.PartnerId
                DeviceName     = $DeviceResult.Settings.AN -join ''                                                                
                PartnerName    = $DeviceResult.Settings.AR -join ''
                Reference      = $DeviceResult.Settings.PF -join ''
                DataSources    = $DeviceResult.Settings.AP -join ''                                                                
                Location       = $DeviceResult.Settings.LN -join ''
                Notes          = $DeviceResult.Settings.AA843 -join ''
                Product        = $DeviceResult.Settings.PN -join ''
                ProductID      = $DeviceResult.Settings.PD -join ''
                Profile        = $DeviceResult.Settings.OP -join ''
                OS             = $DeviceResult.Settings.OS -join ''
                MachineName    = $DeviceResult.Settings.MN -join ''  
                MFG_Name       = $DeviceResult.Settings.MF -join ''
                MFG_Model      = $DeviceResult.Settings.MO -join ''
                IP             = $DeviceResult.Settings.IP -join ''  
                Ext_IP         = $DeviceResult.Settings.EI -join ''
                Creation       = $DeviceResult.Settings.CD -join ''
                TimeStamp      = $DeviceResult.Settings.TS -join ''
                ClientVersion  = $DeviceResult.Settings.VN -join ''
                InstallID      = $DeviceResult.Settings.II -join ''  
                InstallMode    = $DeviceResult.Settings.IM -join ''
                LastRestore    = $DeviceResult.Settings.RTG -join ''  
                ProfileID      = $DeviceResult.Settings.OI -join ''
            }
        }
        Return $deviceDetails
        #>
        Return $result
    }