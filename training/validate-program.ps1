param(
    [Parameter(Mandatory)]
    [string]$ProgramFile
)

# Wymaga: Install-Module powershell-yaml
Import-Module powershell-yaml -ErrorAction Stop

$schemaPath = Join-Path $PSScriptRoot "program.schema.json"
if (-not (Test-Path $schemaPath)) { Write-Error "Brak pliku schematu: $schemaPath"; exit 1 }
if (-not (Test-Path $ProgramFile)) { Write-Error "Brak pliku programu: $ProgramFile"; exit 1 }

$yaml   = Get-Content $ProgramFile -Raw | ConvertFrom-Yaml
$json   = $yaml | ConvertTo-Json -Depth 20
$schema = Get-Content $schemaPath -Raw

# --- 1. Walidacja schematu JSON ---
$schemaErrors = $null
$valid = Test-Json -Json $json -Schema $schema -ErrorVariable schemaErrors 2>&1

if (-not $valid) {
    Write-Error "❌ Błędy schematu:`n$($schemaErrors -join "`n")"
    exit 1
}

# --- 2. Reguły biznesowe ---
$errors = @()
$blockWeeks = $yaml.block.weeks

# Liczba unikalnych tygodni w routines == block.weeks
$uniqueWeeks = ($yaml.routines | ForEach-Object { $_.week } | Sort-Object -Unique)
if ($uniqueWeeks.Count -ne $blockWeeks) {
    $errors += "block.weeks=$blockWeeks, ale routines zawiera $($uniqueWeeks.Count) unikalnych tygodni"
}

# Każdy tydzień ma dokładnie 3 dni
$yaml.routines | Group-Object week | ForEach-Object {
    if ($_.Count -ne 3) {
        $errors += "Tydzień $($_.Name) ma $($_.Count) dni (oczekiwano 3)"
    }
}

# Tytuły unikalne
$titles = $yaml.routines | ForEach-Object { $_.title }
$dupes  = $titles | Group-Object | Where-Object { $_.Count -gt 1 }
if ($dupes) {
    $errors += "Duplikaty tytułów rutyn: $($dupes.Name -join ', ')"
}

foreach ($routine in $yaml.routines) {
    foreach ($ex in $routine.exercises) {
        $tag = "'$($ex.name ?? $ex.exercise_template_id)' (dzień $($routine.day), tydzień $($routine.week))"

        # Każde ćwiczenie musi mieć exercise_template_id
        if (-not $ex.exercise_template_id) {
            $errors += "Brak exercise_template_id: $tag"
        }

        $normalSets = @($ex.sets | Where-Object { $_.type -eq 'normal' })
        $warmupSets = @($ex.sets | Where-Object { $_.type -eq 'warmup' })

        # Ćwiczenia złożone identyfikujemy po konwencji notes: "A —" lub "B1/B2 —"
        # Accessory (C) nie wymaga warmupów ani 4 serii
        $isCompound = $ex.notes -match '^[AB]\d* —'

        if ($isCompound) {
            if ($normalSets.Count -lt 3) {
                $errors += "Za mało serii roboczych ($($normalSets.Count) < 3): $tag"
            }
            if ($warmupSets.Count -lt 1) {
                $errors += "Brak serii rozgrzewkowych: $tag"
            }
        } else {
            # Accessory: zawsze dokładnie 3 × 10
            if ($normalSets.Count -ne 3) {
                $errors += "Accessory powinno mieć 3 serie (ma $($normalSets.Count)): $tag"
            }
        }
    }
}

if ($errors.Count -gt 0) {
    $errors | ForEach-Object { Write-Warning "⚠  $_" }
    Write-Error "❌ Walidacja nieudana ($($errors.Count) błędów)"
    exit 1
}

Write-Host "✅ Program valid — $($yaml.block.name), $blockWeeks tyg., $($yaml.routines.Count) rutyn" -ForegroundColor Green
