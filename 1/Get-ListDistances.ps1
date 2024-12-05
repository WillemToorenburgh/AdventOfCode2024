Using Namespace System.Collections.Generic

$RawInput = Get-Content $PSScriptRoot\input.txt

$List1 = [List[Int]]::new()
$List2 = [List[Int]]::new()

ForEach ($Line in $RawInput) {
    $SplitLine = $Line.Split(' ')
    $List1.Add($SplitLine[0])
    $List2.Add($SplitLine[-1])
}

# @(3, 4, 2, 1, 3, 3) | ForEach-Object { $List1.Add($_) } # Example list 1
# @(4, 3, 5, 3, 9, 3) | ForEach-Object { $List2.Add($_) } # Example list 2


# Sort lists by smallest to largest, get the distance between, then add that result to a list

# Cast so Sort-Object doesn't change the variables' type
$List1.Sort()
$List2.Sort()

$Differences = [List[Int]]::new()

For ($Index = 0; $Index -lt $List1.Count; $Index++) {
    $ThisDifference = ($List1[$Index] - $List2[$Index])
    If ($ThisDifference -lt 0) { $ThisDifference *= -1 }
    $Differences.Add($ThisDifference)
}

# Write-Host "Found distances: " ($Differences -Join ", ")
Write-Host "Total difference: " ($Differences | Measure-Object -Sum).Sum

## Part 2: for every number in List 1, multiply it by the number of times it appears in List 2

$Products = [List[Int]]::new()

For ($Index = 0; $Index -lt $List1.Count; $Index++) {
    $FinderPredicate = { param([Int]$x) $x -eq $List1[$Index] }
    $TotalOccurrances = $List2.FindAll($FinderPredicate)
    $ThisProduct = $List1[$Index] * $TotalOccurrances.Count
    $Products.Add($ThisProduct)
}

# Write-Host "Found products: " ($Products -Join ", ")
Write-Host "Total products: " ($Products | Measure-Object -Sum).Sum
