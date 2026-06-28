---
agent: agent
description: 'Wrzuca program treningowy do Hevy — tworzy routineFolder o nazwie bloku i routines w formacie WX_Y (W1_1, W1_2…). Uruchom gdy masz gotowy plik _program.md i chcesz go załadować do Hevy.'
tools:
  - hevy-mcp/*
  - read/readFile
---

Twoim zadaniem jest załadowanie programu treningowego do Hevy.

**Parametry:**
- Plik programu: `${input:file:np. training/07.26_program.md}`
- Nazwa bloku (folder): `${input:name:np. 07.26}`
- Liczba tygodni bloku: `${input:weeks:4}`
- Liczba dni (treningów) w tygodniu: `${input:days:3}`

---

## KROK 1 — Wczytaj program

Wczytaj plik programu wskazany przez `${input:file}`.

Wyciągnij dla każdego dnia (Dzień 1, Dzień 2, Dzień 3…):
- Listę ćwiczeń w kolejności (A, B1, B2, C1, C2…)
- Dla każdego ćwiczenia i każdego tygodnia: ciężar roboczy, liczba serii roboczych, liczba powtórzeń
- Serie rozgrzewkowe (jeśli podane)
- Czy to accessory (3 × 10, stały ciężar bez progresji tygodniowej)

---

## KROK 2 — Utwórz Routine Folder

Utwórz nowy folder na rutyny (`create-routine-folder`) o nazwie: **`${input:name}`**

Zapisz zwrócone `folder_id` — będzie potrzebne przy tworzeniu rutyn.

---

## KROK 3 — Utwórz Routines

Dla każdej kombinacji tydzień × dzień utwórz osobną rutynę (`create-routine`) według poniższych zasad.

### Nazewnictwo

Format: `W{tydzień}_{dzień}` — np.:
- Tydzień 1, Dzień 1 → `W1_1`
- Tydzień 1, Dzień 2 → `W1_2`
- Tydzień 2, Dzień 1 → `W2_1`
- itd.

Łącznie powstanie `${input:weeks}` × `${input:days}` rutyn.

### Ćwiczenia w rutynie

Dla każdego ćwiczenia:
1. Odczytaj `exercise_template_id` z kolumny **Hevy ID** w [training/reps.md](../../training/reps.md) — znajdź wiersz po nazwie ćwiczenia. **Nie używaj `search-exercise-templates`**.
2. Jeśli w kolumnie Hevy ID stoi `—` (brak ID) — **zatrzymaj się przed tworzeniem rutyn i zapytaj użytkownika** (zbierz wszystkie brakujące ID na raz przed startem):\
   > Ćwiczenie **„{nazwa}"** nie ma Hevy ID w reps.md. Czy mam dodać je jako custom exercise w Hevy? [tak/nie]\
   - Jeśli **tak** → utwórz przez `create-exercise-template`, zapisz zwrócone ID, zaktualizuj kolumnę Hevy ID w reps.md (i sekcję Uwagi jeśli trzeba), potem kontynuuj tworzenie rutyn.\
   - Jeśli **nie** → pomiń ćwiczenie w tej rutynie i zgłoś je na końcu w kroku 4.
3. Dodaj serie w kolejności: najpierw serie rozgrzewkowe (`set_type: "warmup"`), potem serie robocze (`set_type: "normal"`).
4. Ustaw `weight_kg` i `reps` zgodnie z planem dla danego tygodnia.
5. Dla accessory: ciężar taki sam we wszystkich tygodniach (z T1 lub z pliku).

**Uwagi specjalne (patrz sekcja "Uwagi do Hevy ID" w reps.md):**
- **Zakroki T1** (BW): użyj ID `32HKJ34K` (Walking Lunge BW, reps_only); od T2 użyj ID `6E6EE645` (Lunge Barbell).
- **Chin Up BW**: użyj `29083183`; jeśli w programie jest ciężar dodatkowy — użyj `023943F1`.

### Serie rozgrzewkowe

- Jeśli program podaje konkretne rozgrzewki — użyj ich.
- Jeśli nie — pomiń (nie dodawaj rozgrzewek do accessory i ćwiczeń bez rozgrzewki w planie).

### Przerwy między seriami (`rest_seconds`)

Ustaw pole `rest_seconds` na każdej serii roboczej według poniższych zasad:

| Typ ćwiczenia | Kontekst | Przerwa |
|---|---|---|
| Compound (A, B1, B2) | samodzielne | 180 s |
| Compound (A1, A2, B1, B2) | superseria | 90 s |
| Accessory (C, C1, C2) | samodzielne | 120 s |
| Accessory (C1, C2) | superseria | 60 s |

Superseria = ćwiczenia z tym samym prefixem i numerem (np. B1/B2, C1/C2, A1/A2).

### Kolejność ćwiczeń

Zachowaj kolejność z programu: A → B1 → B2 → C1 → C2.

Ćwiczenia w superseriach (B1/B2, C1/C2, A1/A2) dodawaj jedno po drugim w tej samej kolejności.

### Superserie — pole `supersetId`

Pole `supersetId` ustawiaj na poziomie ćwiczenia (integer). Zasady:

- Ćwiczenia tworzące tę samą superserie oznaczaj tym samym numerem, zaczynając od `1` dla pierwszej superserii w rutynie.
- Kolejna niezależna superseria w tej samej rutynie → następny numer (`2`, `3`…).
- Ćwiczenia **bez** partnera w superserii → **pomiń pole `supersetId` w ogóle** (nie przekazuj null ani 0 — Hevy traktuje `null` jako grupę 0 i scala wszystkie ćwiczenia z null w jedną superserie).

Przykład (Dzień 2):
- RDL (A) → *(brak pola supersetId)*
- OHP (B1) → `supersetId: 1`
- Chin Up (B2) → `supersetId: 1`
- Crunch (C1) → `supersetId: 2`
- Powell Raise (C2) → `supersetId: 2`

---

## KROK 4 — Potwierdź

Po utworzeniu wszystkich rutyn wyświetl podsumowanie:

```
✅ Folder: ${input:name} (id: ...)

Rutyny:
- W1_1 — Dzień 1: [lista ćwiczeń]
- W1_2 — Dzień 2: [lista ćwiczeń]
- ...
- W{N}_{M} — Dzień M: [lista ćwiczeń]

Łącznie: X rutyn utworzonych.
```

Jeśli którekolwiek ćwiczenie zostało pominięte (użytkownik odmówił dodania custom exercise), wymień je tutaj z sugestią ręcznego uzupełnienia.
