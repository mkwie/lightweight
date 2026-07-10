---
agent: agent
description: 'Tworzy nowy blok treningowy ABC (full body 3-dniowy) bazując na analizie ostatnich 2 miesięcy z Hevy. Ewolucja, nie rewolucja — zachowuje to co działa, wymienia to co utknęło.'
tools:
  - hevy-mcp/*
  - read/readFile
  - edit/editFiles
  - execute/runInTerminal
---

Twoim zadaniem jest stworzenie nowego bloku treningowego ABC.

**Parametry:**
- Nazwa bloku: `${input:name:np. 07.26}`
- Liczba tygodni bloku: `${input:weeks:3}`

---

## KROK 1 — Pobierz dane z Hevy

Pobierz ostatnie **20 treningów** z Hevy (`get-workouts`, page 1-2 po 10). Analizujesz **ostatnie 2 miesiące**.

Dla każdego treningu wyciągnij:
- Datę i tytuł (tytuł w formacie `dzień.tydzień` np. `1.2`)
- Listę ćwiczeń z seriami roboczymi (pomiń serie `warmup`)
- Dla każdego ćwiczenia: nazwa, ciężary, powtórzenia

---

## KROK 2 — Analiza poprzedniego bloku

Wczytaj kontekst:
- [training/reps.md](../../training/reps.md) — zakresy powtórzeń i historia

Następnie dla każdego **ćwiczenia złożonego** (progresowanego) z poprzedniego bloku wygeneruj tabelę:

```
## Analiza bloku poprzedniego

### {Nazwa ćwiczenia}
| Sesja | Data | Tydzień | Ciężar | Reps (serie robocze) |
|-------|------|---------|--------|----------------------|
| ...   | ...  | ...     | ...    | ...                  |

Ocena postępu: ✅ DOBRY / ❌ BRAK
Sugestia: [utrzymaj / zwiększ ciężar startowy / rozważ zamianę ćwiczenia]
```

**Kryteria oceny postępu:**
- ✅ DOBRY — cel w porównaniu z plikiem .md osiągnięty
- ❌ BRAK — nie udało się osiągnąć celu

Dla każdego ćwiczenia z oceną ❌ zaproponuj alternatywę z odpowiedniej sekcji z `reps.md`.

---

## KROK 3 — Zapytaj użytkownika

Wyświetl kompletną analizę, a następnie zadaj poniższe pytania **razem w jednej wiadomości**:

```
---
📋 DECYZJE DO PODJĘCIA

Bazując na analizie powyżej, odpowiedz na poniższe pytania:

1. Jak się czujesz po tym bloku? (regeneracja, motywacja, cokolwiek co uznasz za ważne)

2. Czy chcesz zmienić jakieś ćwiczenia?
   Zaproponowane zamiany (wynikające z analizy):
   - [lista ćwiczeń z problemami i propozycje zamienników]
   Możesz potwierdzić, odrzucić lub zaproponować własne.

3. Czy zmieniamy liczbę tygodni bloku? (domyślnie: ${input:weeks})

4. Czy cokolwiek innego chcesz zmienić w strukturze planu?
   (kolejność dni, typy superserii, ćwiczenia accessory)
---
```

**Poczekaj na odpowiedź użytkownika przed przejściem do kroku 4.**

---

## KROK 4 — Wygeneruj nowy program

Na podstawie analizy i odpowiedzi użytkownika stwórz plik `training/${input:name}_program.yaml`.

### Struktura pliku

Użyj [training/_program_template.yaml](../../training/_program_template.yaml) jako wzorca.  
Schemat walidacji: [training/program.schema.json](../../training/program.schema.json).

Plik zawiera pole `block` (metadane) oraz `routines[]` — **jedna rutyna = jeden trening** (dzień × tydzień).
Blok ${input:weeks}-tygodniowy = 3 dni × ${input:weeks} tygodni = **${input:weeks}×3 rutyn**.

Każda rutyna ma pole `title` w formacie `"Wtydzień_dzień"` np. `"W1_1"`, `"W1_2"`, `"W1_3"`, `"W2_1"` itd.

### Zasady budowania programu

**Struktura każdego dnia (kolejność ćwiczeń):**
1. **A** — jedno ćwiczenie złożone na nogi (SQUAT lub HINGE), `superset_id: null`
2. **B1 + B2** — superseria PUSH + PULL: oba mają **ten sam** `superset_id: 1` (int)
3. **C** — 1–2 ćwiczenia accessory, `superset_id: null` (lub `2` jeśli para)

**Rotacja wzorców przez 3 dni:**
- Dzień 1: Squat (Low Bar lub High Bar) + Bench Press / Cable Row
- Dzień 2: Hinge (RDL) + Overhead Press / Lat Pulldown
- Dzień 3: Squat (drugi wariant) + Incline Press / Pull alternatywny

**Pola ćwiczenia (`exercise_template_id`):**
- Pobierz `Hevy ID` z [training/reps.md](../../training/reps.md)
- `name` — tylko dla czytelności YAML, nie wysyłane do API
- `notes` — format: `"A — Nazwa | N×M @ X kg | RPE Y"` lub `"B1 — Nazwa | SUPERSERIA z B2 | ..."`
- `rest_seconds` — compound solo (A): **180s**, superseria (B1/B2, A1/A2): **90s**, accessory w superserii (C1/C2): **60s**

**Progresja liniowa (ćwiczenia złożone):**
- Punkt startowy: ostatni ciężar z poprzedniego bloku (ostatni tydzień) + przyrost:
  - nogi: +5 kg, górna partia: +2.5 kg (tylko jeśli technicznie zaliczone)
- Oblicz ciężary **skryptem** (jeden wywołanie na ćwiczenie):
  ```
  cd training
  .\calculate-rm.ps1 -Exercise "Nazwa" -CurrentWeight X -CurrentReps N -RepRange "low-high" -RpeRange "7-9" -Weeks ${input:weeks} -Round 2.5
  ```
  Skrypt zwraca ciężar dla każdego tygodnia — przepisz je do `sets[].weight_kg`.

**Liczba serii roboczych (`type: normal`):**

| Reps w tygodniu | Serie normal |
|-----------------|-------------|
| 7 i więcej      | 3           |
| 6 i mniej       | 4           |
| Accessory (C)   | zawsze 3    |

**Sety rozgrzewkowe (`type: warmup`):**
- Tylko dla ćwiczeń złożonych (A, B1, B2)
- Schemat: ~50% × 8, ~70% × 5, ~85% × 3 (względem ciężaru T1)
- Wstawiaj **przed** setami `normal` w tej samej liście `sets[]`

**Accessory (C):**
- Zawsze 3 × 10, `weight_kg` dobrany na RPE ~8 w T1, bez zmian przez cały blok
- Brak warmupów
- Priorytet: mięśnie nieobciążone głównym ruchem danego dnia (core po squat, biceps/triceps po push-pull)

---

## KROK 5 — Zwaliduj plik

Po zapisaniu pliku uruchom walidator:

```powershell
cd training
Install-Module powershell-yaml -Scope CurrentUser -Force  # tylko jeśli brak modułu
.\validate-program.ps1 -ProgramFile "./${input:name}_program.yaml"
```

Jeśli walidacja zwróci błędy — popraw plik i uruchom ponownie.  
**Nie kończ pracy dopóki walidator nie wypisze `✅ Program valid`.**
