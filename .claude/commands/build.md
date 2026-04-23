---
description: Build the solution in Release configuration (matches CI)
argument-hint: "[--debug | extra dotnet args]"
allowed-tools: Bash(dotnet build *)
---

Build TazUO. Default is Release, matching `.github/workflows/build-test.yml`.

If `$ARGUMENTS` is empty, run:

```bash
dotnet build -c Release
```

If `$ARGUMENTS` is `--debug`, run:

```bash
dotnet build -c Debug
```

Otherwise pass `$ARGUMENTS` through to `dotnet build`.

Report compilation errors with `file:line` references. Do not attempt to fix errors unless the user asks.
