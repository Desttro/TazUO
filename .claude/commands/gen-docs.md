---
description: Regenerate the Python API markdown documentation
allowed-tools: Bash(./tools/generate-docs.sh), Bash(git status), Bash(git diff *)
---

Regenerate the auto-generated Python API docs:

```bash
./tools/generate-docs.sh
```

Docs land in `src/ClassicUO.Client/LegionScripting/docs/Api*.md`. After running, show `git status` so the user can review and stage the regenerated files.

Run this after adding or modifying any `Py*` class in `src/ClassicUO.Client/LegionScripting/PyClasses/`.
