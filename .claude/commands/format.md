---
description: Format all C# source projects using dotnet format style
allowed-tools: Bash(./format.sh), Bash(dotnet format *)
---

Run the repo's formatter:

```bash
./format.sh
```

This runs `dotnet format style` across every `src/ClassicUO.*/` project per the existing script. Report any files that were modified.
