---
description: Run the xUnit test suite
argument-hint: "[filter expression]"
allowed-tools: Bash(dotnet test *)
---

Run the TazUO test suite.

If `$ARGUMENTS` is empty:

```bash
dotnet test tests/ClassicUO.UnitTests --verbosity normal
```

If `$ARGUMENTS` is provided, treat it as an xUnit filter:

```bash
dotnet test tests/ClassicUO.UnitTests --verbosity normal --filter "$ARGUMENTS"
```

Summarize pass/fail counts. On failure, dispatch the `test-runner` agent for detailed analysis.
