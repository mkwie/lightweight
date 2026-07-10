param (
    [Parameter(Mandatory = $true)]
    [string]$Exercise,
    [Parameter(Mandatory = $true)]
    [double]$CurrentWeight,
    [Parameter(Mandatory = $true)]
    [int]$CurrentReps,
    [Parameter(Mandatory = $true)]
    [string]$RepRange,
    [Parameter(Mandatory = $true)]
    [string]$RpeRange,
    [Parameter(Mandatory = $true)]
    [int]$Weeks,
    [double]$Round = 2.5
)

# Szacowanie % 1RM na podstawie liczby powtorzeń (przy RPE 10)
function Get-PercentageOf1RM ([int]$reps) {
    return 1.0 / (1.0 + ($reps / 30.0))
}

function Round-ToNearest ([double]$value, [double]$step) {
    return [Math]::Round($value / $step) * $step
}

$repParts = $RepRange -split '-'
if ($repParts.Count -ne 2) { Write-Error "RepRange: uzyj formatu np. '3-5'"; exit 1 }
$repLower = [int]$repParts[0]
$repUpper = [int]$repParts[1]

$rpeParts = $RpeRange -split '-'
if ($rpeParts.Count -ne 2) { Write-Error "RpeRange: uzyj formatu np. '7-9'"; exit 1 }
$rpeLower = [int]$rpeParts[0]
$rpeUpper = [int]$rpeParts[1]

if ($Weeks -lt 1) { Write-Error "Tygodnie >= 1"; exit 1 }

$currentPct = Get-PercentageOf1RM $CurrentReps
$estimated1RM = $CurrentWeight / $currentPct
$out1RM = [Math]::Round($estimated1RM, 1)

Write-Output "=== WYNIK KALKULATOR RM ==="
Write-Output "Cwiczenie     : $Exercise"
Write-Output "Aktualny wynik: $CurrentWeight kg x $CurrentReps"
Write-Output "Szacowany 1RM : $out1RM kg"
Write-Output "Zakres powt.  : $repLower-$repUpper | RPE: $rpeLower-$rpeUpper | Tygodni: $Weeks"
Write-Output ""
Write-Output "Tydzien | Powt | RPE | Ciezar"
Write-Output "--------|------|-----|-------"

for ($i = 0; $i -lt $Weeks; $i++) {
    if ($Weeks -eq 1) {
        $weekReps = $repUpper
        $weekRpe  = $rpeLower
    }
    elseif ($i -eq 0) {
        $weekReps = $repUpper
        $weekRpe  = $rpeLower
    }
    elseif ($i -eq ($Weeks - 1)) {
        $weekReps = $repLower
        $weekRpe  = $rpeUpper
    }
    else {
        $weekReps = [int][Math]::Floor($repUpper - $i * ($repUpper - $repLower) / ($Weeks - 1))
        $weekRpe  = [int][Math]::Round($rpeLower  + $i * ($rpeUpper  - $rpeLower)  / ($Weeks - 1))
    }

    # RIR = 10 - RPE, więc ciężar dla N powt @ RPE X = ciężar dla (N + RIR) powt @ RPE 10
    $effectiveReps = $weekReps + (10 - $weekRpe)
    $pct    = Get-PercentageOf1RM $effectiveReps
    $weight = Round-ToNearest ($estimated1RM * $pct) $Round

    $line = "T{0,-6}  | {1,-4} | {2,-3} | {3} kg" -f ($i + 1), $weekReps, $weekRpe, $weight
    Write-Output $line
}
Write-Output "=========================="
