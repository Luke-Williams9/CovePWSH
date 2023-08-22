Function Filter-Null () {
    [cmdletBinding()]
    param ( 
        [Parameter(ValueFromPipeline=$true)]$in 
    )
    Process { 
        Try {
            $out = $in | where {$_ -ne $null} 
        }
        Catch {
            $out = 'Filter-Null error'
        }
        Return $out
    }
}