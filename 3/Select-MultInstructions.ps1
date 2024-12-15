$ExampleString = @'
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
'@

# $InputString = $ExampleString
$InputString = Get-Content $PSScriptRoot/input.txt

# Could try my hand at making a tokenizer, but first let's just regex the thing
# If I really want to write a tokenizer, having something to compare it against is wise
[Regex]$Pattern = "mul\((?<instruction>\d{1,3},\d{1,3})\)"

$Result = Select-String -Pattern $Pattern -InputObject $InputString -CaseSensitive -AllMatches

$FinalSum = 0

ForEach ($Instruction in $Result.Matches) {
    # Instructions are always in group 1
    $Pair = $Instruction.Groups[1] -Split ','
    $FinalSum += [Int]$Pair[0] * [Int]$Pair[1]
}

Write-Host $Result
Write-Host "Sum of mult results is $FinalSum"
