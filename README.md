# CovePWSH
 Powershell wrapper for the Cove Data Protection API



<!-- Summary -->


## [Install](https://github.com/Luke-Williams9/CovePWSH/archive/refs/heads/master.zip)

 The module can be installed by unzipping the master zip into one of your powershell modules folder, or by running the following one-liner:

`
$ModuleName='CovePWSH';$parentFldr='CovePWSH-main';$u='https://github.com/Luke-Williams9/CovePWSH/archive/refs/heads/main.zip';If($IsWindows){$s=';'}else{$s=':'};$mp=($Env:PSModulePath.split($s) -like "$HOME*")[0];$td='.'+$ModuleName+'_temp';$tempdir=Join-Path '~' $td;$z=Join-Path $tempdir ($ModuleName + '.zip');New-Item -path '~' -name $td -type 'directory' -ErrorAction SilentlyContinue;Invoke-WebRequest -Uri $u -OutFile $z;Expand-Archive $z -DestinationPath $tempdir -Force;New-Item -path $mp -name $ModuleName -ItemType 'directory' -ErrorAction SilentlyContinue;Copy-Item (Join-Path $tempdir $parentFldr $moduleName) -Destination $mp -Force -Recurse;Get-Module -listAvailable $ModuleName
`

