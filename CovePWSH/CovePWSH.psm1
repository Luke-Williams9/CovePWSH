$scriptRoot = $PSScriptRoot + '\public'

Get-ChildItem $scriptRoot *.ps1 | ForEach-Object {
    Import-Module $_.FullName
}

$Script:partnerName = "Global Storm IT (emmanuel@globalstormit.com)"
$Script:partnerInfo = '' # partner info is updated by function Connect-Cove
$Script:visa = ''        # the visa is updated by function Cove-APIcall

$Script:timeZoneOffset = New-Timespan -hours (((get-timezone).baseUtcOffset).hours + (Get-Date).IsDaylightSavingTime()) -minutes ((get-timezone).baseUtcOffset).minutes

# Column status descriptions - array indexes correspond with status numbers
$Script:T0_Statuses = 'null','In process','Failed','Aborted','Completed','Interrupted','Not Started','Completed With Errors','In Progress With Faults','Over Quota','No Selection','Restarted'
$Script:I32_OStypes = 'undefined','workstation','server'