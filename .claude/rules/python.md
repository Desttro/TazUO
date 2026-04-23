---
paths:
  - "src/ClassicUO.Client/LegionScripting/**"
  - "src/APIToMarkdown/**"
---

# IronPython Scripting Rules

## Runtime

IronPython 3.4.2. Scripts are loaded and executed on a scripting thread separate from the main game thread and the network thread.

## Py* wrapper classes

- Every class exposed to Python lives in `LegionScripting/PyClasses/` and is named `Py<Something>`.
- **Public members must have XML `<summary>` comments** — the doc generator (`tools/generate-docs.sh`) reads them to produce `LegionScripting/docs/Api*.md`.
- Only expose types that IronPython can marshal: `bool`, `int`, `long`, `float`, `string`, other `Py*` wrappers, `IronPython.Runtime.PythonFunction`. Do **not** expose `Span<T>`, `Memory<T>`, `ref`/`out` parameters, raw game entity types, or unsafe pointers.
- Return sentinel values (`null`, `false`, `0`) on failure — never let exceptions propagate to scripts unhandled.

## Doc generation

After any change to a `Py*` class, regenerate docs:

```bash
./tools/generate-docs.sh
```

Commit the regenerated `Api*.md` files in the same PR as the C# changes. Do **not** hand-edit the `docs/Api*.md` files.

## Thread safety

Scripts call `Py*` methods on the scripting thread. If accessing game state that requires the main thread, use the existing marshaling pattern (grep for how `PyPlayer` or `PyMobile` accesses world state).

## After changes

Dispatch `python-api-auditor` agent before committing.
