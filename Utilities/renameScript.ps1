$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
cd $scriptPath

$splitArr = $scriptPath.split("\")
$name = $splitArr[-2]+"_"+ $splitArr[-1]

Write-Host $name
Dir *.mha | ForEach-Object  -begin { $count=1 }  -process { rename-item $_ -NewName "$name _$count.mha"; $count++ }


