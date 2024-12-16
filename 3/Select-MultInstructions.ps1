$ExampleString = @'
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
'@

$ExampleString2 = @'
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
'@

# $InputString = $ExampleString2
$InputString = Get-Content $PSScriptRoot/input.txt

# Could try my hand at making a tokenizer, but first let's just regex the thing
# If I really want to write a tokenizer, having something to compare it against is wise
[Regex]$Pattern = "mul\((?<instruction>\d{1,3},\d{1,3})\)"

# $Result = Select-String -Pattern $Pattern -InputObject $InputString -CaseSensitive -AllMatches

# $FinalSum = 0

# ForEach ($Instruction in $Result.Matches) {
#     # Instructions are always in group 1
#     $Pair = $Instruction.Groups[1] -Split ','
#     $FinalSum += [Int]$Pair[0] * [Int]$Pair[1]
# }

# Write-Host $Result
# Write-Host "Sum of mult results is $FinalSum"


### Part 2: no tokenizer necessary just get good at regex lol

$Pattern2 = [Regex]"(do\(\))|(don't\(\))|(mul\((?<command>\d{1,3},\d{1,3})\))"
$Selections = Select-String -List -AllMatches -CaseSensitive -InputObject $InputString -Pattern $Pattern2

$FinalSum = 0
$ShouldExecute = $True

ForEach ($Command in $Selections.Matches) {
    switch ($Command.Value) {
        { $_.StartsWith("do(") } { $ShouldExecute = $True; Break }
        { $_.StartsWith("don't(") } { $ShouldExecute = $False; Break }
        { $_.StartsWith("mul(") } {
            If (-Not $ShouldExecute) { Break }
            $Pair = $Command.Groups[4] -Split ','
            $FinalSum += [Int]$Pair[0] * [Int]$Pair[1]
            Break
        }
        Default { Write-Warning "Not sure how to handle $Command"; Break }
    }
}

Write-Host "Sum of mult results is $FinalSum"

