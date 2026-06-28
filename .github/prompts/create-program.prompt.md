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
- ✅ DOBRY — cel w porównaniu z plikiem .md osiągnięty, albo nawet więcej
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

Na podstawie analizy i odpowiedzi użytkownika stwórz plik `training/${input:name}_program.md`.

### Zasady budowania programu

**Struktura każdego dnia:**
1. **A** — jedno ćwiczenie złożone na nogi (SQUAT lub HINGE)
2. **B1 + B2** — superseria PUSH + PULL (horyzontalne LUB wertykalne)
3. **C** — 1–2 ćwiczenia accessory (3 × 10, bez progresji)

Całość treningu: **≤50 minut** (rozgrzewka trwa ~10 min, więc trening właściwy musi się zmknąć w 50 min). Przy planowaniu czasu:
- Ćwiczenie główne nogi: ~15 min (wliczając rozgrzewkę)
- Superseria B: ~20 min
- Accessory: ~10 min
- Jeśli czas jest zbyt napięty, usuń jedno accessory zamiast rezygnować z rozgrzewek.

**Rotacja wzorców przez 3 dni:**
- Dzień 1: Squat (Low Bar lub High Bar) + Bench Press / Cable Row
- Dzień 2: Hinge (RDL) + Overhead Press / Lat Pulldown
- Dzień 3: Squat (drugi wariant) + Incline Press / Pull alternatywny

**Progresja liniowa (ćwiczenia złożone):**
- Punkt startowy = ostatni ciężar z bloku + 2.5 kg (jeśli ukończono blok z dobrą techniką) LUB ciężar bez zmiany (jeśli były problemy)
- Zakres powtórzeń pobierz z `reps.md` dla danego ćwiczenia (np. `3–10`)
- Tydzień 1 = górna granica zakresu, ostatni tydzień = dolna granica zakresu
- Tygodnie pośrednie rozłóż równomiernie (interpolacja liniowa)
- Przykład dla zakresu 3–10 i 5 tygodni: T1=10, T2=8, T3=6, T4=4, T5=3

**Liczba serii roboczych:**

| Reps w danym tygodniu | Serie robocze |
|------------------------|---------------|
| 7 i więcej | 3 |
| 6 i mniej | 4 |
| Bez zakresu (accessory) | zawsze 3 × 10 |

**Accessory (3 × 10, bez progresji):**
- Dobierz RPE ~8 w tygodniu 1 i nie zmieniaj ciężaru przez cały blok
- Priorytet: mięśnie nieobciążone głównym ruchem w danym dniu (np. core po squat, biceps/triceps po push-pull)

**Rozgrzewki:**
- Dla każdego ćwiczenia złożonego zawrzyj 3 serie rozgrzewkowe
- Schemat: ~50% ciężaru roboczego × 8, ~70% × 5, ~85% × 3

**Obliczanie ciężaru**
- Użyj skryptu calculate-rm.ps1 np.
.\calculate-rm.ps1 -Exercise "Wyciskanie" -CurrentWeight 85 -CurrentReps 5 -RepRange "3-10" -Weeks 5
Zwróci to ciężary dla każdego tygodnia.

### Format pliku wynikowego

Użyj struktury z [training/_program_template.md](../../training/_program_template.md) jako bazy.  
Zastąp wszystkie placeholdery `{...}` rzeczywistymi wartościami.

W sekcji nagłówkowej dodaj:
- Datę utworzenia bloku
- Poprzedni blok (nazwa) i kluczowe zmiany względem niego
- Link do `training/reps.md` jako referencja zakresów
