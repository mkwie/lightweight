---
agent: agent
description: 'Synchronizuje plik _program.yaml do Hevy — update-routine jeśli hevy_routine_id istnieje, create-routine jeśli nie. Jeden prompt do świeżego importu i do aktualizacji po zmianach.'
tools:
  - hevy-mcp/*
  - read/readFile
  - edit/editFiles
---

Twoim zadaniem jest zsynchronizowanie pliku programu treningowego z Hevy.

**Parametry:**
- Plik programu: `${input:file:np. training/07.26_program.yaml}`

---

## KROK 1 — Wczytaj program

Wczytaj plik YAML wskazany przez `${input:file}`.

Odczytaj:
- `block.name` — nazwa bloku (użyta jako nazwa folderu)
- `block.hevy_folder_id` — istniejące ID folderu (jeśli jest)
- `routines[]` — lista rutyn z polami: `title`, `hevy_routine_id` (opcjonalne), `exercises[]`

---

## KROK 2 — Folder w Hevy

- Jeśli `block.hevy_folder_id` **jest ustawione** → użyj go bezpośrednio (bez tworzenia nowego folderu).
- Jeśli `block.hevy_folder_id` **brak** → utwórz folder (`create-routine-folder`) o nazwie `block.name`, zapisz zwrócone ID, wpisz je do pliku YAML (`block.hevy_folder_id`).

---

## KROK 3 — Synchronizuj routines

Dla **każdej rutyny** z `routines[]` wykonaj:

### Tryb: create vs update

- Jeśli rutyna ma pole `hevy_routine_id` → wywołaj **`update-routine`** z tym ID.
- Jeśli rutyna **nie ma** `hevy_routine_id` → wywołaj **`create-routine`** z `folderId: block.hevy_folder_id`, a zwrócone ID zapisz do pliku YAML (`hevy_routine_id` tej rutyny).

### Mapowanie pól YAML → Hevy API

Każde ćwiczenie z `exercises[]` przekształć wg poniższej tabeli:

| YAML | Hevy API |
|---|---|
| `exercise_template_id` | `exerciseTemplateId` |
| `superset_id` | `supersetId` (pomiń pole jeśli brak w YAML — nie wysyłaj null) |
| `rest_seconds` | `restSeconds` |
| `notes` | `notes` |
| `sets[].type` | `sets[].type` (`"warmup"` / `"normal"`) |
| `sets[].weight_kg` | `sets[].weightKg` |
| `sets[].reps` | `sets[].reps` |
| `sets[].duration_seconds` | `sets[].durationSeconds` (ćwiczenia czasowe, np. Dead Hang) |

**Ważne:**
- Sety wysyłaj w oryginalnej kolejności z YAML (warmup przed normal).
- Jeśli set ma `duration_seconds` (np. Dead Hang) — nie wysyłaj `reps` ani `weightKg` dla tego setu.
- `supersetId` **pomijaj całkowicie** gdy ćwiczenie nie należy do superserii (nie wysyłaj `null`).

---

## KROK 4 — Potwierdź

Po zsynchronizowaniu wszystkich rutyn wyświetl:

```
✅ Blok: {block.name} (folder: {hevy_folder_id})

Zsynchronizowane rutyny:
- W1_1 → [created / updated] — {lista ćwiczeń}
- W1_2 → [created / updated] — {lista ćwiczeń}
- ...

Łącznie: X rutyn (Y created, Z updated).
```
