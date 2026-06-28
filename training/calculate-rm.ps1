param (
    [Parameter(Mandatory=$true)]
    [string]$Exercise,
    [Parameter(Mandatory=$true)]
    [double]$CurrentWeight,
    [Parameter(Mandatory=$true)]
    [int]$CurrentReps,
    [Parameter(Mandatory=$true)]
    [string]$RepRange,
    [Parameter(Mandatory=$true)]
    [int]$Weeks,
    [double]$Round = 2.5
)

function Get-PercentageOf1RM ([int]$reps) {
    return 1.0 / (1.0 + ($reps / 30.0))
}

function Round-ToNearest ([double]$value, [double]$step) {
    return [Math]::Round($value / $step) * $step
}

$parts = $RepRange -split '-'
if ($parts.Count -ne 2) { Write-Error "Uzyj formatu np. '3-10'"; exit 1 }
$lower = [int]$parts[0]
$upper = [int]$parts[1]
if ($Weeks -lt 1) { Write-Error "Tygodnie >= 1"; exit 1 }

$currentPct = Get-PercentageOf1RM $CurrentReps
$estimated1RM = $CurrentWeight / $currentPct
$out1RM = [Math]::Round($estimated1RM, 1)

Write-Output "=== WYNIK KALKULATOR RM ==="
Write-Output "Cwiczenie     : $Exercise"
Write-Output "Aktualny wynik: $CurrentWeight kg x $CurrentReps"
Write-Output "Szacowany 1RM : $out1RM kg"
Write-Output "Zakres        : $lower-$upper powt. | Tygodni: $Weeks"
Write-Output "Tydzien | Powt | Ciezar"
Write-Output "--------|------|-------"

for ($i = 0; $i -lt $Weeks; $i++) {
    if ($Weeks -eq 1) {
        $weekReps = $upper
    } elseif ($i -eq 0) {
        $weekReps = $upper
    } elseif ($i -eq ($Weeks - 1)) {
        $weekReps = $lower
    } else {
        $weekReps = [int][Math]::Floor($upper - $i * ($upper - $lower) / ($Weeks - 1))
    }
    $pct = Get-PercentageOf1RM $weekReps
    $weight = Round-ToNearest ($estimated1RM * $pct) $Round
    $line = "T" + ($i+1) + "      | " + $weekReps + "RM   | " + $weight + " kg"
    Write-Output $line
}
Write-Output "=========================="
