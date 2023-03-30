Function Get-CoveBackupStats () {
    <#
        .SYNOPSIS
        Returns the stats from the Cove Dashboard
        
        .DESCRIPTION
        Pulled this call straight outta the web gui dashboard lol

        .EXAMPLE
        Get-CoveBackupStats
    #>
    # 
    $p = '{"method":"EnumerateAccountStatistics","params":{"query":{"PartnerId":2575125,"Filter":"","Columns":["AU"],"SelectionMode":"Merged","Totals":["COUNT(1)","COUNT(((AT == 1 AND OT == 2 AND PD != Product.Documents) OR (AT == 1 AND OT == 1 AND PD != Product.Documents)) OR ((AT == 1 AND (OT == 2 OR OT == 1) AND PD == Product.Documents)) OR ((AT == 1 AND OT == 0)))","COUNT((T0==Session.Completed) OR (T0==Session.Blocked OR T0==Session.Aborted OR T0==Session.Failed OR T0==Session.Interrupted OR T0==Session.OverQuota OR T0==Session.NotStarted OR T0==Session.NoSelection) OR (T0==Session.CompletedWithErrors OR T0==Session.Restarted) OR (T0==Session.Undefined) OR (T0==Session.InProcess OR T0==Session.InProcessWithFaults))","COUNT(AT==2)","COUNT((AT == 1 AND OT == 2 AND PD != Product.Documents))","COUNT((AT == 1 AND OT == 1 AND PD != Product.Documents))","COUNT((AT == 1 AND (OT == 2 OR OT == 1) AND PD == Product.Documents))","COUNT((AT == 1 AND OT == 0))","COUNT(AT!=2)","SUM((AT!=2)*T3)","SUM((AT!=2)*US)","SUM(TM)","SUM((AT==2)*T3)","SUM((AT==2)*US)","COUNT(T0==Session.Completed)","COUNT(T0==Session.Blocked OR T0==Session.Aborted OR T0==Session.Failed OR T0==Session.Interrupted OR T0==Session.OverQuota OR T0==Session.NotStarted OR T0==Session.NoSelection)","COUNT(T0==Session.CompletedWithErrors OR T0==Session.Restarted)","COUNT(T0==Session.Undefined)","COUNT(T0==Session.InProcess OR T0==Session.InProcessWithFaults)","COUNT(TL>1.day().ago())","COUNT(TL>2.day().ago() && TL<1.day().ago())","COUNT(TL<2.day().ago() && TL>0)","COUNT(TL==0)"],"RecordsCount":1,"StartRecordNumber":0,"OrderBy":"","Labels":[]}},"jsonrpc":"2.0","id":"jsonrpc"}' | convertfrom-json
    $ss = Invoke-CoveAPIcall -body @{method = $p.method; params = $p.params} -raw
    $s = $ss.result.totalStatistics
    function getVal () {
        [cmdletbinding()]
        param ( 
            [Parameter(ValueFromPipeline=$true)]$a
        )
        Return $a.PSObject.Properties.Value
    }
    Return [PSCustomObject] @{
        Totals = [PSCustomObject] @{
            Devices = $s[0] | getVal
            Servers = $s[4] | getVal
            Workstations = $s[3] | getVal
            Documents = $s[1] | getVal
            Not_Installed = $s[2] | getVal
            Selected_Size_bytes = $s[18] | getVal
            Used_Storage_bytes = $s[19] | getVal
        }
        Microsoft365_Tenants = [PSCustomObject] @{
            m365a = $s[8] | getVal
            m365b = $s[20] | getVal
            m365c = $s[21] | getVal
            m365d = $s[22] | getVal
        }
        Backups_Completed = [PSCustomObject] @{
            Completed = $s[10] | getVal
            Completed_with_errors = $s[11] | getVal
            In_process = $s[12] | getVal
            Failed = $s[9] | getVal
            No_backups = $s[13] | getVal
        }
        Recent_Backup = [PSCustomObject] @{
            Less_than_1_day = $s[16] | getVal
            One_to_2_days = $s[17] | getVal
            Over_2_days = $s[14] | getVal
            No_backups = $s[15] | getVal
        }
    }
}