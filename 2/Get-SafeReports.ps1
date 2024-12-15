Using Namespace System.Collections.Generic

$ExampleDataString = @'
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
'@

# $DataString = $ExampleDataString
$DataString = Get-Content $PSScriptRoot\input1.txt

# For each line ("report"), ensure both are true:
# * From left to right, values all increase or decrease
# * Difference between each value must be at least one or at most three

Function Compare-Report {
    param(
        [String]$Action,
        [Int]$Current,
        [Int]$Next
    )
    Switch ($Action) {
        "Descending" { Return ($Current -gt $Next) -and (($Current - $Next) -in @(1,2,3)) }
        "Ascending" { Return ($Current -lt $Next) -and (($Current - $Next) -in @(-1,-2,-3)) }
        Default { Return $False }
    }
}

Function Get-SafeReports {
    param (
        [List[Int]]$Report
    )
    $IsSafe = $False

    # Establish the report's direction
    $Direction = Switch ($Report[0]) {
        {$_ -gt $Report[1]} { "Descending"; Break }
        {$_ -lt $Report[1]} { "Ascending"; Break }
        Default { Return $False }
    }

    # We do count minus one to not go out of the array's bounds
    For ($Index = 0; $Index -lt ($Report.Count - 1); $Index++) {
        $IsSafe = Compare-Report -Action $Direction -Current $Report[$Index] -Next $Report[$Index + 1]
        If (-not $IsSafe) { Break }
    }

    Return $IsSafe
}

Function Apply-Tolerance {
    param (
        [List[Int]]$Report
    )

    $IsSafe = $False

    For ($Index = 0; $Index -lt $Report.Count; $Index++) {
        # To work around Powershell's base array being read-only, and to hopefully avoid passing by reference
        [List[Int]]$TempReport = $Report + @()
        $TempReport.RemoveAt($Index)

        $IsSafe = Get-SafeReports -Report $TempReport
        If ($IsSafe) { Break }
    }

    Return $IsSafe
}

$NumberOfSafeReports = 0

$Reports = $DataString.Split("`n")

For ($ReportIndex = 0; $ReportIndex -lt $Reports.Count; $ReportIndex++) {
    $ThisReport = $Reports[$ReportIndex] -Split ' ' -As [List[Int]]

    $IsSafe = Get-SafeReports -Report $ThisReport

    If ($IsSafe) {
        $NumberOfSafeReports++
        Write-Host "Report $ReportIndex is safe!"
    } ElseIf (Apply-Tolerance -Report $ThisReport) {
        $NumberOfSafeReports++
        Write-Host "Report $ReportIndex is safe after tolerance!"
    }
}

Write-Host "Total safe reports is $NumberOfSafeReports"
