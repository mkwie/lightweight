---
name: "improve-program-md"
description: "Improve training/program.md using the current program file, goals, athlete profile, and Sebastian Oreb programming analysis. Use when you want a concise diagnosis plus a rewritten version in Polish Markdown."
agent: "ask"
argument-hint: "Optional focus, e.g. progression, structure, clarity, alignment with goals"
---

Improve [program.md](../../training/program.md) using the following fixed context:

- [goals.md](../../training/goals.md)
- [profile.md](../../training/profile.md)
Working rules:

- Treat [program.md](../../training/program.md) as the only file to improve.
- Use [goals.md](../../training/goals.md) and [profile.md](../../training/profile.md) as context about constraints, priorities, equipment, training frequency, and athlete profile.
- Use the Oreb analysis as a source of programming heuristics, especially around fatigue management, delayed exposure to limit loads, autoregulation, and mesocycle structure.
- Do not invent facts about completed workouts that are not already supported by [program.md](../../training/program.md) or the surrounding training files.
- Improve the file by making it more useful as a coaching/program document: clearer logic, better connection between current split and goals, and more actionable explanation of how the training works.
- Preserve concise Polish Markdown.
- Prefer information density over fluff.
- If a recommendation from the analysis is not clearly applicable to this athlete, keep it conservative or present it as a suggested direction rather than a false certainty.

Return exactly:

1. Krótka diagnoza
2. Najważniejsze zmiany
3. Poprawiona pełna treść [program.md](../../training/program.md)

Additional focus:

${input:focus:optional}