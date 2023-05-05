Function Filter-Null () {
    [cmdletBinding()]
    param ( 
        [Parameter(ValueFromPipeline=$true)]$in 
    )
    Process { 
        Return $out = $in | where {$_ -ne $null} 
    }
}