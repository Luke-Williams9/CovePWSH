Function Get-AllCoveDevices () {
        <#
            .SYNOPSIS
            Get all devices in Cove
            
            .DESCRIPTION
            Enumerate all Cove devices, return a PSobject with some human readable RMM data in it.
            
            .INPUTS
            None
            
            .OUTPUTS
            PSobject

            .EXAMPLE
            Get-AllCoveDevices
        #>
        [cmdletBinding()]
        Write-Host "Statuses: T0_Statuses"
        Write-Host "OS Types: $I32_OStypes"
        <#
        I0 Device ID 
        I18 Computer Name
        I8 Customer
        I19 Internal IP
        I20 External IP
        I21 Mac address
        I1 Device Name
        I2 Device Alias
        I32 OS type
        I44 Computer Manufacturer
        I45 Computer Model
        I6 Timestamp 
        T0 Last session status
        TL Last successful session timestamp
        T7 Errors
        

        'I0','I18','I8','I19','I20','I21','I1','I2','I32','I44','I45','I6','T0','TL'


        #>


        $recordCount = 200
        $recordNum = 0
        $reqBody = @{
            method = 'EnumerateAccountStatistics'
            params = @{
                query = @{
                    Columns = 'I0','I18','I8','I19','I20','I21','I1','I2','I32','I44','I45','I6','T0','TL','T7'
                    Filter = ''
                    OrderBy = "I8 I18"
                    PartnerId = $PartnerInfo.ID
                    RecordsCount = $recordCount
                    SelectionMode = 'Merged'
                    StartRecordNumber = $recordNum
                }
            }
        }
        $result = @()
        $ErrorActionPreference = 'Continue'
        Do {
            $reqBody.params.query.StartRecordNumber = $recordNum
            $query = Invoke-CoveAPIcall -body $reqBody # -verbose
            foreach ($q in $query.result) {
                #$q.settings | FL
                if ($q.Flags -eq $null) {
                    Continue
                }
                
                # catch null values for these two, set them to 0 by default
                $ostyp = $q.settings.I32 | Filter-Null
                if ($ostyp -isnot [int]) {
                    $ostyp = 0
                }
                $OS_Type = $I32_OStypes[$ostyp]
                
                $stat = $q.settings.T0 | Filter-Null
                if ($stat -isnot [int]) {
                    $stat = 0
                }
                $LastSession_Status = $T0_Statuses[$stat]

                $result += [PSCustomObject] @{
                    DeviceID = $q.settings.I0 | Filter-Null
                    HostName = $q.settings.I18 | Filter-Null
                    Customer = $q.settings.I8 | Filter-Null
                    IP_Internal = ($q.settings.I19 | Filter-Null) -split(';')
                    IP_External = ($q.settings.I20 | Filter-Null) 
                    MAC_Addresses = ($q.settings.I21 | Filter-Null) -split(';')
                    DeviceName = $q.settings.I1 | Filter-Null
                    DeviceAlias = $q.settings.I2 | Filter-Null
                    OS_Type = $OS_Type
                    Computer_Make = $q.settings.I44 | Filter-Null
                    Computer_Model = $q.settings.I45 | Filter-Null
                    Timestamp_epoch = $q.settings.I6 | Filter-Null
                    TimeStamp = ($q.settings.I6 | Filter-Null | Convert-FromEpoch)
                    LastSession_Status = $LastSession_Status
                    LastSession_TimeStamp = ($q.settings.TL | Filter-Null | Convert-FromEpoch)
                    Errors = $q.settings.T7 | Filter-Null
                }
            }
            $recordNum += $recordCount
        }  While ($query.result.count -eq $recordCount) # For pagination - Once the $query.result.count number of devices recieved is less than $recordCount, we know we've hit the last page     
        
        Return $result

    }